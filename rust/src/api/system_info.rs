use flutter_rust_bridge::frb;
use std::process::Command;

#[cfg(target_os = "windows")]
use winapi::um::sysinfoapi::{GetSystemInfo, SYSTEM_INFO};
#[cfg(target_os = "windows")]
use winapi::um::winnt::HKEY_LOCAL_MACHINE;
#[cfg(target_os = "windows")]
use winapi::um::winreg::{RegCloseKey, RegOpenKeyExW, RegQueryValueExW, KEY_READ};
#[cfg(target_os = "windows")]
use widestring::U16CString;

/// Get the system OS name
#[frb(sync)]
pub fn get_system_name() -> anyhow::Result<String> {
    #[cfg(target_os = "windows")]
    {
        use winapi::um::sysinfoapi::{GetVersionExW, OSVERSIONINFOW};
        use winapi::um::winnt::VER_NT_WORKSTATION;
        
        // Try to get Windows version information
        unsafe {
            let mut version_info: OSVERSIONINFOW = std::mem::zeroed();
            version_info.dwOSVersionInfoSize = std::mem::size_of::<OSVERSIONINFOW>() as u32;
            
            if GetVersionExW(&mut version_info) != 0 {
                // Basic Windows version detection
                match (version_info.dwMajorVersion, version_info.dwMinorVersion) {
                    (10, 0) => {
                        // Windows 10/11 - need to check build number for more precise detection
                        if version_info.dwBuildNumber >= 22000 {
                            return Ok("Windows 11".to_string());
                        } else {
                            return Ok("Windows 10".to_string());
                        }
                    }
                    (6, 3) => return Ok("Windows 8.1".to_string()),
                    (6, 2) => return Ok("Windows 8".to_string()),
                    (6, 1) => return Ok("Windows 7".to_string()),
                    (6, 0) => return Ok("Windows Vista".to_string()),
                    _ => return Ok(format!("Windows {}.{}", version_info.dwMajorVersion, version_info.dwMinorVersion)),
                }
            }
        }
        
        // Fallback method
        Ok("Windows".to_string())
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        // For non-Windows systems, try to get OS info
        if let Ok(output) = Command::new("uname").arg("-s").output() {
            return Ok(String::from_utf8_lossy(&output.stdout).trim().to_string());
        }
        Ok("Unknown".to_string())
    }
}

/// Get the CPU name/model
#[frb(sync)]
pub fn get_cpu_name() -> anyhow::Result<String> {
    #[cfg(target_os = "windows")]
    {
        use winapi::um::winreg::{HKEY_LOCAL_MACHINE, RegCloseKey, RegOpenKeyExW, RegQueryValueExW, KEY_READ};
        use winapi::um::winnt::{REG_SZ, WCHAR};
        use widestring::U16CString;
        
        unsafe {
            let mut hkey = std::ptr::null_mut();
            let key_name = U16CString::from_str("HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0").unwrap();
            
            if RegOpenKeyExW(HKEY_LOCAL_MACHINE, key_name.as_ptr(), 0, KEY_READ, &mut hkey) == 0 {
                let value_name = U16CString::from_str("ProcessorNameString").unwrap();
                let mut buffer: [WCHAR; 256] = [0; 256];
                let mut buffer_size = (buffer.len() * std::mem::size_of::<WCHAR>()) as u32;
                
                if RegQueryValueExW(hkey, value_name.as_ptr(), std::ptr::null_mut(), 
                                  std::ptr::null_mut(), buffer.as_mut_ptr() as *mut u8, &mut buffer_size) == 0 {
                    RegCloseKey(hkey);
                    let cpu_name = U16CString::from_ptr(buffer.as_ptr(), (buffer_size / 2) as usize).unwrap();
                    return Ok(cpu_name.to_string_lossy().trim().to_string());
                }
                RegCloseKey(hkey);
            }
        }
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        // For Linux/Unix systems
        if let Ok(contents) = std::fs::read_to_string("/proc/cpuinfo") {
            for line in contents.lines() {
                if line.starts_with("model name") {
                    if let Some(name) = line.split(':').nth(1) {
                        return Ok(name.trim().to_string());
                    }
                }
            }
        }
    }
    
    Ok("Unknown CPU".to_string())
}

