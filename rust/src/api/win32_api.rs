use notify_rust::Notification;
use sysinfo::{System, Disks};

// ============================================
// Notification Functions
// ============================================

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

// ============================================
// Window Management Functions
// ============================================

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
    Ok(false)
}

// ============================================
// Registry Operations (Windows Only)
// ============================================

#[cfg(target_os = "windows")]
pub fn check_nvme_patch_status() -> anyhow::Result<bool> {
    use winreg::enums::*;
    use winreg::RegKey;

    let hklm = RegKey::predef(HKEY_LOCAL_MACHINE);
    let key_path = r"SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device";
    
    match hklm.open_subkey(key_path) {
        Ok(key) => {
            match key.get_raw_value("ForcedPhysicalSectorSizeInBytes") {
                Ok(value) => {
                    // Check if value contains "* 4095"
                    let data_str = String::from_utf8_lossy(&value.bytes);
                    // print str
                    println!("check_nvme_patch_status: {}", data_str);
                    Ok(data_str.contains("* 4095"))
                }
                Err(_) => {
                    Ok(false)
                },
            }
        }
        Err(_) => Ok(false),
    }
}

#[cfg(not(target_os = "windows"))]
pub fn check_nvme_patch_status() -> anyhow::Result<bool> {
    Ok(false)
}

#[cfg(target_os = "windows")]
pub fn add_nvme_patch() -> anyhow::Result<String> {
    use winreg::enums::*;
    use winreg::RegKey;

    let hklm = RegKey::predef(HKEY_LOCAL_MACHINE);
    let key_path = r"SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device";
    
    match hklm.open_subkey_with_flags(key_path, KEY_WRITE) {
        Ok(key) => {
            let value = "* 4095\0".encode_utf16().collect::<Vec<u16>>();
            match key.set_raw_value(
                "ForcedPhysicalSectorSizeInBytes",
                &winreg::RegValue {
                    bytes: value.iter().flat_map(|&x| x.to_le_bytes()).collect(),
                    vtype: winreg::enums::RegType::REG_MULTI_SZ,
                },
            ) {
                Ok(_) => Ok(String::new()),
                Err(e) => Ok(e.to_string()),
            }
        }
        Err(e) => Ok(e.to_string()),
    }
}

#[cfg(not(target_os = "windows"))]
pub fn add_nvme_patch() -> anyhow::Result<String> {
    Ok("Not supported on this platform".to_string())
}

#[cfg(target_os = "windows")]
pub fn remove_nvme_patch() -> anyhow::Result<bool> {
    use winreg::enums::*;
    use winreg::RegKey;

    let hklm = RegKey::predef(HKEY_LOCAL_MACHINE);
    let key_path = r"SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device";
    
    match hklm.open_subkey_with_flags(key_path, KEY_WRITE) {
        Ok(key) => {
            match key.delete_value("ForcedPhysicalSectorSizeInBytes") {
                Ok(_) => Ok(true),
                Err(_) => Ok(false),
            }
        }
        Err(_) => Ok(false),
    }
}

#[cfg(not(target_os = "windows"))]
pub fn remove_nvme_patch() -> anyhow::Result<bool> {
    Ok(false)
}

// ============================================
// Process Management Functions
// ============================================

pub fn get_process_ids(process_name: &str) -> anyhow::Result<Vec<u32>> {
    let mut system = System::new_all();
    system.refresh_processes(sysinfo::ProcessesToUpdate::All, true);
    
    let pids: Vec<u32> = system
        .processes()
        .iter()
        .filter(|(_, process)| {
            process.name().to_string_lossy().to_lowercase() == process_name.to_lowercase()
                || process.name().to_string_lossy().to_lowercase() == format!("{}.exe", process_name.to_lowercase())
        })
        .map(|(pid, _)| pid.as_u32())
        .collect();
    
    Ok(pids)
}

pub fn kill_process_by_name(process_name: &str) -> anyhow::Result<()> {
    let pids = get_process_ids(process_name)?;
    let system = System::new_all();
    
    for pid in pids {
        if let Some(process) = system.process(sysinfo::Pid::from_u32(pid)) {
            process.kill();
        }
    }
    
    Ok(())
}

