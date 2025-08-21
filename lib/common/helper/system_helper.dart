import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class SystemHelper {
  /// No longer needed - we use direct Windows tools instead of PowerShell
  /// static String powershellPath = "powershell.exe";

  /// No longer needed - PowerShell initialization removed
  /// static Future<void> initPowershellPath() async {

  static Future<bool> checkNvmePatchStatus() async {
    try {
      // Use reg.exe instead of PowerShell for better performance
      var result = await Process.run("reg.exe", [
        "query",
        "HKLM\\SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device",
        "/v",
        "ForcedPhysicalSectorSizeInBytes"
      ]);
      dPrint("checkNvmePatchStatus result ==== ${result.stdout}");
      if (result.exitCode == 0 && result.stdout.toString().contains("* 4095")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<String> addNvmePatch() async {
    // Use reg.exe instead of PowerShell for better performance
    var result = await Process.run("reg.exe", [
      "add",
      "HKLM\\SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device",
      "/v",
      "ForcedPhysicalSectorSizeInBytes",
      "/t",
      "REG_MULTI_SZ",
      "/d",
      "* 4095",
      "/f"
    ]);
    dPrint("nvme_PhysicalBytes result == ${result.stdout}");
    return result.exitCode == 0 ? "" : result.stderr.toString();
  }

  static Future<bool> doRemoveNvmePath() async {
    try {
      // Use reg.exe instead of PowerShell for better performance
      var result = await Process.run("reg.exe", [
        "delete",
        "HKLM\\SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device",
        "/v",
        "ForcedPhysicalSectorSizeInBytes",
        "/f"
      ]);
      dPrint("doRemoveNvmePath result ==== ${result.stdout}");
      return result.exitCode == 0;
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
      // Keep PowerShell for shortcut resolution as it's complex to replace
      // This is one of the few remaining PowerShell uses
      final r = await Process.run("powershell.exe",
          ["-Command", "(New-Object -ComObject WScript.Shell).CreateShortcut(\"$rsiFilePath\").targetpath"]);
      if (r.stdout.toString().contains("RSI Launcher.exe")) {
        final start = r.stdout.toString().split("RSI Launcher.exe");
        if (skipEXE) {
          return start[0];
        }
        return "${start[0]}RSI Launcher.exe";
      }
    }
    return "";
  }

  static Future<void> killRSILauncher() async {
    // Use tasklist and taskkill instead of PowerShell for better performance
    var psr = await Process.run("tasklist.exe", ["/FI", "IMAGENAME eq RSI Launcher.exe", "/FO", "CSV", "/NH"]);
    if (psr.exitCode == 0) {
      final lines = psr.stdout.toString().split('\n');
      for (var line in lines) {
        if (line.trim().isNotEmpty && line.contains("RSI Launcher.exe")) {
          // Extract PID from CSV format (second column)
          final parts = line.split(',');
          if (parts.length >= 2) {
            final pid = parts[1].replaceAll('"', '').trim();
            if (pid.isNotEmpty) {
              dPrint("Killing RSI Launcher with PID: $pid");
              await Process.run("taskkill.exe", ["/PID", pid, "/F"]);
            }
          }
        }
      }
    }
  }

  static Future<List<String>> getPID(String name) async {
    try {
      // Use tasklist instead of PowerShell for better performance
      final r = await Process.run("tasklist.exe", ["/FI", "IMAGENAME eq $name", "/FO", "CSV", "/NH"]);
      if (r.exitCode != 0) {
        dPrint("getPID Error: ${r.stderr}");
        return [];
      }
      final List<String> pids = [];
      final lines = r.stdout.toString().trim().split('\n');
      for (var line in lines) {
        if (line.trim().isNotEmpty && line.contains(name)) {
          // Extract PID from CSV format (second column)
          final parts = line.split(',');
          if (parts.length >= 2) {
            final pid = parts[1].replaceAll('"', '').trim();
            if (pid.isNotEmpty) {
              pids.add(pid);
            }
          }
        }
      }
      dPrint("getPID result: $pids");
      return pids;
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
    // Use wmic instead of PowerShell for better performance
    final r = await Process.run("wmic.exe", ["computersystem", "get", "TotalPhysicalMemory", "/value"]);
    final output = r.stdout.toString();
    final match = RegExp(r'TotalPhysicalMemory=(\d+)').firstMatch(output);
    if (match != null) {
      final bytes = int.tryParse(match.group(1) ?? "0") ?? 0;
      return (bytes / (1024 * 1024 * 1024)).round();
    }
    return 0;
  }

  static Future<String> getSystemCimInstance(String win32InstanceName, {pathName = "Name"}) async {
    // Use wmic instead of PowerShell for better performance
    final r = await Process.run("wmic.exe", [win32InstanceName, "get", pathName, "/value"]);
    final output = r.stdout.toString();
    final match = RegExp('$pathName=(.*)').firstMatch(output);
    return match?.group(1)?.trim() ?? "";
  }

  static Future<String> getSystemName() async {
    // Use wmic instead of PowerShell for better performance
    final r = await Process.run("wmic.exe", ["os", "get", "Caption", "/value"]);
    final output = r.stdout.toString();
    final match = RegExp(r'Caption=(.*)').firstMatch(output);
    return match?.group(1)?.trim() ?? "Unknown";
  }

  static Future<String> getCpuName() async {
    // Use wmic instead of PowerShell for better performance
    final r = await Process.run("wmic.exe", ["cpu", "get", "Name", "/value"]);
    final output = r.stdout.toString();
    final match = RegExp(r'Name=(.*)').firstMatch(output);
    return match?.group(1)?.trim() ?? "Unknown";
  }

  static Future<String> getGpuInfo() async {
    // Use wmic instead of PowerShell for better performance  
    final r = await Process.run("wmic.exe", ["path", "win32_VideoController", "get", "Name,AdapterRAM", "/format:csv"]);
    final lines = r.stdout.toString().split('\n');
    final List<String> gpuInfo = [];
    
    for (var line in lines) {
      if (line.contains(',') && !line.startsWith('Node,')) {
        final parts = line.split(',');
        if (parts.length >= 3) {
          final name = parts[2].trim();
          final ramStr = parts[1].trim();
          if (name.isNotEmpty && name != "Name") {
            final ramBytes = int.tryParse(ramStr) ?? 0;
            final ramGB = ramBytes > 0 ? (ramBytes / (1024 * 1024 * 1024)).round() : 0;
            gpuInfo.add("Model: $name VRAM (GB): $ramGB");
          }
        }
      }
    }
    
    return gpuInfo.isEmpty ? "No GPU information found" : gpuInfo.join('\n');
  }

  static Future<String> getDiskInfo() async {
    // Use wmic instead of PowerShell for better performance
    final r = await Process.run("wmic.exe", ["diskdrive", "get", "InterfaceType,Model,Size", "/format:table"]);
    return r.stdout.toString().trim();
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
    // Use wmic instead of PowerShell for better performance
    final cpuNumberResult = await Process.run("wmic.exe", ["cpu", "get", "NumberOfLogicalProcessors", "/value"]);
    if (cpuNumberResult.exitCode != 0) return 0;
    final output = cpuNumberResult.stdout.toString();
    final match = RegExp(r'NumberOfLogicalProcessors=(\d+)').firstMatch(output);
    return int.tryParse(match?.group(1) ?? "0") ?? 0;
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
      // Use explorer.exe directly instead of through PowerShell for better performance
      await Process.run("explorer.exe", [isFile ? "/select,$path" : path]);
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