/// Get the system memory size in GB
#[frb(sync)]
pub fn get_system_memory_size_gb() -> anyhow::Result<u64> {
    #[cfg(target_os = "windows")]
    {
        use winapi::um::sysinfoapi::{GlobalMemoryStatusEx, MEMORYSTATUSEX};
        
        unsafe {
            let mut mem_status: MEMORYSTATUSEX = std::mem::zeroed();
            mem_status.dwLength = std::mem::size_of::<MEMORYSTATUSEX>() as u32;
            
            if GlobalMemoryStatusEx(&mut mem_status) != 0 {
                let total_memory_gb = mem_status.ullTotalPhys / (1024 * 1024 * 1024);
                return Ok(total_memory_gb);
            }
        }
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        // For Linux/Unix systems
        if let Ok(contents) = std::fs::read_to_string("/proc/meminfo") {
            for line in contents.lines() {
                if line.starts_with("MemTotal:") {
                    if let Some(value_str) = line.split_whitespace().nth(1) {
                        if let Ok(kb) = value_str.parse::<u64>() {
                            return Ok(kb / (1024 * 1024)); // Convert KB to GB
                        }
                    }
                }
            }
        }
    }
    
    Ok(0)
}

/// Get the number of logical processors
#[frb(sync)]
pub fn get_number_of_logical_processors() -> anyhow::Result<u32> {
    #[cfg(target_os = "windows")]
    {
        use winapi::um::sysinfoapi::{GetSystemInfo, SYSTEM_INFO};
        
        unsafe {
            let mut system_info: SYSTEM_INFO = std::mem::zeroed();
            GetSystemInfo(&mut system_info);
            return Ok(system_info.dwNumberOfProcessors);
        }
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        // For Linux/Unix systems, count the number of processors in /proc/cpuinfo
        if let Ok(contents) = std::fs::read_to_string("/proc/cpuinfo") {
            let processor_count = contents.lines()
                .filter(|line| line.starts_with("processor"))
                .count() as u32;
            return Ok(processor_count);
        }
        
        // Fallback to std::thread::available_parallelism
        return Ok(std::thread::available_parallelism().unwrap_or(std::num::NonZeroUsize::new(1).unwrap()).get() as u32);
    }
}

/// Check NVMe patch status in Windows registry
#[cfg(target_os = "windows")]
#[frb(sync)]
pub fn check_nvme_patch_status() -> anyhow::Result<bool> {
    use winapi::um::winreg::{HKEY_LOCAL_MACHINE, RegCloseKey, RegOpenKeyExW, RegQueryValueExW, KEY_READ};
    use winapi::um::winnt::{REG_MULTI_SZ, WCHAR};
    use widestring::U16CString;
    
    unsafe {
        let mut hkey = std::ptr::null_mut();
        let key_name = U16CString::from_str("SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device").unwrap();
        
        if RegOpenKeyExW(HKEY_LOCAL_MACHINE, key_name.as_ptr(), 0, KEY_READ, &mut hkey) == 0 {
            let value_name = U16CString::from_str("ForcedPhysicalSectorSizeInBytes").unwrap();
            let mut buffer: [WCHAR; 256] = [0; 256];
            let mut buffer_size = (buffer.len() * std::mem::size_of::<WCHAR>()) as u32;
            let mut value_type = 0u32;
            
            if RegQueryValueExW(hkey, value_name.as_ptr(), std::ptr::null_mut(), 
                              &mut value_type, buffer.as_mut_ptr() as *mut u8, &mut buffer_size) == 0 {
                RegCloseKey(hkey);
                
                if value_type == REG_MULTI_SZ {
                    let data = U16CString::from_ptr(buffer.as_ptr(), (buffer_size / 2) as usize).unwrap();
                    let content = data.to_string_lossy();
                    return Ok(content.contains("* 4095"));
                }
            }
            RegCloseKey(hkey);
        }
    }
    
    Ok(false)
}

#[cfg(not(target_os = "windows"))]
#[frb(sync)]
pub fn check_nvme_patch_status() -> anyhow::Result<bool> {
    // Not applicable on non-Windows systems
    Ok(false)
}

