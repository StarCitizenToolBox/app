import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/rust/api/system_info.dart' as rust_system_info;

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
      return rust_system_info.checkNvmePatchStatus();
    } catch (e) {
      dPrint("checkNvmePatchStatus error: $e");
      // Fallback to PowerShell if Rust function fails
      try {
        var result = await Process.run(SystemHelper.powershellPath, [
          "Get-ItemProperty",
          "-Path",
          "\"HKLM:\\SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device\"",
          "-Name",
          "\"ForcedPhysicalSectorSizeInBytes\""
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
      "\"* 4095\""
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
        "\"ForcedPhysicalSectorSizeInBytes\""
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
      final r = await Process.run(SystemHelper.powershellPath,
          ["(New-Object -ComObject WScript.Shell).CreateShortcut(\"$rsiFilePath\").targetpath"]);
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
    try {
      // Use Rust to get process IDs
      final pids = rust_system_info.getProcessIdsByName(processName: "RSI Launcher");
      if (pids.isNotEmpty) {
        final pidList = pids.map((pid) => pid.toInt()).toList();
        final killedCount = rust_system_info.killProcessesByPids(pids: pidList);
        dPrint("Killed $killedCount RSI Launcher processes using Rust");
        return;
      }
    } catch (e) {
      dPrint("killRSILauncher (Rust) error: $e");
    }
    
    // Fallback to PowerShell method
    var psr = await Process.run(powershellPath, ["ps", "\"RSI Launcher\"", "|select -expand id"]);
    if (psr.stderr == "") {
      for (var value in (psr.stdout ?? "").toString().split("\n")) {
        dPrint(value);
        if (value != "") {
          Process.killPid(int.parse(value));
        }
      }
    }
  }

  static Future<List<String>> getPID(String name) async {
    try {
      final pids = rust_system_info.getProcessIdsByName(processName: name);
      return pids.map((pid) => pid.toString()).toList();
    } catch (e) {
      dPrint("getPID (Rust) error: $e");
      // Fallback to PowerShell if Rust function fails
      try {
        final r = await Process.run(powershellPath, ["(ps $name).Id"]);
        if (r.stderr.toString().trim().isNotEmpty) {
          dPrint("getPID Error: ${r.stderr}");
          return [];
        }
        final str = r.stdout.toString().trim();
        dPrint("getPID result: $str");
        if (str.isEmpty) return [];
        return str.split("\n");
      } catch (e) {
        dPrint("getPID Error: $e");
        return [];
      }
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
      // Fallback to PowerShell if Rust function fails
      final r = await Process.run(
          powershellPath, ["(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb"]);
      return int.tryParse(r.stdout.toString().trim()) ?? 0;
    }
  }

  static Future<String> getSystemCimInstance(String win32InstanceName, {pathName = "Name"}) async {
    final r = await Process.run(powershellPath, ["(Get-CimInstance $win32InstanceName).$pathName"]);
    return r.stdout.toString().trim();
  }

  static Future<String> getSystemName() async {
    try {
      return rust_system_info.getSystemName();
    } catch (e) {
      dPrint("getSystemName error: $e");
      // Fallback to PowerShell if Rust function fails
      final r = await Process.run(powershellPath, ["(Get-ComputerInfo | Select-Object -expand OsName)"]);
      return r.stdout.toString().trim();
    }
  }

  static Future<String> getCpuName() async {
    try {
      return rust_system_info.getCpuName();
    } catch (e) {
      dPrint("getCpuName error: $e");
      // Fallback to PowerShell if Rust function fails
      final r = await Process.run(powershellPath, ["(Get-WmiObject -Class Win32_Processor).Name"]);
      return r.stdout.toString().trim();
    }
  }

  static Future<String> getGpuInfo() async {
    try {
      return rust_system_info.getGpuInfo();
    } catch (e) {
      dPrint("getGpuInfo error: $e");
      // Fallback to PowerShell if Rust function fails
      const cmd = r"""
    $adapterMemory = (Get-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*" -Name "HardwareInformation.AdapterString", "HardwareInformation.qwMemorySize" -Exclude PSPath -ErrorAction SilentlyContinue)
foreach ($adapter in $adapterMemory) {
  [PSCustomObject] @{
    Model=$adapter."HardwareInformation.AdapterString"
    "VRAM (GB)"=[math]::round($adapter."HardwareInformation.qwMemorySize"/1GB)
  }
}
    """;
      final r = await Process.run(powershellPath, [cmd]);
      return r.stdout.toString().trim();
    }
  }

  static Future<String> getDiskInfo() async {
    try {
      return rust_system_info.getDiskInfo();
    } catch (e) {
      dPrint("getDiskInfo error: $e");
      // Fallback to PowerShell if Rust function fails
      return (await Process.run(powershellPath, ["Get-PhysicalDisk | format-table BusType,FriendlyName,Size"]))
          .stdout
          .toString()
          .trim();
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
      // Fallback to PowerShell if Rust function fails
      final cpuNumberResult =
          await Process.run(powershellPath, ["(Get-WmiObject -Class Win32_Processor).NumberOfLogicalProcessors"]);
      if (cpuNumberResult.exitCode != 0) return 0;
      return int.tryParse(cpuNumberResult.stdout.toString().trim()) ?? 0;
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
      await Process.run(
          SystemHelper.powershellPath, ["explorer.exe", isFile ? "/select,$path" : "\"/select,\"$path\"\""]);
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
