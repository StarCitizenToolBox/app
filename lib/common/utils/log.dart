import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

import '../conf/app_conf.dart';

var _logLock = Lock();

void dPrint(src) async {
  if (kDebugMode) {
    print(src);
  }
  try {
    await _logLock.synchronized(() async {
      await AppConf.appLogFile?.writeAsString("$src\n", mode: FileMode.append);
    });
  } catch (_) {}
}
