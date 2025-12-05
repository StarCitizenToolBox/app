// WebView 独立模块
// 此模块包含 wry + tao WebView 的完整实现
// macOS 平台不支持 WebView，因为 tao 的 EventLoop 必须在主线程运行，与 Flutter 冲突

#[cfg(not(target_os = "macos"))]
mod webview_impl;

#[cfg(not(target_os = "macos"))]
pub use webview_impl::*;

// macOS 平台提供空实现
#[cfg(target_os = "macos")]
mod webview_stub;

#[cfg(target_os = "macos")]
pub use webview_stub::*;
