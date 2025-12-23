// WebView 实现 (Windows/Linux)
// 使用 wry + tao 实现跨平台 WebView

use std::collections::HashMap;
use std::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use std::sync::Arc;

use crossbeam_channel::{bounded, Receiver, Sender};
use once_cell::sync::Lazy;
use parking_lot::RwLock;
use tao::dpi::{LogicalPosition, LogicalSize};
use tao::event::{Event, WindowEvent};
use tao::event_loop::{ControlFlow, EventLoop, EventLoopBuilder};
use tao::platform::run_return::EventLoopExtRunReturn;

use tao::window::{Icon, Window, WindowBuilder};
use wry::{NewWindowResponse, PageLoadEvent, WebView, WebViewBuilder};

#[cfg(target_os = "windows")]
use tao::platform::windows::EventLoopBuilderExtWindows;

#[cfg(target_os = "linux")]
use tao::platform::unix::EventLoopBuilderExtUnix;

use crate::api::webview_api::{
    WebViewCommand, WebViewConfiguration, WebViewEvent, WebViewNavigationState,
};

// ============ Loading Progress Animation ============

/// Braille spinner characters for loading animation
/// These are standard Unicode characters that work across all platforms
const SPINNER_CHARS: [char; 10] = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

/// Get the progress animation character for the current frame
fn get_progress_char(frame: usize) -> char {
    SPINNER_CHARS[frame % SPINNER_CHARS.len()]
}

// Embed the app icon at compile time
static APP_ICON_DATA: &[u8] = include_bytes!("../../../windows/runner/resources/app_icon.ico");

// Embed the init script at compile time
static INIT_SCRIPT: &str = include_str!("webview_init_script.js");

// Embed the request interceptor script at compile time
static REQUEST_INTERCEPTOR_SCRIPT: &str = include_str!("request_interceptor.js");

