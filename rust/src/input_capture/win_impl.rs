//! Windows backend: raw HID (SetupAPI + hid.dll) for joysticks / HOTAS / HID gamepads and
//! XInput for Xbox-compatible controllers.

use std::collections::{HashMap, HashSet};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{Arc, Mutex};
use std::thread::JoinHandle;
use std::time::{Duration, Instant};

use anyhow::{anyhow, Result};
use once_cell::sync::Lazy;
use windows::core::{HRESULT, PCWSTR};
use windows::Win32::Devices::DeviceAndDriverInstallation::{
    SetupDiDestroyDeviceInfoList, SetupDiEnumDeviceInterfaces, SetupDiGetClassDevsW,
    SetupDiGetDeviceInterfaceDetailW, DIGCF_DEVICEINTERFACE, DIGCF_PRESENT,
    SP_DEVICE_INTERFACE_DATA, SP_DEVICE_INTERFACE_DETAIL_DATA_W,
};
use windows::Win32::Devices::HumanInterfaceDevice::{
    HidD_FreePreparsedData, HidD_GetAttributes, HidD_GetHidGuid, HidD_GetPreparsedData,
    HidD_GetProductString, HidP_GetButtonCaps, HidP_GetCaps, HidP_GetData, HidP_GetValueCaps,
    HidP_Input, HidP_MaxDataListLength, HIDD_ATTRIBUTES, HIDP_BUTTON_CAPS, HIDP_CAPS, HIDP_DATA,
    HIDP_STATUS_SUCCESS, HIDP_VALUE_CAPS, PHIDP_PREPARSED_DATA,
};
use windows::Win32::Foundation::{
    CloseHandle, ERROR_IO_PENDING, ERROR_SUCCESS, GENERIC_READ, HANDLE, WAIT_TIMEOUT,
};
use windows::Win32::Storage::FileSystem::{
    CreateFileW, ReadFile, FILE_FLAGS_AND_ATTRIBUTES, FILE_FLAG_OVERLAPPED, FILE_SHARE_READ,
    FILE_SHARE_WRITE, OPEN_EXISTING,
};
use windows::Win32::System::Threading::CreateEventW;
use windows::Win32::System::IO::{CancelIoEx, GetOverlappedResult, GetOverlappedResultEx, OVERLAPPED};
use windows::Win32::UI::Input::XboxController::{XInputGetState, XINPUT_STATE};

use super::logic::*;
use crate::api::input_capture_api::{InputCaptureEvent, InputDeviceInfo, InputDeviceKind};
use crate::frb_generated::StreamSink;

/// Reports received during this window after opening a device only establish the baseline
/// (held buttons / hats, axis rest values) and never fire.
const WARM_UP: Duration = Duration::from_millis(250);
/// Read timeout used to poll the stop flag.
const READ_TIMEOUT_MS: u32 = 100;
/// How often newly connected HID devices are picked up.
const RESCAN_INTERVAL: Duration = Duration::from_secs(2);
const XINPUT_POLL: Duration = Duration::from_millis(8);
/// Disconnected XInput slots are expensive to poll; only re-check them this often.
const XINPUT_DISCONNECTED_POLL: Duration = Duration::from_secs(1);

// ---------------------------------------------------------------------------------------
// RAII helpers
// ---------------------------------------------------------------------------------------

struct OwnedHandle(HANDLE);

impl Drop for OwnedHandle {
    fn drop(&mut self) {
        if !self.0.is_invalid() {
            unsafe {
                let _ = CloseHandle(self.0);
            }
        }
    }
}

struct PreparsedData(PHIDP_PREPARSED_DATA);

impl Drop for PreparsedData {
    fn drop(&mut self) {
        if self.0 .0 != 0 {
            unsafe {
                let _ = HidD_FreePreparsedData(self.0);
            }
        }
    }
}

fn to_wide(s: &str) -> Vec<u16> {
    s.encode_utf16().chain(std::iter::once(0)).collect()
}

fn open_hid(path: &str, access: u32, flags: FILE_FLAGS_AND_ATTRIBUTES) -> Result<OwnedHandle> {
    let wide = to_wide(path);
    let handle = unsafe {
        CreateFileW(
            PCWSTR(wide.as_ptr()),
            access,
            FILE_SHARE_READ | FILE_SHARE_WRITE,
            None,
            OPEN_EXISTING,
            flags,
            None,
        )
    }?;
    Ok(OwnedHandle(handle))
}

