import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aria2/aria2.dart';
import 'package:flutter/foundation.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/common/conf/binary_conf.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';

class Aria2cManager {
  static int? _daemonPID;

  static final String _aria2cDir =
      "${AppConf.applicationSupportDir}\\modules\\aria2c";

  static Aria2c? _aria2c;

  static Aria2c getClient() {
    if (_aria2c != null) return _aria2c!;
    throw "not connect!";
  }

  static bool get isAvailable => _daemonPID != null && _aria2c != null;

  static Future checkLazyLoad() async {
    try {
      final sessionFile = File("$_aria2cDir\\aria2.session");
      // 有下载任务则第一时间初始化
      if (await sessionFile.exists() &&
          (await sessionFile.readAsString()).trim().isNotEmpty) {
        await launchDaemon();
      }
    } catch (e) {
      dPrint("Aria2cManager.checkLazyLoad Error:$e");
    }
  }

  static Future launchDaemon() async {
    if (_daemonPID != null) return;
    await BinaryModuleConf.extractModule(["aria2c"]);

    /// skip for debug hot reload
    if (kDebugMode) {
      if ((await SystemHelper.getPID("aria2c")).isNotEmpty) {
        dPrint("[Aria2cManager] debug skip for hot reload");
        return;
      }
    }

    final sessionFile = File("$_aria2cDir\\aria2.session");
    if (!await sessionFile.exists()) {
      await sessionFile.create(recursive: true);
    }

    final exePath = "$_aria2cDir\\aria2c.exe";
    final port = await getFreePort();
    final pwd = generateRandomPassword(16);
    dPrint("Aria2cManager .-----  aria2c start $port------");
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
          "--rpc-listen-port=$port",
          "--rpc-secret=$pwd",
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
        _daemonPID = p.pid;
        _aria2c = Aria2c("ws://127.0.0.1:$port/jsonrpc", "websocket", pwd);
        _aria2c!.getVersion().then((value) {
          dPrint("Aria2cManager.connected!  version == ${value.version}");
        });
      }
    }, onDone: () {
      dPrint("[aria2c] onDone: ");
      _daemonPID = null;
    }, onError: (e) {
      dPrint("[aria2c] stdout ERROR: $e");
      _daemonPID = null;
    });
    p.pid;
    p.stderr.transform(utf8.decoder).listen((event) {
      dPrint("[aria2c] stderr ERROR : $event");
    });
    while (true) {
      if (_daemonPID != null) return;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  static Future<int> getFreePort() async {
    final serverSocket = await ServerSocket.bind("127.0.0.1", 0);
    final port = serverSocket.port;
    await serverSocket.close();
    return port;
  }

  static String generateRandomPassword(int length) {
    const String charset =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random random = Random();
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(charset.length);
      buffer.write(charset[randomIndex]);
    }
    return buffer.toString();
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