/// Get list of process IDs by name
#[frb(sync)]
pub fn get_process_ids_by_name(process_name: &str) -> anyhow::Result<Vec<u32>> {
    #[cfg(target_os = "windows")]
    {
        use winapi::um::handleapi::CloseHandle;
        use winapi::um::processthreadsapi::GetCurrentProcessId;
        use winapi::um::tlhelp32::{
            CreateToolhelp32Snapshot, Process32FirstW, Process32NextW, PROCESSENTRY32W, TH32CS_SNAPPROCESS,
        };
        use widestring::U16CString;
        
        let mut pids = Vec::new();
        
        unsafe {
            let snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
            if snapshot == winapi::um::handleapi::INVALID_HANDLE_VALUE {
                return Err(anyhow::anyhow!("Failed to create process snapshot"));
            }
            
            let mut entry: PROCESSENTRY32W = std::mem::zeroed();
            entry.dwSize = std::mem::size_of::<PROCESSENTRY32W>() as u32;
            
            if Process32FirstW(snapshot, &mut entry) != 0 {
                loop {
                    let exe_name = U16CString::from_ptr(entry.szExeFile.as_ptr(), entry.szExeFile.len()).unwrap();
                    let exe_str = exe_name.to_string_lossy().to_lowercase();
                    let search_name = process_name.to_lowercase();
                    
                    if exe_str.contains(&search_name) {
                        pids.push(entry.th32ProcessID);
                    }
                    
                    if Process32NextW(snapshot, &mut entry) == 0 {
                        break;
                    }
                }
            }
            
            CloseHandle(snapshot);
        }
        
        Ok(pids)
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        // For Unix-like systems, use ps command
        let output = Command::new("ps")
            .args(&["-ax", "-o", "pid,comm"])
            .output()?;
            
        let stdout = String::from_utf8_lossy(&output.stdout);
        let mut pids = Vec::new();
        
        for line in stdout.lines().skip(1) { // Skip header
            let parts: Vec<&str> = line.trim().split_whitespace().collect();
            if parts.len() >= 2 {
                let pid_str = parts[0];
                let comm = parts[1];
                
                if comm.to_lowercase().contains(&process_name.to_lowercase()) {
                    if let Ok(pid) = pid_str.parse::<u32>() {
                        pids.push(pid);
                    }
                }
            }
        }
        
        Ok(pids)
    }
}

