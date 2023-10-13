import 'dart:io';

import 'package:starcitizen_doctor/common/utils/base_utils.dart';

class SystemHelper {
  static Future<bool> checkNvmePatchStatus() async {
    try {
      var result = await Process.run('powershell.exe', [
        "Get-ItemProperty",
        "-Path",
        "\"HKLM:\\SYSTEM\\CurrentControlSet\\Services\\stornvme\\Parameters\\Device\"",
        "-Name",
        "\"ForcedPhysicalSectorSizeInBytes\""
      ]);
      dPrint("checkNvmePatchStatus result ==== ${result.stdout}");
      if (result.stderr == "" &&
          result.stdout.toString().contains("{* 4095}")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<String> addNvmePatch() async {
    var result = await Process.run('powershell.exe', [
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

  static doRemoveNvmePath() async {
    try {
      var result = await Process.run('powershell.exe', [
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
  static Future<String> getRSILauncherPath() async {
    Map<String, String> envVars = Platform.environment;
    final programDataPath = envVars["programdata"];
    final rsiFilePath =
        "$programDataPath\\Microsoft\\Windows\\Start Menu\\Programs\\Roberts Space Industries\\RSI Launcher.lnk";
    final rsiLinkFile = File(rsiFilePath);
    if (await rsiLinkFile.exists()) {
      final r = await Process.run("powershell.exe", [
        "(New-Object -ComObject WScript.Shell).CreateShortcut(\"$rsiFilePath\").targetpath"
      ]);
      if (r.stdout.toString().contains("RSI Launcher.exe")) {
        final start = r.stdout.toString().split("RSI Launcher.exe");
        return "${start[0]}RSI Launcher.exe";
      }
    }
    return "";
  }

  static killRSILauncher() async {
    var psr = await Process.run(
        "powershell", ["ps", "\"RSI Launcher\"", "|select -expand id"]);
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
    final r = await Process.run("powershell", ["(ps $name).Id"]);
    final str = r.stdout.toString().trim();
    dPrint(str);
    if (str.isEmpty) return [];
    return str.split("\n");
  }

  static checkAndLaunchRSILauncher(String path) async {
    // check running and kill
    await killRSILauncher();
    // launch
    final r = await Process.run("powershell", ["start", "\"$path\""]);
    dPrint(path);
    dPrint(r.stdout);
    dPrint(r.stderr);
  }

  static Future<int> getSystemMemorySizeGB() async {
    final r = await Process.run("powershell", [
      "(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb"
    ]);
    return int.tryParse(r.stdout.toString().trim()) ?? 0;
  }

  static Future<String> getSystemCimInstance(String win32InstanceName,
      {pathName = "Name"}) async {
    final r = await Process.run(
        "powershell", ["(Get-CimInstance $win32InstanceName).$pathName"]);
    return r.stdout.toString().trim();
  }

  static Future<String> getSystemName() async {
    final r = await Process.run(
        "powershell", ["(Get-ComputerInfo | Select-Object -expand OsName)"]);
    return r.stdout.toString().trim();
  }

  static Future<String> getGpuInfo() async {
    const cmd = r"""
    $adapterMemory = (Get-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*" -Name "HardwareInformation.AdapterString", "HardwareInformation.qwMemorySize" -Exclude PSPath -ErrorAction SilentlyContinue)
foreach ($adapter in $adapterMemory) {
  [PSCustomObject] @{
    Model=$adapter."HardwareInformation.AdapterString"
    "VRAM (GB)"=[math]::round($adapter."HardwareInformation.qwMemorySize"/1GB)
  }
}
    """;
    final r = await Process.run("powershell", [cmd]);
    return r.stdout.toString().trim();
  }

  static Future<String> getDiskInfo() async {
    return (await Process.run("powershell",
            ["Get-PhysicalDisk | format-table BusType,FriendlyName,Size"]))
        .stdout
        .toString()
        .trim();
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
}
