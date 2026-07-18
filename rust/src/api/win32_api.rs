use notify_rust::Notification;

pub fn send_notify(
    summary: Option<String>,
    body: Option<String>,
    app_name: Option<String>,
    app_id: Option<String>,
) -> anyhow::Result<()> {
    let mut n = Notification::new();
    if let Some(summary) = summary {
        n.summary(&summary);
    }
    if let Some(body) = body {
        n.body(&body);
    }
    if let Some(app_name) = app_name {
        n.appname(&app_name);
    }
    #[cfg(target_os = "windows")]
    if let Some(app_id) = app_id {
        n.app_id(&app_id);
    }
    #[cfg(not(target_os = "windows"))]
    println!("send_notify (unix) appid: {:?}", app_id);
    n.show()?;
    Ok(())
}

/// Get system memory size in GB
#[cfg(target_os = "windows")]
pub fn get_system_memory_size_gb() -> anyhow::Result<u64> {
    use std::mem;
    use windows::Win32::System::SystemInformation::{GlobalMemoryStatusEx, MEMORYSTATUSEX};

    unsafe {
        let mut mem_status: MEMORYSTATUSEX = mem::zeroed();
        mem_status.dwLength = mem::size_of::<MEMORYSTATUSEX>() as u32;

        GlobalMemoryStatusEx(&mut mem_status)?;

        // Convert bytes to GB
        Ok(mem_status.ullTotalPhys / (1024 * 1024 * 1024))
    }
}

#[cfg(not(target_os = "windows"))]
pub fn get_system_memory_size_gb() -> anyhow::Result<u64> {
    Ok(0)
}

/// Get number of logical processors
#[cfg(target_os = "windows")]
pub fn get_number_of_logical_processors() -> anyhow::Result<u32> {
    use std::mem;
    use windows::Win32::System::SystemInformation::{GetSystemInfo, SYSTEM_INFO};

    unsafe {
        let mut sys_info: SYSTEM_INFO = mem::zeroed();
        GetSystemInfo(&mut sys_info);
        Ok(sys_info.dwNumberOfProcessors)
    }
}

#[cfg(not(target_os = "windows"))]
pub fn get_number_of_logical_processors() -> anyhow::Result<u32> {
    Ok(0)
}

/// System information struct
#[derive(Debug, Clone)]
pub struct SystemInfo {
    pub os_name: String,
    pub cpu_name: String,
    pub gpu_info: String,
    pub disk_info: String,
}

/// Get all system information at once
#[cfg(target_os = "windows")]
pub fn get_system_info() -> anyhow::Result<SystemInfo> {
    use serde::Deserialize;
    use wmi::WMIConnection;

    #[derive(Deserialize, Debug)]
    #[serde(rename = "Caption")]
    struct OsInfo {
        #[serde(rename = "Caption")]
        caption: Option<String>,
    }

    #[derive(Deserialize, Debug)]
    struct CpuInfo {
        #[serde(rename = "Name")]
        name: Option<String>,
    }

    #[derive(Deserialize, Debug)]
    struct GpuInfo {
        #[serde(rename = "Name")]
        name: Option<String>,
        #[serde(rename = "AdapterRAM")]
        adapter_ram: Option<u64>,
    }

    #[derive(Deserialize, Debug)]
    struct DiskInfo {
        #[serde(rename = "MediaType")]
        media_type: Option<String>,
        #[serde(rename = "Model")]
        model: Option<String>,
        #[serde(rename = "Size")]
        size: Option<u64>,
    }

    let wmi_con = WMIConnection::new()?;

    // Get OS name using raw query
    let os_name = match wmi_con.raw_query::<OsInfo>("SELECT Caption FROM Win32_OperatingSystem") {
        Ok(results) => results
            .first()
            .and_then(|os| os.caption.clone())
            .unwrap_or_default(),
        Err(_) => String::new(),
    };

    // Get CPU name using raw query
    let cpu_name = match wmi_con.raw_query::<CpuInfo>("SELECT Name FROM Win32_Processor") {
        Ok(results) => results
            .first()
            .and_then(|cpu| cpu.name.clone())
            .unwrap_or_default(),
        Err(_) => String::new(),
    };

    // Get GPU info using raw query
    let gpu_info =
        match wmi_con.raw_query::<GpuInfo>("SELECT Name, AdapterRAM FROM Win32_VideoController") {
            Ok(results) => results
                .iter()
                .filter_map(|gpu| {
                    gpu.name.as_ref().map(|name| {
                        let vram_gb = gpu.adapter_ram.unwrap_or(0) / (1024 * 1024 * 1024);
                        format!("{} ({} GB)", name, vram_gb)
                    })
                })
                .collect::<Vec<_>>()
                .join("\n"),
            Err(_) => String::new(),
        };

    // Get Disk info using raw query
    let disk_info =
        match wmi_con.raw_query::<DiskInfo>("SELECT MediaType, Model, Size FROM Win32_DiskDrive") {
            Ok(results) => results
                .iter()
                .filter(|disk| disk.model.is_some())
                .map(|disk| {
                    let size_gb = disk.size.unwrap_or(0) / (1024 * 1024 * 1024);
                    format!(
                        "{}\t{}\t{} GB",
                        disk.media_type.as_deref().unwrap_or(""),
                        disk.model.as_deref().unwrap_or(""),
                        size_gb
                    )
                })
                .collect::<Vec<_>>()
                .join("\n"),
            Err(_) => String::new(),
        };

    Ok(SystemInfo {
        os_name,
        cpu_name,
        gpu_info,
        disk_info,
    })
}

