import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as rust_win32;

class SystemHelper {
  // Remove PowerShell dependency - all functions now use Rust implementations

  static Future<void> initPowershellPath() async {
    // No longer needed - keeping for backward compatibility
    dPrint("SystemHelper initialized - using Rust implementations");
  }

  static Future<bool> checkNvmePatchStatus() async {
    try {
      return await rust_win32.checkNvmePatchStatus();
    } catch (e) {
      dPrint("checkNvmePatchStatus error: $e");
      return false;
    }
  }

  static Future<String> addNvmePatch() async {
    try {
      return await rust_win32.addNvmePatch();
    } catch (e) {
      dPrint("addNvmePatch error: $e");
      return e.toString();
    }
  }

  static Future<bool> doRemoveNvmePath() async {
    try {
      return await rust_win32.removeNvmePatch();
    } catch (e) {
      dPrint("doRemoveNvmePath error: $e");
      return false;
    }
  }

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
        final targetPath = await rust_win32.resolveShortcut(lnkPath: rsiFilePath);
        if (targetPath.contains("RSI Launcher.exe")) {
          final start = targetPath.split("RSI Launcher.exe");
          if (skipEXE) {
            return start[0];
          }
          return "${start[0]}RSI Launcher.exe";
        }
      } catch (e) {
        dPrint("getRSILauncherPath error: $e");
      }
    }
    return "";
  }

  static Future<void> killRSILauncher() async {
    try {
      await rust_win32.killProcessByName(processName: "RSI Launcher");
    } catch (e) {
      dPrint("killRSILauncher error: $e");
    }
  }

  static Future<void> killProcessByName(String processName) async {
    try {
      await rust_win32.killProcessByName(processName: processName);
    } catch (e) {
      dPrint("killProcessByName error: $e");
    }
  }

  static Future<List<String>> getPID(String name) async {
    try {
      final pids = await rust_win32.getProcessIds(processName: name);
      return pids.map((pid) => pid.toString()).toList();
    } catch (e) {
      dPrint("getPID Error: $e");
      return [];
    }
  }

  static Future<void> checkAndLaunchRSILauncher(String path) async {
    // check running and kill
    await killRSILauncher();
    // launch
    final processorAffinity = await SystemHelper.getCpuAffinity();
    try {
      await rust_win32.launchProcessWithAffinity(executablePath: path, args: [], affinityMask: processorAffinity);
    } catch (e) {
      dPrint("checkAndLaunchRSILauncher error: $e");
    }
  }

  static Future<int> getSystemMemorySizeGB() async {
    try {
      final memoryGb = await rust_win32.getSystemMemoryGb();
      return memoryGb.toInt();
    } catch (e) {
      dPrint("getSystemMemorySizeGB error: $e");
      return 0;
    }
  }

  static Future<String> getSystemCimInstance(String win32InstanceName, {pathName = "Name"}) async {
    // This function is deprecated - specific functions should be used instead
    dPrint("getSystemCimInstance is deprecated, use specific functions instead");
    return "";
  }

  static Future<String> getSystemName() async {
    try {
      return await rust_win32.getSystemName();
    } catch (e) {
      dPrint("getSystemName error: $e");
      return "Unknown";
    }
  }

  static Future<String> getCpuName() async {
    try {
      return await rust_win32.getCpuName();
    } catch (e) {
      dPrint("getCpuName error: $e");
      return "Unknown";
    }
  }

  static Future<String> getGpuInfo() async {
    try {
      return await rust_win32.getGpuInfo();
    } catch (e) {
      dPrint("getGpuInfo error: $e");
      return "Unknown";
    }
  }

  static Future<String> getDiskInfo() async {
    try {
      return await rust_win32.getDiskInfo();
    } catch (e) {
      dPrint("getDiskInfo error: $e");
      return "Unknown";
    }
  }

  static Future<int> getDirLen(String path, {List<String>? skipPath}) async {
    if (path == "") return 0;
    try {
      final size = await rust_win32.calculateDirectorySize(path: path, skipPaths: skipPath ?? []);
      return size.toInt();
    } catch (e) {
      dPrint("getDirLen error: $e");
      return 0;
    }
  }

  static Future<int> getNumberOfLogicalProcessors() async {
    try {
      final count = await rust_win32.getCpuCount();
      return count.toInt();
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

    try {
      return await rust_win32.calculateCpuAffinity(eCoreCount: BigInt.from(eCoreCount));
    } catch (e) {
      dPrint("getCpuAffinity error: $e");
      return null;
    }
  }

  static Future openDir(dynamic path, {bool isFile = false}) async {
    dPrint("SystemHelper.openDir  path === $path");
    try {
      await rust_win32.openDirectory(path: path.toString(), selectFile: isFile);
    } catch (e) {
      dPrint("openDir error: $e");
    }
  }

  static String getHostsFilePath() {
    try {
      // Note: This is synchronous but Rust function is async
      // We'll handle this by making it a Future if needed
      if (Platform.isWindows) {
        final envVars = Platform.environment;
        final systemRoot = envVars["SYSTEMROOT"];
        return "$systemRoot\\System32\\drivers\\etc\\hosts";
      }
      return "/etc/hosts";
    } catch (e) {
      dPrint("getHostsFilePath error: $e");
      return "";
    }
  }
}