/// Get GPU information
#[frb(sync)]
pub fn get_gpu_info() -> anyhow::Result<String> {
    #[cfg(target_os = "windows")]
    {
        use winapi::um::winreg::{HKEY_LOCAL_MACHINE, RegCloseKey, RegOpenKeyExW, RegQueryValueExW, RegEnumKeyExW, KEY_READ};
        use winapi::um::winnt::{REG_SZ, REG_QWORD, WCHAR};
        use widestring::U16CString;
        
        let mut gpu_info = String::new();
        
        unsafe {
            let mut hkey = std::ptr::null_mut();
            let key_name = U16CString::from_str("SYSTEM\\ControlSet001\\Control\\Class\\{4d36e968-e325-11ce-bfc1-08002be10318}").unwrap();
            
            if RegOpenKeyExW(HKEY_LOCAL_MACHINE, key_name.as_ptr(), 0, KEY_READ, &mut hkey) == 0 {
                // Enumerate subkeys (GPU entries)
                let mut index = 0u32;
                loop {
                    let mut subkey_name: [WCHAR; 256] = [0; 256];
                    let mut subkey_name_len = 256u32;
                    
                    if RegEnumKeyExW(hkey, index, subkey_name.as_mut_ptr(), &mut subkey_name_len,
                                   std::ptr::null_mut(), std::ptr::null_mut(), std::ptr::null_mut(), std::ptr::null_mut()) != 0 {
                        break;
                    }
                    
                    let subkey_str = U16CString::from_ptr(subkey_name.as_ptr(), subkey_name_len as usize).unwrap();
                    let subkey_string = subkey_str.to_string_lossy();
                    
                    // Skip non-numeric keys (they're not GPU entries)
                    if subkey_string.chars().all(|c| c.is_ascii_digit()) {
                        // Open the GPU subkey
                        let mut gpu_hkey = std::ptr::null_mut();
                        let gpu_key_path = format!("SYSTEM\\ControlSet001\\Control\\Class\\{{4d36e968-e325-11ce-bfc1-08002be10318}}\\{}", subkey_string);
                        let gpu_key_name = U16CString::from_str(&gpu_key_path).unwrap();
                        
                        if RegOpenKeyExW(HKEY_LOCAL_MACHINE, gpu_key_name.as_ptr(), 0, KEY_READ, &mut gpu_hkey) == 0 {
                            // Get adapter string
                            let adapter_name = U16CString::from_str("HardwareInformation.AdapterString").unwrap();
                            let mut adapter_buffer: [WCHAR; 256] = [0; 256];
                            let mut adapter_buffer_size = (adapter_buffer.len() * std::mem::size_of::<WCHAR>()) as u32;
                            
                            if RegQueryValueExW(gpu_hkey, adapter_name.as_ptr(), std::ptr::null_mut(),
                                              std::ptr::null_mut(), adapter_buffer.as_mut_ptr() as *mut u8, &mut adapter_buffer_size) == 0 {
                                let adapter_str = U16CString::from_ptr(adapter_buffer.as_ptr(), (adapter_buffer_size / 2) as usize).unwrap();
                                let model = adapter_str.to_string_lossy();
                                
                                // Get VRAM size
                                let vram_name = U16CString::from_str("HardwareInformation.qwMemorySize").unwrap();
                                let mut vram_buffer: u64 = 0;
                                let mut vram_buffer_size = std::mem::size_of::<u64>() as u32;
                                
                                if RegQueryValueExW(gpu_hkey, vram_name.as_ptr(), std::ptr::null_mut(),
                                                  std::ptr::null_mut(), &mut vram_buffer as *mut u64 as *mut u8, &mut vram_buffer_size) == 0 {
                                    let vram_gb = (vram_buffer as f64 / (1024.0 * 1024.0 * 1024.0)).round() as u64;
                                    gpu_info.push_str(&format!("Model: {}\nVRAM (GB): {}\n\n", model.trim(), vram_gb));
                                } else {
                                    gpu_info.push_str(&format!("Model: {}\nVRAM (GB): Unknown\n\n", model.trim()));
                                }
                            }
                            RegCloseKey(gpu_hkey);
                        }
                    }
                    
                    index += 1;
                }
                RegCloseKey(hkey);
            }
        }
        
        if gpu_info.is_empty() {
            return Ok("No GPU information found".to_string());
        }
        
        Ok(gpu_info.trim_end().to_string())
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        // For Linux systems, try to get GPU info from various sources
        if let Ok(output) = Command::new("lspci").output() {
            let stdout = String::from_utf8_lossy(&output.stdout);
            let mut gpu_lines = Vec::new();
            
            for line in stdout.lines() {
                if line.contains("VGA compatible controller") || line.contains("3D controller") {
                    gpu_lines.push(line.trim());
                }
            }
            
            if !gpu_lines.is_empty() {
                return Ok(gpu_lines.join("\n"));
            }
        }
        
        Ok("GPU information not available".to_string())
    }
}

/// Get disk information
#[frb(sync)]
pub fn get_disk_info() -> anyhow::Result<String> {
    #[cfg(target_os = "windows")]
    {
        use winapi::um::fileapi::{GetLogicalDrives, GetDriveTypeW};
        use winapi::um::winbase::{DRIVE_FIXED, DRIVE_REMOVABLE, DRIVE_CDROM};
        use widestring::U16CString;
        
        let mut disk_info = String::new();
        
        unsafe {
            let drives = GetLogicalDrives();
            for i in 0..26 {
                if (drives & (1 << i)) != 0 {
                    let drive_letter = format!("{}:\\", (b'A' + i) as char);
                    let drive_path = U16CString::from_str(&drive_letter).unwrap();
                    let drive_type = GetDriveTypeW(drive_path.as_ptr());
                    
                    let type_str = match drive_type {
                        DRIVE_FIXED => "Fixed Drive",
                        DRIVE_REMOVABLE => "Removable Drive", 
                        DRIVE_CDROM => "CD-ROM Drive",
                        _ => "Other",
                    };
                    
                    if drive_type == DRIVE_FIXED {
                        // Get free space for fixed drives
                        use winapi::um::fileapi::GetDiskFreeSpaceExW;
                        let mut free_bytes: u64 = 0;
                        let mut total_bytes: u64 = 0;
                        
                        if GetDiskFreeSpaceExW(drive_path.as_ptr(), &mut free_bytes, &mut total_bytes, std::ptr::null_mut()) != 0 {
                            let total_gb = (total_bytes as f64 / (1024.0 * 1024.0 * 1024.0)).round() as u64;
                            let free_gb = (free_bytes as f64 / (1024.0 * 1024.0 * 1024.0)).round() as u64;
                            disk_info.push_str(&format!("Drive {}: {} ({} GB total, {} GB free)\n", 
                                                       drive_letter, type_str, total_gb, free_gb));
                        } else {
                            disk_info.push_str(&format!("Drive {}: {}\n", drive_letter, type_str));
                        }
                    } else {
                        disk_info.push_str(&format!("Drive {}: {}\n", drive_letter, type_str));
                    }
                }
            }
        }
        
        if disk_info.is_empty() {
            return Ok("No disk information found".to_string());
        }
        
        Ok(disk_info.trim_end().to_string())
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        // For Linux systems, use df command
        if let Ok(output) = Command::new("df").args(&["-h", "--type=ext4", "--type=ext3", "--type=ext2", "--type=xfs"]).output() {
            let stdout = String::from_utf8_lossy(&output.stdout);
            return Ok(stdout.to_string());
        }
        
        // Fallback to basic df
        if let Ok(output) = Command::new("df").arg("-h").output() {
            let stdout = String::from_utf8_lossy(&output.stdout);
            return Ok(stdout.to_string());
        }
        
        Ok("Disk information not available".to_string())
    }
}