#[cfg(not(target_os = "windows"))]
pub fn get_system_info() -> anyhow::Result<SystemInfo> {
    Ok(SystemInfo {
        os_name: String::new(),
        cpu_name: String::new(),
        gpu_info: String::new(),
        disk_info: String::new(),
    })
}

/// Get GPU info from registry (more accurate VRAM)
#[cfg(target_os = "windows")]
pub fn get_gpu_info_from_registry() -> anyhow::Result<String> {
    use std::mem;
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::System::Registry::{
        RegCloseKey, RegEnumKeyExW, RegOpenKeyExW, RegQueryValueExW, HKEY_LOCAL_MACHINE, KEY_READ,
        REG_VALUE_TYPE,
    };

    let mut result = Vec::new();
    let base_path =
        HSTRING::from(r"SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}");

    unsafe {
        let mut hkey = std::mem::zeroed();
        if RegOpenKeyExW(
            HKEY_LOCAL_MACHINE,
            PCWSTR(base_path.as_ptr()),
            Some(0),
            KEY_READ,
            &mut hkey,
        )
        .is_err()
        {
            return Ok(String::new());
        }

        let mut index = 0u32;
        let mut key_name = [0u16; 256];

        loop {
            let mut key_name_len = key_name.len() as u32;
            if RegEnumKeyExW(
                hkey,
                index,
                Some(windows::core::PWSTR::from_raw(key_name.as_mut_ptr())),
                &mut key_name_len,
                None,
                None,
                None,
                None,
            )
            .is_err()
            {
                break;
            }

            let subkey_name = String::from_utf16_lossy(&key_name[..key_name_len as usize]);

            // Only process numbered subkeys (0000, 0001, etc.)
            if subkey_name.chars().all(|c| c.is_ascii_digit()) {
                let full_path = HSTRING::from(format!(
                    r"SYSTEM\ControlSet001\Control\Class\{{4d36e968-e325-11ce-bfc1-08002be10318}}\{}",
                    subkey_name
                ));

                let mut subkey = mem::zeroed();
                if RegOpenKeyExW(
                    HKEY_LOCAL_MACHINE,
                    PCWSTR(full_path.as_ptr()),
                    Some(0),
                    KEY_READ,
                    &mut subkey,
                )
                .is_ok()
                {
                    // Read adapter string
                    let adapter_name = HSTRING::from("HardwareInformation.AdapterString");
                    let mut adapter_buffer = [0u16; 512];
                    let mut adapter_size = (adapter_buffer.len() * 2) as u32;
                    let mut adapter_type = REG_VALUE_TYPE::default();

                    let adapter_string = if RegQueryValueExW(
                        subkey,
                        PCWSTR(adapter_name.as_ptr()),
                        None,
                        Some(&mut adapter_type),
                        Some(adapter_buffer.as_mut_ptr() as *mut u8),
                        Some(&mut adapter_size),
                    )
                    .is_ok()
                    {
                        let len = (adapter_size as usize / 2).saturating_sub(1);
                        String::from_utf16_lossy(&adapter_buffer[..len])
                    } else {
                        String::new()
                    };

                    // Read memory size
                    let mem_name = HSTRING::from("HardwareInformation.qwMemorySize");
                    let mut mem_value: u64 = 0;
                    let mut mem_size = std::mem::size_of::<u64>() as u32;
                    let mut mem_type = REG_VALUE_TYPE::default();

                    let vram_gb = if RegQueryValueExW(
                        subkey,
                        PCWSTR(mem_name.as_ptr()),
                        None,
                        Some(&mut mem_type),
                        Some(&mut mem_value as *mut u64 as *mut u8),
                        Some(&mut mem_size),
                    )
                    .is_ok()
                    {
                        mem_value / (1024 * 1024 * 1024)
                    } else {
                        0
                    };

                    if !adapter_string.is_empty() {
                        result.push(format!("Model: {}\nVRAM (GB): {}", adapter_string, vram_gb));
                    }

                    let _ = RegCloseKey(subkey);
                }
            }

            index += 1;
        }

        let _ = RegCloseKey(hkey);
    }

    Ok(result.join("\n\n"))
}

#[cfg(not(target_os = "windows"))]
pub fn get_gpu_info_from_registry() -> anyhow::Result<String> {
    Ok(String::new())
}

