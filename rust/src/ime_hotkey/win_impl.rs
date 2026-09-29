//! Windows backend: one thread owns the low-level keyboard hook, the popup window and its
//! message loop; pasting into the game runs on a short-lived sender thread so the hook keeps
//! being serviced while we sleep between keystrokes (a stalled LL hook gets removed by Windows).

use std::sync::atomic::{AtomicBool, AtomicIsize, AtomicU32, AtomicU64, Ordering};
use std::sync::{Mutex, Once};
use std::thread::JoinHandle;
use std::time::{Duration, Instant};

use anyhow::{anyhow, Result};
use once_cell::sync::Lazy;
use windows::core::{w, PCWSTR, PWSTR};
use windows::Win32::Foundation::{
    CloseHandle, COLORREF, HINSTANCE, HWND, LPARAM, LRESULT, POINT, RECT, WPARAM,
};
use windows::Win32::Graphics::Gdi::{
    CreateFontW, CreateSolidBrush, DeleteObject, GetMonitorInfoW, MonitorFromPoint,
    MonitorFromWindow, SetBkColor, SetTextColor, CLEARTYPE_QUALITY, CLIP_DEFAULT_PRECIS,
    DEFAULT_CHARSET, HBRUSH, HDC, HFONT, HGDIOBJ, MONITORINFO, MONITOR_DEFAULTTONEAREST,
    MONITOR_DEFAULTTONULL, OUT_DEFAULT_PRECIS,
};
use windows::Win32::System::LibraryLoader::GetModuleHandleW;
use windows::Win32::System::Threading::{
    AttachThreadInput, GetCurrentThreadId, OpenProcess, QueryFullProcessImageNameW, PROCESS_NAME_WIN32,
    PROCESS_QUERY_LIMITED_INFORMATION,
};
use windows::Win32::UI::HiDpi::{GetDpiForMonitor, MDT_EFFECTIVE_DPI};
use windows::Win32::UI::Input::Ime::{
    ImmGetCompositionStringW, ImmGetContext, ImmGetConversionStatus, ImmReleaseContext,
    ImmSetConversionStatus, ImmSetOpenStatus, GCS_COMPSTR, IME_CMODE_NATIVE, IME_CONVERSION_MODE,
    IME_SENTENCE_MODE,
};
use windows::Win32::UI::Input::KeyboardAndMouse::{
    GetAsyncKeyState, GetKeyNameTextW, GetKeyState, GetKeyboardLayout, MapVirtualKeyExW,
    MapVirtualKeyW, SendInput, SetFocus, INPUT, INPUT_0, INPUT_KEYBOARD, KEYBDINPUT,
    KEYBD_EVENT_FLAGS, KEYEVENTF_EXTENDEDKEY, KEYEVENTF_KEYUP, KEYEVENTF_SCANCODE,
    MAPVK_VK_TO_VSC_EX, VIRTUAL_KEY,
};
use windows::Win32::UI::WindowsAndMessaging::*;

use super::clipboard::ClipboardSnapshot;
use super::logic::*;
use crate::api::ime_hotkey_api::{ImeHotkeyConfig, ImeHotkeyEvent, ImeSendFailure};
use crate::frb_generated::StreamSink;

const CLASS_NAME: PCWSTR = w!("SCToolBoxImeHotkeyPopup");

const WM_APP_HOTKEY: u32 = WM_APP + 1;
const WM_APP_SEND: u32 = WM_APP + 2;
const WM_APP_SEND_DONE: u32 = WM_APP + 3;
const WM_APP_MESSAGE: u32 = WM_APP + 4;
const WM_APP_CONFIG: u32 = WM_APP + 5;
const WM_APP_CAPTURED: u32 = WM_APP + 6;

// `lParam` of `WM_APP_CAPTURED`.
const CAPTURE_OK: isize = 0;
const CAPTURE_CANCELLED: isize = 1;
const CAPTURE_REJECTED: isize = 2;

const ES_AUTOHSCROLL: u32 = 0x0080;
const EM_SETSEL: u32 = 0x00B1;
const EM_LIMITTEXT: u32 = 0x00C5;
const EM_SETREADONLY: u32 = 0x00CF;
const WM_DPICHANGED: u32 = 0x02E0;
const LLKHF_INJECTED: u32 = 0x10;
/// Unassigned virtual key, tapped after an Alt / Win hotkey so releasing the modifier does
/// not open the window menu / Start menu.
const VK_DUMMY: u16 = 0xE8;

const COLOR_BG: u32 = 0x00_24_20_1E; // 0x00BBGGRR
const COLOR_EDIT_BG: u32 = 0x00_33_2D_2B;
const COLOR_TEXT: u32 = 0x00_F2_F2_F2;
const COLOR_HINT: u32 = 0x00_A8_A0_9A;
const COLOR_ERROR: u32 = 0x00_6B_6B_FF;

// ---------------------------------------------------------------------------------------
// Shared state
// ---------------------------------------------------------------------------------------

struct PendingMessage {
    id: u64,
    text: String,
    is_error: bool,
    busy: bool,
}

struct Shared {
    config: ImeHotkeyConfig,
    sink: StreamSink<ImeHotkeyEvent>,
    /// Queues (not single slots) so an answer to an older submit cannot overwrite the current
    /// one before the popup thread reads it; stale ids are dropped when drained.
    pending_sends: Vec<(u64, String)>,
    pending_messages: Vec<PendingMessage>,
}

static SHARED: Lazy<Mutex<Option<Shared>>> = Lazy::new(|| Mutex::new(None));
/// UI thread handle and its Win32 thread id (target of `WM_QUIT`).
type UiThread = (JoinHandle<()>, u32);
static THREAD: Lazy<Mutex<Option<UiThread>>> = Lazy::new(|| Mutex::new(None));
/// Serializes start / stop, which flutter_rust_bridge may call from different worker threads.
static LIFECYCLE: Mutex<()> = Mutex::new(());

/// Bumped on every start/stop; a sender thread from an older generation stops.
static GENERATION: AtomicU64 = AtomicU64::new(0);
static MAIN_HWND: AtomicIsize = AtomicIsize::new(0);
static EDIT_HWND: AtomicIsize = AtomicIsize::new(0);
static STATUS_HWND: AtomicIsize = AtomicIsize::new(0);
static EDIT_PROC: AtomicIsize = AtomicIsize::new(0);
static TARGET_HWND: AtomicIsize = AtomicIsize::new(0);