/// Kill processes by PID
#[frb(sync)]
pub fn kill_processes_by_pids(pids: Vec<u32>) -> anyhow::Result<u32> {
    let mut killed_count = 0;
    
    #[cfg(target_os = "windows")]
    {
        use winapi::um::handleapi::CloseHandle;
        use winapi::um::processthreadsapi::{OpenProcess, TerminateProcess};
        use winapi::um::winnt::PROCESS_TERMINATE;
        
        for pid in pids {
            unsafe {
                let handle = OpenProcess(PROCESS_TERMINATE, 0, pid);
                if handle != std::ptr::null_mut() {
                    if TerminateProcess(handle, 1) != 0 {
                        killed_count += 1;
                    }
                    CloseHandle(handle);
                }
            }
        }
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        use std::process::Command;
        
        for pid in pids {
            if let Ok(_) = Command::new("kill").arg(pid.to_string()).output() {
                killed_count += 1;
            }
        }
    }
    
    Ok(killed_count)
}

/// Add NVMe patch registry entry
#[cfg(target_os = "windows")]
#[frb(sync)]
pub fn add_nvme_patch() -> anyhow::Result<String> {
    use winapi::um::winreg::{HKEY_LOCAL_MACHINE, RegCreateKeyExW, RegSetValueExW, RegCloseKey, KEY_WRITE};
    use winapi::um::winnt::{REG_MULTI_SZ, WCHAR};
    use widestring::U16CString;
    
    unsafe {
        let mut hkey = std::ptr::null_mut();
        let key_name = U16CString::from_str("SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device").unwrap();
        
        let result = RegCreateKeyExW(
            HKEY_LOCAL_MACHINE,
            key_name.as_ptr(),
            0,
            std::ptr::null_mut(),
            0,
            KEY_WRITE,
            std::ptr::null_mut(),
            &mut hkey,
            std::ptr::null_mut()
        );
        
        if result != 0 {
            return Err(anyhow::anyhow!("Failed to create/open registry key: {}", result));
        }
        
        let value_name = U16CString::from_str("ForcedPhysicalSectorSizeInBytes").unwrap();
        let value_data = U16CString::from_str("* 4095\0").unwrap();
        let value_bytes = value_data.as_slice_with_nul();
        
        let set_result = RegSetValueExW(
            hkey,
            value_name.as_ptr(),
            0,
            REG_MULTI_SZ,
            value_bytes.as_ptr() as *const u8,
            (value_bytes.len() * std::mem::size_of::<WCHAR>()) as u32
        );
        
        RegCloseKey(hkey);
        
        if set_result != 0 {
            return Err(anyhow::anyhow!("Failed to set registry value: {}", set_result));
        }
        
        Ok("NVMe patch added successfully".to_string())
    }
}

#[cfg(not(target_os = "windows"))]
#[frb(sync)]
pub fn add_nvme_patch() -> anyhow::Result<String> {
    Err(anyhow::anyhow!("NVMe patch is only supported on Windows"))
}