/// Resolve shortcut (.lnk) file to get target path
#[cfg(target_os = "windows")]
pub fn resolve_shortcut(lnk_path: String) -> anyhow::Result<String> {
    use windows::core::{Interface, HSTRING};
    use windows::Win32::System::Com::IPersistFile;
    use windows::Win32::System::Com::{
        CoCreateInstance, CoInitializeEx, CoUninitialize, CLSCTX_INPROC_SERVER,
        COINIT_APARTMENTTHREADED, STGM_READ,
    };
    use windows::Win32::UI::Shell::{IShellLinkW, ShellLink};

    unsafe {
        // Initialize COM
        let _ = CoInitializeEx(None, COINIT_APARTMENTTHREADED);

        let result = (|| -> anyhow::Result<String> {
            // Create ShellLink instance
            let shell_link: IShellLinkW = CoCreateInstance(&ShellLink, None, CLSCTX_INPROC_SERVER)?;

            // Get IPersistFile interface
            let persist_file: IPersistFile = shell_link.cast()?;

            // Load the shortcut file
            let lnk_path_w = HSTRING::from(&lnk_path);
            persist_file.Load(windows::core::PCWSTR(lnk_path_w.as_ptr()), STGM_READ)?;

            // Get target path
            let mut path_buffer = [0u16; 260];
            shell_link.GetPath(&mut path_buffer, std::ptr::null_mut(), 0)?;

            let path = String::from_utf16_lossy(
                &path_buffer[..path_buffer
                    .iter()
                    .position(|&c| c == 0)
                    .unwrap_or(path_buffer.len())],
            );

            Ok(path)
        })();

        CoUninitialize();
        result
    }
}

#[cfg(not(target_os = "windows"))]
pub fn resolve_shortcut(_lnk_path: String) -> anyhow::Result<String> {
    Ok(String::new())
}

/// Open file explorer and select file/folder
#[cfg(target_os = "windows")]
pub fn open_dir_with_explorer(path: &str, is_file: bool) -> anyhow::Result<()> {
    use std::process::Command;

    let args = if is_file {
        vec!["/select,", path]
    } else {
        vec![path]
    };
    Command::new("explorer.exe").args(args).spawn()?;

    Ok(())
}

#[cfg(not(target_os = "windows"))]
pub fn open_dir_with_explorer(path: &str, is_file: bool) -> anyhow::Result<()> {
    println!(
        "open_dir_with_explorer (unix): {} is_file={}",
        path, is_file
    );
    Ok(())
}

#[cfg(target_os = "windows")]
pub fn set_foreground_window(window_name: &str) -> anyhow::Result<bool> {
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::Foundation::HWND;
    use windows::Win32::UI::WindowsAndMessaging;
    let window_name_p: PCWSTR = PCWSTR(HSTRING::from(window_name).as_ptr());
    let h = unsafe { WindowsAndMessaging::FindWindowW(PCWSTR::null(), window_name_p)? };
    if h == HWND::default() {
        return Ok(false);
    }
    let sr = unsafe { WindowsAndMessaging::ShowWindow(h, WindowsAndMessaging::SW_RESTORE) };
    if !sr.as_bool() {
        return Ok(false);
    }
    let r = unsafe { WindowsAndMessaging::SetForegroundWindow(h) };
    Ok(r.as_bool())
}

#[cfg(not(target_os = "windows"))]
pub fn set_foreground_window(window_name: &str) -> anyhow::Result<bool> {
    println!("set_foreground_window (unix): {}", window_name);
    return Ok(false);
}

#[derive(Debug, Clone)]
pub struct ProcessInfo {
    pub pid: u32,
    pub name: String,
    pub path: String,
}

#[cfg(target_os = "windows")]
pub fn get_process_pid_by_name(process_name: &str) -> anyhow::Result<i32> {
    // 保持向后兼容：返回第一个匹配进程的 PID
    let processes = get_process_list_by_name(process_name)?;
    if let Some(first) = processes.first() {
        Ok(first.pid as i32)
    } else {
        Ok(-1)
    }
}

#[cfg(not(target_os = "windows"))]
pub fn get_process_pid_by_name(process_name: &str) -> anyhow::Result<i32> {
    println!("get_process_pid_by_name (unix): {}", process_name);
    Ok(-1)
}

#[cfg(target_os = "windows")]
pub fn get_process_list_by_name(process_name: &str) -> anyhow::Result<Vec<ProcessInfo>> {
    use std::mem;
    use windows::Win32::Foundation::CloseHandle;
    use windows::Win32::System::Diagnostics::ToolHelp::{
        CreateToolhelp32Snapshot, Process32FirstW, Process32NextW, PROCESSENTRY32W,
        TH32CS_SNAPPROCESS,
    };

    let mut result = Vec::new();
    let search_lower = process_name.to_lowercase();

    unsafe {
        let snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)?;
        if snapshot.is_invalid() {
            return Ok(result);
        }

        let mut process_entry: PROCESSENTRY32W = mem::zeroed();
        process_entry.dwSize = mem::size_of::<PROCESSENTRY32W>() as u32;

        if Process32FirstW(snapshot, &mut process_entry).is_err() {
            let _ = CloseHandle(snapshot);
            return Ok(result);
        }

        loop {
            // 将 WCHAR 数组转换为 String
            let exe_file = String::from_utf16_lossy(
                &process_entry.szExeFile[..process_entry
                    .szExeFile
                    .iter()
                    .position(|&c| c == 0)
                    .unwrap_or(process_entry.szExeFile.len())],
            );

            // 支持部分匹配（不区分大小写）
            if exe_file.to_lowercase().contains(&search_lower) {
                let pid = process_entry.th32ProcessID;

                // 获取完整路径
                let full_path = get_process_path(pid).unwrap_or_default();

                result.push(ProcessInfo {
                    pid,
                    name: exe_file,
                    path: full_path,
                });
            }

            if Process32NextW(snapshot, &mut process_entry).is_err() {
                break;
            }
        }

        let _ = CloseHandle(snapshot);
    }

    Ok(result)
}