static HOTKEY: AtomicU64 = AtomicU64::new(0);
static GAME_ONLY: AtomicBool = AtomicBool::new(true);
static CAPTURING: AtomicBool = AtomicBool::new(false);
static SENDING: AtomicBool = AtomicBool::new(false);
/// Virtual key whose key-down we swallowed; its repeats and key-up are swallowed too.
static SWALLOWED_VK: AtomicU32 = AtomicU32::new(0);
static SUBMIT_SEQ: AtomicU64 = AtomicU64::new(0);
static CURRENT_SUBMIT: AtomicU64 = AtomicU64::new(0);
static STATUS_IS_ERROR: AtomicBool = AtomicBool::new(false);
/// A submit is being processed on the Dart side (encoding / translating); the edit is
/// read-only and Enter is ignored until it answers.
static BUSY: AtomicBool = AtomicBool::new(false);

fn lock_shared() -> std::sync::MutexGuard<'static, Option<Shared>> {
    SHARED.lock().unwrap_or_else(|e| e.into_inner())
}

fn emit(event: ImeHotkeyEvent) {
    if let Some(shared) = lock_shared().as_ref() {
        let _ = shared.sink.add(event);
    }
}

fn load_hwnd(a: &AtomicIsize) -> HWND {
    HWND(a.load(Ordering::SeqCst) as *mut _)
}

fn store_hwnd(a: &AtomicIsize, h: HWND) {
    a.store(h.0 as isize, Ordering::SeqCst);
}

fn post_main(msg: u32, wparam: usize, lparam: isize) {
    let main = load_hwnd(&MAIN_HWND);
    if !main.is_invalid() {
        unsafe {
            let _ = PostMessageW(Some(main), msg, WPARAM(wparam), LPARAM(lparam));
        }
    }
}

fn apply_config_atomics(config: &ImeHotkeyConfig) {
    HOTKEY.store(pack_hotkey(&config.hotkey), Ordering::SeqCst);
    GAME_ONLY.store(config.game_only, Ordering::SeqCst);
}

// ---------------------------------------------------------------------------------------
// Public entry points
// ---------------------------------------------------------------------------------------

/// Starts (or restarts) the popup. Failures are reported as an error on `sink`, because the
/// return value of a stream function never reaches Dart.
pub(crate) fn start(config: ImeHotkeyConfig, sink: StreamSink<ImeHotkeyEvent>) {
    let _lifecycle = LIFECYCLE.lock().unwrap_or_else(|e| e.into_inner());
    stop_locked();
    if !is_valid_hotkey(&config.hotkey) {
        let _ = sink.add_error(anyhow!("invalid hotkey"));
        return;
    }
    apply_config_atomics(&config);
    *lock_shared() = Some(Shared {
        config,
        sink,
        pending_sends: Vec::new(),
        pending_messages: Vec::new(),
    });
    let generation = GENERATION.fetch_add(1, Ordering::SeqCst) + 1;
    let (tx, rx) = std::sync::mpsc::channel::<Result<u32>>();
    let spawned = std::thread::Builder::new()
        .name("ime-hotkey".into())
        .spawn(move || run_ui_thread(generation, tx));
    let error = match spawned {
        Err(e) => anyhow!("failed to spawn ime hotkey thread: {e}"),
        Ok(handle) => match rx.recv() {
            Ok(Ok(thread_id)) => {
                *THREAD.lock().unwrap_or_else(|e| e.into_inner()) = Some((handle, thread_id));
                return;
            }
            Ok(Err(e)) => {
                let _ = handle.join();
                e
            }
            Err(_) => {
                let _ = handle.join();
                anyhow!("ime hotkey thread exited during startup")
            }
        },
    };
    if let Some(shared) = lock_shared().take() {
        let _ = shared.sink.add_error(error);
    }
}

pub(crate) fn stop() {
    let _lifecycle = LIFECYCLE.lock().unwrap_or_else(|e| e.into_inner());
    stop_locked();
}

fn stop_locked() {
    GENERATION.fetch_add(1, Ordering::SeqCst);
    let thread = THREAD.lock().unwrap_or_else(|e| e.into_inner()).take();
    if let Some((handle, thread_id)) = thread {
        unsafe {
            let _ = PostThreadMessageW(thread_id, WM_QUIT, WPARAM(0), LPARAM(0));
        }
        let _ = handle.join();
    }
    CAPTURING.store(false, Ordering::SeqCst);
    *lock_shared() = None;
}

fn is_running() -> bool {
    THREAD
        .lock()
        .unwrap_or_else(|e| e.into_inner())
        .as_ref()
        .is_some_and(|(h, _)| !h.is_finished())
}

pub(crate) fn update_config(config: ImeHotkeyConfig) {
    if !is_valid_hotkey(&config.hotkey) {
        return;
    }
    apply_config_atomics(&config);
    if let Some(shared) = lock_shared().as_mut() {
        shared.config = config;
    }
    post_main(WM_APP_CONFIG, 0, 0);
}

pub(crate) fn send(id: u64, encoded: String) {
    if let Some(shared) = lock_shared().as_mut() {
        shared.pending_sends.push((id, encoded));
    }
    post_main(WM_APP_SEND, 0, 0);
}

pub(crate) fn show_message(id: u64, text: String, is_error: bool, busy: bool) {
    if let Some(shared) = lock_shared().as_mut() {
        shared.pending_messages.push(PendingMessage {
            id,
            text,
            is_error,
            busy,
        });
    }
    post_main(WM_APP_MESSAGE, 0, 0);
}

pub(crate) fn begin_capture() -> Result<()> {
    if !is_running() {
        return Err(anyhow!("ime hotkey is not running"));
    }
    CAPTURING.store(true, Ordering::SeqCst);
    Ok(())
}

pub(crate) fn cancel_capture() {
    CAPTURING.store(false, Ordering::SeqCst);
}

