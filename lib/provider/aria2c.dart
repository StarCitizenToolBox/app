import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/conf/binary_conf.dart';
import 'package:starcitizen_doctor/common/rust/api/process_api.dart'
    as rs_process;
import 'dart:io';
import 'dart:math';
import 'package:aria2/aria2.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';

import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';

part 'aria2c.g.dart';

part 'aria2c.freezed.dart';

@freezed
class Aria2cModelState with _$Aria2cModelState {
  const factory Aria2cModelState({
    required bool isDaemonRunning,
    required String aria2cDir,
    Aria2c? aria2c,
  }) = _Aria2cModelState;
}

@riverpod
class Aria2cModel extends _$Aria2cModel {
  @override
  Aria2cModelState build() {
    if (appGlobalState.applicationBinaryModuleDir == null) {
      throw Exception("applicationBinaryModuleDir is null");
    }
    ref.keepAlive();
    final aria2cDir = "${appGlobalState.applicationBinaryModuleDir}\\aria2c";
    // LazyLoad init
    () async {
      try {
        final sessionFile = File("$aria2cDir\\aria2.session");
        // 有下载任务则第一时间初始化
        if (await sessionFile.exists() &&
            (await sessionFile.readAsString()).trim().isNotEmpty) {
          dPrint("launch Aria2c daemon");
          await launchDaemon(appGlobalState.applicationBinaryModuleDir!);
        } else {
          dPrint("LazyLoad Aria2c daemon");
        }
      } catch (e) {
        dPrint("Aria2cManager.checkLazyLoad Error:$e");
      }
    }();

    return Aria2cModelState(isDaemonRunning: false, aria2cDir: aria2cDir);
  }

  Future launchDaemon(String applicationBinaryModuleDir) async {
    if (state.isDaemonRunning) return;
    await BinaryModuleConf.extractModule(
        ["aria2c"], applicationBinaryModuleDir);

    /// skip for debug hot reload
    if (kDebugMode) {
      if ((await SystemHelper.getPID("aria2c")).isNotEmpty) {
        dPrint("[Aria2cManager] debug skip for hot reload");
        return;
      }
    }

    final sessionFile = File("${state.aria2cDir}\\aria2.session");
    if (!await sessionFile.exists()) {
      await sessionFile.create(recursive: true);
    }

    final exePath = "${state.aria2cDir}\\aria2c.exe";
    final port = await getFreePort();
    final pwd = generateRandomPassword(16);
    dPrint("pwd === $pwd");
    final trackerList = await Api.getTorrentTrackerList();
    dPrint("trackerList === $trackerList");
    dPrint("Aria2cManager .-----  aria2c start $port------");

    final stream = rs_process.startProcess(
        executable: exePath,
        arguments: [
          "-V",
          "-c",
          "-x 10",
          "--dir=${state.aria2cDir}\\downloads",
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
        workingDirectory: state.aria2cDir);

    String launchError = "";

    stream.listen((event) {
      dPrint("Aria2cManager.rs_process event === $event");
      if (event.startsWith("output:")) {
        if (event.contains("IPv4 RPC: listening on TCP port")) {
          _onLaunch(port, pwd, trackerList);
        }
      } else if (event.startsWith("error:")) {
        state = state.copyWith(aria2c: null, isDaemonRunning: false);
        launchError = event;
      } else if (event.startsWith("exit:")) {
        state = state.copyWith(aria2c: null, isDaemonRunning: false);
        launchError = event;
      }
    });

    while (true) {
      if (state.isDaemonRunning) return;
      if (launchError.isNotEmpty) throw launchError;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<int> getFreePort() async {
    final serverSocket = await ServerSocket.bind("127.0.0.1", 0);
    final port = serverSocket.port;
    await serverSocket.close();
    return port;
  }

  String generateRandomPassword(int length) {
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

  int textToByte(String text) {
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

  Future<void> _onLaunch(int port, String pwd, String trackerList) async {
    final aria2c = Aria2c("ws://127.0.0.1:$port/jsonrpc", "websocket", pwd);
    state = state.copyWith(aria2c: aria2c, isDaemonRunning: true);
    aria2c.getVersion().then((value) {
      dPrint("Aria2cManager.connected!  version == ${value.version}");
    });
    final box = await Hive.openBox("app_conf");
    aria2c.changeGlobalOption(Aria2Option()
      ..maxOverallUploadLimit =
          textToByte(box.get("downloader_up_limit", defaultValue: "0"))
      ..maxOverallDownloadLimit =
          textToByte(box.get("downloader_down_limit", defaultValue: "0"))
      ..btTracker = trackerList);
  }
}
