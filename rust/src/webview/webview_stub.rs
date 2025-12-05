// macOS WebView 存根实现
// macOS 平台不支持 WebView，因为 tao 的 EventLoop 必须在主线程运行，与 Flutter 冲突

use std::collections::HashMap;
use std::sync::Arc;
use std::sync::atomic::AtomicBool;

use crossbeam_channel::{Receiver, Sender};
use parking_lot::RwLock;
use once_cell::sync::Lazy;

use crate::api::webview_api::{
    WebViewConfiguration, WebViewNavigationState, WebViewEvent, WebViewCommand,
};

// ============ Types ============

pub type WebViewId = String;

pub struct WebViewInstance {
    pub command_sender: Sender<WebViewCommand>,
    pub event_receiver: Receiver<WebViewEvent>,
    pub state: Arc<RwLock<WebViewNavigationState>>,
    pub is_closed: Arc<AtomicBool>,
}

pub static WEBVIEW_INSTANCES: Lazy<RwLock<HashMap<WebViewId, WebViewInstance>>> =
    Lazy::new(|| RwLock::new(HashMap::new()));

// ============ macOS 存根实现 ============

/// macOS 上 WebView 不可用
pub fn create_webview(_config: WebViewConfiguration) -> Result<String, String> {
    Err("WebView is not supported on macOS".to_string())
}

pub fn send_command(id: &str, _command: WebViewCommand) -> Result<(), String> {
    Err(format!("WebView instance not found: {} (WebView not supported on macOS)", id))
}
