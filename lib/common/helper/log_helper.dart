import 'dart:convert';
import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class SCLoggerHelper {
  static Future<String?> getLogFilePath() async {
    if (!Platform.isWindows) {
      final wineUserPath = await getWineUserPath();
      if (wineUserPath == null) return null;
      // /home/xkeyc/Games/star-citizen/drive_c/users/xkeyc/AppData/Roaming/rsilauncher/
      final rsiLauncherPath = "$wineUserPath/AppData/Roaming/rsilauncher";
      dPrint("rsiLauncherPath Wine:$rsiLauncherPath");
      final jsonLogPath = "$rsiLauncherPath/logs/log.log";
      return jsonLogPath;
    }
    ;
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
    if (!Platform.isWindows) {
      final wineUserPath = await getWineUserPath();
      if (wineUserPath == null) return null;
      // /home/xkeyc/Games/star-citizen/drive_c/users/xkeyc/AppData/Local/star citizen/
      final scCachePath = "$wineUserPath/AppData/Local/star citizen";
      dPrint("getShaderCachePath Wine === $scCachePath");
      return scCachePath;
    }
    Map<String, String> envVars = Platform.environment;
    final appDataPath = envVars["LOCALAPPDATA"];
    if (appDataPath == null) {
      return null;
    }
    final scCachePath = "$appDataPath\\Star Citizen";
    dPrint("getShaderCachePath === $scCachePath");
    return scCachePath;
  }

  static Future<String?> getWineUserPath() async {
    // get game path in hiveBox
    final confBox = await Hive.openBox("app_conf");
    final path = confBox.get("custom_game_path");
    if (path?.isEmpty ?? true) return null;
    // path eg: /home/xkeyc/Games/star-citizen/drive_c/Program Files/Roberts Space Industries/StarCitizen/LIVE/
    // resolve wine c_drive path
    final wineCDrivePath = path.toString().split('/drive_c/').first;
    // scan wine user path == current_unix_user
    final wineUserPath = "$wineCDrivePath/drive_c/users/${Platform.environment['USER']}";
    // check exists
    final wineUserDir = Directory(wineUserPath);
    if (!await wineUserDir.exists()) return null;
    dPrint("getWineUserPath === $wineUserPath");
    return wineUserPath;
  }

  static Future<List?> getLauncherLogList() async {
    if (!Platform.isWindows) return [];
    try {
      final jsonLogPath = await getLogFilePath();
      if (jsonLogPath == null) throw "no file path";
      var jsonString = utf8.decode(await File(jsonLogPath).readAsBytes());
      return jsonString.split("\n");
    } catch (e) {
      dPrint(e);
      return [];
    }
  }

  static Future<List<String>> getGameInstallPath(
    List listData, {
    bool checkExists = true,
    List<String> withVersion = const ["LIVE"],
  }) async {
    List<String> scInstallPaths = [];

    checkAndAddPath(String path, bool checkExists) async {
      // Handle JSON-escaped backslashes (\\\\) -> single backslash (\\)
      path = path.replaceAll(r'\\', r'\');
      // Normalize path separators to current platform format
      path = path.platformPath;

      // Case-insensitive check for existing paths
      if (path.isNotEmpty && !scInstallPaths.any((p) => p.toLowerCase() == path.toLowerCase())) {
        if (!checkExists) {
          dPrint("find installPath == $path");
          scInstallPaths.add(path);
        } else if (await File("$path/Bin64/StarCitizen.exe").exists() && await File("$path/Data.p4k").exists()) {
          dPrint("find installPath == $path");
          scInstallPaths.add(path);
        }
      }
    }

    final confBox = await Hive.openBox("app_conf");
    final path = confBox.get("custom_game_path");
    if (path != null && path != "") {
      for (var v in withVersion) {
        await checkAndAddPath("$path\\$v".platformPath, checkExists);
      }
    }

    try {
      for (var v in withVersion) {
        // Platform-specific regex patterns for game install path detection
        // Uses restrictive character class to avoid matching across JSON delimiters
        String pattern;
        if (Platform.isWindows) {
          // Windows: Match paths like C:\...\StarCitizen\LIVE
          // Path segments can only contain: letters, numbers, space, dot, underscore, hyphen, parentheses
          // Handles both single backslash, forward slash, and JSON-escaped double backslash
          pattern =
              r'([a-zA-Z]:(?:[/\\]|\\\\)(?:[a-zA-Z0-9 ._()-]+(?:[/\\]|\\\\))*StarCitizen(?:[/\\]|\\\\)' + v + r')';
        } else {
          // Unix (Wine): Match paths like /home/user/.../StarCitizen/LIVE
          pattern = r'(/(?:[a-zA-Z0-9 ._()-]+/)*StarCitizen/' + v + r')';
        }
        RegExp regExp = RegExp(pattern, caseSensitive: false);
        for (var i = listData.length - 1; i > 0; i--) {
          final line = listData[i];
          final matches = regExp.allMatches(line);
          for (var match in matches) {
            await checkAndAddPath(match.group(0)!, checkExists);
          }
        }
      }

      if (scInstallPaths.isNotEmpty) {
        // 动态检测更多位置
        for (var fileName in List.from(scInstallPaths)) {
          for (var v in withVersion) {
            final suffix = '\\$v'.platformPath.toLowerCase();
            if (fileName.toString().toLowerCase().endsWith(suffix)) {
              for (var nv in withVersion) {
                final basePath = fileName.toString().replaceAll(
                  RegExp('${RegExp.escape(suffix)}\$', caseSensitive: false),
                  '',
                );
                final nextName = "$basePath\\$nv".platformPath;
                await checkAndAddPath(nextName, true);
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
    final pathLower = installPath.platformPath.toLowerCase();
    for (var value in AppConf.gameChannels) {
      if (pathLower.endsWith('\\${value.toLowerCase()}'.platformPath)) {
        return value.toUpperCase();
      }
    }
    return "UNKNOWN";
  }

  static Future<List<String>?> getGameRunningLogs(String gameDir) async {
    final logFile = File("$gameDir/Game.log");
    if (!await logFile.exists()) {
      return null;
    }
    return await logFile.readAsLines(encoding: const Utf8Codec(allowMalformed: true));
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
      return MapEntry(S.current.doctor_game_error_low_memory, S.current.doctor_game_error_low_memory_info);
    }
    if (line.contains("EXCEPTION_ACCESS_VIOLATION")) {
      return MapEntry(S.current.doctor_game_error_generic_info, "https://docs.qq.com/doc/DUURxUVhzTmZoY09Z");
    }
    if (line.contains("DXGI_ERROR_DEVICE_REMOVED")) {
      return MapEntry(S.current.doctor_game_error_gpu_crash, "https://www.bilibili.com/read/cv19335199");
    }
    if (line.contains("Wakeup socket sendto error")) {
      return MapEntry(S.current.doctor_game_error_socket_error, S.current.doctor_game_error_socket_error_info);
    }

    if (line.contains("The requested operation requires elevated")) {
      return MapEntry(
        S.current.doctor_game_error_permissions_error,
        S.current.doctor_game_error_permissions_error_info,
      );
    }
    if (line.contains("The process cannot access the file because is is being used by another process")) {
      return MapEntry(
        S.current.doctor_game_error_game_process_error,
        S.current.doctor_game_error_game_process_error_info,
      );
    }
    if (line.contains("0xc0000043")) {
      return MapEntry(
        S.current.doctor_game_error_game_damaged_file,
        S.current.doctor_game_error_game_damaged_file_info,
      );
    }
    if (line.contains("option to verify the content of the Data.p4k file")) {
      return MapEntry(
        S.current.doctor_game_error_game_damaged_p4k_file,
        S.current.doctor_game_error_game_damaged_p4k_file_info,
      );
    }
    if (line.contains("OUTOFMEMORY Direct3D could not allocate")) {
      return MapEntry(S.current.doctor_game_error_low_gpu_memory, S.current.doctor_game_error_low_gpu_memory_info);
    }
    if (line.contains("try disabling with r_vulkanDisableLayers = 1 in your user.cfg")) {
      return MapEntry(S.current.doctor_game_error_gpu_vulkan_crash, S.current.doctor_game_error_gpu_vulkan_crash_info);
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
