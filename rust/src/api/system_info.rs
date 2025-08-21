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