// Loading page HTML for about:blank initialization
static LOADING_PAGE_HTML: &str = r#"<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loading...</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body {
            width: 100%; height: 100%;
            background: #0A1D29;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', system-ui, sans-serif;
            overflow: hidden;
        }
        .loading-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1.5rem;
            animation: fadeIn 0.3s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .spinner {
            width: 48px;
            height: 48px;
            border: 3px solid rgba(255, 255, 255, 0.16);
            border-top-color: rgba(255, 255, 255, 0.92);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        .loading-text {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.875rem;
            letter-spacing: 0.05em;
        }
        .loading-dots::after {
            content: '';
            animation: dots 1.5s steps(4, end) infinite;
        }
        @keyframes dots {
            0%, 20% { content: ''; }
            40% { content: '.'; }
            60% { content: '..'; }
            80%, 100% { content: '...'; }
        }
    </style>
</head>
<body>
    <div class="loading-container">
        <div class="spinner"></div>
        <div class="loading-text">Loading<span class="loading-dots"></span></div>
    </div>
</body>
</html>"#;

// ============ Types ============

pub type WebViewId = String;

/// Navigation history manager to track back/forward capability
#[derive(Debug, Clone, Default)]
struct NavigationHistory {
    urls: Vec<String>,
    current_index: i32,
}

impl NavigationHistory {
    fn new() -> Self {
        Self {
            urls: Vec::new(),
            current_index: -1,
        }
    }

    fn push(&mut self, url: &str) {
        if url == "about:blank" {
            return;
        }

        if self.current_index >= 0
            && (self.current_index as usize) < self.urls.len().saturating_sub(1)
        {
            self.urls.truncate((self.current_index + 1) as usize);
        }

        if self.urls.last().map(|s| s.as_str()) != Some(url) {
            self.urls.push(url.to_string());
        }
        self.current_index = (self.urls.len() as i32) - 1;
    }

    fn can_go_back(&self) -> bool {
        self.current_index > 0
    }

    fn can_go_forward(&self) -> bool {
        self.current_index >= 0 && (self.current_index as usize) < self.urls.len().saturating_sub(1)
    }

    fn go_back(&mut self) -> bool {
        if self.can_go_back() {
            self.current_index -= 1;
            true
        } else {
            false
        }
    }

    fn go_forward(&mut self) -> bool {
        if self.can_go_forward() {
            self.current_index += 1;
            true
        } else {
            false
        }
    }

    #[allow(dead_code)]
    fn current_url(&self) -> Option<&str> {
        if self.current_index >= 0 && (self.current_index as usize) < self.urls.len() {
            Some(&self.urls[self.current_index as usize])
        } else {
            None
        }
    }
}

pub struct WebViewInstance {
    pub command_sender: Sender<WebViewCommand>,
    pub event_receiver: Receiver<WebViewEvent>,
    pub state: Arc<RwLock<WebViewNavigationState>>,
    pub is_closed: Arc<AtomicBool>,
}

pub static WEBVIEW_INSTANCES: Lazy<RwLock<HashMap<WebViewId, WebViewInstance>>> =
    Lazy::new(|| RwLock::new(HashMap::new()));

// Custom event type for the event loop
#[derive(Debug, Clone)]
#[allow(dead_code)]
enum UserEvent {
    Command(WebViewCommand),
    Quit,
}

// ============ Public Implementation ============

/// Create a new WebView window
pub fn create_webview(config: WebViewConfiguration) -> Result<String, String> {
    let id = uuid::Uuid::new_v4().to_string();
    let id_clone = id.clone();

    let (cmd_tx, cmd_rx) = bounded::<WebViewCommand>(100);
    let (event_tx, event_rx) = bounded::<WebViewEvent>(100);
    let state = Arc::new(RwLock::new(WebViewNavigationState::default()));
    let state_clone = Arc::clone(&state);
    let is_closed = Arc::new(AtomicBool::new(false));
    let is_closed_clone = Arc::clone(&is_closed);

    std::thread::spawn(move || {
        run_webview_loop(
            id_clone,
            config,
            cmd_rx,
            event_tx,
            state_clone,
            is_closed_clone,
        );
    });

    // Wait a moment for the window to be created
    std::thread::sleep(std::time::Duration::from_millis(100));

    let instance = WebViewInstance {
        command_sender: cmd_tx,
        event_receiver: event_rx,
        state,
        is_closed,
    };

    WEBVIEW_INSTANCES.write().insert(id.clone(), instance);
    Ok(id)
}

pub fn send_command(id: &str, command: WebViewCommand) -> Result<(), String> {
    let instances = WEBVIEW_INSTANCES.read();
    let instance = instances
        .get(id)
        .ok_or_else(|| format!("WebView instance not found: {}", id))?;

    if instance.is_closed.load(Ordering::SeqCst) {
        return Err("WebView is closed".to_string());
    }

    instance
        .command_sender
        .send(command)
        .map_err(|e| e.to_string())
}

// ============ Internal Implementation ============

fn run_webview_loop(
    _id: String,
    config: WebViewConfiguration,
    cmd_rx: Receiver<WebViewCommand>,
    event_tx: Sender<WebViewEvent>,
    state: Arc<RwLock<WebViewNavigationState>>,
    is_closed: Arc<AtomicBool>,
) {
    // Create event loop with any_thread support for non-main thread execution
    let mut event_loop: EventLoop<UserEvent> = EventLoopBuilder::with_user_event()
        .with_any_thread(true)
        .build();

    let proxy = event_loop.create_proxy();

    // Load window icon from embedded ICO file
    let window_icon = load_app_icon();

    // Build the window with decorations (title bar provided by OS)
    let mut window_builder = WindowBuilder::new()
        .with_title(&config.title)
        .with_inner_size(LogicalSize::new(config.width, config.height))
        .with_visible(true);

    // Set window icon if loaded successfully
    if let Some(icon) = window_icon {
        window_builder = window_builder.with_window_icon(Some(icon));
    }

    let window = window_builder
        .build(&event_loop)
        .expect("Failed to create window");

    let window = Arc::new(window);

    // Navigation history for tracking back/forward state
    let nav_history = Arc::new(RwLock::new(NavigationHistory::new()));

    // Counter for CF bypass: number of page loads to skip init script injection
    // When CF challenge is detected, we set this to 1, skip next load, then resume normal injection
    let cf_skip_count = Arc::new(AtomicU32::new(0));

    // Store original title for restoration after loading
    let original_title = Arc::new(RwLock::new(config.title.clone()));

    let event_tx_clone = event_tx.clone();
    let nav_history_ipc = Arc::clone(&nav_history);
    let state_ipc = Arc::clone(&state);
    let cf_skip_count_ipc = Arc::clone(&cf_skip_count);
    let original_title_ipc = Arc::clone(&original_title);

    // Create web context with custom data directory if provided
    let mut web_context = config
        .user_data_folder
        .as_ref()
        .map(|path| wry::WebContext::new(Some(std::path::PathBuf::from(path))))
        .unwrap_or_default();

    let mut builder = WebViewBuilder::new_with_web_context(&mut web_context)
        .with_url("about:blank")
        .with_devtools(config.enable_devtools)
        .with_transparent(config.transparent)
        .with_background_color((10, 29, 41, 255))
        .with_initialization_script(REQUEST_INTERCEPTOR_SCRIPT);

    // Set user agent if provided
    if let Some(ref user_agent) = config.user_agent {
        builder = builder.with_user_agent(user_agent);
    }

    // Store proxy for IPC commands
    let proxy_ipc = proxy.clone();

    let webview = builder
        .with_ipc_handler(move |message| {
            let msg = message.body().to_string();

            // Try to parse as navigation command from JS
            if let Ok(parsed) = serde_json::from_str::<serde_json::Value>(&msg) {
                if let Some(msg_type) = parsed.get("type").and_then(|v| v.as_str()) {
                    match msg_type {
                        "nav_back" => {
                            let can_back = nav_history_ipc.read().can_go_back();
                            if can_back {
                                let _ = proxy_ipc
                                    .send_event(UserEvent::Command(WebViewCommand::GoBack));
                            }
                            return;
                        }
                        "nav_forward" => {
                            let can_forward = nav_history_ipc.read().can_go_forward();
                            if can_forward {
                                let _ = proxy_ipc
                                    .send_event(UserEvent::Command(WebViewCommand::GoForward));
                            }
                            return;
                        }
                        "nav_reload" => {
                            let _ =
                                proxy_ipc.send_event(UserEvent::Command(WebViewCommand::Reload));
                            return;
                        }
                        "get_nav_state" => {
                            let state_guard = state_ipc.read();
                            let history = nav_history_ipc.read();
                            let state_json = serde_json::json!({
                                "can_go_back": history.can_go_back(),
                                "can_go_forward": history.can_go_forward(),
                                "is_loading": state_guard.is_loading,
                                "url": state_guard.url
                            });
                            let script = format!("window._sctUpdateNavState({})", state_json);
                            let _ = proxy_ipc.send_event(UserEvent::Command(
                                WebViewCommand::ExecuteScript(script),
                            ));
                            return;
                        }
                        "cf_challenge_detected" => {
                            // CF challenge was detected, skip next page load cycle (2 events: Started + Finished)
                            cf_skip_count_ipc.store(2, Ordering::SeqCst);
                            let _ = proxy_ipc.send_event(UserEvent::Command(WebViewCommand::Reload));
                            return;
                        }
                        "loading_progress" => {
                            // Update window title with loading progress
                            if let Some(payload) = parsed.get("payload") {
                                let progress = payload.get("progress").and_then(|v| v.as_f64());
                                let is_loading = payload.get("is_loading").and_then(|v| v.as_bool()).unwrap_or(false);
                                let dot_frame = payload.get("dot_frame").and_then(|v| v.as_i64()).unwrap_or(0) as usize;
                                
                                let base_title = original_title_ipc.read().clone();
                                
                                let new_title = if is_loading {
                                    // Get Windows progress animation character
                                    let progress_char = get_progress_char(dot_frame);
                                    
                                    if let Some(p) = progress {
                                        let percent = (p * 100.0).round() as i32;
                                        format!("{} {} {}%", base_title, progress_char, percent)
                                    } else {
                                        format!("{} {} Loading", base_title, progress_char)
                                    }
                                } else {
                                    // Loading complete, restore original title
                                    base_title
                                };
                                
                                let _ = proxy_ipc.send_event(UserEvent::Command(
                                    WebViewCommand::SetWindowTitle(new_title)
                                ));
                            }
                            return;
                        }
                        _ => {}
                    }
                }
            }

            // Forward other messages to Dart
            let _ = event_tx_clone.send(WebViewEvent::WebMessage { message: msg });
        })
        .with_navigation_handler({
            let event_tx = event_tx.clone();
            let state = Arc::clone(&state);
            let nav_history = Arc::clone(&nav_history);
            let proxy = proxy.clone();
            let original_title = Arc::clone(&original_title);
            move |uri| {
                // Block navigation to about:blank (except initial load)
                // This prevents users from going back to the blank initial page
                if uri == "about:blank" {
                    // Check if we already have navigation history
                    // If yes, this is a back navigation to about:blank - block it
                    let has_history = !nav_history.read().urls.is_empty();
                    if has_history {
                        // Navigate forward instead to stay on valid page
                        let _ = proxy.send_event(UserEvent::Command(WebViewCommand::ExecuteScript(
                            "history.forward()".to_string()
                        )));
                        return false;
                    }
                    return true;
                }

                // Note: cf_skip_count is NOT reset here
                // The counter naturally decrements to 0 after skipping, allowing normal injection

                let can_back;
                let can_forward;
                {
                    let mut state_guard = state.write();
                    state_guard.url = uri.clone();
                    state_guard.is_loading = true;
                    let history = nav_history.read();
                    can_back = history.can_go_back();
                    can_forward = history.can_go_forward();
                    state_guard.can_go_back = can_back;
                    state_guard.can_go_forward = can_forward;
                }

                // Update window title immediately to show loading state
                // This provides instant feedback before JS is injected
                {
                    let base_title = original_title.read().clone();
                    let progress_char = get_progress_char(0);
                    let loading_title = format!("{} {} 0%", base_title, progress_char);
                    let _ = proxy.send_event(UserEvent::Command(
                        WebViewCommand::SetWindowTitle(loading_title)
                    ));
                }

                // Send loading state to JS immediately when navigation starts
                // This makes the spinner appear on the current page before navigating away
                let state_json = serde_json::json!({
                    "can_go_back": can_back,
                    "can_go_forward": can_forward,
                    "is_loading": true,
                    "url": uri
                });
                let script = format!(
                    "window._sctUpdateNavState && window._sctUpdateNavState({})",
                    state_json
                );
                let _ = proxy.send_event(UserEvent::Command(WebViewCommand::ExecuteScript(script)));

                let _ = event_tx.send(WebViewEvent::NavigationStarted { url: uri });
                true
            }
        })
        .with_on_page_load_handler({
            let event_tx = event_tx.clone();
            let state = Arc::clone(&state);
            let nav_history = Arc::clone(&nav_history);
            let cf_skip_count = Arc::clone(&cf_skip_count);
            let proxy = proxy.clone();
            move |event, url| {
                if url == "about:blank" {
                    if matches!(event, PageLoadEvent::Finished) {
                        // if url is about:blank, show loading
                        // Add URL check in JS to prevent injection if page has already navigated away
                        let loading_script = format!(
                            r#"(function() {{
                                if (window.location.href === 'about:blank') {{
                                    document.open();
                                    document.write({});
                                    document.close();
                                }}
                            }})();"#,
                            serde_json::to_string(LOADING_PAGE_HTML).unwrap_or_default()
                        );
                        let _ = proxy.send_event(UserEvent::Command(
                            WebViewCommand::ExecuteScript(loading_script),
                        ));
                    }
                    return;
                }

                // Check if we should skip injection/CF check (CF bypass active)
                // Counter is set to 2 when CF detected: decrements once in Started, once in Finished
                let should_skip = {
                    let count = cf_skip_count.load(Ordering::SeqCst);
                    if count > 0 {
                        cf_skip_count.fetch_sub(1, Ordering::SeqCst);
                        true
                    } else {
                        false
                    }
                };

                match event {
                    PageLoadEvent::Started => {
                        let can_back;
                        let can_forward;
                        {
                            let mut state_guard = state.write();
                            state_guard.url = url.clone();
                            state_guard.is_loading = true;
                            let history = nav_history.read();
                            can_back = history.can_go_back();
                            can_forward = history.can_go_forward();
                            state_guard.can_go_back = can_back;
                            state_guard.can_go_forward = can_forward;
                        }

                        // Inject init script at page start for fast navbar display
                        // Skip injection if CF bypass counter is active
                        if !should_skip {
                            let state_json = serde_json::json!({
                                "can_go_back": can_back,
                                "can_go_forward": can_forward,
                                "is_loading": true,
                                "url": url
                            });
                            let init_script_with_state = format!(
                                r#"(function() {{
                                    if (!window._sctInitialized) {{
                                        {init_script}
                                    }}
                                    if (window._sctUpdateNavState) {{
                                        window._sctUpdateNavState({state_json});
                                    }}
                                }})();"#,
                                init_script = INIT_SCRIPT,
                                state_json = state_json
                            );
                            let _ = proxy.send_event(UserEvent::Command(
                                WebViewCommand::ExecuteScript(init_script_with_state),
                            ));
                        }
                    }
                    PageLoadEvent::Finished => {
                        let can_back;
                        let can_forward;
                        {
                            let mut history = nav_history.write();
                            history.push(&url);
                            can_back = history.can_go_back();
                            can_forward = history.can_go_forward();
                        }
                        {
                            let mut state_guard = state.write();
                            state_guard.url = url.clone();
                            state_guard.is_loading = false;
                            state_guard.can_go_back = can_back;
                            state_guard.can_go_forward = can_forward;
                        }
                        let _ =
                            event_tx.send(WebViewEvent::NavigationCompleted { url: url.clone() });

                        // If CF bypass is active for this URL, skip CF check
                        // Let the user complete the CF challenge without interference
                        if should_skip {
                            // Just update nav state if navbar somehow exists
                            let state_json = serde_json::json!({
                                "can_go_back": can_back,
                                "can_go_forward": can_forward,
                                "is_loading": false,
                                "url": url
                            });
                            let script = format!(
                                "window._sctUpdateNavState && window._sctUpdateNavState({})",
                                state_json
                            );
                            let _ = proxy.send_event(UserEvent::Command(
                                WebViewCommand::ExecuteScript(script),
                            ));
                            return;
                        }

                        // Check for CF challenge and handle accordingly
                        let state_json = serde_json::json!({
                            "can_go_back": can_back,
                            "can_go_forward": can_forward,
                            "is_loading": false,
                            "url": url
                        });
                        
                        // Script to check CF challenge and notify Rust via IPC if detected
                        let cf_check_script = format!(
                            r#"(function() {{
                                // Check if this is a Cloudflare challenge page
                                var isCfChallenge = (function() {{
                                    // Check page title
                                    if (document.title && (
                                        document.title.indexOf('Just a moment') !== -1 ||
                                        document.title.indexOf('Checking your browser') !== -1 ||
                                        document.title.indexOf('Please wait') !== -1 ||
                                        document.title.indexOf('Attention Required') !== -1
                                    )) return true;
                                    // Check for CF challenge elements
                                    if (document.getElementById('challenge-running') ||
                                        document.getElementById('challenge-form') ||
                                        document.getElementById('cf-spinner-please-wait') ||
                                        document.getElementById('cf-stage') ||
                                        document.querySelector('.cf-browser-verification') ||
                                        document.querySelector('[data-ray]')) return true;
                                    // Check for CF challenge script
                                    var scripts = document.getElementsByTagName('script');
                                    for (var i = 0; i < scripts.length; i++) {{
                                        if (scripts[i].src && scripts[i].src.indexOf('/cdn-cgi/challenge-platform/') !== -1) return true;
                                    }}
                                    return false;
                                }})();
                                
                                if (isCfChallenge) {{
                                    console.log('[SCToolbox] CF challenge detected, will reload without navbar');
                                    // Remove navbar if it was injected
                                    var navbar = document.getElementById('sct-navbar');
                                    if (navbar) navbar.remove();
                                    window._sctInitialized = false;
                                    // Notify Rust to skip init script on next load and reload
                                    if (window.ipc && typeof window.ipc.postMessage === 'function') {{
                                        window.ipc.postMessage(JSON.stringify({{ type: 'cf_challenge_detected' }}));
                                    }}
                                }} else {{
                                    // Update nav state if navbar exists
                                    if (window._sctUpdateNavState) {{
                                        window._sctUpdateNavState({state_json});
                                    }}
                                }}
                            }})();"#,
                            state_json = state_json
                        );
                        let _ = proxy.send_event(UserEvent::Command(
                            WebViewCommand::ExecuteScript(cf_check_script),
                        ));
                    }
                }
            }
        })
        .with_new_window_req_handler({
            let proxy = proxy.clone();
            move |uri, _features| {
                // Intercept new window requests (e.g., target="_blank" links)
                // Navigate in current window instead since we don't support multiple windows
                let _ = proxy.send_event(UserEvent::Command(WebViewCommand::Navigate(uri)));
                // Return Deny to prevent opening a new window
                NewWindowResponse::Deny
            }
        })
        .build(&window)
        .expect("Failed to create webview");

    let webview = Arc::new(webview);
    let webview_cmd = Arc::clone(&webview);

    // Spawn command handler thread
    let proxy_cmd = proxy.clone();
    std::thread::spawn(move || {
        while let Ok(cmd) = cmd_rx.recv() {
            if proxy_cmd.send_event(UserEvent::Command(cmd)).is_err() {
                break;
            }
        }
    });

    // Run the event loop with run_return so we can properly cleanup
    event_loop.run_return(|event, _, control_flow| {
        *control_flow = ControlFlow::Wait;

        match event {
            Event::WindowEvent {
                event: WindowEvent::CloseRequested,
                ..
            } => {
                is_closed.store(true, Ordering::SeqCst);
                let _ = event_tx.send(WebViewEvent::WindowClosed);
                *control_flow = ControlFlow::Exit;
            }
            Event::UserEvent(user_event) => match user_event {
                UserEvent::Command(cmd) => {
                    handle_command(
                        &webview_cmd,
                        &window,
                        cmd,
                        &state,
                        &nav_history,
                        &event_tx,
                        &is_closed,
                        control_flow,
                    );
                }
                UserEvent::Quit => {
                    is_closed.store(true, Ordering::SeqCst);
                    *control_flow = ControlFlow::Exit;
                }
            },
            _ => {}
        }
    });

    // Explicitly drop in correct order
    drop(webview_cmd);
    drop(web_context);
    drop(window);
}

