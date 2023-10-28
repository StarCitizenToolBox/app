import 'dart:convert';
import 'dart:io';

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
          if (installPath.isNotEmpty && !scInstallPaths.contains(installPath)) {
            if (!checkExists) {
              dPrint("find installPath == $installPath");
              scInstallPaths.add(installPath);
            } else if (await File("$installPath/Bin64/StarCitizen.exe")
                    .exists() &&
                await File("$installPath/Data.p4k").exists()) {
              dPrint("find installPath == $installPath");
              scInstallPaths.add(installPath);
            }
          }
        }
      }
    }

    return scInstallPaths;
  }
}
