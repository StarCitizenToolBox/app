import 'dart:convert';
import 'dart:io';

import 'package:aria2/aria2.dart';
import 'package:flutter/foundation.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';

class Aria2cManager {
  static bool _isDaemonRunning = false;

  static final String _aria2cDir =
      "${AppConf.applicationSupportDir}\\modules\\aria2c";

  static Aria2c? _aria2c;

  static Aria2c get aria2c {
    if (!_isDaemonRunning) throw Exception("Aria2c Daemon not running!");
    if (_aria2c == null) {
      _aria2c = Aria2c(
          "ws://127.0.0.1:64664/jsonrpc", "websocket", "ScToolbox_64664");
      _aria2c!.getVersion().then((value) {
        dPrint("Aria2cManager.connected!  version == ${value.version}");
      });
    }
    return _aria2c!;
  }

  static Future launchDaemon() async {
    if (_isDaemonRunning) return;

    /// skip for debug hot reload
    if (kDebugMode) {
      if ((await SystemHelper.getPID("aria2c")).isNotEmpty) {
        dPrint("[Aria2cManager] debug skip for hot reload");
        _isDaemonRunning = true;
        return;
      }
    }

    final sessionFile = File("$_aria2cDir\\aria2.session");
    if (!await sessionFile.exists()) {
      await sessionFile.create(recursive: true);
    }

    final exePath = "$_aria2cDir\\aria2c.exe";
    dPrint("Aria2cManager .-----  aria2c start ------");
    final p = await Process.start(
        exePath,
        [
          "-V",
          "-c",
          "-x 10",
          "--dir=$_aria2cDir\\downloads",
          "--disable-ipv6",
          "--enable-rpc",
          "--pause",
          "--rpc-listen-port=64664",
          "--rpc-secret=ScToolbox_64664",
          "--input-file=${sessionFile.absolute.path.trim()}",
          "--save-session=${sessionFile.absolute.path.trim()}",
          "--save-session-interval=60",
          "--file-allocation=trunc",
          "--seed-time=0",
        ],
        workingDirectory: _aria2cDir);
    p.stdout.transform(utf8.decoder).listen((event) {
      if (event.trim().isEmpty) return;
      dPrint("[aria2c]: ${event.trim()}");
      if (event.contains("IPv4 RPC: listening on TCP port")) {
        _isDaemonRunning = true;
        aria2c;
      }
    }, onDone: () {
      dPrint("[aria2c] onDone: ");
      _isDaemonRunning = false;
    }, onError: (e) {
      dPrint("[aria2c] stdout ERROR: $e");
      _isDaemonRunning = false;
    });
    p.stderr.transform(utf8.decoder).listen((event) {
      dPrint("[aria2c] stderr ERROR : $event");
    });
    while (true) {
      if (_isDaemonRunning) return;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  static int textToByte(String text) {
    if (text.length == 1) {
      return 0;
    }
    if (int.tryParse(text) != null) {
      return int.parse(text);
    }
    if (text.endsWith("k")) {
      return int.parse(text.substring(0, text.length - 1)) * 1024;
    }
    if (text.endsWith("m")) {
      return int.parse(text.substring(0, text.length - 1)) * 1024 * 1024;
    }
    return 0;
  }
}
