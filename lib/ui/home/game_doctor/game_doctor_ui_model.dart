import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'game_doctor_ui_model.g.dart';

part 'game_doctor_ui_model.freezed.dart';

@freezed
class HomeGameDoctorState with _$HomeGameDoctorState {
  const factory HomeGameDoctorState({
    @Default(false) bool isChecking,
    @Default(false) bool isFixing,
    @Default("") String lastScreenInfo,
    @Default("") String isFixingString,
    List<MapEntry<String, String>>? checkResult,
  }) = _HomeGameDoctorState;
}

@riverpod
class HomeGameDoctorUIModel extends _$HomeGameDoctorUIModel {
  @override
  HomeGameDoctorState build() {
    state = const HomeGameDoctorState();
    return state;
  }

  Future<void> doFix(
      // ignore: avoid_build_context_in_providers
      BuildContext context,
      MapEntry<String, String> item) async {
    final checkResult =
        List<MapEntry<String, String>>.from(state.checkResult ?? []);
    state = state.copyWith(isFixing: true, isFixingString: "");
    switch (item.key) {
      case "unSupport_system":
        showToast(context, "若您的硬件达标，请尝试安装最新的 Windows 系统。");
        break;
      case "no_live_path":
        try {
          await Directory(item.value).create(recursive: true);
          if (!context.mounted) break;
          showToast(context, "创建文件夹成功，请尝试继续下载游戏！");
          checkResult.remove(item);
          state = state.copyWith(checkResult: checkResult);
        } catch (e) {
          showToast(context, "创建文件夹失败，请尝试手动创建。\n目录：${item.value} \n错误：$e");
        }
        break;
      case "nvme_PhysicalBytes":
        final r = await SystemHelper.addNvmePatch();
        if (r == "") {
          if (!context.mounted) break;
          showToast(context,
              "修复成功，请尝试重启后继续安装游戏！ 若注册表修改操作导致其他软件出现兼容问题，请使用 工具 中的 NVME 注册表清理。");
          checkResult.remove(item);
          state = state.copyWith(checkResult: checkResult);
        } else {
          if (!context.mounted) break;
          showToast(context, "修复失败，$r");
        }
        break;
      case "eac_file_miss":
        showToast(
            context, "未在 LIVE 文件夹找到 EasyAntiCheat 文件 或 文件不完整，请使用 RSI 启动器校验文件");
        break;
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
            if (!context.mounted) break;
            showToast(context, "修复成功，请尝试启动游戏。（若问题无法解决，请使用工具箱的 《重装 EAC》）");
            checkResult.remove(item);
            state = state.copyWith(checkResult: checkResult);
          } else {
            if (!context.mounted) break;
            showToast(context, "修复失败，${result.stderr}");
          }
        } catch (e) {
          if (!context.mounted) break;
          showToast(context, "修复失败，$e");
        }
        break;
      case "cn_user_name":
        showToast(context, "即将跳转，教程来自互联网，请谨慎操作...");
        await Future.delayed(const Duration(milliseconds: 300));
        launchUrlString(
            "https://btfy.eu.org/?q=5L+u5pS5d2luZG93c+eUqOaIt+WQjeS7juS4reaWh+WIsOiLseaWhw==");
        break;
      default:
        showToast(context, "该问题暂不支持自动处理，请提供截图寻求帮助");
        break;
    }
    state = state.copyWith(isFixing: false, isFixingString: "");
  }

  // ignore: avoid_build_context_in_providers
  doCheck(BuildContext context) async {
    if (state.isChecking) return;
    state = state.copyWith(isChecking: true, lastScreenInfo: "正在分析...");
    dPrint("-------- start docker check -----");
    if (!context.mounted) return;
    await _statCheck(context);
    state = state.copyWith(isChecking: false);
  }

  // ignore: avoid_build_context_in_providers
  _statCheck(BuildContext context) async {
    final homeState = ref.read(homeUIModelProvider);
    final scInstalledPath = homeState.scInstalledPath!;

    final checkResult = <MapEntry<String, String>>[];
    // TODO for debug
    // checkResult?.add(const MapEntry("unSupport_system", "android"));
    // checkResult?.add(const MapEntry("nvme_PhysicalBytes", "C"));
    // checkResult?.add(const MapEntry("no_live_path", ""));

    await _checkPreInstall(context, scInstalledPath, checkResult);
    if (!context.mounted) return;
    await _checkEAC(context, scInstalledPath, checkResult);
    if (!context.mounted) return;
    await _checkGameRunningLog(context, scInstalledPath, checkResult);

    if (checkResult.isEmpty) {
      const lastScreenInfo = "分析完毕，没有发现问题";
      state = state.copyWith(checkResult: null, lastScreenInfo: lastScreenInfo);
    } else {
      final lastScreenInfo = "分析完毕，发现 ${checkResult.length} 个问题";
      state = state.copyWith(
          checkResult: checkResult, lastScreenInfo: lastScreenInfo);
    }

    if (scInstalledPath == "not_install" && (checkResult.isEmpty)) {
      if (!context.mounted) return;
      showToast(context, "扫描完毕，没有发现问题，若仍然安装失败，请尝试使用工具箱中的 RSI启动器管理员模式。");
    }
  }

  // ignore: avoid_build_context_in_providers
  Future _checkGameRunningLog(BuildContext context, String scInstalledPath,
      List<MapEntry<String, String>> checkResult) async {
    if (scInstalledPath == "not_install") return;
    const lastScreenInfo = "正在检查：Game.log";
    state = state.copyWith(lastScreenInfo: lastScreenInfo);
    final logs = await SCLoggerHelper.getGameRunningLogs(scInstalledPath);
    if (logs == null) return;
    final info = SCLoggerHelper.getGameRunningLogInfo(logs);
    if (info != null) {
      if (info.key != "_") {
        checkResult.add(MapEntry("游戏异常退出：${info.key}", info.value));
      } else {
        checkResult
            .add(MapEntry("游戏异常退出：未知异常", "info:${info.value}，请点击右下角加群反馈。"));
      }
    }
  }

  // ignore: avoid_build_context_in_providers
  Future _checkEAC(BuildContext context, String scInstalledPath,
      List<MapEntry<String, String>> checkResult) async {
    if (scInstalledPath == "not_install") return;
    const lastScreenInfo = "正在检查：EAC";
    state = state.copyWith(lastScreenInfo: lastScreenInfo);

    final eacPath = "$scInstalledPath\\EasyAntiCheat";
    final eacJsonPath = "$eacPath\\Settings.json";
    if (!await Directory(eacPath).exists() ||
        !await File(eacJsonPath).exists()) {
      checkResult.add(const MapEntry("eac_file_miss", ""));
      return;
    }
    final eacJsonData = await File(eacJsonPath).readAsBytes();
    final Map eacJson = json.decode(utf8.decode(eacJsonData));
    final eacID = eacJson["productid"];
    final eacDeploymentId = eacJson["deploymentid"];
    if (eacID == null || eacDeploymentId == null) {
      checkResult.add(const MapEntry("eac_file_miss", ""));
      return;
    }
    final eacFilePath =
        "${Platform.environment["appdata"]}\\EasyAntiCheat\\$eacID\\$eacDeploymentId\\anticheatlauncher.log";
    if (!await File(eacFilePath).exists()) {
      checkResult.add(MapEntry("eac_not_install", eacPath));
      return;
    }
  }

  final cnExp = RegExp(r"[^\x00-\xff]");

  // ignore: avoid_build_context_in_providers
  Future _checkPreInstall(BuildContext context, String scInstalledPath,
      List<MapEntry<String, String>> checkResult) async {
    const lastScreenInfo = "正在检查：运行环境";
    state = state.copyWith(lastScreenInfo: lastScreenInfo);

    if (!(Platform.operatingSystemVersion.contains("Windows 10") ||
        Platform.operatingSystemVersion.contains("Windows 11"))) {
      checkResult
          .add(MapEntry("unSupport_system", Platform.operatingSystemVersion));
      final lastScreenInfo = "不支持的操作系统：${Platform.operatingSystemVersion}";
      state = state.copyWith(lastScreenInfo: lastScreenInfo);
      await showToast(context, lastScreenInfo);
    }

    if (cnExp.hasMatch(await SCLoggerHelper.getLogFilePath() ?? "")) {
      checkResult.add(const MapEntry("cn_user_name", ""));
    }

    // 检查 RAM
    final ramSize = await SystemHelper.getSystemMemorySizeGB();
    if (ramSize < 16) {
      checkResult.add(MapEntry("low_ram", "$ramSize"));
    }
    state = state.copyWith(lastScreenInfo: "正在检查：安装信息");
    // 检查安装分区
    try {
      final listData = await SCLoggerHelper.getGameInstallPath(
          await SCLoggerHelper.getLauncherLogList() ?? []);
      final p = [];
      final checkedPath = [];
      for (var installPath in listData) {
        if (!checkedPath.contains(installPath)) {
          if (cnExp.hasMatch(installPath)) {
            checkResult.add(MapEntry("cn_install_path", installPath));
          }
          if (scInstalledPath == "not_install") {
            checkedPath.add(installPath);
            if (!await Directory(installPath).exists()) {
              checkResult.add(MapEntry("no_live_path", installPath));
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
        dPrint(
            "fsutil info sector info: ->>> ${result.stdout.toString().trim()}");
        if (result.stderr == "") {
          final rs = result.stdout.toString().trim();
          final physicalBytesPerSectorForPerformance = (int.tryParse(rs) ?? 0);
          if (physicalBytesPerSectorForPerformance > 4096) {
            checkResult.add(MapEntry("nvme_PhysicalBytes", element));
          }
        }
      }
    } catch (e) {
      dPrint(e);
    }
  }
}
