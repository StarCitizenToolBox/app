import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';

import '../utils/base_utils.dart';

class SCLoggerHelper {
  static Future<String?> getLogFilePath() async {
    Map<String, String> envVars = Platform.environment;
    final appDataPath = envVars["appdata"];
    if (appDataPath == null) {
      return null;
    }
    final rsiLauncherPath = "$appDataPath\\rsilauncher";
    dPrint("rsiLauncherPath:$rsiLauncherPath");
    final jsonLogPath = "$rsiLauncherPath\\logs\\log.log";
    return jsonLogPath;
  }

  static Future<String?> getShaderCachePath() async {
    Map<String, String> envVars = Platform.environment;
    final appDataPath = envVars["LOCALAPPDATA"];
    if (appDataPath == null) {
      return null;
    }
    final scCachePath = "$appDataPath\\Star Citizen";
    dPrint("getShaderCachePath === $scCachePath");
    return scCachePath;
  }

  static Future<List?> getLauncherLogList() async {
    final jsonLogPath = await getLogFilePath();
    if (jsonLogPath == null) return null;
    var jsonString = utf8.decode(await File(jsonLogPath).readAsBytes());
    if (jsonString.endsWith("\n")) {
      jsonString = jsonString.substring(0, jsonString.length - 3);
    }
    if (jsonString.endsWith(" ")) {
      jsonString = jsonString.substring(0, jsonString.length - 3);
    }
    if (jsonString.endsWith(",")) {
      jsonString = jsonString.substring(0, jsonString.length - 3);
    }
    return json.decode("[$jsonString]");
  }

  static Future<List<String>> getGameInstallPath(List listData,
      {bool checkExists = true,
      List<String> withVersion = const ["LIVE"]}) async {
    List<String> scInstallPaths = [];

    checkAndAddPath(String path, bool checkExists) async {
      if (path.isNotEmpty && !scInstallPaths.contains(path)) {
        if (!checkExists) {
          dPrint("find installPath == $path");
          scInstallPaths.add(path);
        } else if (await File("$path/Bin64/StarCitizen.exe").exists() &&
            await File("$path/Data.p4k").exists()) {
          dPrint("find installPath == $path");
          scInstallPaths.add(path);
        }
      }
    }

    final confBox = await Hive.openBox("app_conf");
    final path = confBox.get("custom_game_path");
    if (path != null && path != "") {
      for (var v in withVersion) {
        await checkAndAddPath("$path\\$v", checkExists);
      }
    }

    try {
      for (var v in withVersion) {
        for (var i = listData.length - 1; i > 0; i--) {
          final m = listData[i];
          final info = m["[browser][info] "];
          if (info is String) {
            String installPath = "";
            if (info.contains("Installing Star Citizen $v")) {
              installPath = "${info.split(" at ")[1]}\\$v";
            }
            if (info.contains("Launching Star Citizen $v from")) {
              installPath = info
                  .replaceAll("Launching Star Citizen $v from (", "")
                  .replaceAll(")", "");
            }
            await checkAndAddPath(installPath, checkExists);
          }
        }
      }
    } catch (e) {
      dPrint(e);
      if (scInstallPaths.isEmpty) rethrow;
    }

    if (scInstallPaths.isNotEmpty) {
      // 动态检测更多位置
      for (var v in withVersion) {
        for (var fileName in List.from(scInstallPaths)) {
          if (fileName.toString().endsWith(v)) {
            for (var nv in withVersion) {
              final nextName =
                  "${fileName.toString().replaceAll("\\$v", "")}\\$nv";
              await checkAndAddPath(nextName, true);
            }
          }
        }
      }
    }

    return scInstallPaths;
  }

  static Future<List<String>?> getGameRunningLogs(String gameDir) async {
    final logFile = File("$gameDir/Game.log");
    if (!await logFile.exists()) {
      return null;
    }
    return await logFile.readAsLines(
        encoding: const Utf8Codec(allowMalformed: true));
  }

  static MapEntry<String, String>? getGameRunningLogInfo(List<String> logs) {
    for (var i = logs.length - 1; i > 0; i--) {
      final line = logs[i];
      final r = _checkRunningLine(line);
      if (r != null) {
        return r;
      }
    }
    return null;
  }

  static MapEntry<String, String>? _checkRunningLine(String line) {
    if (line.contains("STATUS_CRYENGINE_OUT_OF_SYSMEM")) {
      return const MapEntry("可用内存不足", "请尝试增加虚拟内存（ 1080p 下， 物理可用+虚拟内存需 > 64G ）");
    }
    if (line.contains("EXCEPTION_ACCESS_VIOLATION")) {
      return const MapEntry("游戏触发了最为广泛的崩溃问题，请查看排障指南：",
          "https://docs.qq.com/doc/DUURxUVhzTmZoY09Z");
    }
    if (line.contains("DXGI_ERROR_DEVICE_REMOVED")) {
      return const MapEntry(
          "您的显卡崩溃啦！，请查看排障指南：", "https://www.bilibili.com/read/cv19335199");
    }
    if (line.contains("Wakeup socket sendto error")) {
      return const MapEntry("检测到 socket 异常", "如使用 X黑盒 加速器，请尝试更换加速模式");
    }

    if (line.contains("The requested operation requires elevated")) {
      return const MapEntry("权限不足", "请尝试以管理员权限运行启动器，或使用盒子（微软商店版）启动。");
    }
    if (line.contains(
        "The process cannot access the file because is is being used by another process")) {
      return const MapEntry("游戏进程被占用", "请尝试重启启动器，或直接重启电脑");
    }
    if (line.contains("0xc0000043")) {
      return const MapEntry("游戏程序文件损坏", "请尝试删除 Bin64 文件夹 并在启动器校验。");
    }
    if (line.contains("option to verify the content of the Data.p4k file")) {
      return const MapEntry("P4K文件损坏", "请尝试删除 Data.p4k 文件 并在启动器校验 或 使用盒子分流。");
    }
    if (line.contains("OUTOFMEMORY Direct3D could not allocate")) {
      return const MapEntry("可用显存不足", "请不要在后台运行其他高显卡占用的 游戏/应用，或更换显卡。");
    }
    if (line.contains("OUTOFMEMORY Direct3D could not allocate")) {
      return const MapEntry("可用显存不足", "请不要在后台运行其他高显卡占用的 游戏/应用，或更换显卡。");
    }

    /// Unknown
    if (line.contains("network.replicatedEntityHandle")) {
      return const MapEntry("_", "network.replicatedEntityHandle");
    }
    if (line.contains("Exception Unknown")) {
      return const MapEntry("_", "Exception Unknown");
    }
    return null;
  }
}