// ---------------------------------------------------------------------------------------
// Enumeration
// ---------------------------------------------------------------------------------------

fn enumerate_hid_paths() -> Result<Vec<String>> {
    let guid = unsafe { HidD_GetHidGuid() };
    let set = unsafe {
        SetupDiGetClassDevsW(
            Some(&guid as *const _),
            PCWSTR::null(),
            None,
            DIGCF_PRESENT | DIGCF_DEVICEINTERFACE,
        )
    }?;
    scopeguard::defer! {
        unsafe { let _ = SetupDiDestroyDeviceInfoList(set); }
    }

    let mut paths = Vec::new();
    for index in 0.. {
        let mut iface = SP_DEVICE_INTERFACE_DATA {
            cbSize: std::mem::size_of::<SP_DEVICE_INTERFACE_DATA>() as u32,
            ..Default::default()
        };
        if unsafe { SetupDiEnumDeviceInterfaces(set, None, &guid, index, &mut iface) }.is_err() {
            break; // ERROR_NO_MORE_ITEMS
        }
        let mut required = 0u32;
        let _ = unsafe {
            SetupDiGetDeviceInterfaceDetailW(set, &iface, None, 0, Some(&mut required), None)
        };
        if (required as usize) < std::mem::size_of::<SP_DEVICE_INTERFACE_DETAIL_DATA_W>() {
            continue;
        }
        // u32 backing storage keeps the struct aligned.
        let mut buf = vec![0u32; (required as usize).div_ceil(4)];
        let detail = buf.as_mut_ptr() as *mut SP_DEVICE_INTERFACE_DETAIL_DATA_W;
        unsafe {
            (*detail).cbSize = std::mem::size_of::<SP_DEVICE_INTERFACE_DETAIL_DATA_W>() as u32;
        }
        if unsafe {
            SetupDiGetDeviceInterfaceDetailW(set, &iface, Some(detail), required, None, None)
        }
        .is_err()
        {
            continue;
        }
        let path = unsafe {
            let start = std::ptr::addr_of!((*detail).DevicePath) as *const u16;
            let offset = start as usize - detail as usize;
            let max_chars = (required as usize).saturating_sub(offset) / 2;
            let chars = std::slice::from_raw_parts(start, max_chars);
            let len = chars.iter().position(|&c| c == 0).unwrap_or(max_chars);
            String::from_utf16_lossy(&chars[..len])
        };
        if !path.is_empty() {
            paths.push(path);
        }
    }
    Ok(paths)
}

#[derive(Debug, Clone)]
enum ValueRole {
    Axis(String),
    /// 1-based hat index.
    Hat(u32),
}

#[derive(Debug, Clone)]
struct ButtonSpec {
    data_index: u16,
    usage: u16,
    report_id: u8,
}

#[derive(Debug, Clone)]
struct ValueSpec {
    data_index: u16,
    range: ValueRange,
    role: ValueRole,
}

#[derive(Debug, Clone)]
struct HidDeviceDesc {
    path: String,
    id: String,
    name: String,
    vendor_id: u16,
    product_id: u16,
    kind: InputDeviceKind,
    input_report_len: usize,
    button_count: u32,
    hat_count: u32,
    buttons: Vec<ButtonSpec>,
    values: Vec<ValueSpec>,
}

impl HidDeviceDesc {
    fn info(&self) -> InputDeviceInfo {
        InputDeviceInfo {
            id: self.id.clone(),
            name: self.name.clone(),
            vendor_id: self.vendor_id,
            product_id: self.product_id,
            kind: self.kind,
            button_count: self.button_count,
            axes: self
                .values
                .iter()
                .filter_map(|v| match &v.role {
                    ValueRole::Axis(name) => Some(name.clone()),
                    ValueRole::Hat(_) => None,
                })
                .collect(),
            hat_count: self.hat_count,
        }
    }
}

fn product_string(handle: HANDLE) -> Option<String> {
    let mut buf = [0u16; 256];
    let ok = unsafe {
        HidD_GetProductString(
            handle,
            buf.as_mut_ptr() as *mut _,
            std::mem::size_of_val(&buf) as u32,
        )
    };
    if !ok {
        return None;
    }
    let len = buf.iter().position(|&c| c == 0).unwrap_or(buf.len());
    let name = String::from_utf16_lossy(&buf[..len]).trim().to_string();
    (!name.is_empty()).then_some(name)
}