#[cfg(target_os = "windows")]
fn get_process_path(pid: u32) -> Option<String> {
    use windows::core::PWSTR;
    use windows::Win32::Foundation::{CloseHandle, MAX_PATH};
    use windows::Win32::System::Threading::{
        OpenProcess, QueryFullProcessImageNameW, PROCESS_NAME_WIN32,
        PROCESS_QUERY_LIMITED_INFORMATION,
    };

    unsafe {
        if let Ok(h_process) = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, false, pid) {
            if !h_process.is_invalid() {
                let mut path_buffer = [0u16; MAX_PATH as usize];
                let mut path_len = path_buffer.len() as u32;

                let result = if QueryFullProcessImageNameW(
                    h_process,
                    PROCESS_NAME_WIN32,
                    PWSTR::from_raw(path_buffer.as_mut_ptr()),
                    &mut path_len,
                )
                .is_ok()
                    && path_len > 0
                {
                    Some(String::from_utf16_lossy(&path_buffer[..path_len as usize]))
                } else {
                    None
                };

                let _ = CloseHandle(h_process);
                return result;
            }
        }
    }

    None
}

#[cfg(not(target_os = "windows"))]
pub fn get_process_list_by_name(process_name: &str) -> anyhow::Result<Vec<ProcessInfo>> {
    println!("get_process_list_by_name (unix): {}", process_name);
    Ok(Vec::new())
}

#[cfg(target_os = "windows")]
struct CloseWindowContext {
    pid: u32,
    requests_sent: u32,
}

#[cfg(target_os = "windows")]
unsafe extern "system" fn close_process_window(
    hwnd: windows::Win32::Foundation::HWND,
    lparam: windows::Win32::Foundation::LPARAM,
) -> windows::core::BOOL {
    use windows::core::BOOL;
    use windows::Win32::Foundation::{LPARAM, WPARAM};
    use windows::Win32::UI::WindowsAndMessaging::{
        GetWindowThreadProcessId, PostMessageW, WM_CLOSE,
    };

    let context = &mut *(lparam.0 as *mut CloseWindowContext);
    let mut window_pid = 0u32;
    GetWindowThreadProcessId(hwnd, Some(&mut window_pid));
    if window_pid == context.pid && PostMessageW(Some(hwnd), WM_CLOSE, WPARAM(0), LPARAM(0)).is_ok()
    {
        context.requests_sent += 1;
    }
    BOOL(1)
}

#[cfg(target_os = "windows")]
fn request_process_close(pid: u32) -> anyhow::Result<u32> {
    use windows::Win32::Foundation::LPARAM;
    use windows::Win32::UI::WindowsAndMessaging::EnumWindows;

    let mut context = CloseWindowContext {
        pid,
        requests_sent: 0,
    };
    unsafe {
        EnumWindows(
            Some(close_process_window),
            LPARAM((&mut context as *mut CloseWindowContext) as isize),
        )?;
    }
    Ok(context.requests_sent)
}

fn process_name_matches(process_name: &str, executable_name: &str) -> bool {
    let requested = process_name.strip_suffix(".exe").unwrap_or(process_name);
    let executable = executable_name
        .strip_suffix(".exe")
        .unwrap_or(executable_name);
    requested.eq_ignore_ascii_case(executable)
}

/// Ask matching GUI processes to exit normally, then force-terminate only
/// processes that do not exit before the grace period expires.
#[cfg(target_os = "windows")]
pub fn kill_process_by_name(process_name: &str) -> anyhow::Result<u32> {
    use windows::Win32::Foundation::{CloseHandle, WAIT_OBJECT_0};
    use windows::Win32::System::Threading::{
        OpenProcess, TerminateProcess, WaitForSingleObject, PROCESS_SYNCHRONIZE, PROCESS_TERMINATE,
    };

    const GRACEFUL_EXIT_TIMEOUT_MS: u32 = 15_000;
    const FORCED_EXIT_TIMEOUT_MS: u32 = 5_000;

    let processes = get_process_list_by_name(process_name)?;
    let mut killed_count = 0u32;

    for process in processes
        .into_iter()
        .filter(|process| process_name_matches(process_name, &process.name))
    {
        unsafe {
            if let Ok(h_process) =
                OpenProcess(PROCESS_TERMINATE | PROCESS_SYNCHRONIZE, false, process.pid)
            {
                if !h_process.is_invalid() {
                    let close_requested = request_process_close(process.pid).unwrap_or(0) > 0;
                    if close_requested
                        && WaitForSingleObject(h_process, GRACEFUL_EXIT_TIMEOUT_MS) == WAIT_OBJECT_0
                    {
                        killed_count += 1;
                        let _ = CloseHandle(h_process);
                        continue;
                    }
                    if TerminateProcess(h_process, 0).is_ok() {
                        let _ = WaitForSingleObject(h_process, FORCED_EXIT_TIMEOUT_MS);
                        killed_count += 1;
                    }
                    let _ = CloseHandle(h_process);
                }
            }
        }
    }

    Ok(killed_count)
}

