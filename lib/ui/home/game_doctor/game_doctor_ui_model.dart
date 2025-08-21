import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/rust/api/system_info.dart' as rust_system_info;
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'game_doctor_ui_model.g.dart';

part 'game_doctor_ui_model.freezed.dart';

@freezed
abstract class HomeGameDoctorState with _$HomeGameDoctorState {
  factory HomeGameDoctorState({
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
    state = HomeGameDoctorState();
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
        showToast(context, S.current.doctor_action_result_try_latest_windows);
        break;
      case "no_live_path":
        try {
          await Directory(item.value).create(recursive: true);
          if (!context.mounted) break;
          showToast(
              context, S.current.doctor_action_result_create_folder_success);
          checkResult.remove(item);
          state = state.copyWith(checkResult: checkResult);
        } catch (e) {
          showToast(context,
              S.current.doctor_action_result_create_folder_fail(item.value, e));
        }
        break;
      case "nvme_PhysicalBytes":
        final r = await SystemHelper.addNvmePatch();
        if (r == "") {
          if (!context.mounted) break;
          showToast(context, S.current.doctor_action_result_fix_success);
          checkResult.remove(item);
          state = state.copyWith(checkResult: checkResult);
        } else {
          if (!context.mounted) break;
          showToast(context, S.current.doctor_action_result_fix_fail(r));
        }
        break;
      case "eac_file_miss":
        showToast(context,
            S.current.doctor_info_result_verify_files_with_rsi_launcher);
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
            showToast(
                context, S.current.doctor_action_result_game_start_success);
            checkResult.remove(item);
            state = state.copyWith(checkResult: checkResult);
          } else {
            if (!context.mounted) break;
            showToast(context,
                S.current.doctor_action_result_fix_fail(result.stderr));
          }
        } catch (e) {
          if (!context.mounted) break;
          showToast(context, S.current.doctor_action_result_fix_fail(e));
        }
        break;
      case "cn_user_name":
        showToast(context, S.current.doctor_action_result_redirect_warning);
        await Future.delayed(const Duration(milliseconds: 300));
        launchUrlString(
            "https://jingyan.baidu.com/article/59703552a318a08fc0074021.html");
        break;
      default:
        showToast(context, S.current.doctor_action_result_issue_not_supported);
        break;
    }
    state = state.copyWith(isFixing: false, isFixingString: "");
  }

  // ignore: avoid_build_context_in_providers
  Future<void> doCheck(BuildContext context) async {
    if (state.isChecking) return;
    state = state.copyWith(
        isChecking: true, lastScreenInfo: S.current.doctor_action_analyzing);
    dPrint("-------- start docker check -----");
    if (!context.mounted) return;
    await _statCheck(context);
    state = state.copyWith(isChecking: false);
  }

  // ignore: avoid_build_context_in_providers
  Future<void> _statCheck(BuildContext context) async {
    final homeState = ref.read(homeUIModelProvider);
    final scInstalledPath = homeState.scInstalledPath!;

    final checkResult = <MapEntry<String, String>>[];
    // for debug
    // checkResult?.add(MapEntry("unSupport_system", "android"));
    // checkResult?.add(MapEntry("nvme_PhysicalBytes", "C"));
    // checkResult?.add(MapEntry("no_live_path", ""));

    await _checkPreInstall(context, scInstalledPath, checkResult);
    if (!context.mounted) return;
    await _checkEAC(context, scInstalledPath, checkResult);
    if (!context.mounted) return;
    await _checkGameRunningLog(context, scInstalledPath, checkResult);

    if (checkResult.isEmpty) {
      final lastScreenInfo = S.current.doctor_action_result_analysis_no_issue;
      state = state.copyWith(checkResult: null, lastScreenInfo: lastScreenInfo);
    } else {
      final lastScreenInfo = S.current
          .doctor_action_result_analysis_issues_found(
              checkResult.length.toString());
      state = state.copyWith(
          checkResult: checkResult, lastScreenInfo: lastScreenInfo);
    }

    if (scInstalledPath == "not_install" && (checkResult.isEmpty)) {
      if (!context.mounted) return;
      showToast(context, S.current.doctor_action_result_toast_scan_no_issue);
    }
  }

  // ignore: avoid_build_context_in_providers
  Future _checkGameRunningLog(BuildContext context, String scInstalledPath,
      List<MapEntry<String, String>> checkResult) async {
    if (scInstalledPath == "not_install") return;
    final lastScreenInfo = S.current.doctor_action_tip_checking_game_log;
    state = state.copyWith(lastScreenInfo: lastScreenInfo);
    final logs = await SCLoggerHelper.getGameRunningLogs(scInstalledPath);
    if (logs == null) return;
    final info = SCLoggerHelper.getGameRunningLogInfo(logs);
    if (info != null) {
      if (info.key != "_") {
        checkResult.add(MapEntry(
            S.current.doctor_action_info_game_abnormal_exit(info.key),
            info.value));
      } else {
        checkResult.add(MapEntry(
            S.current.doctor_action_info_game_abnormal_exit_unknown,
            S.current.doctor_action_info_info_feedback(info.value)));
      }
    }
  }

  // ignore: avoid_build_context_in_providers
  Future _checkEAC(BuildContext context, String scInstalledPath,
      List<MapEntry<String, String>> checkResult) async {
    if (scInstalledPath == "not_install") return;
    final lastScreenInfo = S.current.doctor_action_info_checking_eac;
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

  final _cnExp = RegExp(r"[^\x00-\xff]");

  // ignore: avoid_build_context_in_providers
  Future _checkPreInstall(BuildContext context, String scInstalledPath,
      List<MapEntry<String, String>> checkResult) async {
    final lastScreenInfo = S.current.doctor_action_info_checking_runtime;
    state = state.copyWith(lastScreenInfo: lastScreenInfo);

    if (!(Platform.operatingSystemVersion.contains("Windows 10") ||
        Platform.operatingSystemVersion.contains("Windows 11"))) {
      checkResult
          .add(MapEntry("unSupport_system", Platform.operatingSystemVersion));
      final lastScreenInfo = S.current.doctor_action_result_info_unsupported_os(
          Platform.operatingSystemVersion);
      state = state.copyWith(lastScreenInfo: lastScreenInfo);
      await showToast(context, lastScreenInfo);
    }

    if (_cnExp.hasMatch(await SCLoggerHelper.getLogFilePath() ?? "")) {
      checkResult.add(const MapEntry("cn_user_name", ""));
    }

    // 检查 RAM
    final ramSize = await SystemHelper.getSystemMemorySizeGB();
    if (ramSize < 16) {
      checkResult.add(MapEntry("low_ram", "$ramSize"));
    }
    state = state.copyWith(
        lastScreenInfo: S.current.doctor_action_info_checking_install_info);
    // 检查安装分区
    try {
      final listData = await SCLoggerHelper.getGameInstallPath(
          await SCLoggerHelper.getLauncherLogList() ?? []);
      final p = [];
      final checkedPath = [];
      for (var installPath in listData) {
        if (!checkedPath.contains(installPath)) {
          if (_cnExp.hasMatch(installPath)) {
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
        try {
          final physicalBytesPerSectorForPerformance = rust_system_info.getDiskSectorInfo(driveLetter: element);
          dPrint("fsutil info sector info: ->>> $physicalBytesPerSectorForPerformance");
          if (physicalBytesPerSectorForPerformance > 4096) {
            checkResult.add(MapEntry("nvme_PhysicalBytes", element));
          }
        } catch (e) {
          dPrint("Error checking disk sector info for $element: $e");
        }
      }
    } catch (e) {
      dPrint(e);
    }
  }
}
