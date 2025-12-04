// WebView API using wry + tao
// This module provides a cross-platform WebView implementation for Flutter

use std::collections::HashMap;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

use crossbeam_channel::{bounded, Receiver, Sender};
use flutter_rust_bridge::frb;
use parking_lot::RwLock;
use serde::{Deserialize, Serialize};
use tao::dpi::{LogicalPosition, LogicalSize};
use tao::event::{Event, WindowEvent};
use tao::event_loop::{ControlFlow, EventLoop, EventLoopBuilder};
use tao::platform::run_return::EventLoopExtRunReturn;
use tao::window::{Icon, Window, WindowBuilder};
use wry::{PageLoadEvent, WebView, WebViewBuilder};

// Platform-specific imports for running event loop on any thread
#[cfg(target_os = "windows")]
use tao::platform::windows::EventLoopBuilderExtWindows;

use once_cell::sync::Lazy;

// Embed the app icon at compile time
static APP_ICON_DATA: &[u8] = include_bytes!("../../../windows/runner/resources/app_icon.ico");

// Embed the init script at compile time
static INIT_SCRIPT: &str = include_str!("../assets/webview_init_script.js");

// ============ Data Structures ============

/// WebView window configuration
#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(dart_metadata = ("freezed"))]
pub struct WebViewConfiguration {
    pub title: String,
    pub width: u32,
    pub height: u32,
    pub user_data_folder: Option<String>,
    pub enable_devtools: bool,
    pub transparent: bool,
    pub user_agent: Option<String>,
}

impl Default for WebViewConfiguration {
    fn default() -> Self {
        Self {
            title: "WebView".to_string(),
            width: 1280,
            height: 720,
            user_data_folder: None,
            enable_devtools: false,
            transparent: false,
            user_agent: None,
        }
    }
}

/// Navigation state of the WebView
#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(dart_metadata = ("freezed"))]
pub struct WebViewNavigationState {
    pub url: String,
    pub title: String,
    pub can_go_back: bool,
    pub can_go_forward: bool,
    pub is_loading: bool,
}

impl Default for WebViewNavigationState {
    fn default() -> Self {
        Self {
            url: String::new(),
            title: String::new(),
            can_go_back: false,
            can_go_forward: false,
            is_loading: false,
        }
    }
}

/// Events from WebView to Dart
#[derive(Debug, Clone, Serialize, Deserialize)]
#[frb(dart_metadata = ("freezed"))]
pub enum WebViewEvent {
    NavigationStarted { url: String },
    NavigationCompleted { url: String },
    TitleChanged { title: String },
    WebMessage { message: String },
    WindowClosed,
    Error { message: String },
}

/// Commands from Dart to WebView
#[derive(Debug, Clone)]
pub enum WebViewCommand {
    Navigate(String),
    GoBack,
    GoForward,
    Reload,
    Stop,
    ExecuteScript(String),
    SetVisibility(bool),
    Close,
    SetWindowSize(u32, u32),
    SetWindowPosition(i32, i32),
}

// ============ Global State ============

type WebViewId = String;

struct WebViewInstance {
    command_sender: Sender<WebViewCommand>,
    event_receiver: Receiver<WebViewEvent>,
    state: Arc<RwLock<WebViewNavigationState>>,
    is_closed: Arc<AtomicBool>,
}

static WEBVIEW_INSTANCES: Lazy<RwLock<HashMap<WebViewId, WebViewInstance>>> =
    Lazy::new(|| RwLock::new(HashMap::new()));

// Custom event type for the event loop
#[derive(Debug, Clone)]
#[allow(dead_code)]
enum UserEvent {
    Command(WebViewCommand),
    Quit,
}

// ============ Public API ============