pub(crate) fn key_name(vk: u32) -> String {
    let named = match vk {
        0x20 => Some("Space"),
        0x0D => Some("Enter"),
        0x09 => Some("Tab"),
        0x08 => Some("Backspace"),
        0x1B => Some("Esc"),
        0xC0 => Some("`"),
        _ => None,
    };
    if let Some(n) = named {
        return n.to_string();
    }
    if (0x70..=0x87).contains(&vk) {
        return format!("F{}", vk - 0x6F);
    }
    unsafe {
        let scan = MapVirtualKeyW(vk, MAPVK_VK_TO_VSC_EX);
        if scan & 0xFF != 0 {
            let mut lparam = ((scan & 0xFF) << 16) as i32;
            if scan & 0xFF00 != 0 {
                lparam |= 1 << 24;
            }
            let mut buf = [0u16; 64];
            let len = GetKeyNameTextW(lparam, &mut buf);
            if len > 0 {
                return String::from_utf16_lossy(&buf[..len as usize]);
            }
        }
    }
    format!("VK 0x{vk:02X}")
}

// ---------------------------------------------------------------------------------------
// Keyboard hook
// ---------------------------------------------------------------------------------------

fn key_held(vk: u32) -> bool {
    unsafe { (GetAsyncKeyState(vk as i32) as u16 & 0x8000) != 0 }
}

fn current_modifiers() -> (bool, bool, bool, bool) {
    (
        key_held(VK_CONTROL),
        key_held(VK_MENU),
        key_held(VK_SHIFT),
        key_held(VK_LWIN) || key_held(VK_RWIN),
    )
}

/// File name of the process owning `hwnd`, lower-cased.
fn window_process_name(hwnd: HWND) -> Option<String> {
    unsafe {
        let mut pid = 0u32;
        GetWindowThreadProcessId(hwnd, Some(&mut pid));
        if pid == 0 {
            return None;
        }
        let process = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, false, pid).ok()?;
        let mut buf = [0u16; 1024];
        let mut len = buf.len() as u32;
        let r = QueryFullProcessImageNameW(
            process,
            PROCESS_NAME_WIN32,
            PWSTR(buf.as_mut_ptr()),
            &mut len,
        );
        let _ = CloseHandle(process);
        r.ok()?;
        let path = String::from_utf16_lossy(&buf[..len as usize]);
        Some(path.rsplit(['\\', '/']).next()?.to_ascii_lowercase())
    }
}

fn should_trigger_hotkey() -> bool {
    if SENDING.load(Ordering::SeqCst) {
        return false;
    }
    let fg = unsafe { GetForegroundWindow() };
    let main = load_hwnd(&MAIN_HWND);
    if fg == main {
        return true;
    }
    if !GAME_ONLY.load(Ordering::SeqCst) {
        return true;
    }
    window_process_name(fg).is_some_and(|n| n == "starcitizen.exe")
}

unsafe extern "system" fn keyboard_hook(code: i32, wparam: WPARAM, lparam: LPARAM) -> LRESULT {
    if code == HC_ACTION as i32 {
        let kb = unsafe { &*(lparam.0 as *const KBDLLHOOKSTRUCT) };
        let injected = kb.flags.0 & LLKHF_INJECTED != 0;
        let msg = wparam.0 as u32;
        let down = msg == WM_KEYDOWN || msg == WM_SYSKEYDOWN;
        let up = msg == WM_KEYUP || msg == WM_SYSKEYUP;
        let vk = kb.vkCode;
        if !injected {
            let swallowed = SWALLOWED_VK.load(Ordering::SeqCst);
            if swallowed != 0 && vk == swallowed {
                if up {
                    SWALLOWED_VK.store(0, Ordering::SeqCst);
                }
                return LRESULT(1);
            }
            if down && !is_modifier_vk(vk) {
                if CAPTURING.load(Ordering::SeqCst) {
                    SWALLOWED_VK.store(vk, Ordering::SeqCst);
                    let (ctrl, alt, shift, win) = current_modifiers();
                    let hotkey = crate::api::ime_hotkey_api::ImeHotkey {
                        vk,
                        ctrl,
                        alt,
                        shift,
                        win,
                    };
                    let plain_escape = vk == VK_ESCAPE && !(ctrl || alt || shift || win);
                    let result = if plain_escape {
                        CAPTURE_CANCELLED
                    } else if is_valid_hotkey(&hotkey) {
                        CAPTURE_OK
                    } else {
                        // Keys the popup or plain typing needs; keep waiting for a valid one.
                        CAPTURE_REJECTED
                    };
                    if result != CAPTURE_REJECTED {
                        CAPTURING.store(false, Ordering::SeqCst);
                    }
                    post_main(WM_APP_CAPTURED, pack_hotkey(&hotkey) as usize, result);
                    return LRESULT(1);
                }
                let hotkey = unpack_hotkey(HOTKEY.load(Ordering::SeqCst));
                if vk == hotkey.vk
                    && current_modifiers() == (hotkey.ctrl, hotkey.alt, hotkey.shift, hotkey.win)
                    && should_trigger_hotkey()
                {
                    SWALLOWED_VK.store(vk, Ordering::SeqCst);
                    post_main(WM_APP_HOTKEY, 0, 0);
                    return LRESULT(1);
                }
            }
        }
    }
    unsafe { CallNextHookEx(None, code, wparam, lparam) }
}

// ---------------------------------------------------------------------------------------
// Input injection
// ---------------------------------------------------------------------------------------

fn send_scan_keys(keys: &[ScanKey]) -> bool {
    let inputs: Vec<INPUT> = keys
        .iter()
        .map(|k| {
            let mut flags = KEYEVENTF_SCANCODE;
            if k.extended {
                flags |= KEYEVENTF_EXTENDEDKEY;
            }
            if k.up {
                flags |= KEYEVENTF_KEYUP;
            }
            INPUT {
                r#type: INPUT_KEYBOARD,
                Anonymous: INPUT_0 {
                    ki: KEYBDINPUT {
                        wVk: VIRTUAL_KEY(0),
                        wScan: k.scan,
                        dwFlags: flags,
                        time: 0,
                        dwExtraInfo: 0,
                    },
                },
            }
        })
        .collect();
    let sent = unsafe { SendInput(&inputs, std::mem::size_of::<INPUT>() as i32) };
    sent as usize == inputs.len()
}