#[cfg(not(target_os = "windows"))]
pub fn kill_process_by_name(process_name: &str) -> anyhow::Result<u32> {
    println!("kill_process_by_name (unix): {}", process_name);
    Ok(0)
}

/// Get disk physical sector size for performance
#[cfg(target_os = "windows")]
pub fn get_disk_physical_sector_size(drive_letter: &str) -> anyhow::Result<u32> {
    use std::mem;
    use windows::core::HSTRING;
    use windows::Win32::Foundation::CloseHandle;
    use windows::Win32::Storage::FileSystem::{
        CreateFileW, FILE_SHARE_READ, FILE_SHARE_WRITE, OPEN_EXISTING,
    };
    use windows::Win32::System::Ioctl::IOCTL_STORAGE_QUERY_PROPERTY;
    use windows::Win32::System::IO::DeviceIoControl;

    // STORAGE_PROPERTY_QUERY structure
    #[repr(C)]
    struct StoragePropertyQuery {
        property_id: u32,
        query_type: u32,
        additional_parameters: [u8; 1],
    }

    // STORAGE_ACCESS_ALIGNMENT_DESCRIPTOR structure
    #[repr(C)]
    struct StorageAccessAlignmentDescriptor {
        version: u32,
        size: u32,
        bytes_per_cache_line: u32,
        bytes_offset_for_cache_alignment: u32,
        bytes_per_logical_sector: u32,
        bytes_per_physical_sector: u32,
        bytes_offset_for_sector_alignment: u32,
    }

    let drive_path = format!(r"\\.\{}:", drive_letter.chars().next().unwrap_or('C'));
    let drive_path_w = HSTRING::from(&drive_path);

    unsafe {
        let handle = CreateFileW(
            &drive_path_w,
            0, // No access needed, just query
            FILE_SHARE_READ | FILE_SHARE_WRITE,
            None,
            OPEN_EXISTING,
            windows::Win32::Storage::FileSystem::FILE_FLAGS_AND_ATTRIBUTES(0),
            None,
        )?;

        if handle.is_invalid() {
            return Err(anyhow::anyhow!("Failed to open drive"));
        }

        // StorageAccessAlignmentProperty = 6
        let query = StoragePropertyQuery {
            property_id: 6,
            query_type: 0, // PropertyStandardQuery
            additional_parameters: [0],
        };

        let mut descriptor: StorageAccessAlignmentDescriptor = mem::zeroed();
        let mut bytes_returned: u32 = 0;

        let result = DeviceIoControl(
            handle,
            IOCTL_STORAGE_QUERY_PROPERTY,
            Some(&query as *const _ as *const std::ffi::c_void),
            mem::size_of::<StoragePropertyQuery>() as u32,
            Some(&mut descriptor as *mut _ as *mut std::ffi::c_void),
            mem::size_of::<StorageAccessAlignmentDescriptor>() as u32,
            Some(&mut bytes_returned),
            None,
        );

        let _ = CloseHandle(handle);

        if result.is_ok() {
            Ok(descriptor.bytes_per_physical_sector)
        } else {
            Err(anyhow::anyhow!("DeviceIoControl failed"))
        }
    }
}

#[cfg(not(target_os = "windows"))]
pub fn get_disk_physical_sector_size(drive_letter: &str) -> anyhow::Result<u32> {
    println!("get_disk_physical_sector_size (unix): {}", drive_letter);
    Ok(0)
}

/// Create a desktop shortcut
#[cfg(target_os = "windows")]
pub fn create_desktop_shortcut(target_path: &str, shortcut_name: &str) -> anyhow::Result<()> {
    use windows::core::{Interface, BSTR, HSTRING};
    use windows::Win32::System::Com::IPersistFile;
    use windows::Win32::System::Com::{
        CoCreateInstance, CoInitializeEx, CoUninitialize, CLSCTX_INPROC_SERVER,
        COINIT_APARTMENTTHREADED,
    };
    use windows::Win32::UI::Shell::{
        FOLDERID_Desktop, IShellLinkW, SHGetKnownFolderPath, ShellLink,
    };

    unsafe {
        let _ = CoInitializeEx(None, COINIT_APARTMENTTHREADED);

        let result = (|| -> anyhow::Result<()> {
            // Get desktop path
            let desktop_path = SHGetKnownFolderPath(
                &FOLDERID_Desktop,
                windows::Win32::UI::Shell::KNOWN_FOLDER_FLAG(0),
                None,
            )?;
            let desktop_str = desktop_path.to_string()?;

            // Create ShellLink instance
            let shell_link: IShellLinkW = CoCreateInstance(&ShellLink, None, CLSCTX_INPROC_SERVER)?;

            // Set target path
            let target_w = HSTRING::from(target_path);
            shell_link.SetPath(&target_w)?;

            // Get IPersistFile interface
            let persist_file: IPersistFile = shell_link.cast()?;

            // Create shortcut file path
            let shortcut_path = format!("{}\\{}", desktop_str, shortcut_name);
            let shortcut_w = BSTR::from(&shortcut_path);

            // Save shortcut
            persist_file.Save(windows::core::PCWSTR(shortcut_w.as_ptr()), true)?;

            Ok(())
        })();

        CoUninitialize();
        result
    }
}