/// Reads attributes and capabilities of an open HID interface. Returns `None` for devices
/// that are not joystick-like.
fn describe(handle: HANDLE, path: &str) -> Option<(HidDeviceDesc, PreparsedData)> {
    let mut ppd = PHIDP_PREPARSED_DATA::default();
    if !unsafe { HidD_GetPreparsedData(handle, &mut ppd) } {
        return None;
    }
    let ppd = PreparsedData(ppd);

    let mut caps = HIDP_CAPS::default();
    if unsafe { HidP_GetCaps(ppd.0, &mut caps) } != HIDP_STATUS_SUCCESS {
        return None;
    }
    let kind = top_level_kind(caps.UsagePage, caps.Usage)?;

    let mut attrs = HIDD_ATTRIBUTES {
        Size: std::mem::size_of::<HIDD_ATTRIBUTES>() as u32,
        ..Default::default()
    };
    if !unsafe { HidD_GetAttributes(handle, &mut attrs) } {
        return None;
    }

    let mut button_caps = vec![HIDP_BUTTON_CAPS::default(); caps.NumberInputButtonCaps as usize];
    let mut len = caps.NumberInputButtonCaps;
    if len > 0
        && unsafe { HidP_GetButtonCaps(HidP_Input, button_caps.as_mut_ptr(), &mut len, ppd.0) }
            == HIDP_STATUS_SUCCESS
    {
        button_caps.truncate(len as usize);
    } else {
        button_caps.clear();
    }

    let mut value_caps = vec![HIDP_VALUE_CAPS::default(); caps.NumberInputValueCaps as usize];
    let mut len = caps.NumberInputValueCaps;
    if len > 0
        && unsafe { HidP_GetValueCaps(HidP_Input, value_caps.as_mut_ptr(), &mut len, ppd.0) }
            == HIDP_STATUS_SUCCESS
    {
        value_caps.truncate(len as usize);
    } else {
        value_caps.clear();
    }

    let mut buttons = Vec::new();
    for cap in button_caps.iter().filter(|c| c.UsagePage == USAGE_PAGE_BUTTON) {
        let (usage_min, usage_max, data_min) = unsafe {
            if cap.IsRange {
                let r = cap.Anonymous.Range;
                (r.UsageMin, r.UsageMax, r.DataIndexMin)
            } else {
                let n = cap.Anonymous.NotRange;
                (n.Usage, n.Usage, n.DataIndex)
            }
        };
        if usage_max < usage_min {
            continue;
        }
        for k in 0..=(usage_max - usage_min) {
            buttons.push(ButtonSpec {
                data_index: data_min.wrapping_add(k),
                usage: usage_min + k,
                report_id: cap.ReportID,
            });
        }
    }
    let button_count = buttons.iter().map(|b| b.usage as u32).max().unwrap_or(0);

    // (usage, data index, range) of every generic desktop axis / hat, in descriptor order.
    let mut raw_values: Vec<(u16, u16, ValueRange)> = Vec::new();
    for cap in value_caps
        .iter()
        .filter(|c| c.UsagePage == USAGE_PAGE_GENERIC_DESKTOP)
    {
        let range = ValueRange::new(cap.LogicalMin, cap.LogicalMax, cap.BitSize);
        let (usage_min, usage_max, data_min) = unsafe {
            if cap.IsRange {
                let r = cap.Anonymous.Range;
                (r.UsageMin, r.UsageMax, r.DataIndexMin)
            } else {
                let n = cap.Anonymous.NotRange;
                (n.Usage, n.Usage, n.DataIndex)
            }
        };
        if usage_max < usage_min {
            continue;
        }
        for k in 0..=(usage_max - usage_min) {
            let usage = usage_min + k;
            if is_axis_usage(usage) || usage == USAGE_HAT {
                raw_values.push((usage, data_min.wrapping_add(k), range));
            }
        }
    }

    let axis_usages: Vec<u16> = raw_values
        .iter()
        .filter(|(u, _, _)| *u != USAGE_HAT)
        .map(|(u, _, _)| *u)
        .collect();
    let mut axis_names = assign_axis_names(&axis_usages).into_iter();
    let mut values = Vec::new();
    let mut hat_count = 0u32;
    for (usage, data_index, range) in raw_values {
        let role = if usage == USAGE_HAT {
            hat_count += 1;
            Some(ValueRole::Hat(hat_count))
        } else {
            axis_names.next().flatten().map(ValueRole::Axis)
        };
        if let Some(role) = role {
            values.push(ValueSpec {
                data_index,
                range,
                role,
            });
        }
    }

    let name = product_string(handle)
        .unwrap_or_else(|| format!("{:04X}:{:04X}", attrs.VendorID, attrs.ProductID));

    Some((
        HidDeviceDesc {
            path: path.to_string(),
            id: stable_device_id(path),
            name,
            vendor_id: attrs.VendorID,
            product_id: attrs.ProductID,
            kind,
            input_report_len: caps.InputReportByteLength as usize,
            button_count,
            hat_count,
            buttons,
            values,
        },
        ppd,
    ))
}

