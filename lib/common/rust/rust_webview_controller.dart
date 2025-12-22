// Rust WebView 管理器
// 使用 wry + tao 实现的 WebView 窗口管理

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:starcitizen_doctor/common/rust/api/webview_api.dart' as rust_webview;
import 'package:starcitizen_doctor/common/utils/log.dart';

typedef OnWebMessageCallback = void Function(String message);
typedef OnNavigationCallback = void Function(String url);
typedef OnNavigationCompletedCallback = void Function(String url);
typedef OnWindowClosedCallback = void Function();

/// Rust WebView 控制器
/// 封装 Rust wry + tao WebView 的业务逻辑
class RustWebViewController {
  final String id;
  final List<OnWebMessageCallback> _messageCallbacks = [];
  final List<OnNavigationCallback> _navigationCallbacks = [];
  final List<OnNavigationCompletedCallback> _navigationCompletedCallbacks = [];
  final List<OnWindowClosedCallback> _closeCallbacks = [];

  Timer? _pollTimer;
  bool _isDisposed = false;

  /// 本地化脚本（从 assets 加载）
  String _localizationScript = "";

  /// 当前 URL
  String _currentUrl = "";
  String get currentUrl => _currentUrl;

  RustWebViewController._(this.id);

  /// 创建新的 WebView 窗口
  static Future<RustWebViewController> create({
    String title = "WebView",
    int width = 1280,
    int height = 720,
    String? userDataFolder,
    bool enableDevtools = false,
    bool transparent = false,
    String? userAgent,
  }) async {
    try {
      final config = rust_webview.WebViewConfiguration(
        title: title,
        width: width,
        height: height,
        userDataFolder: userDataFolder,
        enableDevtools: enableDevtools,
        transparent: transparent,
        userAgent: userAgent,
      );

      final id = rust_webview.webviewCreate(config: config);
      final controller = RustWebViewController._(id);

      // 加载脚本资源
      await controller._loadScripts();

      // 启动事件轮询
      controller._startEventPolling();

      return controller;
    } catch (e) {
      throw Exception("Failed to create WebView: $e");
    }
  }

  /// 加载本地化和拦截器脚本
  Future<void> _loadScripts() async {
    try {
      _localizationScript = await rootBundle.loadString('assets/web_script.js');
    } catch (e) {
      dPrint("Failed to load scripts: $e");
    }
  }

