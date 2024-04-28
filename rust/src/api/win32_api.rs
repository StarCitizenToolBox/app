use notify_rust::Notification;
use windows::core::{HSTRING, PCWSTR};
use windows::Win32::Foundation::HWND;
use windows::Win32::UI::WindowsAndMessaging;

pub fn send_notify(summary: Option<String>, body: Option<String>, app_name: Option<String>, app_id: Option<String>) -> anyhow::Result<()> {
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
    if let Some(app_id) = app_id {
        n.app_id(&app_id);
    }
    n.show()?;
    Ok(())
}

pub fn set_foreground_window(window_name: &str) -> anyhow::Result<bool> {
    let window_name_p: PCWSTR = PCWSTR(HSTRING::from(window_name).as_ptr());
    let h = unsafe { WindowsAndMessaging::FindWindowW(PCWSTR::null(), window_name_p) };
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
