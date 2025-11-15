import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/conf/binary_conf.dart';
import 'dart:io';
import 'dart:math';
import 'package:aria2/aria2.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/rust/api/rs_process.dart' as rs_process;

import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/ui/home/downloader/home_downloader_ui_model.dart';

part 'aria2c.g.dart';

part 'aria2c.freezed.dart';

@freezed
abstract class Aria2cModelState with _$Aria2cModelState {
  const factory Aria2cModelState({required String aria2cDir, Aria2c? aria2c, Aria2GlobalStat? aria2globalStat}) =
  _Aria2cModelState;
}

extension Aria2cModelExt on Aria2cModelState {
  bool get isRunning => aria2c != null;

  bool get hasDownloadTask => aria2globalStat != null && aria2TotalTaskNum > 0;

  int get aria2TotalTaskNum =>
      aria2globalStat == null ? 0 : ((aria2globalStat!.numActive ?? 0) + (aria2globalStat!.numWaiting ?? 0));
}

@riverpod
class Aria2cModel extends _$Aria2cModel {
  bool _disposed = false;

  @override
  Aria2cModelState build() {
    if (appGlobalState.applicationBinaryModuleDir == null) {
      throw Exception("applicationBinaryModuleDir is null");
    }
    ref.onDispose(() {
      _disposed = true;
    });
    ref.keepAlive();
    final aria2cDir = "${appGlobalState.applicationBinaryModuleDir}\\aria2c";
    // LazyLoad init
    () async {
      try {
        final sessionFile = File("$aria2cDir\\aria2.session");
        // 有下载任务则第一时间初始化
        if (await sessionFile.exists ()
    && (await sessionFile.readAsString()).trim().isNotEmpty) {
    dPrint("launch Aria2c daemon");
    await launchDaemon(appGlobalState.applicationBinaryModuleDir!);
    } else {
    dPrint("LazyLoad Aria2c daemon");
    }
    } catch (e) {
    dPrint("Aria2cManager.checkLazyLoad Error:$e");
    }
    }();

    return Aria2cModelState(aria2cDir: aria2cDir);
  }

  Future launchDaemon(String applicationBinaryModuleDir) async {
    if (state.aria2c != null) return;
    await BinaryModuleConf.extractModule(["aria2c"], applicationBinaryModuleDir);

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

    final stream = rs_process.start(
      executable: exePath,
      arguments: [
        "-V",
        "-c",
        "-x 16",
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
      workingDirectory: state.aria2cDir,
    );

    String launchError = "";

    stream.listen((event) {
      dPrint("Aria2cManager.rs_process event === [${event.rsPid}] ${event.dataType} >> ${event.data}");
      switch (event.dataType) {
        case rs_process.RsProcessStreamDataType.output:
          if (event.data.contains("IPv4 RPC: listening on TCP port")) {
            _onLaunch(port, pwd, trackerList);
          }
          break;
        case rs_process.RsProcessStreamDataType.error:
          launchError = event.data;
          state = state.copyWith(aria2c: null);
          break;
        case rs_process.RsProcessStreamDataType.exit:
          launchError = event.data;
          state = state.copyWith(aria2c: null);
          break;
      }
    });

    while (true) {
      if (state.aria2c != null) return;
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
    const String charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
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
    state = state.copyWith(aria2c: aria2c);
    aria2c.getVersion().then((value) {
      dPrint("Aria2cManager.connected!  version == ${value.version}");
      _listenState(aria2c);
    });
    final box = await Hive.openBox("app_conf");
    aria2c.changeGlobalOption(
      Aria2Option()
        ..maxOverallUploadLimit = textToByte(box.get("downloader_up_limit", defaultValue: "0"))
        ..maxOverallDownloadLimit = textToByte(box.get("downloader_down_limit", defaultValue: "0"))
        ..btTracker = trackerList,
    );
  }

  Future<void> _listenState(Aria2c aria2c) async {
    dPrint("Aria2cModel._listenState start");
    while (true) {
      if (_disposed || state.aria2c == null) {
        dPrint("Aria2cModel._listenState end");
        return;
      }
      try {
        final aria2globalStat = await aria2c.getGlobalStat();
        state = state.copyWith(aria2globalStat: aria2globalStat);
      } catch (e) {
        dPrint("aria2globalStat update error:$e");
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<bool> isNameInTask(String name) async {
    final aria2c = state.aria2c;
    if (aria2c == null) return false;
    for (var value in [...await aria2c.tellActive(), ...await aria2c.tellWaiting(0, 100000)]) {
      final t = HomeDownloaderUIModel.getTaskTypeAndName(value);
      if (t.key == "torrent" && t.value.contains(name)) {
        return true;
      }
    }
    return false;
  }
}
