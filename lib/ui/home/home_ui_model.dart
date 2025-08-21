import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_rss/domain/rss_item.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/api/rss.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/rust/api/system_info.dart' as rust_system_info;
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;
import 'package:starcitizen_doctor/common/utils/async.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/app_placard_data.dart';
import 'package:starcitizen_doctor/data/app_web_localization_versions_data.dart';
import 'package:starcitizen_doctor/data/countdown_festival_item_data.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/home_game_login_dialog_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as html_dom;

import '../webview/webview.dart';
import 'localization/localization_ui_model.dart';

part 'home_ui_model.freezed.dart';

part 'home_ui_model.g.dart';

@freezed
abstract class HomeUIModelState with _$HomeUIModelState {
  factory HomeUIModelState({
    AppPlacardData? appPlacardData,
    @Default(false) bool isFixing,
    @Default("") String isFixingString,
    String? scInstalledPath,
    @Default([]) List<String> scInstallPaths,
    AppWebLocalizationVersionsData? webLocalizationVersionsData,
    @Default("") String lastScreenInfo,
    List<RssItem>? rssVideoItems,
    List<RssItem>? rssTextItems,
    MapEntry<String, bool>? localizationUpdateInfo,
    List? scServerStatus,
    List<CountdownFestivalItemData>? countdownFestivalListData,
    @Default({}) Map<String, bool> isGameRunning,
  }) = _HomeUIModelState;
}

extension HomeUIModelStateEx on HomeUIModelState {
  bool get isCurGameRunning => isGameRunning[scInstalledPath] ?? false;
}

@riverpod
class HomeUIModel extends _$HomeUIModel {
  @override
  HomeUIModelState build() {
    state = HomeUIModelState();
    _init();
    _loadData();
    return state;
  }

  Future<void> closePlacard() async {
    final box = await Hive.openBox("app_conf");
    await box.put("close_placard", state.appPlacardData?.version);
    state = state.copyWith(appPlacardData: null);
  }

  Future<void> reScanPath() async {
    state = state.copyWith(scInstalledPath: "not_install", lastScreenInfo: S.current.home_action_info_scanning);
    try {
      final listData = await SCLoggerHelper.getLauncherLogList();
      if (listData == null) {
        state = state.copyWith(scInstalledPath: "not_install");
        return;
      }
      final scInstallPaths = await SCLoggerHelper.getGameInstallPath(
        listData,
        withVersion: AppConf.gameChannels,
        checkExists: true,
      );

      String scInstalledPath = "not_install";

      if (scInstallPaths.isNotEmpty) {
        if (scInstallPaths.first.isNotEmpty) {
          scInstalledPath = scInstallPaths.first;
        }
      }
      final lastScreenInfo = S.current.home_action_info_scan_complete_valid_directories_found(
        scInstallPaths.length.toString(),
      );
      state = state.copyWith(
        scInstalledPath: scInstalledPath,
        scInstallPaths: scInstallPaths,
        lastScreenInfo: lastScreenInfo,
      );
    } catch (e) {
      state = state.copyWith(
        scInstalledPath: "not_install",
        lastScreenInfo: S.current.home_action_info_log_file_parse_fail,
      );
      AnalyticsApi.touch("error_launchLogs");
      // showToast(context!,
      //     "${S.current.home_action_info_log_file_parse_fail} \n请关闭游戏，退出RSI启动器后重试，若仍有问题，请使用工具箱中的 RSI Launcher log 修复。");
    }
  }

  String getRssImage(RssItem item) {
    final h = html.parse(item.description ?? "");
    if (h.body == null) return "";
    for (var node in h.body!.nodes) {
      if (node is html_dom.Element) {
        if (node.localName == "img") {
          return node.attributes["src"]?.trim() ?? "";
        }
      }
    }
    return "";
  }

  String handleTitle(String? title) {
    if (title == null) return "";
    title = title.replaceAll("【", "[ ");
    title = title.replaceAll("】", " ] ");
    return title;
  }