#[cfg(target_os = "windows")]
pub fn launch_process_with_affinity(
    executable_path: String,
    args: Vec<String>,
    affinity_mask: Option<String>,
) -> anyhow::Result<()> {
    use std::os::windows::process::CommandExt;
    use std::process::Command;

    if let Some(mask) = affinity_mask {
        // Launch with affinity using cmd
        let mut cmd = Command::new("cmd.exe");
        cmd.args(["/C", "Start", "\"\"", "/High", "/Affinity", &mask, &executable_path]);
        for arg in args {
            cmd.arg(arg);
        }
        cmd.creation_flags(0x08000000); // CREATE_NO_WINDOW
        cmd.spawn()?;
    } else {
        // Launch without affinity
        let mut cmd = Command::new(&executable_path);
        cmd.args(args);
        cmd.spawn()?;
    }
    
    Ok(())
}

#[cfg(not(target_os = "windows"))]
pub fn launch_process_with_affinity(
    executable_path: String,
    args: Vec<String>,
    _affinity_mask: Option<String>,
) -> anyhow::Result<()> {
    use std::process::Command;
    let mut cmd = Command::new(&executable_path);
    cmd.args(args);
    cmd.spawn()?;
    Ok(())
}

// ============================================
// System Information Functions
// ============================================

pub fn get_system_memory_gb() -> anyhow::Result<u64> {
    let mut system = System::new_all();
    system.refresh_memory();
    let total_memory_bytes = system.total_memory();
    let total_memory_gb = total_memory_bytes / (1024 * 1024 * 1024);
    Ok(total_memory_gb)
}

pub fn get_cpu_name() -> anyhow::Result<String> {
    let mut system = System::new_all();
    system.refresh_cpu_all();
    
    if let Some(cpu) = system.cpus().first() {
        Ok(cpu.brand().to_string())
    } else {
        Ok(String::from("Unknown CPU"))
    }
}

pub fn get_cpu_count() -> anyhow::Result<usize> {
    let mut system = System::new_all();
    system.refresh_cpu_all();
    Ok(system.cpus().len())
}

pub fn calculate_cpu_affinity(e_core_count: usize) -> anyhow::Result<String> {
    let cpu_count = get_cpu_count()?;
    
    if e_core_count == 0 || e_core_count >= cpu_count {
        return Err(anyhow::anyhow!("Invalid E-core count"));
    }
    
    let mut binary_string = String::new();
    for i in 0..cpu_count {
        if i < e_core_count {
            binary_string.push('0');
        } else {
            binary_string.push('1');
        }
    }
    
    let value = u64::from_str_radix(&binary_string, 2)?;
    let hex_digits = (binary_string.len() as f64 / 4.0).ceil() as usize;
    Ok(format!("{:0width$X}", value, width = hex_digits))
}

pub fn get_system_name() -> anyhow::Result<String> {
    let mut system = System::new_all();
    system.refresh_all();
    Ok(System::long_os_version().unwrap_or_else(|| "Unknown OS".to_string()))
}

#[cfg(target_os = "windows")]
pub fn get_gpu_info() -> anyhow::Result<String> {
    use wmi::*;
    use serde::Deserialize;

    #[derive(Deserialize)]
    #[allow(non_snake_case)]
    struct Win32VideoController {
        Name: Option<String>,
        AdapterRAM: Option<u64>,
    }

    let com_con = COMLibrary::new()?;
    let wmi_con = WMIConnection::new(com_con)?;
    
    let results: Vec<Win32VideoController> = wmi_con.query()?;
    
    let mut output = String::new();
    for (i, gpu) in results.iter().enumerate() {
        if let Some(name) = &gpu.Name {
            output.push_str(&format!("GPU {}: {}", i + 1, name));
            if let Some(ram) = gpu.AdapterRAM {
                let ram_gb = ram / (1024 * 1024 * 1024);
                output.push_str(&format!(" ({} GB)", ram_gb));
            }
            output.push('\n');
        }
    }
    
    Ok(output.trim().to_string())
}

#[cfg(not(target_os = "windows"))]
pub fn get_gpu_info() -> anyhow::Result<String> {
    Ok("GPU info not available on this platform".to_string())
}