/// Presses one key combination (Enter, Ctrl+V) with the timing of typemiao/betterscime, which
/// was verified in game: each modifier down + 8 ms, key down, 8 ms hold, then key up and the
/// modifiers up together.
fn type_scan_keys(keys: &[ScanKey]) -> bool {
    let first_up = keys.iter().position(|k| k.up).unwrap_or(keys.len());
    let mut ok = true;
    for key in &keys[..first_up] {
        ok &= send_scan_keys(std::slice::from_ref(key));
        std::thread::sleep(Duration::from_millis(8));
    }
    ok && send_scan_keys(&keys[first_up..])
}

fn tap_dummy_key() {
    let make = |flags: KEYBD_EVENT_FLAGS| INPUT {
        r#type: INPUT_KEYBOARD,
        Anonymous: INPUT_0 {
            ki: KEYBDINPUT {
                wVk: VIRTUAL_KEY(VK_DUMMY),
                wScan: 0,
                dwFlags: flags,
                time: 0,
                dwExtraInfo: 0,
            },
        },
    };
    let inputs = [make(KEYBD_EVENT_FLAGS(0)), make(KEYEVENTF_KEYUP)];
    unsafe {
        SendInput(&inputs, std::mem::size_of::<INPUT>() as i32);
    }
}

/// Brings `target` to the front. Attaching to the current foreground thread lifts the
/// foreground lock that otherwise stops a background process from taking focus.
fn force_foreground(target: HWND) {
    unsafe {
        let fg = GetForegroundWindow();
        let cur = GetCurrentThreadId();
        let target_tid = GetWindowThreadProcessId(target, None);
        let fg_tid = if fg.is_invalid() {
            0
        } else {
            GetWindowThreadProcessId(fg, None)
        };
        let attach_target = target_tid != 0 && target_tid != cur;
        let attach_fg = fg_tid != 0 && fg_tid != cur && fg_tid != target_tid;
        if attach_target {
            let _ = AttachThreadInput(cur, target_tid, true);
        }
        if attach_fg {
            let _ = AttachThreadInput(cur, fg_tid, true);
        }
        if IsIconic(target).as_bool() {
            let _ = ShowWindow(target, SW_RESTORE);
        }
        let _ = SetForegroundWindow(target);
        let _ = BringWindowToTop(target);
        if attach_fg {
            let _ = AttachThreadInput(cur, fg_tid, false);
        }
        if attach_target {
            let _ = AttachThreadInput(cur, target_tid, false);
        }
    }
}

struct SendJob {
    id: u64,
    generation: u64,
    target: HWND,
    text: String,
    open_chat_before_send: bool,
    auto_send: bool,
    reopen_chat_after_send: bool,
}

// HWND is a raw pointer; the sender thread only passes it back to user32.
unsafe impl Send for SendJob {}

fn run_send(job: &SendJob) -> std::result::Result<(), ImeSendFailure> {
    let alive = || GENERATION.load(Ordering::SeqCst) == job.generation;
    let in_front = || unsafe { GetForegroundWindow() } == job.target;
    let pause = |ms: u64| std::thread::sleep(Duration::from_millis(ms));

    // Same as betterscime: poll the foreground every 8 ms, up to 60 times.
    let mut in_front_now = in_front();
    for _ in 0..60 {
        if in_front_now || !alive() {
            break;
        }
        pause(8);
        in_front_now = in_front();
    }
    if !in_front_now {
        return Err(ImeSendFailure::FocusFailed);
    }

    // Wait for the user to let go of Enter (and any modifier) so our keystrokes do not
    // interleave with physical ones.
    let started = Instant::now();
    while [0x0D, VK_SHIFT, VK_CONTROL, VK_MENU, VK_LWIN, VK_RWIN]
        .iter()
        .any(|&vk| key_held(vk))
        && started.elapsed() < Duration::from_secs(2)
    {
        pause(10);
    }
    send_scan_keys(&release_modifier_keys());
    // Let the game recover from losing focus (betterscime: 250 ms).
    pause(250);

    let enter = [
        ScanKey { scan: SC_ENTER, extended: false, up: false },
        ScanKey { scan: SC_ENTER, extended: false, up: true },
    ];
    let check = || {
        if alive() && in_front() {
            Ok(())
        } else {
            Err(ImeSendFailure::FocusLost)
        }
    };

    if job.open_chat_before_send {
        check()?;
        type_scan_keys(&enter);
        pause(250);
    }

    check()?;
    let snapshot = ClipboardSnapshot::replace_with_text(load_hwnd(&MAIN_HWND), &job.text)
        .ok_or(ImeSendFailure::ClipboardFailed)?;
    // Saving the old clipboard (e.g. a large image) can take a moment.
    if let Err(e) = check() {
        snapshot.restore();
        return Err(e);
    }
    let hkl = unsafe { GetKeyboardLayout(GetWindowThreadProcessId(job.target, None)) };
    let v_scan = unsafe { MapVirtualKeyExW(0x56, MAPVK_VK_TO_VSC_EX, Some(hkl)) };
    type_scan_keys(&ctrl_v_keys(v_scan));

    // From here on the text is in the chat box (and possibly already sent), so a focus change
    // is not reported as a failure: keeping the text for a retry would paste / send it twice.
    let finish = || -> std::result::Result<(), ImeSendFailure> {
        pause(100);
        if job.auto_send {
            check()?;
            type_scan_keys(&enter);
            if job.reopen_chat_after_send {
                pause(200);
                check()?;
                type_scan_keys(&enter);
            }
        }
        Ok(())
    };
    if finish().is_err() {
        println!("[ime_hotkey] focus changed after pasting; not sending / reopening");
    }
    // The game reads the clipboard while handling Ctrl+V; give it time before restoring.
    pause(300);
    snapshot.restore();
    Ok(())
}

// ---------------------------------------------------------------------------------------
// Popup window
// ---------------------------------------------------------------------------------------

struct Gdi {
    dpi: u32,
    edit_font: HFONT,
    status_font: HFONT,
    bg_brush: HBRUSH,
    edit_brush: HBRUSH,
}

static GDI: Lazy<Mutex<Option<GdiHandles>>> = Lazy::new(|| Mutex::new(None));

