// WebView API using wry + tao

use std::sync::atomic::Ordering;

use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

use crate::webview::{WEBVIEW_INSTANCES, send_command};

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

// ============ Public API ============

/// Create a new WebView window and return its ID
#[frb(sync)]
pub fn webview_create(config: WebViewConfiguration) -> Result<String, String> {
    crate::webview::create_webview(config)
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