/// Remove NVMe patch registry entry
#[cfg(target_os = "windows")]
#[frb(sync)]
pub fn remove_nvme_patch() -> anyhow::Result<bool> {
    use winapi::um::winreg::{HKEY_LOCAL_MACHINE, RegOpenKeyExW, RegDeleteValueW, RegCloseKey, KEY_WRITE};
    use widestring::U16CString;
    
    unsafe {
        let mut hkey = std::ptr::null_mut();
        let key_name = U16CString::from_str("SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device").unwrap();
        
        if RegOpenKeyExW(HKEY_LOCAL_MACHINE, key_name.as_ptr(), 0, KEY_WRITE, &mut hkey) != 0 {
            return Ok(false);
        }
        
        let value_name = U16CString::from_str("ForcedPhysicalSectorSizeInBytes").unwrap();
        let result = RegDeleteValueW(hkey, value_name.as_ptr());
        
        RegCloseKey(hkey);
        
        Ok(result == 0)
    }
}

#[cfg(not(target_os = "windows"))]
#[frb(sync)]
pub fn remove_nvme_patch() -> anyhow::Result<bool> {
    Ok(false) // Not applicable on non-Windows systems
}

/// Resolve Windows shortcut (.lnk) file to get target path
#[cfg(target_os = "windows")]
#[frb(sync)]
pub fn resolve_shortcut_path(shortcut_path: &str) -> anyhow::Result<String> {
    use winapi::shared::winerror::S_OK;
    use winapi::um::combaseapi::{CoCreateInstance, CoInitialize, CoUninitialize};
    use winapi::um::objbase::CLSCTX_INPROC_SERVER;
    use winapi::um::shlobj::{IShellLinkW, IPersistFile};
    use winapi::um::shobjidl_core::CLSID_ShellLink;
    use winapi::Interface;
    use widestring::U16CString;
    
    unsafe {
        CoInitialize(std::ptr::null_mut());
        
        let mut shell_link: *mut IShellLinkW = std::ptr::null_mut();
        let hr = CoCreateInstance(
            &CLSID_ShellLink,
            std::ptr::null_mut(),
            CLSCTX_INPROC_SERVER,
            &IShellLinkW::uuidof(),
            &mut shell_link as *mut *mut IShellLinkW as *mut *mut _,
        );
        
        if hr != S_OK {
            CoUninitialize();
            return Err(anyhow::anyhow!("Failed to create ShellLink instance"));
        }
        
        let mut persist_file: *mut IPersistFile = std::ptr::null_mut();
        let hr = (*shell_link).QueryInterface(
            &IPersistFile::uuidof(),
            &mut persist_file as *mut *mut IPersistFile as *mut *mut _,
        );
        
        if hr != S_OK {
            (*shell_link).Release();
            CoUninitialize();
            return Err(anyhow::anyhow!("Failed to get IPersistFile interface"));
        }
        
        let wide_path = U16CString::from_str(shortcut_path).unwrap();
        let hr = (*persist_file).Load(wide_path.as_ptr(), 0);
        
        if hr != S_OK {
            (*persist_file).Release();
            (*shell_link).Release();
            CoUninitialize();
            return Err(anyhow::anyhow!("Failed to load shortcut file"));
        }
        
        let mut target_path: [u16; 260] = [0; 260];
        let hr = (*shell_link).GetPath(
            target_path.as_mut_ptr(),
            target_path.len() as i32,
            std::ptr::null_mut(),
            0,
        );
        
        (*persist_file).Release();
        (*shell_link).Release();
        CoUninitialize();
        
        if hr != S_OK {
            return Err(anyhow::anyhow!("Failed to get target path"));
        }
        
        let result = U16CString::from_ptr(target_path.as_ptr(), target_path.len()).unwrap();
        Ok(result.to_string_lossy())
    }
}

#[cfg(not(target_os = "windows"))]
#[frb(sync)]
pub fn resolve_shortcut_path(_shortcut_path: &str) -> anyhow::Result<String> {
    Err(anyhow::anyhow!("Shortcut resolution is only supported on Windows"))
}

