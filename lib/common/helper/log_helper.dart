import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class SCLoggerHelper {
  static Future<String?> getLogFilePath() async {
    if (!Platform.isWindows) return null;
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
    if (!Platform.isWindows) return [];
    try {
      final jsonLogPath = await getLogFilePath();
      if (jsonLogPath == null) throw "no file path";
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
    } catch (e) {
      dPrint(e);
      return [];
    }
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
            if (info.contains("Verifying Star Citizen $v")) {
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
      }
    } catch (e) {
      dPrint(e);
      if (scInstallPaths.isEmpty) rethrow;
    }

    return scInstallPaths;
  }

  static String getGameChannelID(String installPath) {
    for (var value in ConstConf.gameChannels) {
      if (installPath.endsWith("\\$value")) {
        return value;
      }
    }
    return "UNKNOWN";
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
      return MapEntry(S.current.doctor_game_error_low_memory,
          S.current.doctor_game_error_low_memory_info);
    }
    if (line.contains("EXCEPTION_ACCESS_VIOLATION")) {
      return MapEntry(S.current.doctor_game_error_generic_info,
          "https://docs.qq.com/doc/DUURxUVhzTmZoY09Z");
    }
    if (line.contains("DXGI_ERROR_DEVICE_REMOVED")) {
      return MapEntry(S.current.doctor_game_error_gpu_crash,
          "https://www.bilibili.com/read/cv19335199");
    }
    if (line.contains("Wakeup socket sendto error")) {
      return MapEntry(S.current.doctor_game_error_socket_error,
          S.current.doctor_game_error_socket_error_info);
    }

    if (line.contains("The requested operation requires elevated")) {
      return MapEntry(S.current.doctor_game_error_permissions_error,
          S.current.doctor_game_error_permissions_error_info);
    }
    if (line.contains(
        "The process cannot access the file because is is being used by another process")) {
      return MapEntry(S.current.doctor_game_error_game_process_error,
          S.current.doctor_game_error_game_process_error_info);
    }
    if (line.contains("0xc0000043")) {
      return MapEntry(S.current.doctor_game_error_game_damaged_file,
          S.current.doctor_game_error_game_damaged_file_info);
    }
    if (line.contains("option to verify the content of the Data.p4k file")) {
      return MapEntry(S.current.doctor_game_error_game_damaged_p4k_file,
          S.current.doctor_game_error_game_damaged_p4k_file_info);
    }
    if (line.contains("OUTOFMEMORY Direct3D could not allocate")) {
      return MapEntry(S.current.doctor_game_error_low_gpu_memory,
          S.current.doctor_game_error_low_gpu_memory_info);
    }
    if (line.contains(
        "try disabling with r_vulkanDisableLayers = 1 in your user.cfg")) {
      return MapEntry(S.current.doctor_game_error_gpu_vulkan_crash,
          S.current.doctor_game_error_gpu_vulkan_crash_info);
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