  /// 启动事件轮询
  void _startEventPolling() {
    _pollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_isDisposed) return;
      _pollEvents();
    });
  }

  /// 轮询事件
  void _pollEvents() {
    try {
      final events = rust_webview.webviewPollEvents(id: id);
      for (final event in events) {
        _handleEvent(event);
      }
    } catch (e) {
      // WebView 可能已关闭
      if (!_isDisposed) {
        dPrint("Error polling events: $e");
      }
    }
  }

  /// 处理事件
  void _handleEvent(rust_webview.WebViewEvent event) {
    switch (event) {
      case rust_webview.WebViewEvent_NavigationStarted(:final url):
        dPrint("Navigation started: $url");
        _currentUrl = url;
        // 导航开始时通知
        for (final callback in _navigationCallbacks) {
          callback(url);
        }
        break;

      case rust_webview.WebViewEvent_NavigationCompleted(:final url):
        dPrint("Navigation completed: $url");
        _currentUrl = url;
        // 导航完成回调（用于注入脚本）
        for (final callback in _navigationCompletedCallbacks) {
          callback(url);
        }
        for (final callback in _navigationCallbacks) {
          callback(url);
        }
        break;

      case rust_webview.WebViewEvent_TitleChanged(:final title):
        dPrint("Title changed: $title");
        break;

      case rust_webview.WebViewEvent_WebMessage(:final message):
        _handleWebMessage(message);
        break;

      case rust_webview.WebViewEvent_WindowClosed():
        dPrint("Window closed");
        for (final callback in _closeCallbacks) {
          callback();
        }
        dispose();
        break;

      case rust_webview.WebViewEvent_Error(:final message):
        dPrint("WebView error: $message");
        break;
    }
  }

  /// 处理来自 WebView 的消息
  void _handleWebMessage(String message) {
    dPrint("Web message: $message");
    try {
      final data = json.decode(message);
      final action = data["action"];

      switch (action) {
        case "navigation_state":
          // 从 JS 获取导航状态更新
          final url = data["url"] ?? "";
          final isLoading = data["isLoading"] ?? false;
          _currentUrl = url;
          if (!isLoading) {
            for (final callback in _navigationCallbacks) {
              callback(url);
            }
          }
          break;
        case "close_window":
          // 处理来自导航栏的关闭请求
          close();
          break;
        default:
          // 转发其他消息给回调
          for (final callback in _messageCallbacks) {
            callback(message);
          }
      }
    } catch (e) {
      // 非 JSON 消息，直接转发
      for (final callback in _messageCallbacks) {
        callback(message);
      }
    }
  }

  /// 导航到 URL
  void navigate(String url) {
    if (_isDisposed) return;
    _currentUrl = url;
    rust_webview.webviewNavigate(id: id, url: url);
  }

  /// 后退
  void goBack() {
    if (_isDisposed) return;
    rust_webview.webviewGoBack(id: id);
  }

  /// 前进
  void goForward() {
    if (_isDisposed) return;
    rust_webview.webviewGoForward(id: id);
  }

  /// 刷新
  void reload() {
    if (_isDisposed) return;
    rust_webview.webviewReload(id: id);
  }

  /// 停止加载
  void stop() {
    if (_isDisposed) return;
    rust_webview.webviewStop(id: id);
  }

  /// 执行 JavaScript
  void executeScript(String script) {
    if (_isDisposed) return;
    rust_webview.webviewExecuteScript(id: id, script: script);
  }

  /// 设置窗口可见性
  void setVisible(bool visible) {
    if (_isDisposed) return;
    rust_webview.webviewSetVisibility(id: id, visible: visible);
  }

  /// 关闭窗口
  void close() {
    if (_isDisposed) return;
    rust_webview.webviewClose(id: id);
    dispose();
  }

  /// 设置窗口大小
  void setWindowSize(int width, int height) {
    if (_isDisposed) return;
    rust_webview.webviewSetWindowSize(id: id, width: width, height: height);
  }

  /// 设置窗口位置
  void setWindowPosition(int x, int y) {
    if (_isDisposed) return;
    rust_webview.webviewSetWindowPosition(id: id, x: x, y: y);
  }

  /// 获取当前导航状态
  rust_webview.WebViewNavigationState getState() {
    return rust_webview.webviewGetState(id: id);
  }

  /// 检查窗口是否已关闭
  bool get isClosed {
    if (_isDisposed) return true;
    return rust_webview.webviewIsClosed(id: id);
  }

  /// 添加消息回调
  void addOnWebMessageCallback(OnWebMessageCallback callback) {
    _messageCallbacks.add(callback);
  }

  /// 移除消息回调
  void removeOnWebMessageCallback(OnWebMessageCallback callback) {
    _messageCallbacks.remove(callback);
  }

  /// 添加导航回调
  void addOnNavigationCallback(OnNavigationCallback callback) {
    _navigationCallbacks.add(callback);
  }

  /// 移除导航回调
  void removeOnNavigationCallback(OnNavigationCallback callback) {
    _navigationCallbacks.remove(callback);
  }

  /// 添加导航完成回调（用于在页面加载完成后注入脚本）
  void addOnNavigationCompletedCallback(OnNavigationCompletedCallback callback) {
    _navigationCompletedCallbacks.add(callback);
  }

  /// 移除导航完成回调
  void removeOnNavigationCompletedCallback(OnNavigationCompletedCallback callback) {
    _navigationCompletedCallbacks.remove(callback);
  }

  /// 添加关闭回调
  void addOnCloseCallback(OnWindowClosedCallback callback) {
    _closeCallbacks.add(callback);
  }

  /// 移除关闭回调
  void removeOnCloseCallback(OnWindowClosedCallback callback) {
    _closeCallbacks.remove(callback);
  }

  /// 注入本地化脚本
  void injectLocalizationScript() {
    if (_localizationScript.isNotEmpty) {
      executeScript(_localizationScript);
    }
  }

  /// 初始化网页本地化
  void initWebLocalization() {
    executeScript("InitWebLocalization()");
  }

  /// 更新翻译词典
  void updateReplaceWords(List<Map<String, String>> words, bool enableCapture) {
    final jsonWords = json.encode(words);
    executeScript("WebLocalizationUpdateReplaceWords($jsonWords, $enableCapture)");
  }

  /// 执行 RSI 登录脚本
  void executeRsiLogin(String channel) {
    executeScript('getRSILauncherToken("$channel");');
  }

  /// 释放资源
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _pollTimer?.cancel();
    _messageCallbacks.clear();
    _navigationCallbacks.clear();
    _navigationCompletedCallbacks.clear();
    _closeCallbacks.clear();
  }
}