  // ignore: avoid_build_context_in_providers
  Future<void> goWebView(
    BuildContext context,
    String title,
    String url, {
    bool useLocalization = false,
    bool loginMode = false,
    RsiLoginCallback? rsiLoginCallback,
  }) async {
    if (useLocalization) {
      const tipVersion = 2;
      final box = await Hive.openBox("app_conf");
      final skip = await box.get("skip_web_localization_tip_version", defaultValue: 0);
      if (skip != tipVersion) {
        if (!context.mounted) return;
        final ok = await showConfirmDialogs(
          context,
          S.current.home_action_title_star_citizen_website_localization,
          Text(S.current.home_action_info_web_localization_plugin_disclaimer, style: const TextStyle(fontSize: 16)),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
        );
        if (!ok) {
          if (loginMode) {
            rsiLoginCallback?.call(null, false);
          }
          return;
        }
        await box.put("skip_web_localization_tip_version", tipVersion);
      }
    }
    if (!await WebviewWindow.isWebviewAvailable()) {
      if (!context.mounted) return;
      showToast(context, S.current.home_login_action_title_need_webview2_runtime);
      launchUrlString("https://developer.microsoft.com/en-us/microsoft-edge/webview2/");
      return;
    }
    if (!context.mounted) return;
    final webViewModel = WebViewModel(context, loginMode: loginMode, loginCallback: rsiLoginCallback);
    if (useLocalization) {
      state = state.copyWith(isFixing: true, isFixingString: S.current.home_action_info_initializing_resources);
      try {
        await webViewModel.initLocalization(state.webLocalizationVersionsData!);
      } catch (e) {
        if (!context.mounted) return;
        showToast(context, S.current.home_action_info_initialization_failed(e));
      }
      state = state.copyWith(isFixingString: "", isFixing: false);
    }
    await webViewModel.initWebView(
      title: title,
      applicationSupportDir: appGlobalState.applicationSupportDir!,
      appVersionData: appGlobalState.networkVersionData!,
    );

    await Future.delayed(const Duration(milliseconds: 500));
    await webViewModel.launch(url, appGlobalState.networkVersionData!);
  }

  bool isRSIServerStatusOK(Map map) {
    return (map["status"] == "ok" || map["status"] == "operational");
  }

  Timer? _serverUpdateTimer;
  Timer? _appUpdateTimer;