#[cfg(not(target_os = "windows"))]
pub fn create_desktop_shortcut(target_path: &str, shortcut_name: &str) -> anyhow::Result<()> {
    println!(
        "create_desktop_shortcut (unix): {} -> {}",
        target_path, shortcut_name
    );
    Ok(())
}

/// Run a program with admin privileges (UAC)
#[cfg(target_os = "windows")]
pub fn run_as_admin(program: &str, args: &str) -> anyhow::Result<()> {
    use windows::core::HSTRING;
    use windows::Win32::UI::Shell::ShellExecuteW;
    use windows::Win32::UI::WindowsAndMessaging::SW_SHOWNORMAL;

    let operation = HSTRING::from("runas");
    let file = HSTRING::from(program);
    let parameters = HSTRING::from(args);

    unsafe {
        let result = ShellExecuteW(None, &operation, &file, &parameters, None, SW_SHOWNORMAL);

        // ShellExecuteW returns a value > 32 on success
        if result.0 as usize > 32 {
            Ok(())
        } else {
            Err(anyhow::anyhow!(
                "ShellExecuteW failed with code: {}",
                result.0 as usize
            ))
        }
    }
}

#[cfg(not(target_os = "windows"))]
pub fn run_as_admin(program: &str, args: &str) -> anyhow::Result<()> {
    println!("run_as_admin (unix): {} {}", program, args);
    Ok(())
}

fn quote_windows_argument(argument: &str) -> String {
    if !argument.is_empty()
        && !argument
            .chars()
            .any(|character| character.is_whitespace() || character == '"')
    {
        return argument.to_string();
    }

    let mut quoted = String::from("\"");
    let mut backslashes = 0usize;
    for character in argument.chars() {
        if character == '\\' {
            backslashes += 1;
            continue;
        }
        if character == '"' {
            quoted.push_str(&"\\".repeat(backslashes * 2 + 1));
            quoted.push('"');
        } else {
            quoted.push_str(&"\\".repeat(backslashes));
            quoted.push(character);
        }
        backslashes = 0;
    }
    quoted.push_str(&"\\".repeat(backslashes * 2));
    quoted.push('"');
    quoted
}

/// Run a program with admin privileges, wait for it to exit, and return its exit code.
#[cfg(target_os = "windows")]
pub fn run_as_admin_and_wait(
    program: &str,
    args: Vec<String>,
    timeout_ms: u32,
) -> anyhow::Result<u32> {
    use std::mem::size_of;
    use std::path::Path;
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::Foundation::{CloseHandle, WAIT_OBJECT_0, WAIT_TIMEOUT};
    use windows::Win32::System::Threading::{GetExitCodeProcess, WaitForSingleObject};
    use windows::Win32::UI::Shell::{ShellExecuteExW, SEE_MASK_NOCLOSEPROCESS, SHELLEXECUTEINFOW};
    use windows::Win32::UI::WindowsAndMessaging::SW_SHOWNORMAL;

    let operation = HSTRING::from("runas");
    let file = HSTRING::from(program);
    let parameters = HSTRING::from(
        args.iter()
            .map(|argument| quote_windows_argument(argument))
            .collect::<Vec<_>>()
            .join(" "),
    );
    let working_directory = Path::new(program)
        .parent()
        .filter(|path| !path.as_os_str().is_empty())
        .map(|path| HSTRING::from(path.to_string_lossy().as_ref()));

    unsafe {
        let mut execute_info = SHELLEXECUTEINFOW {
            cbSize: size_of::<SHELLEXECUTEINFOW>() as u32,
            fMask: SEE_MASK_NOCLOSEPROCESS,
            lpVerb: PCWSTR(operation.as_ptr()),
            lpFile: PCWSTR(file.as_ptr()),
            lpParameters: PCWSTR(parameters.as_ptr()),
            lpDirectory: working_directory
                .as_ref()
                .map_or(PCWSTR::null(), |directory| PCWSTR(directory.as_ptr())),
            nShow: SW_SHOWNORMAL.0,
            ..Default::default()
        };
        ShellExecuteExW(&mut execute_info)?;
        let process = execute_info.hProcess;
        if process.is_invalid() {
            return Err(anyhow::anyhow!(
                "ShellExecuteExW succeeded without returning a process handle"
            ));
        }

        let result = match WaitForSingleObject(process, timeout_ms) {
            WAIT_OBJECT_0 => {
                let mut exit_code = 0u32;
                match GetExitCodeProcess(process, &mut exit_code) {
                    Ok(()) => Ok(exit_code),
                    Err(error) => Err(error.into()),
                }
            }
            WAIT_TIMEOUT => Err(anyhow::anyhow!(
                "Elevated process did not exit within {} ms",
                timeout_ms
            )),
            wait_result => Err(anyhow::anyhow!(
                "WaitForSingleObject failed with result {}",
                wait_result.0
            )),
        };
        let _ = CloseHandle(process);
        result
    }
}

