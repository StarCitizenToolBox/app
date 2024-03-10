import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

var _logLock = Lock();
File? _logFile;

void dPrint(src) async {
  if (kDebugMode) {
    print(src);
  }
  try {
    await _logLock.synchronized(() async {
      _logFile?.writeAsString("$src\n", mode: FileMode.append);
    });
  } catch (_) {}
}

void setDPrintFile(File file) {
  _logFile = file;
}

File? getDPrintFile() {
  return _logFile;
}