/// GDI handles are plain integers owned by the UI thread; the mutex only exists because
/// statics must be `Sync`.
struct GdiHandles(Gdi);
unsafe impl Send for GdiHandles {}

fn scale(v: i32, dpi: u32) -> i32 {
    (v as i64 * dpi as i64 / 96) as i32
}

fn popup_size(dpi: u32) -> (i32, i32) {
    (scale(560, dpi), scale(78, dpi))
}

fn create_font(px: i32) -> HFONT {
    unsafe {
        CreateFontW(
            -px,
            0,
            0,
            0,
            400,
            0,
            0,
            0,
            DEFAULT_CHARSET,
            OUT_DEFAULT_PRECIS,
            CLIP_DEFAULT_PRECIS,
            CLEARTYPE_QUALITY,
            0,
            w!("Microsoft YaHei UI"),
        )
    }
}

/// Recreates the fonts for `dpi` (if changed) and lays out the child controls.
fn apply_dpi(dpi: u32) {
    // Copy the handles out and release the lock before talking to the controls: WM_SETFONT and
    // MoveWindow repaint synchronously, which re-enters main_proc (WM_CTLCOLOR*) -> brushes().
    let (edit_font, status_font, old_fonts) = {
        let mut gdi = GDI.lock().unwrap_or_else(|e| e.into_inner());
        let Some(GdiHandles(g)) = gdi.as_mut() else {
            return;
        };
        let mut old_fonts = None;
        if g.dpi != dpi {
            old_fonts = Some((g.edit_font, g.status_font));
            g.edit_font = create_font(scale(20, dpi));
            g.status_font = create_font(scale(13, dpi));
            g.dpi = dpi;
        }
        (g.edit_font, g.status_font, old_fonts)
    };
    let edit = load_hwnd(&EDIT_HWND);
    let status = load_hwnd(&STATUS_HWND);
    let (w, _) = popup_size(dpi);
    let pad = scale(10, dpi);
    unsafe {
        SendMessageW(edit, WM_SETFONT, Some(WPARAM(edit_font.0 as usize)), Some(LPARAM(1)));
        SendMessageW(status, WM_SETFONT, Some(WPARAM(status_font.0 as usize)), Some(LPARAM(1)));
        let _ = MoveWindow(edit, pad, pad, w - pad * 2, scale(32, dpi), true);
        let _ = MoveWindow(status, pad, pad + scale(38, dpi), w - pad * 2, scale(20, dpi), true);
        // Only delete the previous fonts once the controls no longer use them.
        if let Some((old_edit, old_status)) = old_fonts {
            for font in [old_edit, old_status] {
                if !font.is_invalid() {
                    let _ = DeleteObject(HGDIOBJ(font.0));
                }
            }
        }
    }
}

fn monitor_dpi(monitor: windows::Win32::Graphics::Gdi::HMONITOR) -> u32 {
    let (mut x, mut y) = (96u32, 96u32);
    unsafe {
        if GetDpiForMonitor(monitor, MDT_EFFECTIVE_DPI, &mut x, &mut y).is_err() {
            return 96;
        }
    }
    x.max(96)
}

/// Saved position if it is still on a monitor, otherwise bottom left of the target's monitor.
fn place_popup(main: HWND, target: HWND) {
    let (saved_x, saved_y) = lock_shared()
        .as_ref()
        .map(|s| (s.config.window_x, s.config.window_y))
        .unwrap_or((None, None));
    unsafe {
        let saved_monitor = match (saved_x, saved_y) {
            (Some(x), Some(y)) => {
                let m = MonitorFromPoint(POINT { x, y }, MONITOR_DEFAULTTONULL);
                (!m.is_invalid()).then_some((m, x, y))
            }
            _ => None,
        };
        let (monitor, x, y) = match saved_monitor {
            Some(v) => v,
            None => {
                let m = MonitorFromWindow(
                    if target.is_invalid() { main } else { target },
                    MONITOR_DEFAULTTONEAREST,
                );
                let mut info = MONITORINFO {
                    cbSize: std::mem::size_of::<MONITORINFO>() as u32,
                    ..Default::default()
                };
                let _ = GetMonitorInfoW(m, &mut info);
                let dpi = monitor_dpi(m);
                let rc = info.rcMonitor;
                (m, rc.left + scale(40, dpi), rc.bottom - scale(300, dpi))
            }
        };
        let dpi = monitor_dpi(monitor);
        apply_dpi(dpi);
        let (w, h) = popup_size(dpi);
        let _ = SetWindowPos(main, Some(HWND_TOPMOST), x, y, w, h, SWP_NOACTIVATE);
    }
}

fn set_status(text: &str, is_error: bool) {
    let status = load_hwnd(&STATUS_HWND);
    STATUS_IS_ERROR.store(is_error, Ordering::SeqCst);
    let wide: Vec<u16> = text.encode_utf16().chain(std::iter::once(0)).collect();
    unsafe {
        let _ = SetWindowTextW(status, PCWSTR(wide.as_ptr()));
        let _ = windows::Win32::Graphics::Gdi::InvalidateRect(Some(status), None, true);
    }
}

fn show_hint() {
    let hint = lock_shared()
        .as_ref()
        .map(|s| s.config.hint_text.clone())
        .unwrap_or_default();
    set_status(&hint, false);
}

fn edit_text() -> String {
    let edit = load_hwnd(&EDIT_HWND);
    unsafe {
        let len = GetWindowTextLengthW(edit);
        if len <= 0 {
            return String::new();
        }
        let mut buf = vec![0u16; len as usize + 1];
        let n = GetWindowTextW(edit, &mut buf);
        String::from_utf16_lossy(&buf[..n.max(0) as usize])
    }
}

fn clear_edit() {
    unsafe {
        let _ = SetWindowTextW(load_hwnd(&EDIT_HWND), w!(""));
    }
}

/// Switches the popup's input context to native (Chinese) mode, best effort.
fn open_ime(edit: HWND) {
    unsafe {
        let himc = ImmGetContext(edit);
        if himc.is_invalid() {
            return;
        }
        let _ = ImmSetOpenStatus(himc, true);
        let mut conversion = IME_CONVERSION_MODE(0);
        let mut sentence = IME_SENTENCE_MODE(0);
        if ImmGetConversionStatus(himc, Some(&mut conversion), Some(&mut sentence)).as_bool() {
            let _ = ImmSetConversionStatus(himc, conversion | IME_CMODE_NATIVE, sentence);
        }
        let _ = ImmReleaseContext(edit, himc);
    }
}

