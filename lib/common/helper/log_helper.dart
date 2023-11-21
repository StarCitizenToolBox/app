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
}