fn handle_command(
    webview: &Arc<WebView>,
    window: &Arc<Window>,
    command: WebViewCommand,
    state: &Arc<RwLock<WebViewNavigationState>>,
    nav_history: &Arc<RwLock<NavigationHistory>>,
    event_tx: &Sender<WebViewEvent>,
    is_closed: &Arc<AtomicBool>,
    control_flow: &mut ControlFlow,
) {
    match command {
        WebViewCommand::Navigate(url) => {
            {
                let mut s = state.write();
                s.url = url.clone();
                s.is_loading = true;
            }
            let _ = webview.load_url(&url);
            let _ = event_tx.send(WebViewEvent::NavigationStarted { url });
        }
        WebViewCommand::GoBack => {
            let can_go = {
                let mut history = nav_history.write();
                history.go_back()
            };
            if can_go {
                let _ = webview.evaluate_script("history.back()");
            }
        }
        WebViewCommand::GoForward => {
            let can_go = {
                let mut history = nav_history.write();
                history.go_forward()
            };
            if can_go {
                let _ = webview.evaluate_script("history.forward()");
            }
        }
        WebViewCommand::Reload => {
            let _ = webview.evaluate_script("location.reload()");
        }
        WebViewCommand::Stop => {
            let _ = webview.evaluate_script("window.stop()");
        }
        WebViewCommand::ExecuteScript(script) => {
            let _ = webview.evaluate_script(&script);
        }
        WebViewCommand::SetVisibility(visible) => {
            window.set_visible(visible);
        }
        WebViewCommand::Close => {
            is_closed.store(true, Ordering::SeqCst);
            let _ = event_tx.send(WebViewEvent::WindowClosed);
            *control_flow = ControlFlow::Exit;
        }
        WebViewCommand::SetWindowSize(width, height) => {
            let _ = window.set_inner_size(LogicalSize::new(width, height));
        }
        WebViewCommand::SetWindowPosition(x, y) => {
            window.set_outer_position(LogicalPosition::new(x, y));
        }
        WebViewCommand::SetWindowTitle(title) => {
            window.set_title(&title);
        }
    }
}

/// Load the application icon from embedded ICO data
fn load_app_icon() -> Option<Icon> {
    use image::ImageReader;
    use std::io::Cursor;

    let cursor = Cursor::new(APP_ICON_DATA);
    let reader = match ImageReader::new(cursor).with_guessed_format() {
        Ok(r) => r,
        Err(e) => {
            eprintln!("[SCToolbox] Failed to create image reader: {}", e);
            return None;
        }
    };

    let img = match reader.decode() {
        Ok(img) => img,
        Err(e) => {
            eprintln!("[SCToolbox] Failed to decode icon: {}", e);
            return None;
        }
    };

    let rgba = img.to_rgba8();
    let (width, height) = rgba.dimensions();
    let raw_data = rgba.into_raw();

    match Icon::from_rgba(raw_data, width, height) {
        Ok(icon) => Some(icon),
        Err(e) => {
            eprintln!("[SCToolbox] Failed to create icon: {:?}", e);
            None
        }
    }
}
