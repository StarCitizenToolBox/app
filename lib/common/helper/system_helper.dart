import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/rust/api/system_info.dart' as rust_system_info;

class SystemHelper {
  // Note: PowerShell is no longer used - all critical functions now use Rust implementations

  static Future<bool> checkNvmePatchStatus() async {
    try {
      return rust_system_info.checkNvmePatchStatus();
    } catch (e) {
      dPrint("checkNvmePatchStatus error: $e");
      return false;
    }
  }

  static Future<String> addNvmePatch() async {
    try {
      return rust_system_info.addNvmePatch();
    } catch (e) {
      dPrint("addNvmePatch error: $e");
      return "Error: $e";
    }
  }

  static Future<bool> doRemoveNvmePath() async {
    try {
      return rust_system_info.removeNvmePatch();
    } catch (e) {
      dPrint("doRemoveNvmePath error: $e");
      return false;
    }
  }

  /// 获取 RSI 启动器 目录
  static Future<String> getRSILauncherPath({bool skipEXE = false}) async {
    final confBox = await Hive.openBox("app_conf");
    final path = confBox.get("custom_launcher_path");
    if (path != null && path != "") {
      if (await File(path).exists()) {
        if (skipEXE) {
          return "${path.toString().replaceAll("\\RSI Launcher.exe", "")}\\";
        }
        return path;
      }
    }

    Map<String, String> envVars = Platform.environment;
    final programDataPath = envVars["programdata"];
    final rsiFilePath =
        "$programDataPath\\Microsoft\\Windows\\Start Menu\\Programs\\Roberts Space Industries\\RSI Launcher.lnk";
    final rsiLinkFile = File(rsiFilePath);
    if (await rsiLinkFile.exists()) {
      try {
        final targetPath = rust_system_info.resolveShortcutPath(shortcutPath: rsiFilePath);
        if (targetPath.contains("RSI Launcher.exe")) {
          final start = targetPath.split("RSI Launcher.exe");
          if (skipEXE) {
            return start[0];
          }
          return "${start[0]}RSI Launcher.exe";
        }
      } catch (e) {
        dPrint("getRSILauncherPath shortcut resolution error: $e");
      }
    }
    return "";
  }

  static Future<void> killRSILauncher() async {
    try {
      // Use Rust to get process IDs
      final pids = rust_system_info.getProcessIdsByName(processName: "RSI Launcher");
      if (pids.isNotEmpty) {
        final pidList = pids.map((pid) => pid.toInt()).toList();
        final killedCount = rust_system_info.killProcessesByPids(pids: pidList);
        dPrint("Killed $killedCount RSI Launcher processes using Rust");
      }
    } catch (e) {
      dPrint("killRSILauncher error: $e");
    }
  }

  static Future<List<String>> getPID(String name) async {
    try {
      final pids = rust_system_info.getProcessIdsByName(processName: name);
      return pids.map((pid) => pid.toString()).toList();
    } catch (e) {
      dPrint("getPID error: $e");
      return [];
    }
  }

  static Future<void> checkAndLaunchRSILauncher(String path) async {
    // check running and kill
    await killRSILauncher();
    // launch
    final processorAffinity = await SystemHelper.getCpuAffinity();
    if (processorAffinity == null) {
      Process.run(path, []);
    } else {
      Process.run("cmd.exe", [
        '/C',
        'Start',
        '""',
        '/High',
        '/Affinity',
        processorAffinity,
        path,
      ]);
    }
    dPrint(path);
  }

  static Future<int> getSystemMemorySizeGB() async {
    try {
      final sizeGB = rust_system_info.getSystemMemorySizeGb();
      return sizeGB.toInt();
    } catch (e) {
      dPrint("getSystemMemorySizeGB error: $e");
      return 0;
    }
  }



  static Future<String> getSystemName() async {
    try {
      return rust_system_info.getSystemName();
    } catch (e) {
      dPrint("getSystemName error: $e");
      return "Unknown";
    }
  }

  static Future<String> getCpuName() async {
    try {
      return rust_system_info.getCpuName();
    } catch (e) {
      dPrint("getCpuName error: $e");
      return "Unknown CPU";
    }
  }

  static Future<String> getGpuInfo() async {
    try {
      return rust_system_info.getGpuInfo();
    } catch (e) {
      dPrint("getGpuInfo error: $e");
      return "GPU information not available";
    }
  }

  static Future<String> getDiskInfo() async {
    try {
      return rust_system_info.getDiskInfo();
    } catch (e) {
      dPrint("getDiskInfo error: $e");
      return "Disk information not available";
    }
  }

  static Future<int> getDirLen(String path, {List<String>? skipPath}) async {
    if (path == "") return 0;
    int totalSize = 0;
    try {
      final l = await Directory(path).list(recursive: true).toList();
      for (var element in l) {
        if (element is File) {
          bool skip = false;
          if (skipPath != null) {
            for (var value in skipPath) {
              if (element.absolute.path.startsWith(value)) {
                skip = true;
                break;
              }
            }
          }
          if (!skip) totalSize += await element.length();
        }
      }
    } catch (_) {}
    return totalSize;
  }

  static Future<int> getNumberOfLogicalProcessors() async {
    try {
      return rust_system_info.getNumberOfLogicalProcessors();
    } catch (e) {
      dPrint("getNumberOfLogicalProcessors error: $e");
      return 0;
    }
  }

  static Future<String?> getCpuAffinity() async {
    final confBox = await Hive.openBox("app_conf");
    final eCoreCount = int.tryParse(confBox.get("gameLaunch_eCore_count", defaultValue: "0")) ?? 0;
    final cpuNumber = await getNumberOfLogicalProcessors();
    if (cpuNumber == 0 || eCoreCount == 0 || eCoreCount > cpuNumber) {
      return null;
    }

    StringBuffer sb = StringBuffer();
    for (var i = 0; i < cpuNumber; i++) {
      if (i < eCoreCount) {
        sb.write("0");
      } else {
        sb.write("1");
      }
    }
    final binaryString = sb.toString();
    int hexDigits = (binaryString.length / 4).ceil();
    dPrint("Affinity sb ==== $sb");
    return int.parse(binaryString, radix: 2).toRadixString(16).padLeft(hexDigits, '0').toUpperCase();
  }

  static Future openDir(dynamic path, {bool isFile = false}) async {
    dPrint("SystemHelper.openDir  path === $path");
    try {
      rust_system_info.openInExplorer(path: path.toString(), isFile: isFile);
    } catch (e) {
      dPrint("openDir error: $e");
    }
  }

  static String getHostsFilePath() {
    if (Platform.isWindows) {
      final envVars = Platform.environment;
      final systemRoot = envVars["SYSTEMROOT"];
      return "$systemRoot\\System32\\drivers\\etc\\hosts";
    }
    return "/etc/hosts";
  }
}