#[cfg(not(target_os = "windows"))]
pub fn run_as_admin_and_wait(
    program: &str,
    args: Vec<String>,
    _timeout_ms: u32,
) -> anyhow::Result<u32> {
    use std::process::Command;

    let status = Command::new(program).args(args).status()?;
    status
        .code()
        .map(|code| code as u32)
        .ok_or_else(|| anyhow::anyhow!("Process exited without an exit code"))
}

/// Write a DWORD value below HKEY_CURRENT_USER, creating the key if necessary.
#[cfg(target_os = "windows")]
pub fn set_current_user_registry_dword(
    key_path: &str,
    value_name: &str,
    value: u32,
) -> anyhow::Result<()> {
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::System::Registry::{
        RegCloseKey, RegCreateKeyExW, RegSetValueExW, HKEY_CURRENT_USER, KEY_SET_VALUE, REG_DWORD,
        REG_OPTION_NON_VOLATILE,
    };

    let key_path = HSTRING::from(key_path);
    let value_name = HSTRING::from(value_name);
    unsafe {
        let mut key = std::mem::zeroed();
        let create_result = RegCreateKeyExW(
            HKEY_CURRENT_USER,
            PCWSTR(key_path.as_ptr()),
            Some(0),
            PCWSTR::null(),
            REG_OPTION_NON_VOLATILE,
            KEY_SET_VALUE,
            None,
            &mut key,
            None,
        );
        if create_result.is_err() {
            return Err(anyhow::anyhow!(
                "Failed to create or open HKCU registry key: {:?}",
                create_result
            ));
        }

        let bytes = value.to_le_bytes();
        let set_result = RegSetValueExW(
            key,
            PCWSTR(value_name.as_ptr()),
            Some(0),
            REG_DWORD,
            Some(&bytes),
        );
        let _ = RegCloseKey(key);
        if set_result.is_err() {
            return Err(anyhow::anyhow!(
                "Failed to set HKCU registry value: {:?}",
                set_result
            ));
        }
        Ok(())
    }
}

#[cfg(not(target_os = "windows"))]
pub fn set_current_user_registry_dword(
    _key_path: &str,
    _value_name: &str,
    _value: u32,
) -> anyhow::Result<()> {
    Ok(())
}

/// Start a program (without waiting)
#[cfg(target_os = "windows")]
pub fn start_process(program: &str, args: Vec<String>) -> anyhow::Result<()> {
    use std::process::Command;

    Command::new(program).args(&args).spawn()?;

    Ok(())
}

#[cfg(not(target_os = "windows"))]
pub fn start_process(program: &str, args: Vec<String>) -> anyhow::Result<()> {
    println!("start_process (unix): {} {:?}", program, args);
    Ok(())
}

// ============== NVME Patch Functions ==============
#[cfg(target_os = "windows")]
const NVME_REGISTRY_PATH: &str = r"SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device";
#[cfg(target_os = "windows")]
const NVME_VALUE_NAME: &str = "ForcedPhysicalSectorSizeInBytes";

/// Check if NVME patch is applied
#[cfg(target_os = "windows")]
pub fn check_nvme_patch_status() -> anyhow::Result<bool> {
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::System::Registry::{
        RegCloseKey, RegOpenKeyExW, RegQueryValueExW, HKEY_LOCAL_MACHINE, KEY_READ, REG_VALUE_TYPE,
    };

    unsafe {
        let path = HSTRING::from(NVME_REGISTRY_PATH);
        let mut hkey = std::mem::zeroed();

        // Try to open the registry key
        if RegOpenKeyExW(
            HKEY_LOCAL_MACHINE,
            PCWSTR(path.as_ptr()),
            Some(0),
            KEY_READ,
            &mut hkey,
        )
        .is_err()
        {
            return Ok(false);
        }

        // Query the value
        let value_name = HSTRING::from(NVME_VALUE_NAME);
        let mut buffer = [0u8; 1024];
        let mut size = buffer.len() as u32;
        let mut value_type = REG_VALUE_TYPE::default();

        let result = if RegQueryValueExW(
            hkey,
            PCWSTR(value_name.as_ptr()),
            None,
            Some(&mut value_type),
            Some(buffer.as_mut_ptr()),
            Some(&mut size),
        )
        .is_ok()
        {
            // Check if the value contains "* 4095"
            // REG_MULTI_SZ is stored as null-terminated wide strings
            let data = String::from_utf16_lossy(std::slice::from_raw_parts(
                buffer.as_ptr() as *const u16,
                size as usize / 2,
            ));
            data.contains("* 4095")
        } else {
            false
        };

        let _ = RegCloseKey(hkey);
        Ok(result)
    }
}

