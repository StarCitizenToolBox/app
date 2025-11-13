import 'package:flutter/foundation.dart';

export 'package:starcitizen_doctor/generated/l10n.dart';

void dPrint(src) {
  if (kDebugMode) {
    print(src);
    return;
  }
  // For web, we only use print in debug mode
  // File logging is not supported on web
  if (kIsWeb) {
    if (kDebugMode) {
      print(src);
    }
  }
}

Future<void> initDPrintFile(String applicationSupportDir) async {
  // File logging is not supported on web
  if (kIsWeb) {
    return;
  }
  // For non-web platforms, file logging would be implemented here
  // but is disabled in the web version
}

dynamic getDPrintFile() {
  // File logging is not supported on web
  return null;
}