fn is_composing(edit: HWND) -> bool {
    unsafe {
        let himc = ImmGetContext(edit);
        if himc.is_invalid() {
            return false;
        }
        let len = ImmGetCompositionStringW(himc, GCS_COMPSTR, None, 0);
        let _ = ImmReleaseContext(edit, himc);
        len > 0
    }
}

fn activate_popup(main: HWND) {
    let edit = load_hwnd(&EDIT_HWND);
    force_foreground(main);
    unsafe {
        let _ = SetFocus(Some(edit));
        SendMessageW(edit, EM_SETSEL, Some(WPARAM(0)), Some(LPARAM(-1)));
    }
    open_ime(edit);
}

fn show_popup(main: HWND) {
    set_busy(false);
    let target = load_hwnd(&TARGET_HWND);
    place_popup(main, target);
    unsafe {
        let _ = ShowWindow(main, SW_SHOWNOACTIVATE);
    }
    activate_popup(main);
}

fn set_busy(busy: bool) {
    BUSY.store(busy, Ordering::SeqCst);
    unsafe {
        SendMessageW(
            load_hwnd(&EDIT_HWND),
            EM_SETREADONLY,
            Some(WPARAM(busy as usize)),
            Some(LPARAM(0)),
        );
    }
}

/// Forgets the submit the Dart side is working on, so a late answer is ignored.
fn cancel_pending() {
    CURRENT_SUBMIT.store(0, Ordering::SeqCst);
    set_busy(false);
}

/// Hides the popup and hands the focus back to the window it was opened over.
/// `release_modifiers` is for the cancel paths; when sending, the sender thread releases them
/// after waiting for the physical keys to go up.
fn hide_popup(main: HWND, release_modifiers: bool) {
    cancel_pending();
    let target = load_hwnd(&TARGET_HWND);
    unsafe {
        if !target.is_invalid() && IsWindow(Some(target)).as_bool() {
            force_foreground(target);
            // The game last saw the hotkey's modifiers go down; release them so it does not
            // treat them as held (the key-ups went to the popup).
            if release_modifiers {
                send_scan_keys(&release_modifier_keys());
            }
        }
        let _ = ShowWindow(main, SW_HIDE);
    }
}

fn on_hotkey(main: HWND) {
    let hotkey = unpack_hotkey(HOTKEY.load(Ordering::SeqCst));
    if hotkey.alt || hotkey.win {
        tap_dummy_key();
    }
    unsafe {
        let fg = GetForegroundWindow();
        if IsWindowVisible(main).as_bool() {
            if fg == main {
                hide_popup(main, true);
            } else {
                activate_popup(main);
            }
            return;
        }
        if !fg.is_invalid() && fg != main {
            store_hwnd(&TARGET_HWND, fg);
        }
    }
    show_hint();
    show_popup(main);
}

fn on_submit() {
    if SENDING.load(Ordering::SeqCst) || BUSY.load(Ordering::SeqCst) {
        return;
    }
    let text = edit_text();
    if text.trim().is_empty() {
        return;
    }
    let id = SUBMIT_SEQ.fetch_add(1, Ordering::SeqCst) + 1;
    CURRENT_SUBMIT.store(id, Ordering::SeqCst);
    let sending = lock_shared()
        .as_ref()
        .map(|s| s.config.sending_text.clone())
        .unwrap_or_default();
    set_status(&sending, false);
    set_busy(true);
    emit(ImeHotkeyEvent::Submit { id, text });
}

fn failure_code(result: std::result::Result<(), ImeSendFailure>) -> usize {
    match result {
        Ok(()) => 0,
        Err(ImeSendFailure::TargetWindowGone) => 1,
        Err(ImeSendFailure::FocusFailed) => 2,
        Err(ImeSendFailure::FocusLost) => 3,
        Err(ImeSendFailure::ClipboardFailed) => 4,
    }
}

fn failure_from_code(code: usize) -> std::result::Result<(), ImeSendFailure> {
    match code {
        0 => Ok(()),
        1 => Err(ImeSendFailure::TargetWindowGone),
        2 => Err(ImeSendFailure::FocusFailed),
        3 => Err(ImeSendFailure::FocusLost),
        _ => Err(ImeSendFailure::ClipboardFailed),
    }
}

fn on_send(main: HWND) {
    let current = CURRENT_SUBMIT.load(Ordering::SeqCst);
    let pending = lock_shared().as_mut().and_then(|s| {
        let text = s
            .pending_sends
            .drain(..)
            .filter(|(id, _)| *id == current)
            .next_back()
            .map(|(_, text)| text)?;
        Some((text, s.config.clone()))
    });
    // Nothing for the current submit: older answers are dropped.
    let Some((text, config)) = pending else {
        return;
    };
    // A submit is only accepted while not sending, so SENDING cannot be set here.
    let id = current;
    let target = load_hwnd(&TARGET_HWND);
    if target.is_invalid() || !unsafe { IsWindow(Some(target)) }.as_bool() {
        on_send_done(main, failure_code(Err(ImeSendFailure::TargetWindowGone)), id);
        return;
    }
    SENDING.store(true, Ordering::SeqCst);
    hide_popup(main, false);
    let job = SendJob {
        id,
        generation: GENERATION.load(Ordering::SeqCst),
        target,
        text,
        open_chat_before_send: config.open_chat_before_send,
        auto_send: config.auto_send,
        reopen_chat_after_send: config.reopen_chat_after_send,
    };
    let spawned = std::thread::Builder::new()
        .name("ime-hotkey-send".into())
        .spawn(move || {
            let code = failure_code(run_send(&job));
            if GENERATION.load(Ordering::SeqCst) == job.generation {
                post_main(WM_APP_SEND_DONE, code, job.id as isize);
            }
        });
    if spawned.is_err() {
        on_send_done(main, failure_code(Err(ImeSendFailure::FocusFailed)), id);
    }
}