fn enumerate_hid_joysticks() -> Result<Vec<HidDeviceDesc>> {
    let mut out = Vec::new();
    for path in enumerate_hid_paths()? {
        if is_xinput_hid_path(&path) {
            continue;
        }
        // Access 0: attributes / caps only, works even for devices opened exclusively.
        let Ok(handle) = open_hid(&path, 0, FILE_FLAGS_AND_ATTRIBUTES(0)) else {
            continue;
        };
        if let Some((desc, _ppd)) = describe(handle.0, &path) {
            out.push(desc);
        }
    }
    Ok(out)
}

fn xinput_state(slot: u32) -> Option<XINPUT_STATE> {
    let mut state = XINPUT_STATE::default();
    (unsafe { XInputGetState(slot, &mut state) } == ERROR_SUCCESS.0).then_some(state)
}

fn xinput_info(slot: u32) -> InputDeviceInfo {
    InputDeviceInfo {
        id: format!("xinput{slot}"),
        name: format!("Xbox Controller {}", slot + 1),
        vendor_id: 0,
        product_id: 0,
        kind: InputDeviceKind::XInput,
        button_count: XINPUT_BUTTON_TOKENS.len() as u32,
        axes: XINPUT_AXES.iter().map(|a| a.to_string()).collect(),
        hat_count: 0,
    }
}

pub(crate) fn list_devices() -> Result<Vec<InputDeviceInfo>> {
    let mut devices: Vec<InputDeviceInfo> =
        enumerate_hid_joysticks()?.iter().map(|d| d.info()).collect();
    for slot in 0..4 {
        if xinput_state(slot).is_some() {
            devices.push(xinput_info(slot));
        }
    }
    Ok(devices)
}

// ---------------------------------------------------------------------------------------
// Capture
// ---------------------------------------------------------------------------------------

static GENERATION: AtomicU64 = AtomicU64::new(0);
static MANAGER: Lazy<Mutex<Option<JoinHandle<()>>>> = Lazy::new(|| Mutex::new(None));

struct CaptureCtx {
    generation: u64,
    sink: StreamSink<InputCaptureEvent>,
    closed: AtomicBool,
}

impl CaptureCtx {
    fn alive(&self) -> bool {
        GENERATION.load(Ordering::SeqCst) == self.generation && !self.closed.load(Ordering::SeqCst)
    }

    fn emit(&self, event: InputCaptureEvent) {
        if self.sink.add(event).is_err() {
            // Dart side went away; wind the whole capture down.
            self.closed.store(true, Ordering::SeqCst);
        }
    }

    /// Sleeps up to `total`, returning early (false) when the capture was stopped.
    fn sleep(&self, total: Duration) -> bool {
        let deadline = Instant::now() + total;
        while self.alive() {
            let now = Instant::now();
            if now >= deadline {
                return true;
            }
            std::thread::sleep((deadline - now).min(Duration::from_millis(50)));
        }
        false
    }
}

fn join_manager() {
    let handle = MANAGER.lock().unwrap_or_else(|e| e.into_inner()).take();
    if let Some(handle) = handle {
        let _ = handle.join();
    }
}

