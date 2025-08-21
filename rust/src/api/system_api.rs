use anyhow::{Context, Result};
use flutter_rust_bridge::frb;
use sysinfo::System;

#[cfg(target_os = "windows")]
use {
    winreg::{enums::*, RegKey},
    wmi::{COMLibrary, WMIConnection, Variant},
    std::process::{Command, Stdio},
    std::collections::HashMap,
    windows::{
        core::PCWSTR, 
        Win32::{
            Foundation::{HWND, HANDLE, CloseHandle},
            System::{
                Threading::{OpenProcess, TerminateProcess, PROCESS_TERMINATE},
                ProcessStatus::EnumProcesses,
                Registry::{RegOpenKeyExW, RegQueryValueExW, RegSetValueExW, RegDeleteValueW, HKEY_LOCAL_MACHINE},
            },
            Storage::FileSystem::{CreateFileW, GENERIC_READ, FILE_SHARE_READ, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL},
        }
    },
};

/// Check NVME patch status by reading registry
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn check_nvme_patch_status() -> Result<bool> {
    let hklm = RegKey::predef(HKEY_LOCAL_MACHINE);
    let path = r"SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device";
    
    match hklm.open_subkey(path) {
        Ok(key) => {
            match key.get_value::<Vec<String>, &str>("ForcedPhysicalSectorSizeInBytes") {
                Ok(values) => {
                    for value in values {
                        if value.contains("* 4095") {
                            return Ok(true);
                        }
                    }
                    Ok(false)
                }
                Err(_) => Ok(false),
            }
        }
        Err(_) => Ok(false),
    }
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn check_nvme_patch_status() -> Result<bool> {
    Ok(false)
}

/// Add NVME patch to registry
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn add_nvme_patch() -> Result<String> {
    let hklm = RegKey::predef(HKEY_LOCAL_MACHINE);
    let path = r"SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device";
    
    match hklm.open_subkey_with_flags(path, KEY_WRITE) {
        Ok(key) => {
            let values = vec!["* 4095".to_string()];
            match key.set_value("ForcedPhysicalSectorSizeInBytes", &values) {
                Ok(_) => Ok(String::new()), // Empty string means success
                Err(e) => Ok(format!("Registry write failed: {}", e)),
            }
        }
        Err(e) => Ok(format!("Registry access failed: {}", e)),
    }
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn add_nvme_patch() -> Result<String> {
    Ok("Not supported on this platform".to_string())
}

/// Remove NVME patch from registry
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn remove_nvme_patch() -> Result<bool> {
    let hklm = RegKey::predef(HKEY_LOCAL_MACHINE);
    let path = r"SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device";
    
    match hklm.open_subkey_with_flags(path, KEY_WRITE) {
        Ok(key) => {
            match key.delete_value("ForcedPhysicalSectorSizeInBytes") {
                Ok(_) => Ok(true),
                Err(_) => Ok(false),
            }
        }
        Err(_) => Ok(false),
    }
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn remove_nvme_patch() -> Result<bool> {
    Ok(false)
}

/// Get process IDs by name
#[frb(sync)]
pub fn get_process_ids(process_name: String) -> Result<Vec<String>> {
    let mut system = System::new_all();
    system.refresh_processes_specifics(sysinfo::ProcessesToUpdate::All, true, sysinfo::ProcessRefreshKind::everything());
    
    let mut pids = Vec::new();
    for (pid, process) in system.processes() {
        let process_name_str = process.name().to_string_lossy();
        if process_name_str.to_lowercase().contains(&process_name.to_lowercase()) {
            pids.push(pid.as_u32().to_string());
        }
    }
    
    Ok(pids)
}

/// Kill process by PID
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn kill_process(pid: u32) -> Result<bool> {
    use windows::Win32::System::Threading::{OpenProcess, TerminateProcess, PROCESS_TERMINATE};
    
    unsafe {
        let handle = OpenProcess(PROCESS_TERMINATE, false, pid)?;
        if handle.is_invalid() {
            return Ok(false);
        }
        let result = TerminateProcess(handle, 1);
        let _ = CloseHandle(handle);
        Ok(result.as_bool())
    }
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn kill_process(pid: u32) -> Result<bool> {
    use std::process::Command;
    let output = Command::new("kill")
        .arg(pid.to_string())
        .output()
        .context("Failed to execute kill command")?;
    Ok(output.status.success())
}

/// Get system memory size in GB
#[frb(sync)]
pub fn get_system_memory_gb() -> Result<u64> {
    let mut system = System::new_all();
    system.refresh_memory();
    Ok(system.total_memory() / (1024 * 1024 * 1024))
}

/// Get system name
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn get_system_name() -> Result<String> {
    let com_con = COMLibrary::new()?;
    let wmi_con = WMIConnection::new(com_con.into())?;
    
    let results: Vec<HashMap<String, Variant>> = wmi_con.raw_query("SELECT Caption FROM Win32_OperatingSystem")?;
    if let Some(os) = results.first() {
        if let Some(Variant::String(name)) = os.get("Caption") {
            return Ok(name.clone());
        }
    }
    Ok("Unknown".to_string())
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn get_system_name() -> Result<String> {
    Ok(System::long_os_version().unwrap_or_else(|| "Unknown".to_string()))
}

/// Get CPU name
#[frb(sync)]
pub fn get_cpu_name() -> Result<String> {
    let mut system = System::new_all();
    system.refresh_cpu_all();
    
    if let Some(cpu) = system.cpus().first() {
        Ok(cpu.brand().to_string())
    } else {
        Ok("Unknown".to_string())
    }
}

/// Get GPU information
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn get_gpu_info() -> Result<String> {
    let hklm = RegKey::predef(HKEY_LOCAL_MACHINE);
    let path = r"SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}";
    
    let mut gpu_info = Vec::new();
    
    if let Ok(key) = hklm.open_subkey(path) {
        for subkey_name in key.enum_keys().map(|x| x.unwrap()) {
            if subkey_name.chars().all(|c| c.is_ascii_digit()) {
                let subkey_path = format!("{}\\{}", path, subkey_name);
                if let Ok(subkey) = hklm.open_subkey(&subkey_path) {
                    if let (Ok(adapter_name), Ok(memory_size)) = (
                        subkey.get_value::<String, _>("HardwareInformation.AdapterString"),
                        subkey.get_value::<u64, _>("HardwareInformation.qwMemorySize")
                    ) {
                        let memory_gb = memory_size / (1024 * 1024 * 1024);
                        gpu_info.push(format!("Model: {} VRAM (GB): {}", adapter_name, memory_gb));
                    }
                }
            }
        }
    }
    
    if gpu_info.is_empty() {
        Ok("No GPU information found".to_string())
    } else {
        Ok(gpu_info.join("\n"))
    }
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn get_gpu_info() -> Result<String> {
    Ok("GPU info not available on this platform".to_string())
}

/// Get disk information
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn get_disk_info() -> Result<String> {
    let com_con = COMLibrary::new()?;
    let wmi_con = WMIConnection::new(com_con.into())?;
    
    let results: Vec<HashMap<String, Variant>> = wmi_con.raw_query(
        "SELECT BusType, FriendlyName, Size FROM Win32_DiskDrive"
    )?;
    
    let mut disk_info = Vec::new();
    for disk in results {
        let bus_type = disk.get("BusType").map(|v| format!("{:?}", v)).unwrap_or_else(|| "Unknown".to_string());
        let friendly_name = disk.get("FriendlyName").map(|v| format!("{:?}", v)).unwrap_or_else(|| "Unknown".to_string());
        let size = disk.get("Size").map(|v| format!("{:?}", v)).unwrap_or_else(|| "Unknown".to_string());
        disk_info.push(format!("BusType: {} FriendlyName: {} Size: {}", bus_type, friendly_name, size));
    }
    
    Ok(disk_info.join("\n"))
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn get_disk_info() -> Result<String> {
    Ok("Disk info not available on this platform".to_string())
}

/// Get number of logical processors
#[frb(sync)]
pub fn get_logical_processors() -> Result<usize> {
    let mut system = System::new_all();
    system.refresh_cpu_all();
    Ok(system.cpus().len())
}

/// Open directory or file in system file manager
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn open_path(path: String, is_file: bool) -> Result<()> {
    let mut cmd = std::process::Command::new("explorer.exe");
    if is_file {
        cmd.arg(format!("/select,{}", path));
    } else {
        cmd.arg(path);
    }
    cmd.spawn().context("Failed to open path")?;
    Ok(())
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn open_path(path: String, _is_file: bool) -> Result<()> {
    std::process::Command::new("xdg-open")
        .arg(path)
        .spawn()
        .context("Failed to open path")?;
    Ok(())
}

/// Resolve shortcut (.lnk) file to target path
#[frb(sync)]
#[cfg(target_os = "windows")]
pub fn resolve_shortcut(lnk_path: String) -> Result<String> {
    // For now, fall back to PowerShell for this specific case
    // A complete COM implementation would be quite complex
    let output = std::process::Command::new("powershell.exe")
        .args([
            "-Command",
            &format!("(New-Object -ComObject WScript.Shell).CreateShortcut('{}').TargetPath", lnk_path)
        ])
        .output()
        .context("Failed to resolve shortcut")?;
    
    Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
}

#[frb(sync)]
#[cfg(not(target_os = "windows"))]
pub fn resolve_shortcut(lnk_path: String) -> Result<String> {
    Ok(lnk_path) // No shortcuts on non-Windows
}