fn on_send_done(main: HWND, code: usize, id: u64) {
    SENDING.store(false, Ordering::SeqCst);
    let reason = match failure_from_code(code) {
        Ok(()) => {
            clear_edit();
            emit(ImeHotkeyEvent::Sent { id });
            return;
        }
        Err(reason) => reason,
    };
    // Keep the text so the user can retry. The Dart side follows up with a message for this
    // submit, so make it current again (hiding the popup had cleared it).
    show_popup(main);
    CURRENT_SUBMIT.store(id, Ordering::SeqCst);
    emit(ImeHotkeyEvent::SendFailed { id, reason });
}

unsafe extern "system" fn edit_proc(hwnd: HWND, msg: u32, wparam: WPARAM, lparam: LPARAM) -> LRESULT {
    match msg {
        WM_KEYDOWN => {
            let vk = wparam.0 as u32;
            if vk == 0x0D && !is_composing(hwnd) {
                on_submit();
                return LRESULT(0);
            }
            if vk == VK_ESCAPE && !is_composing(hwnd) {
                clear_edit();
                hide_popup(load_hwnd(&MAIN_HWND), true);
                return LRESULT(0);
            }
            if vk == 0x41 && unsafe { GetKeyState(VK_CONTROL as i32) } < 0 {
                unsafe { SendMessageW(hwnd, EM_SETSEL, Some(WPARAM(0)), Some(LPARAM(-1))) };
                return LRESULT(0);
            }
        }
        // Swallow the characters of Enter / Esc / Ctrl+A so the edit does not beep.
        WM_CHAR if matches!(wparam.0, 0x0D | 0x1B | 0x01) => return LRESULT(0),
        _ => {}
    }
    let prev: WNDPROC = unsafe { std::mem::transmute(EDIT_PROC.load(Ordering::SeqCst)) };
    unsafe { CallWindowProcW(prev, hwnd, msg, wparam, lparam) }
}

fn ctl_color(wparam: WPARAM, text: u32, bg: u32, brush: HBRUSH) -> LRESULT {
    let hdc = HDC(wparam.0 as *mut _);
    unsafe {
        SetTextColor(hdc, COLORREF(text));
        SetBkColor(hdc, COLORREF(bg));
    }
    LRESULT(brush.0 as isize)
}

fn brushes() -> (HBRUSH, HBRUSH) {
    GDI.lock()
        .unwrap_or_else(|e| e.into_inner())
        .as_ref()
        .map(|GdiHandles(g)| (g.bg_brush, g.edit_brush))
        .unwrap_or_default()
}

unsafe extern "system" fn main_proc(hwnd: HWND, msg: u32, wparam: WPARAM, lparam: LPARAM) -> LRESULT {
    match msg {
        WM_APP_HOTKEY => {
            on_hotkey(hwnd);
            return LRESULT(0);
        }
        WM_APP_SEND => {
            on_send(hwnd);
            return LRESULT(0);
        }
        WM_APP_SEND_DONE => {
            on_send_done(hwnd, wparam.0, lparam.0 as u64);
            return LRESULT(0);
        }
        WM_APP_MESSAGE => {
            let current = CURRENT_SUBMIT.load(Ordering::SeqCst);
            let latest = lock_shared().as_mut().and_then(|s| {
                s.pending_messages
                    .drain(..)
                    .filter(|m| m.id == current && current != 0)
                    .next_back()
            });
            // Messages about an older or cancelled submit are dropped.
            if let Some(m) = latest {
                set_status(&m.text, m.is_error);
                set_busy(m.busy);
            }
            return LRESULT(0);
        }
        WM_APP_CONFIG => {
            if unsafe { IsWindowVisible(hwnd) }.as_bool() && !STATUS_IS_ERROR.load(Ordering::SeqCst) {
                show_hint();
            }
            return LRESULT(0);
        }
        WM_APP_CAPTURED => {
            let pressed = unpack_hotkey(wparam.0 as u64);
            // The key was swallowed, so releasing Alt / Win would look like a lone tap.
            if pressed.alt || pressed.win {
                tap_dummy_key();
            }
            emit(match lparam.0 {
                CAPTURE_OK => ImeHotkeyEvent::HotkeyCaptured {
                    hotkey: Some(pressed),
                },
                CAPTURE_CANCELLED => ImeHotkeyEvent::HotkeyCaptured { hotkey: None },
                _ => ImeHotkeyEvent::HotkeyCaptureRejected,
            });
            return LRESULT(0);
        }
        WM_CTLCOLOREDIT => {
            let (_, edit_brush) = brushes();
            return ctl_color(wparam, COLOR_TEXT, COLOR_EDIT_BG, edit_brush);
        }
        WM_CTLCOLORSTATIC => {
            let (bg_brush, edit_brush) = brushes();
            // A read-only edit (busy) asks for static colors: keep its box, gray out the text.
            if lparam.0 == EDIT_HWND.load(Ordering::SeqCst) {
                return ctl_color(wparam, COLOR_HINT, COLOR_EDIT_BG, edit_brush);
            }
            let color = if STATUS_IS_ERROR.load(Ordering::SeqCst) {
                COLOR_ERROR
            } else {
                COLOR_HINT
            };
            return ctl_color(wparam, color, COLOR_BG, bg_brush);
        }
        WM_NCHITTEST => {
            // Drag the popup by any spot that is not the edit box.
            let hit = unsafe { DefWindowProcW(hwnd, msg, wparam, lparam) };
            if hit.0 == HTCLIENT as isize {
                return LRESULT(HTCAPTION as isize);
            }
            return hit;
        }
        WM_EXITSIZEMOVE => {
            let mut rc = RECT::default();
            if unsafe { GetWindowRect(hwnd, &mut rc) }.is_ok() {
                if let Some(s) = lock_shared().as_mut() {
                    s.config.window_x = Some(rc.left);
                    s.config.window_y = Some(rc.top);
                }
                emit(ImeHotkeyEvent::WindowMoved { x: rc.left, y: rc.top });
            }
            unsafe {
                let _ = SetFocus(Some(load_hwnd(&EDIT_HWND)));
            }
            return LRESULT(0);
        }
        WM_DPICHANGED => {
            let dpi = (wparam.0 & 0xFFFF) as u32;
            apply_dpi(dpi);
            let suggested = unsafe { &*(lparam.0 as *const RECT) };
            let (w, h) = popup_size(dpi);
            unsafe {
                let _ = SetWindowPos(
                    hwnd,
                    None,
                    suggested.left,
                    suggested.top,
                    w,
                    h,
                    SWP_NOZORDER | SWP_NOACTIVATE,
                );
            }
            return LRESULT(0);
        }
        WM_ACTIVATE => {
            let inactive = wparam.0 & 0xFFFF == 0;
            if inactive && !SENDING.load(Ordering::SeqCst) {
                cancel_pending();
                unsafe {
                    let _ = ShowWindow(hwnd, SW_HIDE);
                }
            } else if !inactive {
                unsafe {
                    let _ = SetFocus(Some(load_hwnd(&EDIT_HWND)));
                }
            }
            return LRESULT(0);
        }
        WM_CLOSE => {
            hide_popup(hwnd, true);
            return LRESULT(0);
        }
        _ => {}
    }
    unsafe { DefWindowProcW(hwnd, msg, wparam, lparam) }
}