pub(crate) fn start_capture(sink: StreamSink<InputCaptureEvent>) -> Result<()> {
    let generation = GENERATION.fetch_add(1, Ordering::SeqCst) + 1;
    join_manager();
    let ctx = Arc::new(CaptureCtx {
        generation,
        sink,
        closed: AtomicBool::new(false),
    });
    let handle = std::thread::Builder::new()
        .name("input-capture".into())
        .spawn(move || run_manager(ctx))
        .map_err(|e| anyhow!("failed to spawn input capture thread: {e}"))?;
    *MANAGER.lock().unwrap_or_else(|e| e.into_inner()) = Some(handle);
    Ok(())
}

pub(crate) fn stop_capture() {
    GENERATION.fetch_add(1, Ordering::SeqCst);
    join_manager();
}

fn run_manager(ctx: Arc<CaptureCtx>) {
    let mut threads: Vec<JoinHandle<()>> = Vec::new();
    {
        let ctx = ctx.clone();
        if let Ok(h) = std::thread::Builder::new()
            .name("input-capture-xinput".into())
            .spawn(move || run_xinput(ctx))
        {
            threads.push(h);
        }
    }

    let active: Arc<Mutex<HashSet<String>>> = Arc::new(Mutex::new(HashSet::new()));
    while ctx.alive() {
        match enumerate_hid_joysticks() {
            Ok(devices) => {
                for desc in devices {
                    let is_new = active
                        .lock()
                        .unwrap_or_else(|e| e.into_inner())
                        .insert(desc.path.clone());
                    if !is_new {
                        continue;
                    }
                    let ctx = ctx.clone();
                    let active = active.clone();
                    let spawned = std::thread::Builder::new()
                        .name("input-capture-hid".into())
                        .spawn(move || {
                            let path = desc.path.clone();
                            if let Err(e) = run_hid_device(&ctx, &desc) {
                                println!("[input_capture] {} ({}): {e}", desc.name, path);
                            }
                            active
                                .lock()
                                .unwrap_or_else(|e| e.into_inner())
                                .remove(&path);
                        });
                    if let Ok(h) = spawned {
                        threads.push(h);
                    }
                }
            }
            Err(e) => println!("[input_capture] HID enumeration failed: {e}"),
        }
        threads.retain(|h| !h.is_finished());
        ctx.sleep(RESCAN_INTERVAL);
    }
    for h in threads {
        let _ = h.join();
    }
}

struct HidReader<'a> {
    desc: &'a HidDeviceDesc,
    button_by_index: HashMap<u16, usize>,
    value_by_index: HashMap<u16, usize>,
    pressed: Vec<bool>,
    axes: Vec<AxisDetector>,
    hats: Vec<HatTracker>,
}

impl<'a> HidReader<'a> {
    fn new(desc: &'a HidDeviceDesc) -> Self {
        Self {
            desc,
            button_by_index: desc
                .buttons
                .iter()
                .enumerate()
                .map(|(i, b)| (b.data_index, i))
                .collect(),
            value_by_index: desc
                .values
                .iter()
                .enumerate()
                .map(|(i, v)| (v.data_index, i))
                .collect(),
            pressed: vec![false; desc.buttons.len()],
            axes: desc
                .values
                .iter()
                .map(|v| AxisDetector::new(v.range.min as f64, v.range.max as f64))
                .collect(),
            hats: vec![HatTracker::default(); desc.values.len()],
        }
    }

    fn event(&self, input: String, value: f64) -> InputCaptureEvent {
        InputCaptureEvent {
            device_id: self.desc.id.clone(),
            device_name: self.desc.name.clone(),
            vendor_id: self.desc.vendor_id,
            product_id: self.desc.product_id,
            kind: self.desc.kind,
            input,
            value,
        }
    }