/// Open file or directory in system file explorer
#[frb(sync)]
pub fn open_in_explorer(path: &str, is_file: bool) -> anyhow::Result<()> {
    #[cfg(target_os = "windows")]
    {
        use std::process::Command;
        
        let args = if is_file {
            vec!["/select,".to_string(), path.to_string()]
        } else {
            vec![path.to_string()]
        };
        
        let output = Command::new("explorer.exe")
            .args(&args)
            .output()?;
            
        if !output.status.success() {
            return Err(anyhow::anyhow!("Failed to open explorer: {}", String::from_utf8_lossy(&output.stderr)));
        }
        
        Ok(())
    }
    
    #[cfg(target_os = "macos")]
    {
        use std::process::Command;
        
        if is_file {
            Command::new("open").args(&["-R", path]).output()?;
        } else {
            Command::new("open").arg(path).output()?;
        }
        
        Ok(())
    }
    
    #[cfg(target_os = "linux")]
    {
        use std::process::Command;
        
        // Try different file managers commonly found on Linux
        let file_managers = ["nautilus", "dolphin", "thunar", "pcmanfm", "caja"];
        
        for fm in &file_managers {
            if let Ok(_) = Command::new("which").arg(fm).output() {
                let mut cmd = Command::new(fm);
                
                if is_file {
                    // Most file managers support selecting a file with --select or similar
                    if *fm == "nautilus" {
                        cmd.args(&["--select", path]);
                    } else {
                        // For others, open the parent directory
                        if let Some(parent) = std::path::Path::new(path).parent() {
                            cmd.arg(parent.to_string_lossy().as_ref());
                        }
                    }
                } else {
                    cmd.arg(path);
                }
                
                let _ = cmd.output();
                return Ok(());
            }
        }
        
        // Fallback to xdg-open
        Command::new("xdg-open").arg(path).output()?;
        Ok(())
    }
    
    #[cfg(not(any(target_os = "windows", target_os = "macos", target_os = "linux")))]
    {
        Err(anyhow::anyhow!("File explorer opening not supported on this platform"))
    }
}

/// Start process with elevated privileges (Windows) or regular privileges (other platforms)
#[frb(sync)]
pub fn start_process_elevated(executable_path: &str, args: Vec<String>) -> anyhow::Result<()> {
    #[cfg(target_os = "windows")]
    {
        use std::process::Command;
        
        let mut cmd = Command::new("cmd.exe");
        cmd.arg("/C");
        cmd.arg("start");
        cmd.arg("\"\""); // Empty title
        cmd.arg("/B"); // Don't create new console window
        cmd.arg(executable_path);
        
        for arg in args {
            cmd.arg(arg);
        }
        
        let output = cmd.output()?;
        
        if !output.status.success() {
            return Err(anyhow::anyhow!("Failed to start process: {}", String::from_utf8_lossy(&output.stderr)));
        }
        
        Ok(())
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        use std::process::Command;
        
        let mut cmd = Command::new(executable_path);
        cmd.args(args);
        
        let output = cmd.output()?;
        
        if !output.status.success() {
            return Err(anyhow::anyhow!("Failed to start process: {}", String::from_utf8_lossy(&output.stderr)));
        }
        
        Ok(())
    }
}

/// Execute a script or command with system shell
#[frb(sync)]
pub fn execute_system_command(command: &str) -> anyhow::Result<String> {
    use std::process::Command;
    
    #[cfg(target_os = "windows")]
    {
        let output = Command::new("cmd.exe")
            .args(&["/C", command])
            .output()?;
            
        if !output.status.success() {
            return Err(anyhow::anyhow!("Command failed: {}", String::from_utf8_lossy(&output.stderr)));
        }
        
        Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        let output = Command::new("sh")
            .args(&["-c", command])
            .output()?;
            
        if !output.status.success() {
            return Err(anyhow::anyhow!("Command failed: {}", String::from_utf8_lossy(&output.stderr)));
        }
        
        Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
    }
}

/// Get disk sector information for a specific drive (Windows only)
#[cfg(target_os = "windows")]
#[frb(sync)]
pub fn get_disk_sector_info(drive_letter: &str) -> anyhow::Result<u32> {
    use std::process::Command;
    
    let command = format!("fsutil fsinfo sectorinfo {}:", drive_letter);
    let output = Command::new("fsutil")
        .args(&["fsinfo", "sectorinfo", &format!("{}:", drive_letter)])
        .output()?;
        
    if !output.status.success() {
        return Err(anyhow::anyhow!("fsutil command failed: {}", String::from_utf8_lossy(&output.stderr)));
    }
    
    let stdout = String::from_utf8_lossy(&output.stdout);
    
    // Parse the output to find PhysicalBytesPerSectorForPerformance
    for line in stdout.lines() {
        if line.contains("PhysicalBytesPerSectorForPerformance") {
            if let Some(colon_pos) = line.find(':') {
                let value_part = &line[colon_pos + 1..];
                let trimmed = value_part.trim();
                if let Ok(value) = trimmed.parse::<u32>() {
                    return Ok(value);
                }
            }
        }
    }
    
    Err(anyhow::anyhow!("Could not parse sector information"))
}

