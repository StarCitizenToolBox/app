import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_rss/domain/rss_item.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/api/rss.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
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

part 'home_ui_model.freezed.dart';

part 'home_ui_model.g.dart';

@freezed
class HomeUIModelState with _$HomeUIModelState {
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

  closePlacard() async {
    final box = await Hive.openBox("app_conf");
    await box.put("close_placard", state.appPlacardData?.version);
    state = state.copyWith(appPlacardData: null);
  }

  Future<void> reScanPath() async {
    state = state.copyWith(
        scInstalledPath: "not_install", lastScreenInfo: "正在扫描 ...");
    try {
      final listData = await SCLoggerHelper.getLauncherLogList();
      if (listData == null) {
        state = state.copyWith(scInstalledPath: "not_install");
        return;
      }
      final scInstallPaths = await SCLoggerHelper.getGameInstallPath(listData,
          withVersion: ["LIVE", "PTU", "EPTU"], checkExists: true);
      String? scInstalledPath;
      if (scInstallPaths.isNotEmpty) {
        scInstalledPath = scInstallPaths.first;
      }
      final lastScreenInfo = "扫描完毕，共找到 ${scInstallPaths.length} 个有效安装目录";
      state = state.copyWith(
          scInstalledPath: scInstalledPath,
          scInstallPaths: scInstallPaths,
          lastScreenInfo: lastScreenInfo);
    } catch (e) {
      state = state.copyWith(
          scInstalledPath: "not_install", lastScreenInfo: "解析 log 文件失败！");
      AnalyticsApi.touch("error_launchLogs");
      // showToast(context!,
      //     "解析 log 文件失败！ \n请关闭游戏，退出RSI启动器后重试，若仍有问题，请使用工具箱中的 RSI Launcher log 修复。");
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

  onMenuTap(String key) {}

  // ignore: avoid_build_context_in_providers
  Future<void> goWebView(BuildContext context, String title, String url,
      {bool useLocalization = false,
      bool loginMode = false,
      RsiLoginCallback? rsiLoginCallback}) async {
    if (useLocalization) {
      const tipVersion = 2;
      final box = await Hive.openBox("app_conf");
      final skip =
          await box.get("skip_web_localization_tip_version", defaultValue: 0);
      if (skip != tipVersion) {
        if (!context.mounted) return;
        final ok = await showConfirmDialogs(
            context,
            "星际公民网站汉化",
            const Text(
              "本插功能件仅供大致浏览使用，不对任何有关本功能产生的问题负责！在涉及账号操作前请注意确认网站的原本内容！"
              "\n\n\n使用此功能登录账号时请确保您的 SC汉化盒子 是从可信任的来源下载。",
              style: TextStyle(fontSize: 16),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6));
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
      showToast(context, "需要安装 WebView2 Runtime");
      launchUrlString(
          "https://developer.microsoft.com/en-us/microsoft-edge/webview2/");
      return;
    }
    if (!context.mounted) return;
    final webViewModel = WebViewModel(context,
        loginMode: loginMode, loginCallback: rsiLoginCallback);
    if (useLocalization) {
      state = state.copyWith(isFixing: true, isFixingString: "正在初始化汉化资源...");
      try {
        await webViewModel.initLocalization(state.webLocalizationVersionsData!);
      } catch (e) {
        if (!context.mounted) return;
        showToast(context, "初始化网页汉化资源失败！$e");
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
    _serverUpdateTimer = Timer.periodic(
      const Duration(minutes: 10),
      (timer) {
        _updateSCServerStatus();
      },
    );

    _appUpdateTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      _checkLocalizationUpdate();
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

      final appWebLocalizationVersionsData =
          AppWebLocalizationVersionsData.fromJson(json.decode(
              (await RSHttp.getText(
                  "${URLConf.webTranslateHomeUrl}/versions.json"))));
      final countdownFestivalListData = await Api.getFestivalCountdownList();
      state = state.copyWith(
          webLocalizationVersionsData: appWebLocalizationVersionsData,
          countdownFestivalListData: countdownFestivalListData);
      _updateSCServerStatus();
      _loadRRS();
    } catch (e) {
      dPrint(e);
    }
    // check Localization update
    _checkLocalizationUpdate();
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
      final rssTextItems = await RSSApi.getRssText();
      state = state.copyWith(
          rssVideoItems: rssVideoItems, rssTextItems: rssTextItems);
      dPrint("RSS update Success !");
    } catch (e) {
      dPrint("_loadRRS Error:$e");
    }
  }

  void _checkLocalizationUpdate() {}

  // ignore: avoid_build_context_in_providers
  launchRSI(BuildContext context) async {
    if (state.scInstalledPath == "not_install") {
      showToast(context, "该功能需要一个有效的安装位置");
      return;
    }

    if (ConstConf.isMSE) {
      if (state.isCurGameRunning) {
        await Process.run(
            SystemHelper.powershellPath, ["ps \"StarCitizen\" | kill"]);
        return;
      }
      AnalyticsApi.touch("gameLaunch");
      showDialog(
          context: context,
          dismissWithEsc: false,
          builder: (context) => const HomeGameLoginDialogUI());
    } else {
      final ok = await showConfirmDialogs(
          context,
          "一键启动功能提示",
          const Text("为确保账户安全，一键启动功能已在开发版中禁用，我们将在微软商店版本中提供此功能。"
              "\n\n微软商店版由微软提供可靠的分发下载与数字签名，可有效防止软件被恶意篡改。\n\n提示：您无需使用盒子启动游戏也可使用汉化。"),
          confirm: "安装微软商店版本",
          cancel: "取消");
      if (ok == true) {
        await launchUrlString(
            "https://apps.microsoft.com/detail/9NF3SWFWNKL1?launch=true");
        await Future.delayed(const Duration(seconds: 2));
        exit(0);
      }
    }
  }

  void onChangeInstallPath(String? value) {
    if (value == null) return;
    state = state.copyWith(scInstalledPath: value);
  }

  doLaunchGame(
      // ignore: avoid_build_context_in_providers
      BuildContext context,
      String launchExe,
      List<String> args,
      String installPath,
      String? processorAffinity) async {
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
          ...args
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
        showToast(context,
            "游戏非正常退出\nexitCode=${result.exitCode}\nstdout=${result.stdout ?? ""}\nstderr=${result.stderr ?? ""}\n\n诊断信息：${exitInfo == null ? "未知错误，请通过一键诊断加群反馈。" : exitInfo.key} \n${hasUrl ? "请查看弹出的网页链接获得详细信息。" : exitInfo?.value ?? ""}");
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
