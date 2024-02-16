import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GameDoctorUIModel extends BaseUIModel {
  String scInstalledPath = "";

  GameDoctorUIModel(this.scInstalledPath);

  String _lastScreenInfo = "";

  String get lastScreenInfo => _lastScreenInfo;

  List<MapEntry<String, String>>? checkResult;

  set lastScreenInfo(String info) {
    _lastScreenInfo = info;
    notifyListeners();
  }

  bool isChecking = false;

  bool isFixing = false;
  String isFixingString = "";

  final cnExp = RegExp(r"[^\x00-\xff]");

  @override
  void initModel() {
    doCheck()?.call();
    super.initModel();
  }

  VoidCallback? doCheck() {
    if (isChecking) return null;
    return () async {
      isChecking = true;
      lastScreenInfo = "正在分析...";
      await _statCheck();
      isChecking = false;
      notifyListeners();
    };
  }

  Future _statCheck() async {
    checkResult = [];
    // TODO for debug
    // checkResult?.add(const MapEntry("unSupport_system", "android"));
    // checkResult?.add(const MapEntry("nvme_PhysicalBytes", "C"));
    // checkResult?.add(const MapEntry("no_live_path", ""));

    await _checkPreInstall();
    await _checkEAC();
    await _checkGameRunningLog();

    if (checkResult!.isEmpty) {
      checkResult = null;
      lastScreenInfo = "分析完毕，没有发现问题";
    } else {
      lastScreenInfo = "分析完毕，发现 ${checkResult!.length} 个问题";
    }

    if (scInstalledPath == "not_install" && (checkResult?.isEmpty ?? true)) {
      showToast(context!, "扫描完毕，没有发现问题，若仍然安装失败，请尝试使用工具箱中的 RSI启动器管理员模式。");
    }
  }

  Future _checkGameRunningLog() async {
    if (scInstalledPath == "not_install") return;
    lastScreenInfo = "正在检查：Game.log";
    final logs = await SCLoggerHelper.getGameRunningLogs(scInstalledPath);
    if (logs == null) return;
    final info = SCLoggerHelper.getGameRunningLogInfo(logs);
    if (info != null) {
      if (info.key != "_") {
        checkResult?.add(MapEntry("游戏异常退出：${info.key}", info.value));
      } else {
        checkResult
            ?.add(MapEntry("游戏异常退出：未知异常", "info:${info.value}，请点击右下角加群反馈。"));
      }
    }
  }

  Future _checkEAC() async {
    if (scInstalledPath == "not_install") return;
    lastScreenInfo = "正在检查：EAC";
    final eacPath = "$scInstalledPath\\EasyAntiCheat";
    final eacJsonPath = "$eacPath\\Settings.json";
    if (!await Directory(eacPath).exists() ||
        !await File(eacJsonPath).exists()) {
      checkResult?.add(const MapEntry("eac_file_miss", ""));
      return;
    }
    final eacJsonData = await File(eacJsonPath).readAsBytes();
    final Map eacJson = json.decode(utf8.decode(eacJsonData));
    final eacID = eacJson["productid"];
    final eacDeploymentId = eacJson["deploymentid"];
    if (eacID == null || eacDeploymentId == null) {
      checkResult?.add(const MapEntry("eac_file_miss", ""));
      return;
    }
    final eacFilePath =
        "${Platform.environment["appdata"]}\\EasyAntiCheat\\$eacID\\$eacDeploymentId\\anticheatlauncher.log";
    if (!await File(eacFilePath).exists()) {
      checkResult?.add(MapEntry("eac_not_install", eacPath));
      return;
    }
  }

  Future _checkPreInstall() async {
    lastScreenInfo = "正在检查：运行环境";
    if (!(Platform.operatingSystemVersion.contains("Windows 10") ||
        Platform.operatingSystemVersion.contains("Windows 11"))) {
      checkResult
          ?.add(MapEntry("unSupport_system", Platform.operatingSystemVersion));
      lastScreenInfo = "不支持的操作系统：${Platform.operatingSystemVersion}";
      await showToast(context!, lastScreenInfo);
    }

    if (cnExp.hasMatch(await SCLoggerHelper.getLogFilePath() ?? "")) {
      checkResult?.add(const MapEntry("cn_user_name", ""));
    }

    // 检查 RAM
    final ramSize = await SystemHelper.getSystemMemorySizeGB();
    if (ramSize < 16) {
      checkResult?.add(MapEntry("low_ram", "$ramSize"));
    }

    lastScreenInfo = "正在检查：安装信息";
    // 检查安装分区
    try {
      final listData = await SCLoggerHelper.getGameInstallPath(
          await SCLoggerHelper.getLauncherLogList() ?? []);
      final p = [];
      final checkedPath = [];
      for (var installPath in listData) {
        if (!checkedPath.contains(installPath)) {
          if (cnExp.hasMatch(installPath)) {
            checkResult?.add(MapEntry("cn_install_path", installPath));
          }
          if (scInstalledPath == "not_install") {
            checkedPath.add(installPath);
            if (!await Directory(installPath).exists()) {
              checkResult?.add(MapEntry("no_live_path", installPath));
            }
          }
          final tp = installPath.split(":")[0];
          if (!p.contains(tp)) {
            p.add(tp);
          }
        }
      }

      // call check
      for (var element in p) {
        var result = await Process.run('powershell', [
          "(fsutil fsinfo sectorinfo $element: | Select-String 'PhysicalBytesPerSectorForPerformance').ToString().Split(':')[1].Trim()"
        ]);
        dPrint(result.stdout);
        if (result.stderr == "") {
          final rs = result.stdout.toString();
          final physicalBytesPerSectorForPerformance = (int.tryParse(rs) ?? 0);
          if (physicalBytesPerSectorForPerformance > 4096) {
            checkResult?.add(MapEntry("nvme_PhysicalBytes", element));
          }
        }
      }
    } catch (e) {
      dPrint(e);
    }
  }

  Future<void> doFix(MapEntry<String, String> item) async {
    isFixing = true;
    notifyListeners();
    switch (item.key) {
      case "unSupport_system":
        showToast(context!, "若您的硬件达标，请尝试安装最新的 Windows 系统。");
        return;
      case "no_live_path":
        try {
          await Directory(item.value).create(recursive: true);
          showToast(context!, "创建文件夹成功，请尝试继续下载游戏！");
          checkResult?.remove(item);
          notifyListeners();
        } catch (e) {
          showToast(context!, "创建文件夹失败，请尝试手动创建。\n目录：${item.value} \n错误：$e");
        }
        return;
      case "nvme_PhysicalBytes":
        final r = await SystemHelper.addNvmePatch();
        if (r == "") {
          showToast(context!,
              "修复成功，请尝试重启后继续安装游戏！ 若注册表修改操作导致其他软件出现兼容问题，请使用 工具 中的 NVME 注册表清理。");
          checkResult?.remove(item);
          notifyListeners();
        } else {
          showToast(context!, "修复失败，$r");
        }
        return;
      case "eac_file_miss":
        showToast(
            context!, "未在 LIVE 文件夹找到 EasyAntiCheat 文件 或 文件不完整，请使用 RSI 启动器校验文件");
        return;
      case "eac_not_install":
        final eacJsonPath = "${item.value}\\Settings.json";
        final eacJsonData = await File(eacJsonPath).readAsBytes();
        final Map eacJson = json.decode(utf8.decode(eacJsonData));
        final eacID = eacJson["productid"];
        try {
          var result = await Process.run(
              "${item.value}\\EasyAntiCheat_EOS_Setup.exe", ["install", eacID]);
          dPrint("${item.value}\\EasyAntiCheat_EOS_Setup.exe install $eacID");
          if (result.stderr == "") {
            showToast(context!, "修复成功，请尝试启动游戏。（若问题无法解决，请使用工具箱的 《重装 EAC》）");
            checkResult?.remove(item);
            notifyListeners();
          } else {
            showToast(context!, "修复失败，${result.stderr}");
          }
        } catch (e) {
          showToast(context!, "修复失败，$e");
        }
        return;
      case "cn_user_name":
        showToast(context!, "即将跳转，教程来自互联网，请谨慎操作...");
        await Future.delayed(const Duration(milliseconds: 300));
        launchUrlString(
            "https://btfy.eu.org/?q=5L+u5pS5d2luZG93c+eUqOaIt+WQjeS7juS4reaWh+WIsOiLseaWhw==");
        return;
      default:
        showToast(context!, "该问题暂不支持自动处理，请提供截图寻求帮助");
        return;
    }
  }
}