    fn process(&mut self, data: &[HIDP_DATA], report_id: u8, warm_up: bool, ctx: &CaptureCtx) {
        let mut down = vec![false; self.pressed.len()];
        for item in data {
            if let Some(&i) = self.button_by_index.get(&item.DataIndex) {
                down[i] = unsafe { item.Anonymous.On };
            } else if let Some(&i) = self.value_by_index.get(&item.DataIndex) {
                let spec = &self.desc.values[i];
                let raw = unsafe { item.Anonymous.RawValue };
                let v = spec.range.decode(raw);
                match &spec.role {
                    ValueRole::Axis(name) => {
                        if warm_up {
                            self.axes[i].set_rest(v as f64);
                        } else if self.axes[i].feed(v as f64) {
                            ctx.emit(self.event(name.clone(), spec.range.normalize(v)));
                        }
                    }
                    ValueRole::Hat(n) => {
                        let pos = hat_position(v, &spec.range);
                        if let Some(dir) = self.hats[i].feed(pos, warm_up) {
                            ctx.emit(self.event(hat_token(*n, dir), 1.0));
                        }
                    }
                }
            }
        }
        // Buttons only change state for the report they belong to.
        for (i, spec) in self.desc.buttons.iter().enumerate() {
            if spec.report_id != report_id {
                continue;
            }
            if down[i] && !self.pressed[i] && !warm_up {
                ctx.emit(self.event(button_token(spec.usage), 1.0));
            }
            // Release: value 0.0, so the UI can show a held button.
            if !down[i] && self.pressed[i] && !warm_up {
                ctx.emit(self.event(button_token(spec.usage), 0.0));
            }
            self.pressed[i] = down[i];
        }
    }
}

fn run_hid_device(ctx: &CaptureCtx, listed: &HidDeviceDesc) -> Result<()> {
    let handle = open_hid(&listed.path, GENERIC_READ.0, FILE_FLAG_OVERLAPPED)
        .map_err(|e| anyhow!("open for reading failed: {e}"))?;
    let (desc, ppd) =
        describe(handle.0, &listed.path).ok_or_else(|| anyhow!("device capabilities changed"))?;
    if desc.input_report_len == 0 {
        return Ok(());
    }
    let event = OwnedHandle(unsafe { CreateEventW(None, true, false, PCWSTR::null()) }?);

    let max_data = unsafe { HidP_MaxDataListLength(HidP_Input, ppd.0) } as usize;
    let mut data = vec![HIDP_DATA::default(); max_data.max(1)];
    let mut report = vec![0u8; desc.input_report_len];
    let mut reader = HidReader::new(&desc);
    let opened = Instant::now();
    let timeout = HRESULT::from_win32(WAIT_TIMEOUT.0);

    let mut overlapped = OVERLAPPED::default();
    let mut pending = false;
    let mut result = Ok(());
    while ctx.alive() {
        if !pending {
            overlapped = OVERLAPPED {
                hEvent: event.0,
                ..Default::default()
            };
            match unsafe { ReadFile(
                    handle.0,
                    Some(report.as_mut_slice()),
                    None,
                    Some(&mut overlapped as *mut _),
                ) } {
                Ok(()) => {}
                Err(e) if e.code() == ERROR_IO_PENDING.to_hresult() => {}
                Err(e) => {
                    result = Err(anyhow!("read failed: {e}"));
                    break;
                }
            }
            pending = true;
        }
        let mut read = 0u32;
        match unsafe {
            GetOverlappedResultEx(handle.0, &overlapped, &mut read, READ_TIMEOUT_MS, false)
        } {
            Ok(()) => pending = false,
            Err(e) if e.code() == timeout => continue,
            Err(e) => {
                // Typically ERROR_DEVICE_NOT_CONNECTED after unplugging.
                pending = false;
                result = Err(anyhow!("read failed: {e}"));
                break;
            }
        }
        let read = (read as usize).min(report.len());
        if read == 0 {
            continue;
        }
        let mut len = data.len() as u32;
        let status = unsafe {
            HidP_GetData(
                HidP_Input,
                data.as_mut_ptr(),
                &mut len,
                ppd.0,
                &mut report[..read],
            )
        };
        if status != HIDP_STATUS_SUCCESS {
            continue;
        }
        let warm_up = opened.elapsed() < WARM_UP;
        let report_id = report[0];
        reader.process(&data[..len as usize], report_id, warm_up, ctx);
    }

    if pending {
        unsafe {
            let _ = CancelIoEx(handle.0, Some(&overlapped as *const _));
            let mut read = 0u32;
            // Wait for the cancelled read so the kernel no longer references `report`.
            let _ = GetOverlappedResult(handle.0, &overlapped, &mut read, true);
        }
    }
    drop(ppd);
    result
}