#[cfg(not(target_os = "windows"))]
#[frb(sync)]
pub fn get_disk_sector_info(_drive_letter: &str) -> anyhow::Result<u32> {
    // Not applicable on non-Windows systems, return default sector size
    Ok(4096)
}

/// Create desktop shortcut (Windows only)
#[cfg(target_os = "windows")]
#[frb(sync)]
pub fn create_desktop_shortcut(target_path: &str, shortcut_name: &str) -> anyhow::Result<()> {
    use winapi::shared::winerror::S_OK;
    use winapi::um::combaseapi::{CoCreateInstance, CoInitialize, CoUninitialize};
    use winapi::um::objbase::CLSCTX_INPROC_SERVER;
    use winapi::um::shlobj::{IShellLinkW, IPersistFile};
    use winapi::um::shobjidl_core::CLSID_ShellLink;
    use winapi::Interface;
    use widestring::U16CString;
    
    unsafe {
        CoInitialize(std::ptr::null_mut());
        
        // Create shell link
        let mut shell_link: *mut IShellLinkW = std::ptr::null_mut();
        let hr = CoCreateInstance(
            &CLSID_ShellLink,
            std::ptr::null_mut(),
            CLSCTX_INPROC_SERVER,
            &IShellLinkW::uuidof(),
            &mut shell_link as *mut *mut IShellLinkW as *mut *mut _,
        );
        
        if hr != S_OK {
            CoUninitialize();
            return Err(anyhow::anyhow!("Failed to create ShellLink instance"));
        }
        
        // Set target path
        let wide_target = U16CString::from_str(target_path).unwrap();
        let hr = (*shell_link).SetPath(wide_target.as_ptr());
        if hr != S_OK {
            (*shell_link).Release();
            CoUninitialize();
            return Err(anyhow::anyhow!("Failed to set target path"));
        }
        
        // Get desktop directory
        use winapi::um::shlobj::SHGetFolderPathW;
        use winapi::um::shlobj::CSIDL_DESKTOP;
        let mut desktop_path: [u16; 260] = [0; 260];
        let hr = SHGetFolderPathW(
            std::ptr::null_mut(),
            CSIDL_DESKTOP,
            std::ptr::null_mut(),
            0,
            desktop_path.as_mut_ptr(),
        );
        
        if hr != S_OK {
            (*shell_link).Release();
            CoUninitialize();
            return Err(anyhow::anyhow!("Failed to get desktop path"));
        }
        
        // Build shortcut path
        let desktop_str = U16CString::from_ptr(desktop_path.as_ptr(), desktop_path.len()).unwrap();
        let desktop_string = desktop_str.to_string_lossy();
        let shortcut_path = format!("{}\\{}.lnk", desktop_string, shortcut_name);
        
        // Get IPersistFile interface
        let mut persist_file: *mut IPersistFile = std::ptr::null_mut();
        let hr = (*shell_link).QueryInterface(
            &IPersistFile::uuidof(),
            &mut persist_file as *mut *mut IPersistFile as *mut *mut _,
        );
        
        if hr != S_OK {
            (*shell_link).Release();
            CoUninitialize();
            return Err(anyhow::anyhow!("Failed to get IPersistFile interface"));
        }
        
        // Save shortcut
        let wide_path = U16CString::from_str(&shortcut_path).unwrap();
        let hr = (*persist_file).Save(wide_path.as_ptr(), 1);
        
        (*persist_file).Release();
        (*shell_link).Release();
        CoUninitialize();
        
        if hr != S_OK {
            return Err(anyhow::anyhow!("Failed to save shortcut"));
        }
        
        Ok(())
    }
}

#[cfg(not(target_os = "windows"))]
#[frb(sync)]
pub fn create_desktop_shortcut(_target_path: &str, _shortcut_name: &str) -> anyhow::Result<()> {
    // For non-Windows systems, creating shortcuts is platform-specific
    // This is a basic implementation that could be extended for Linux/macOS
    Err(anyhow::anyhow!("Desktop shortcut creation not implemented for this platform"))
}