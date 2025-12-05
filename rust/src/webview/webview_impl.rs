// WebView 实现 (Windows/Linux)
// 使用 wry + tao 实现跨平台 WebView

use std::collections::HashMap;
use std::sync::Arc;
use std::sync::atomic::{AtomicBool, Ordering};

use crossbeam_channel::{bounded, Receiver, Sender};
use parking_lot::RwLock;
use once_cell::sync::Lazy;
use tao::dpi::{LogicalPosition, LogicalSize};
use tao::event::{Event, WindowEvent};
use tao::event_loop::{ControlFlow, EventLoop, EventLoopBuilder};
use tao::platform::run_return::EventLoopExtRunReturn;
use tao::window::{Icon, Window, WindowBuilder};
use wry::{PageLoadEvent, WebView, WebViewBuilder};

#[cfg(target_os = "windows")]
use tao::platform::windows::EventLoopBuilderExtWindows;

use crate::api::webview_api::{
    WebViewConfiguration, WebViewNavigationState, WebViewEvent, WebViewCommand,
};

// Embed the app icon at compile time
static APP_ICON_DATA: &[u8] = include_bytes!("../../windows/runner/resources/app_icon.ico");

// Embed the init script at compile time
static INIT_SCRIPT: &str = include_str!("../assets/webview_init_script.js");

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
        
        if self.current_index >= 0 && (self.current_index as usize) < self.urls.len().saturating_sub(1) {
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
        run_webview_loop(id_clone, config, cmd_rx, event_tx, state_clone, is_closed_clone);
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
    #[cfg(target_os = "windows")]
    let mut event_loop: EventLoop<UserEvent> = EventLoopBuilder::with_user_event()
        .with_any_thread(true)
        .build();
    
    #[cfg(not(target_os = "windows"))]
    let mut event_loop: EventLoop<UserEvent> = EventLoopBuilder::with_user_event().build();
    
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
    
    let window = window_builder.build(&event_loop)
        .expect("Failed to create window");

    let window = Arc::new(window);

    // Navigation history for tracking back/forward state
    let nav_history = Arc::new(RwLock::new(NavigationHistory::new()));

    let event_tx_clone = event_tx.clone();
    let nav_history_ipc = Arc::clone(&nav_history);
    let state_ipc = Arc::clone(&state);

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
        .with_background_color((26, 26, 26, 255)) // Dark background #1a1a1a
        .with_initialization_script(INIT_SCRIPT);

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
                                let _ = proxy_ipc.send_event(UserEvent::Command(WebViewCommand::GoBack));
                            }
                            return;
                        }
                        "nav_forward" => {
                            let can_forward = nav_history_ipc.read().can_go_forward();
                            if can_forward {
                                let _ = proxy_ipc.send_event(UserEvent::Command(WebViewCommand::GoForward));
                            }
                            return;
                        }
                        "nav_reload" => {
                            let _ = proxy_ipc.send_event(UserEvent::Command(WebViewCommand::Reload));
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
                            let _ = proxy_ipc.send_event(UserEvent::Command(WebViewCommand::ExecuteScript(script)));
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
            move |uri| {
                if uri == "about:blank" {
                    return true;
                }
                
                {
                    let mut state_guard = state.write();
                    state_guard.url = uri.clone();
                    state_guard.is_loading = true;
                    let history = nav_history.read();
                    state_guard.can_go_back = history.can_go_back();
                    state_guard.can_go_forward = history.can_go_forward();
                }
                let _ = event_tx.send(WebViewEvent::NavigationStarted { url: uri });
                true
            }
        })
        .with_on_page_load_handler({
            let event_tx = event_tx.clone();
            let state = Arc::clone(&state);
            let nav_history = Arc::clone(&nav_history);
            let proxy = proxy.clone();
            move |event, url| {
                if url == "about:blank" {
                    return;
                }
                
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
                        let state_json = serde_json::json!({
                            "can_go_back": can_back,
                            "can_go_forward": can_forward,
                            "is_loading": true,
                            "url": url
                        });
                        let script = format!("window._sctUpdateNavState && window._sctUpdateNavState({})", state_json);
                        let _ = proxy.send_event(UserEvent::Command(WebViewCommand::ExecuteScript(script)));
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
                        let _ = event_tx.send(WebViewEvent::NavigationCompleted { url: url.clone() });
                        
                        let state_json = serde_json::json!({
                            "can_go_back": can_back,
                            "can_go_forward": can_forward,
                            "is_loading": false,
                            "url": url
                        });
                        let script = format!("window._sctUpdateNavState && window._sctUpdateNavState({})", state_json);
                        let _ = proxy.send_event(UserEvent::Command(WebViewCommand::ExecuteScript(script)));
                    }
                }
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
                    handle_command(&webview_cmd, &window, cmd, &state, &nav_history, &event_tx, &is_closed, control_flow);
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
    }
}

/// Load the application icon from embedded ICO data
fn load_app_icon() -> Option<Icon> {
    use std::io::Cursor;
    use image::ImageReader;
    
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
