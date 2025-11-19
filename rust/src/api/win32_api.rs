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
        OpenProcess, QueryFullProcessImageNameW, PROCESS_NAME_WIN32, PROCESS_QUERY_LIMITED_INFORMATION,
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
                ).is_ok() && path_len > 0 {
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