/// Create a new WebView window and return its ID
#[frb(sync)]
pub fn webview_create(config: WebViewConfiguration) -> Result<String, String> {
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

/// Navigate to a URL
#[frb(sync)]
pub fn webview_navigate(id: String, url: String) -> Result<(), String> {
    send_command(&id, WebViewCommand::Navigate(url))
}

/// Go back in history
#[frb(sync)]
pub fn webview_go_back(id: String) -> Result<(), String> {
    send_command(&id, WebViewCommand::GoBack)
}

/// Go forward in history
#[frb(sync)]
pub fn webview_go_forward(id: String) -> Result<(), String> {
    send_command(&id, WebViewCommand::GoForward)
}

/// Reload the current page
#[frb(sync)]
pub fn webview_reload(id: String) -> Result<(), String> {
    send_command(&id, WebViewCommand::Reload)
}

/// Stop loading
#[frb(sync)]
pub fn webview_stop(id: String) -> Result<(), String> {
    send_command(&id, WebViewCommand::Stop)
}

/// Execute JavaScript in the WebView
#[frb(sync)]
pub fn webview_execute_script(id: String, script: String) -> Result<(), String> {
    send_command(&id, WebViewCommand::ExecuteScript(script))
}

/// Set window visibility
#[frb(sync)]
pub fn webview_set_visibility(id: String, visible: bool) -> Result<(), String> {
    send_command(&id, WebViewCommand::SetVisibility(visible))
}

/// Close the WebView window
#[frb(sync)]
pub fn webview_close(id: String) -> Result<(), String> {
    send_command(&id, WebViewCommand::Close)?;
    // Remove from instances after a short delay
    std::thread::spawn(move || {
        std::thread::sleep(std::time::Duration::from_millis(200));
        WEBVIEW_INSTANCES.write().remove(&id);
    });
    Ok(())
}

/// Set window size
#[frb(sync)]
pub fn webview_set_window_size(id: String, width: u32, height: u32) -> Result<(), String> {
    send_command(&id, WebViewCommand::SetWindowSize(width, height))
}

/// Set window position
#[frb(sync)]
pub fn webview_set_window_position(id: String, x: i32, y: i32) -> Result<(), String> {
    send_command(&id, WebViewCommand::SetWindowPosition(x, y))
}

/// Get the current navigation state
#[frb(sync)]
pub fn webview_get_state(id: String) -> Result<WebViewNavigationState, String> {
    let instances = WEBVIEW_INSTANCES.read();
    let instance = instances
        .get(&id)
        .ok_or_else(|| format!("WebView instance not found: {}", id))?;
    let state = instance.state.read().clone();
    Ok(state)
}

/// Check if the WebView is closed
#[frb(sync)]
pub fn webview_is_closed(id: String) -> bool {
    let instances = WEBVIEW_INSTANCES.read();
    let result = instances
        .get(&id)
        .map(|i| i.is_closed.load(Ordering::SeqCst))
        .unwrap_or(true);
    result
}

/// Poll for events from the WebView (non-blocking)
#[frb(sync)]
pub fn webview_poll_events(id: String) -> Vec<WebViewEvent> {
    let instances = WEBVIEW_INSTANCES.read();
    if let Some(instance) = instances.get(&id) {
        let mut events = Vec::new();
        while let Ok(event) = instance.event_receiver.try_recv() {
            events.push(event);
        }
        drop(instances);
        events
    } else {
        drop(instances);
        vec![]
    }
}

/// Get a list of all active WebView IDs
#[frb(sync)]
pub fn webview_list_all() -> Vec<String> {
    let instances = WEBVIEW_INSTANCES.read();
    let keys: Vec<String> = instances.keys().cloned().collect();
    drop(instances);
    keys
}

// ============ Internal Implementation ============

fn send_command(id: &str, command: WebViewCommand) -> Result<(), String> {
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
    // Set dark background color matching app theme (#1a1a1a)
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

    let event_tx_clone = event_tx.clone();

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

    let webview = builder
        .with_ipc_handler(move |message| {
            let msg = message.body().to_string();
            // Forward all messages to Dart
            let _ = event_tx_clone.send(WebViewEvent::WebMessage { message: msg });
        })
        .with_navigation_handler({
            let event_tx = event_tx.clone();
            let state = Arc::clone(&state);
            move |uri| {
                {
                    let mut state_guard = state.write();
                    state_guard.url = uri.clone();
                    state_guard.is_loading = true;
                }
                let _ = event_tx.send(WebViewEvent::NavigationStarted { url: uri });
                true // Allow navigation
            }
        })
        .with_on_page_load_handler({
            let event_tx = event_tx.clone();
            let state = Arc::clone(&state);
            move |event, url| {
                match event {
                    PageLoadEvent::Started => {
                        let mut state_guard = state.write();
                        state_guard.url = url.clone();
                        state_guard.is_loading = true;
                    }
                    PageLoadEvent::Finished => {
                        {
                            let mut state_guard = state.write();
                            state_guard.url = url.clone();
                            state_guard.is_loading = false;
                        }
                        let _ = event_tx.send(WebViewEvent::NavigationCompleted { url });
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
                    handle_command(&webview_cmd, &window, cmd, &state, &event_tx, &is_closed, control_flow);
                }
                UserEvent::Quit => {
                    is_closed.store(true, Ordering::SeqCst);
                    *control_flow = ControlFlow::Exit;
                }
            },
            _ => {}
        }
    });
    
    // Explicitly drop in correct order: webview first, then web_context, then window
    drop(webview_cmd);
    drop(web_context);
    drop(window);
}

fn handle_command(
    webview: &Arc<WebView>,
    window: &Arc<Window>,
    command: WebViewCommand,
    state: &Arc<RwLock<WebViewNavigationState>>,
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
            let _ = webview.evaluate_script("history.back()");
        }
        WebViewCommand::GoForward => {
            let _ = webview.evaluate_script("history.forward()");
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
            // Properly close the window and exit the event loop
            is_closed.store(true, Ordering::SeqCst);
            let _ = event_tx.send(WebViewEvent::WindowClosed);
            // Exit the event loop - this will cause cleanup
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
    
    // Parse the ICO file from embedded bytes
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
    
    // Convert to RGBA8
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