  void _init() {
    reScanPath();
    _serverUpdateTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _updateSCServerStatus();
    });

    _appUpdateTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      checkLocalizationUpdate();
    });

    ref.onDispose(() {
      _serverUpdateTimer?.cancel();
      _serverUpdateTimer = null;
      _appUpdateTimer?.cancel();
      _appUpdateTimer = null;
    });
  }

  void _loadData() async {
    if (appGlobalState.networkVersionData == null) return;
    try {
      final r = await Api.getAppPlacard();
      final box = await Hive.openBox("app_conf");
      final version = box.get("close_placard", defaultValue: "");
      if (r.enable == true) {
        if (r.alwaysShow != true && version == r.version) {
        } else {
          state = state.copyWith(appPlacardData: r);
        }
      }

      final appWebLocalizationVersionsData = AppWebLocalizationVersionsData.fromJson(
        json.decode((await RSHttp.getText("${URLConf.webTranslateHomeUrl}/versions.json"))),
      );
      final countdownFestivalListData = await Api.getFestivalCountdownList();
      state = state.copyWith(
        webLocalizationVersionsData: appWebLocalizationVersionsData,
        countdownFestivalListData: countdownFestivalListData,
      );
      _updateSCServerStatus();
      _loadRRS();
    } catch (e) {
      dPrint(e);
    }
    // check Localization update
    checkLocalizationUpdate();
  }

  Future<void> _updateSCServerStatus() async {
    try {
      final s = await Api.getScServerStatus();
      dPrint("updateSCServerStatus===$s");
      state = state.copyWith(scServerStatus: s);
    } catch (e) {
      dPrint(e);
    }
  }

  Future _loadRRS() async {
    try {
      final rssVideoItems = await RSSApi.getRssVideo();
      state = state.copyWith(rssVideoItems: rssVideoItems);
      final rssTextItems = await RSSApi.getRssText();
      state = state.copyWith(rssTextItems: rssTextItems);
      dPrint("RSS update Success !");
    } catch (e) {
      dPrint("_loadRRS Error:$e");
      // 避免持续显示 loading
      if (state.rssTextItems == null) {
        state = state.copyWith(rssTextItems: []);
      }
      if (state.rssVideoItems == null) {
        state = state.copyWith(rssVideoItems: []);
      }
    }
  }

  Future<void> checkLocalizationUpdate({bool skipReload = false}) async {
    dPrint("_checkLocalizationUpdate");
    final updates = await (ref.read(
      localizationUIModelProvider.notifier,
    )).checkLangUpdate(skipReload: skipReload).unwrap<List<String>>();
    if (updates == null || updates.isEmpty) {
      state = state.copyWith(localizationUpdateInfo: null);
      return;
    }
    state = state.copyWith(localizationUpdateInfo: MapEntry(updates.first, true));
    if (_appUpdateTimer != null) {
      _appUpdateTimer?.cancel();
      _appUpdateTimer = null;
      // 发送通知
      await win32.sendNotify(
        summary: S.current.home_localization_new_version_available,
        body: S.current.home_localization_new_version_installed(updates.first),
        appName: S.current.home_title_app_name,
        appId: ConstConf.win32AppId,
      );
    }
  }

  // ignore: avoid_build_context_in_providers
  Future<void> launchRSI(BuildContext context) async {
    if (state.scInstalledPath == "not_install") {
      showToast(context, S.current.home_info_valid_installation_required);
      return;
    }

    if (ConstConf.isMSE) {
      if (state.isCurGameRunning) {
        try {
          final pids = rust_system_info.getProcessIdsByName(processName: "StarCitizen");
          if (pids.isNotEmpty) {
            final pidList = pids.map((pid) => pid.toInt()).toList();
            rust_system_info.killProcessesByPids(pids: pidList);
          }
        } catch (e) {
          dPrint("Error killing StarCitizen processes: $e");
        }
        return;
      }
      AnalyticsApi.touch("gameLaunch");
      showDialog(context: context, dismissWithEsc: false, builder: (context) => HomeGameLoginDialogUI(context));
    } else {
      final ok = await showConfirmDialogs(
        context,
        S.current.home_info_one_click_launch_warning,
        Text(S.current.home_info_account_security_warning),
        confirm: S.current.home_action_install_microsoft_store_version,
        cancel: S.current.home_action_cancel,
      );
      if (ok == true) {
        await launchUrlString("https://apps.microsoft.com/detail/9NF3SWFWNKL1?launch=true");
        await Future.delayed(const Duration(seconds: 2));
        exit(0);
      }
    }
  }

  void onChangeInstallPath(String? value) {
    if (value == null) return;
    state = state.copyWith(scInstalledPath: value);
    ref.read(localizationUIModelProvider.notifier).onChangeGameInstallPath(value);
  }

  Future<void> doLaunchGame(
    // ignore: avoid_build_context_in_providers
    BuildContext context,
    String launchExe,
    List<String> args,
    String installPath,
    String? processorAffinity,
  ) async {
    var runningMap = Map<String, bool>.from(state.isGameRunning);
    runningMap[installPath] = true;
    state = state.copyWith(isGameRunning: runningMap);
    try {
      late ProcessResult result;
      if (processorAffinity == null) {
        result = await Process.run(launchExe, args);
      } else {
        dPrint("set Affinity === $processorAffinity launchExe === $launchExe");
        result = await Process.run("cmd.exe", [
          '/C',
          'Start',
          '"StarCitizen"',
          '/High',
          '/Affinity',
          processorAffinity,
          launchExe,
          ...args,
        ]);
      }
      dPrint('Exit code: ${result.exitCode}');
      dPrint('stdout: ${result.stdout}');
      dPrint('stderr: ${result.stderr}');

      if (result.exitCode != 0) {
        final logs = await SCLoggerHelper.getGameRunningLogs(installPath);
        MapEntry<String, String>? exitInfo;
        bool hasUrl = false;
        if (logs != null) {
          exitInfo = SCLoggerHelper.getGameRunningLogInfo(logs);
          if (exitInfo!.value.startsWith("https://")) {
            hasUrl = true;
          }
        }
        if (!context.mounted) return;
        // showToast(context,
        //     "游戏非正常退出\nexitCode=${result.exitCode}\nstdout=${result.stdout ?? ""}\nstderr=${result.stderr ?? ""}\n\n诊断信息：${exitInfo == null ? "未知错误，请通过一键诊断加群反馈。" : exitInfo.key} \n${hasUrl ? "请查看弹出的网页链接获得详细信息。" : exitInfo?.value ?? ""}");
        // S.current.home_action_info_abnormal_game_exit
        showToast(
          context,
          S.current.home_action_info_abnormal_game_exit(
            result.exitCode.toString(),
            result.stdout ?? "",
            result.stderr ?? "",
            exitInfo == null ? S.current.home_action_info_unknown_error : exitInfo.key,
            hasUrl ? S.current.home_action_info_check_web_link : exitInfo?.value ?? "",
          ),
        );
        if (hasUrl) {
          await Future.delayed(const Duration(seconds: 3));
          launchUrlString(exitInfo!.value);
        }
      }

      final launchFile = File("$installPath\\loginData.json");
      if (await launchFile.exists()) {
        await launchFile.delete();
      }
    } catch (_) {}
    runningMap = Map<String, bool>.from(state.isGameRunning);
    runningMap[installPath] = false;
    state = state.copyWith(isGameRunning: runningMap);
  }
}
