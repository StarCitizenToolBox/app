import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

export 'package:starcitizen_doctor/generated/l10n.dart';

var _logLock = Lock();
File? _logFile;

void dPrint(src) async {
  if (kDebugMode) {
    print(src);
  }
  await _logLock.synchronized(() async {
    try {
      _logFile?.writeAsString("$src\n", mode: FileMode.append);
    } catch (_) {}
  });
}

void setDPrintFile(File file) {
  _logFile = file;
}

File? getDPrintFile() {
  return _logFile;
}
