import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class BinaryModuleConf {
  static const _modules = {"aria2c": "0"};

  static Future extractModule(List<String> modules, String workingDir) async {
    for (var m in _modules.entries) {
      if (!modules.contains(m.key)) continue;
      final name = m.key;
      final version = m.value;
      final dir = "$workingDir\\$name";
      final versionFile = File("$dir\\version");
      if (kReleaseMode && await versionFile.exists() && (await versionFile.readAsString()).trim() == version) {
        dPrint("BinaryModuleConf.extractModule  skip $name version == $version");
        continue;
      }
      // write model file
      final zipBuffer = await rootBundle.load("assets/binary/$name.zip");
      final decoder = ZipDecoder().decodeBytes(zipBuffer.buffer.asUint8List());
      for (var value in decoder.files) {
        final filename = value.name;
        if (value.isFile) {
          final data = value.content as List<int>;
          final file = File('$dir\\$filename');
          await file.create(recursive: true);
          await file.writeAsBytes(data);
        } else {
          await Directory('$dir\\$filename').create(recursive: true);
        }
      }
      // write version file
      await versionFile.writeAsString(version);
      dPrint("BinaryModuleConf.extractModule $name $dir");
    }
  }
}
