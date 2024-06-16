import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

export 'package:starcitizen_doctor/generated/l10n.dart';

var _logLock = Lock();
File? _logFile;

void dPrint(src) async {
  if (kDebugMode) {
    print(src);
    return;
  }
  await _logLock.synchronized(() async {
    try {
      await _logFile?.writeAsString("$src\n", mode: FileMode.append);
    } catch (_) {}
  });
}

Future<void> initDPrintFile(String applicationSupportDir) async {
  final now = DateTime.now();
  final logFile =
      File("$applicationSupportDir/logs/${now.millisecondsSinceEpoch}.log");
  await logFile.create(recursive: true);
  _logFile = logFile;
  final logsDir = Directory("$applicationSupportDir/logs");
  await for (final files in logsDir.list()) {
    if (files is File) {
      final stat = await files.stat();
      if (stat.type == FileSystemEntityType.file &&
          now.difference(await files.lastModified()).inDays > 7) {
        await files.delete();
      }
    }
  }
}

File? getDPrintFile() {
  return _logFile;
}
