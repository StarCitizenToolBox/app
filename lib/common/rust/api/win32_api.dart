// Web platform stub for win32_api
// Windows API 在 Web 平台上不可用，提供空实现

/// 发送系统通知（Web 平台使用控制台输出）
Future<void> sendNotify({String? summary, String? body, String? appName, String? appId}) async {
  print('Notification: $summary - $body');
  // Web 平台可以使用浏览器 Notification API
  // 但需要用户授权，这里简化处理
}

/// 设置窗口为前台（Web 平台不支持）
Future<bool> setForegroundWindow({required String windowName}) async {
  print('setForegroundWindow not supported on web platform');
  return false;
}