fn register_class(hinstance: HINSTANCE) {
    static REGISTER: Once = Once::new();
    REGISTER.call_once(|| unsafe {
        let wc = WNDCLASSEXW {
            cbSize: std::mem::size_of::<WNDCLASSEXW>() as u32,
            lpfnWndProc: Some(main_proc),
            hInstance: hinstance,
            hCursor: LoadCursorW(None, IDC_ARROW).unwrap_or_default(),
            lpszClassName: CLASS_NAME,
            ..Default::default()
        };
        RegisterClassExW(&wc);
    });
}

fn create_popup() -> Result<HWND> {
    unsafe {
        let hinstance: HINSTANCE = GetModuleHandleW(None)?.into();
        register_class(hinstance);
        *GDI.lock().unwrap_or_else(|e| e.into_inner()) = Some(GdiHandles(Gdi {
            dpi: 0,
            edit_font: HFONT::default(),
            status_font: HFONT::default(),
            bg_brush: CreateSolidBrush(COLORREF(COLOR_BG)),
            edit_brush: CreateSolidBrush(COLORREF(COLOR_EDIT_BG)),
        }));
        let (w, h) = popup_size(96);
        let main = CreateWindowExW(
            WS_EX_TOPMOST | WS_EX_TOOLWINDOW | WS_EX_LAYERED,
            CLASS_NAME,
            w!("SCToolBox IME"),
            WS_POPUP | WS_BORDER,
            0,
            0,
            w,
            h,
            None,
            None,
            Some(hinstance),
            None,
        )?;
        let _ = SetLayeredWindowAttributes(main, COLORREF(0), 242, LWA_ALPHA);
        let (bg, _) = brushes();
        SetClassLongPtrW(main, GCLP_HBRBACKGROUND, bg.0 as isize);

        let edit = CreateWindowExW(
            WINDOW_EX_STYLE(0),
            w!("EDIT"),
            w!(""),
            WS_CHILD | WS_VISIBLE | WINDOW_STYLE(ES_AUTOHSCROLL),
            0,
            0,
            0,
            0,
            Some(main),
            None,
            Some(hinstance),
            None,
        )?;
        let status = CreateWindowExW(
            WINDOW_EX_STYLE(0),
            w!("STATIC"),
            w!(""),
            WS_CHILD | WS_VISIBLE,
            0,
            0,
            0,
            0,
            Some(main),
            None,
            Some(hinstance),
            None,
        )?;
        SendMessageW(edit, EM_LIMITTEXT, Some(WPARAM(500)), Some(LPARAM(0)));
        store_hwnd(&MAIN_HWND, main);
        store_hwnd(&EDIT_HWND, edit);
        store_hwnd(&STATUS_HWND, status);
        #[cfg(target_pointer_width = "64")]
        let prev = SetWindowLongPtrW(edit, GWLP_WNDPROC, edit_proc as usize as isize);
        #[cfg(target_pointer_width = "32")]
        let prev = SetWindowLongW(edit, GWLP_WNDPROC, edit_proc as usize as i32) as isize;
        EDIT_PROC.store(prev, Ordering::SeqCst);
        apply_dpi(96);
        Ok(main)
    }
}

fn destroy_popup() {
    unsafe {
        let main = load_hwnd(&MAIN_HWND);
        if !main.is_invalid() {
            let _ = DestroyWindow(main);
        }
    }
    MAIN_HWND.store(0, Ordering::SeqCst);
    EDIT_HWND.store(0, Ordering::SeqCst);
    STATUS_HWND.store(0, Ordering::SeqCst);
    TARGET_HWND.store(0, Ordering::SeqCst);
    if let Some(GdiHandles(g)) = GDI.lock().unwrap_or_else(|e| e.into_inner()).take() {
        unsafe {
            for obj in [g.edit_font.0, g.status_font.0, g.bg_brush.0, g.edit_brush.0] {
                if !obj.is_null() {
                    let _ = DeleteObject(HGDIOBJ(obj));
                }
            }
        }
    }
}

fn run_ui_thread(generation: u64, ready: std::sync::mpsc::Sender<Result<u32>>) {
    let startup = (|| -> Result<HHOOK> {
        create_popup()?;
        let hook = unsafe { SetWindowsHookExW(WH_KEYBOARD_LL, Some(keyboard_hook), None, 0) }
            .map_err(|e| anyhow!("SetWindowsHookExW failed: {e}"))?;
        Ok(hook)
    })();
    let hook = match startup {
        Ok(h) => h,
        Err(e) => {
            destroy_popup();
            let _ = ready.send(Err(e));
            return;
        }
    };
    SENDING.store(false, Ordering::SeqCst);
    SWALLOWED_VK.store(0, Ordering::SeqCst);
    let _ = ready.send(Ok(unsafe { GetCurrentThreadId() }));
    println!("[ime_hotkey] started (generation {generation})");

    let mut msg = MSG::default();
    unsafe {
        while GetMessageW(&mut msg, None, 0, 0).as_bool() {
            let _ = TranslateMessage(&msg);
            DispatchMessageW(&msg);
        }
        let _ = UnhookWindowsHookEx(hook);
    }
    destroy_popup();
    SENDING.store(false, Ordering::SeqCst);
    println!("[ime_hotkey] stopped (generation {generation})");
}