#[derive(Default)]
struct XInputSlot {
    connected: bool,
    last_check: Option<Instant>,
    /// Buttons + triggers from the previous poll (None until a baseline exists).
    buttons: Option<u16>,
    triggers: (bool, bool),
    sticks: Vec<AxisDetector>,
}

fn run_xinput(ctx: Arc<CaptureCtx>) {
    let mut slots: Vec<XInputSlot> = (0..4).map(|_| XInputSlot::default()).collect();
    while ctx.alive() {
        let now = Instant::now();
        for (slot_index, slot) in slots.iter_mut().enumerate() {
            if !slot.connected
                && slot
                    .last_check
                    .is_some_and(|t| now.duration_since(t) < XINPUT_DISCONNECTED_POLL)
            {
                continue;
            }
            slot.last_check = Some(now);
            let Some(state) = xinput_state(slot_index as u32) else {
                *slot = XInputSlot {
                    last_check: Some(now),
                    ..Default::default()
                };
                continue;
            };
            slot.connected = true;
            let pad = state.Gamepad;
            let buttons = pad.wButtons.0;
            let triggers = (
                xinput_trigger_pressed(pad.bLeftTrigger),
                xinput_trigger_pressed(pad.bRightTrigger),
            );
            let sticks = [pad.sThumbLX, pad.sThumbLY, pad.sThumbRX, pad.sThumbRY];

            let info = || xinput_info(slot_index as u32);
            let emit = |input: &str, value: f64| {
                let info = info();
                ctx.emit(InputCaptureEvent {
                    device_id: info.id,
                    device_name: info.name,
                    vendor_id: info.vendor_id,
                    product_id: info.product_id,
                    kind: info.kind,
                    input: input.to_string(),
                    value,
                });
            };

            match slot.buttons {
                None => {
                    // First poll: baseline only.
                    slot.sticks = sticks
                        .iter()
                        .map(|&v| {
                            let mut d = AxisDetector::new(i16::MIN as f64, i16::MAX as f64);
                            d.set_rest(v as f64);
                            d
                        })
                        .collect();
                }
                Some(prev) => {
                    for token in xinput_pressed_edges(prev, buttons) {
                        emit(token, 1.0);
                    }
                    for token in xinput_released_edges(prev, buttons) {
                        emit(token, 0.0);
                    }
                    if triggers.0 != slot.triggers.0 {
                        emit("triggerl_btn", if triggers.0 { 1.0 } else { 0.0 });
                    }
                    if triggers.1 != slot.triggers.1 {
                        emit("triggerr_btn", if triggers.1 { 1.0 } else { 0.0 });
                    }
                    for (i, &v) in sticks.iter().enumerate() {
                        if slot.sticks[i].feed(v as f64) {
                            emit(XINPUT_AXES[i], xinput_stick_normalize(v));
                        }
                    }
                }
            }
            slot.buttons = Some(buttons);
            slot.triggers = triggers;
        }
        std::thread::sleep(XINPUT_POLL);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Prints the devices found on this machine: `cargo test input_capture_print_devices -- --ignored --nocapture`
    #[test]
    #[ignore]
    fn input_capture_print_devices() {
        let paths = enumerate_hid_paths().unwrap();
        println!("HID interfaces: {}", paths.len());
        for path in &paths {
            let usage = open_hid(path, 0, FILE_FLAGS_AND_ATTRIBUTES(0))
                .ok()
                .and_then(|h| {
                    let mut ppd = PHIDP_PREPARSED_DATA::default();
                    if !unsafe { HidD_GetPreparsedData(h.0, &mut ppd) } {
                        return None;
                    }
                    let ppd = PreparsedData(ppd);
                    let mut caps = HIDP_CAPS::default();
                    (unsafe { HidP_GetCaps(ppd.0, &mut caps) } == HIDP_STATUS_SUCCESS)
                        .then_some((caps.UsagePage, caps.Usage))
                });
            println!("  {usage:04X?} {path}");
        }
        for d in enumerate_hid_joysticks().unwrap() {
            println!(
                "{:?} {} [{}] {:04X}:{:04X} buttons={} hats={} axes={:?}\n    {}",
                d.kind,
                d.name,
                d.id,
                d.vendor_id,
                d.product_id,
                d.button_count,
                d.hat_count,
                d.info().axes,
                d.path
            );
        }
        for info in list_devices().unwrap() {
            println!("listed: {info:?}");
        }
    }
}
