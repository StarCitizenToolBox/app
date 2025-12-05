import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;

class SystemHelper {
  static String powershellPath = "powershell.exe";

  static Future<void> initPowershellPath() async {
    try {
      var result = await Process.run(powershellPath, ["echo", "pong"]);
      if (!result.stdout.toString().startsWith("pong") && powershellPath == "powershell.exe") {
        throw "powershell check failed";
      }
    } catch (e) {
      Map<String, String> envVars = Platform.environment;
      final systemRoot = envVars["SYSTEMROOT"];
      if (systemRoot != null) {
        final autoSearchPath = "$systemRoot\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
        dPrint("auto search powershell path === $autoSearchPath");
        powershellPath = autoSearchPath;
      }
    }
  }

  static Future<bool> checkNvmePatchStatus() async {
    try {
      var result = await Process.run(SystemHelper.powershellPath, [
        "Get-ItemProperty",
        "-Path",
        "\"HKLM:\\SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device\"",
        "-Name",
        "\"ForcedPhysicalSectorSizeInBytes\"",
      ]);
      dPrint("checkNvmePatchStatus result ==== ${result.stdout}");
      if (result.stderr == "" && result.stdout.toString().contains("{* 4095}")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<String> addNvmePatch() async {
    var result = await Process.run(powershellPath, [
      'New-ItemProperty',
      "-Path",
      "\"HKLM:\\SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device\"",
      "-Name",
      "ForcedPhysicalSectorSizeInBytes",
      "-PropertyType MultiString",
      "-Force -Value",
      "\"* 4095\"",
    ]);
    dPrint("nvme_PhysicalBytes result == ${result.stdout}");
    return result.stderr;
  }

  static Future<bool> doRemoveNvmePath() async {
    try {
      var result = await Process.run(powershellPath, [
        "Clear-ItemProperty",
        "-Path",
        "\"HKLM:\\SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device\"",
        "-Name",
        "\"ForcedPhysicalSectorSizeInBytes\"",
      ]);
      dPrint("doRemoveNvmePath result ==== ${result.stdout}");
      if (result.stderr == "") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
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
        final targetPath = await win32.resolveShortcut(lnkPath: rsiFilePath);
        if (targetPath.contains("RSI Launcher.exe")) {
          final start = targetPath.split("RSI Launcher.exe");
          if (skipEXE) {
            return start[0];
          }
          return "${start[0]}RSI Launcher.exe";
        }
      } catch (e) {
        dPrint("resolveShortcut error: $e");
      }
    }
    return "";
  }

  static Future<void> killRSILauncher() async {
    var pList = await getPID("RSI Launcher");
    for (var pid in pList) {
      try {
        Process.killPid(pid);
      } catch (e) {
        dPrint("killRSILauncher Error: $e");
      }
    }
  }

  static Future<List<int>> getPID(String name) async {
    try {
      final pList = await win32.getProcessListByName(processName: name);
      return pList.map((e) => e.pid).toList();
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
    if (processorAffinity == null) {
      Process.run(path, []);
    } else {
      Process.run("cmd.exe", ['/C', 'Start', '""', '/High', '/Affinity', processorAffinity, path]);
    }
    dPrint(path);
  }

  static Future<int> getSystemMemorySizeGB() async {
    try {
      final memoryGb = await win32.getSystemMemorySizeGb();
      return memoryGb.toInt();
    } catch (e) {
      dPrint("getSystemMemorySizeGB error: $e");
      return 0;
    }
  }

  static Future<String> getSystemCimInstance(String win32InstanceName, {pathName = "Name"}) async {
    // This method is deprecated, use getSystemInfo() instead
    try {
      final sysInfo = await win32.getSystemInfo();
      if (win32InstanceName.contains("OperatingSystem")) {
        return sysInfo.osName;
      } else if (win32InstanceName.contains("Processor")) {
        return sysInfo.cpuName;
      } else if (win32InstanceName.contains("VideoController")) {
        return sysInfo.gpuInfo;
      } else if (win32InstanceName.contains("DiskDrive")) {
        return sysInfo.diskInfo;
      }
    } catch (e) {
      dPrint("getSystemCimInstance error: $e");
    }
    return "";
  }

  static Future<String> getSystemName() async {
    try {
      final sysInfo = await win32.getSystemInfo();
      return sysInfo.osName;
    } catch (e) {
      dPrint("getSystemName error: $e");
      return "";
    }
  }

  static Future<String> getCpuName() async {
    try {
      final sysInfo = await win32.getSystemInfo();
      return sysInfo.cpuName;
    } catch (e) {
      dPrint("getCpuName error: $e");
      return "";
    }
  }

  static Future<String> getGpuInfo() async {
    try {
      // Try registry first for more accurate VRAM info
      final regInfo = await win32.getGpuInfoFromRegistry();
      if (regInfo.isNotEmpty) {
        return regInfo;
      }
      // Fallback to WMI
      final sysInfo = await win32.getSystemInfo();
      return sysInfo.gpuInfo;
    } catch (e) {
      dPrint("getGpuInfo error: $e");
      return "";
    }
  }

  static Future<String> getDiskInfo() async {
    try {
      final sysInfo = await win32.getSystemInfo();
      return sysInfo.diskInfo;
    } catch (e) {
      dPrint("getDiskInfo error: $e");
      return "";
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
      return await win32.getNumberOfLogicalProcessors();
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
    if (Platform.isWindows) {
      try {
        await win32.openDirWithExplorer(path: path.toString(), isFile: isFile);
      } catch (e) {
        dPrint("openDir error: $e");
      }
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