pub fn get_disk_info() -> anyhow::Result<String> {
    let disks = Disks::new_with_refreshed_list();
    
    let mut output = String::new();
    for disk in disks.list() {
        let name = disk.name().to_string_lossy();
        let mount = disk.mount_point().display();
        let total_space = disk.total_space() / (1024 * 1024 * 1024);
        let available_space = disk.available_space() / (1024 * 1024 * 1024);
        
        output.push_str(&format!(
            "{} ({}): {} GB total, {} GB available\n",
            name, mount, total_space, available_space
        ));
    }
    
    Ok(output.trim().to_string())
}

// ============================================
// File System Operations
// ============================================

pub fn calculate_directory_size(path: String, skip_paths: Vec<String>) -> anyhow::Result<u64> {
    use walkdir::WalkDir;
    
    let mut total_size: u64 = 0;
    
    for entry in WalkDir::new(&path).into_iter().filter_map(|e| e.ok()) {
        if entry.file_type().is_file() {
            let entry_path = entry.path().to_string_lossy().to_string();
            
            let mut should_skip = false;
            for skip_path in &skip_paths {
                if entry_path.starts_with(skip_path) {
                    should_skip = true;
                    break;
                }
            }
            
            if !should_skip {
                if let Ok(metadata) = entry.metadata() {
                    total_size += metadata.len();
                }
            }
        }
    }
    
    Ok(total_size)
}

#[cfg(target_os = "windows")]
pub fn resolve_shortcut(lnk_path: String) -> anyhow::Result<String> {
    use std::fs::File;
    use std::io::Read;
    
    // Read .lnk file and parse it manually (simple implementation)
    let mut file = File::open(&lnk_path)?;
    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer)?;
    
    // LNK files have a specific structure, we'll look for the path
    // This is a simplified approach - looking for a null-terminated wide string
    // A more robust solution would parse the full LNK file structure
    
    // Try to find the target path by looking for drive letters (C:\, D:\, etc.)
    let mut result = String::new();
    for i in 0..buffer.len().saturating_sub(4) {
        if buffer[i] >= b'A' && buffer[i] <= b'Z' && 
           buffer[i+1] == b':' && buffer[i+2] == b'\\' {
            // Found a potential path start
            let mut path_bytes = Vec::new();
            for j in i..buffer.len() {
                if buffer[j] == 0 {
                    break;
                }
                if buffer[j] >= 32 && buffer[j] < 127 {
                    path_bytes.push(buffer[j]);
                } else if buffer[j] < 32 || buffer[j] >= 127 {
                    break;
                }
            }
            let potential_path = String::from_utf8_lossy(&path_bytes).to_string();
            if potential_path.len() > 3 && potential_path.contains("\\") {
                result = potential_path;
                break;
            }
        }
    }
    
    if !result.is_empty() {
        Ok(result)
    } else {
        Err(anyhow::anyhow!("Failed to resolve shortcut"))
    }
}

#[cfg(not(target_os = "windows"))]
pub fn resolve_shortcut(lnk_path: String) -> anyhow::Result<String> {
    // On Unix systems, handle symbolic links
    use std::fs;
    use std::path::PathBuf;
    let path = PathBuf::from(lnk_path);
    let resolved = fs::read_link(&path)?;
    Ok(resolved.to_string_lossy().to_string())
}

#[cfg(target_os = "windows")]
pub fn open_directory(path: String, select_file: bool) -> anyhow::Result<()> {
    use std::process::Command;
    
    if select_file {
        Command::new("explorer.exe")
            .args(["/select,", &path])
            .spawn()?;
    } else {
        Command::new("explorer.exe")
            .arg(&path)
            .spawn()?;
    }
    
    Ok(())
}

#[cfg(not(target_os = "windows"))]
pub fn open_directory(path: String, _select_file: bool) -> anyhow::Result<()> {
    use std::process::Command;
    Command::new("xdg-open")
        .arg(&path)
        .spawn()?;
    Ok(())
}

pub fn get_hosts_file_path() -> anyhow::Result<String> {
    #[cfg(target_os = "windows")]
    {
        let system_root = std::env::var("SYSTEMROOT").unwrap_or_else(|_| "C:\\Windows".to_string());
        Ok(format!("{}\\System32\\drivers\\etc\\hosts", system_root))
    }
    
    #[cfg(not(target_os = "windows"))]
    {
        Ok("/etc/hosts".to_string())
    }
}