#[cfg(not(target_os = "windows"))]
pub fn check_nvme_patch_status() -> anyhow::Result<bool> {
    Ok(false)
}

/// Add NVME patch to registry
#[cfg(target_os = "windows")]
pub fn add_nvme_patch() -> anyhow::Result<()> {
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::System::Registry::{
        RegCloseKey, RegOpenKeyExW, RegSetValueExW, HKEY_LOCAL_MACHINE, KEY_WRITE, REG_MULTI_SZ,
    };

    unsafe {
        let path = HSTRING::from(NVME_REGISTRY_PATH);
        let mut hkey = std::mem::zeroed();

        // Open the registry key with write access
        let open_result = RegOpenKeyExW(
            HKEY_LOCAL_MACHINE,
            PCWSTR(path.as_ptr()),
            Some(0),
            KEY_WRITE,
            &mut hkey,
        );
        if open_result.is_err() {
            return Err(anyhow::anyhow!(
                "Failed to open registry key: {:?}",
                open_result
            ));
        }

        // Prepare the value: "* 4095" as REG_MULTI_SZ (double null terminated)
        let value_str = "* 4095\0\0";
        let value_wide: Vec<u16> = value_str.encode_utf16().collect();
        let value_name = HSTRING::from(NVME_VALUE_NAME);

        let result = RegSetValueExW(
            hkey,
            PCWSTR(value_name.as_ptr()),
            Some(0),
            REG_MULTI_SZ,
            Some(std::slice::from_raw_parts(
                value_wide.as_ptr() as *const u8,
                value_wide.len() * 2,
            )),
        );

        let _ = RegCloseKey(hkey);

        if result.is_err() {
            return Err(anyhow::anyhow!(
                "Failed to set registry value: {:?}",
                result
            ));
        }
        Ok(())
    }
}

#[cfg(not(target_os = "windows"))]
pub fn add_nvme_patch() -> anyhow::Result<()> {
    Err(anyhow::anyhow!("NVME patch is only supported on Windows"))
}

/// Remove NVME patch from registry
#[cfg(target_os = "windows")]
pub fn remove_nvme_patch() -> anyhow::Result<()> {
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::Foundation::ERROR_FILE_NOT_FOUND;
    use windows::Win32::System::Registry::{
        RegCloseKey, RegDeleteValueW, RegOpenKeyExW, HKEY_LOCAL_MACHINE, KEY_WRITE,
    };

    unsafe {
        let path = HSTRING::from(NVME_REGISTRY_PATH);
        let mut hkey = std::mem::zeroed();

        // Open the registry key with write access
        let open_result = RegOpenKeyExW(
            HKEY_LOCAL_MACHINE,
            PCWSTR(path.as_ptr()),
            Some(0),
            KEY_WRITE,
            &mut hkey,
        );
        if open_result.is_err() {
            return Err(anyhow::anyhow!(
                "Failed to open registry key: {:?}",
                open_result
            ));
        }

        let value_name = HSTRING::from(NVME_VALUE_NAME);

        let result = RegDeleteValueW(hkey, PCWSTR(value_name.as_ptr()));

        let _ = RegCloseKey(hkey);

        // It's OK if the value doesn't exist
        if result.is_err() && result != ERROR_FILE_NOT_FOUND {
            return Err(anyhow::anyhow!(
                "Failed to delete registry value: {:?}",
                result
            ));
        }

        Ok(())
    }
}

#[cfg(not(target_os = "windows"))]
pub fn remove_nvme_patch() -> anyhow::Result<()> {
    Err(anyhow::anyhow!("NVME patch is only supported on Windows"))
}

/// Copy image data to clipboard
pub fn set_clipboard_image(image_data: Vec<u8>) -> anyhow::Result<()> {
    use clipboard_rs::common::RustImage;
    use clipboard_rs::{Clipboard, ClipboardContext, RustImageData};

    let clipboard = ClipboardContext::new().map_err(|e| anyhow::anyhow!("{}", e))?;

    // Create RustImageData from bytes
    let img = RustImageData::from_bytes(&image_data).map_err(|e| anyhow::anyhow!("{}", e))?;

    clipboard
        .set_image(img)
        .map_err(|e| anyhow::anyhow!("{}", e))?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{process_name_matches, quote_windows_argument};

    #[test]
    fn process_name_match_is_exact_and_ignores_exe_suffix() {
        assert!(process_name_matches("StarCitizen", "StarCitizen.exe"));
        assert!(process_name_matches("starcitizen.exe", "StarCitizen.exe"));
        assert!(!process_name_matches(
            "StarCitizen",
            "StarCitizen_Launcher.exe"
        ));
    }

    #[test]
    fn windows_arguments_are_quoted_for_shell_execute() {
        assert_eq!(quote_windows_argument("install"), "install");
        assert_eq!(quote_windows_argument(""), "\"\"");
        assert_eq!(quote_windows_argument("product id"), "\"product id\"");
        assert_eq!(
            quote_windows_argument(r#"value\with\"quote"#),
            r#""value\with\\\"quote""#
        );
        assert_eq!(
            quote_windows_argument(r#"trailing slash\"#),
            r#""trailing slash\\""#
        );
    }
}
