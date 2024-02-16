import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_rss/dart_rss.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:hive/hive.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/api/rss.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/data/app_placard_data.dart';
import 'package:starcitizen_doctor/data/app_web_localization_versions_data.dart';
import 'package:starcitizen_doctor/data/countdown_festival_item_data.dart';
import 'package:starcitizen_doctor/ui/home/countdown/countdown_dialog_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/md_content_dialog_ui.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/md_content_dialog_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/localization/localization_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/login/login_dialog_ui.dart';
import 'package:starcitizen_doctor/ui/home/login/login_dialog_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/performance/performance_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/webview/webview.dart';
import 'package:starcitizen_doctor/ui/home/webview/webview_localization_capture_ui_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as html_dom;
import 'package:windows_ui/windows_ui.dart';

import 'countdown/countdown_dialog_ui.dart';
import 'game_doctor/game_doctor_ui.dart';
import 'game_doctor/game_doctor_ui_model.dart';
import 'localization/localization_ui.dart';
import 'performance/performance_ui.dart';
import 'webview/webview_localization_capture_ui.dart';

class HomeUIModel extends BaseUIModel {
  var scInstalledPath = "not_install";

  List<String> scInstallPaths = [];

  String lastScreenInfo = "";

  bool isFixing = false;
  String isFixingString = "";

  final Map<String, bool> _isGameRunning = {};

  bool get isCurGameRunning => _isGameRunning[scInstalledPath] ?? false;

  List<RssItem>? rssVideoItems;
  List<RssItem>? rssTextItems;

  AppWebLocalizationVersionsData? appWebLocalizationVersionsData;

  List<CountdownFestivalItemData>? countdownFestivalListData;

  MapEntry<String, bool>? localizationUpdateInfo;

  bool _isSendLocalizationUpdateNotification = false;

  AppPlacardData? appPlacardData;

  List? scServerStatus;

  Timer? serverUpdateTimer;
  Timer? appUpdateTimer;

  final statusCnName = const {
    "Platform": "平台",
    "Persistent Universe": "持续宇宙",
    "Electronic Access": "电子访问",
    "Arena Commander": "竞技场指挥官"
  };

  bool isRsiLauncherStarting = false;

  @override
  Future loadData() async {
    if (AppConf.networkVersionData == null) return;
    try {
      final r = await Api.getAppPlacard();
      final box = await Hive.openBox("app_conf");
      final version = box.get("close_placard", defaultValue: "");
      if (r.enable == true) {
        if (r.alwaysShow != true && version == r.version) {
        } else {
          appPlacardData = r;
        }
      }
      updateSCServerStatus();
      notifyListeners();
      appWebLocalizationVersionsData = AppWebLocalizationVersionsData.fromJson(
          json.decode((await RSHttp.getText(
              "${URLConf.webTranslateHomeUrl}/versions.json"))));
      countdownFestivalListData = await Api.getFestivalCountdownList();
      notifyListeners();
      _loadRRS();
    } catch (e) {
      dPrint(e);
    }
    // check Localization update
    _checkLocalizationUpdate();
    notifyListeners();
  }

  @override
  void initModel() {
    reScanPath();
    serverUpdateTimer = Timer.periodic(
      const Duration(minutes: 10),
      (timer) {
        updateSCServerStatus();
      },
    );

    appUpdateTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      _checkLocalizationUpdate();
    });
    super.initModel();
  }

  @override
  void dispose() {
    serverUpdateTimer?.cancel();
    serverUpdateTimer = null;
    appUpdateTimer?.cancel();
    appUpdateTimer = null;
    super.dispose();
  }

  Future<void> reScanPath() async {
    scInstallPaths.clear();
    scInstalledPath = "not_install";
    lastScreenInfo = "正在扫描 ...";
    try {
      final listData = await SCLoggerHelper.getLauncherLogList();
      if (listData == null) {
        lastScreenInfo = "获取log失败！";
        return;
      }
      scInstallPaths = await SCLoggerHelper.getGameInstallPath(listData,
          withVersion: ["LIVE", "PTU", "EPTU"], checkExists: true);
      if (scInstallPaths.isNotEmpty) {
        scInstalledPath = scInstallPaths.first;
      }
      lastScreenInfo = "扫描完毕，共找到 ${scInstallPaths.length} 个有效安装目录";
    } catch (e) {
      lastScreenInfo = "解析 log 文件失败！";
      AnalyticsApi.touch("error_launchLogs");
      showToast(context!,
          "解析 log 文件失败！ \n请关闭游戏，退出RSI启动器后重试，若仍有问题，请使用工具箱中的 RSI Launcher log 修复。");
    }
  }

  updateSCServerStatus() async {
    try {
      final s = await Api.getScServerStatus();
      dPrint("updateSCServerStatus===$s");
      scServerStatus = s;
      notifyListeners();
    } catch (e) {
      dPrint(e);
    }
  }

  Future _loadRRS() async {
    try {
      final v = await RSSApi.getRssVideo();
      rssVideoItems = v;
      notifyListeners();
      final t = await RSSApi.getRssText();
      rssTextItems = t;
      notifyListeners();
      dPrint("RSS update Success !");
    } catch (e) {
      dPrint("_loadRRS Error:$e");
    }
  }

  openDir(rsiLauncherInstalledPath) async {
    await Process.run(SystemHelper.powershellPath,
        ["explorer.exe", "/select,\"$rsiLauncherInstalledPath\""]);
  }

  onMenuTap(String key) async {
    const String gameInstallReqInfo =
        "该功能需要一个有效的安装位置\n\n如果您的游戏未下载完成，请等待下载完毕后使用此功能。\n\n如果您的游戏已下载完毕但未识别，请启动一次游戏后重新打开盒子 或 在设置选项中手动设置安装位置。";
    switch (key) {
      case "auto_check":
        BaseUIContainer(
                uiCreate: () => GameDoctorUI(),
                modelCreate: () => GameDoctorUIModel(scInstalledPath))
            .push(context!);
        return;
      case "localization":
        if (scInstalledPath == "not_install") {
          showToast(context!, gameInstallReqInfo);
          return;
        }
        await showDialog(
            context: context!,
            dismissWithEsc: false,
            builder: (BuildContext context) {
              return BaseUIContainer(
                  uiCreate: () => LocalizationUI(),
                  modelCreate: () => LocalizationUIModel(scInstalledPath));
            });
        _checkLocalizationUpdate();
        return;
      case "performance":
        if (scInstalledPath == "not_install") {
          showToast(context!, gameInstallReqInfo);
          return;
        }
        AnalyticsApi.touch("performance_launch");
        BaseUIContainer(
                uiCreate: () => PerformanceUI(),
                modelCreate: () => PerformanceUIModel(scInstalledPath))
            .push(context!);
        return;
    }
  }

  showPlacard() {
    switch (appPlacardData?.linkType) {
      case "external":
        launchUrlString(appPlacardData?.link);
        return;
      case "doc":
        showDialog(
            context: context!,
            builder: (context) {
              return BaseUIContainer(
                  uiCreate: () => MDContentDialogUI(),
                  modelCreate: () => MDContentDialogUIModel(
                      appPlacardData?.title ?? "公告详情", appPlacardData?.link));
            });
        return;
    }
  }

  closePlacard() async {
    final box = await Hive.openBox("app_conf");
    await box.put("close_placard", appPlacardData?.version);
    appPlacardData = null;
    notifyListeners();
  }

  goWebView(String title, String url,
      {bool useLocalization = false,
      bool loginMode = false,
      RsiLoginCallback? rsiLoginCallback}) async {
    if (useLocalization) {
      const tipVersion = 2;
      final box = await Hive.openBox("app_conf");
      final skip =
          await box.get("skip_web_localization_tip_version", defaultValue: 0);
      if (skip != tipVersion) {
        final ok = await showConfirmDialogs(
            context!,
            "星际公民网站汉化",
            const Text(
              "本插功能件仅供大致浏览使用，不对任何有关本功能产生的问题负责！在涉及账号操作前请注意确认网站的原本内容！"
              "\n\n\n使用此功能登录账号时请确保您的 SC汉化盒子 是从可信任的来源下载。",
              style: TextStyle(fontSize: 16),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context!).size.width * .6));
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
      showToast(context!, "需要安装 WebView2 Runtime");
      launchUrlString(
          "https://developer.microsoft.com/en-us/microsoft-edge/webview2/");
      return;
    }
    final webViewModel = WebViewModel(context!,
        loginMode: loginMode, loginCallback: rsiLoginCallback);
    if (useLocalization) {
      isFixingString = "正在初始化汉化资源...";
      isFixing = true;
      notifyListeners();
      try {
        await webViewModel.initLocalization(appWebLocalizationVersionsData!);
      } catch (e) {
        showToast(context!, "初始化网页汉化资源失败！$e");
      }
      isFixingString = "";
      isFixing = false;
    }
    await webViewModel.initWebView(
      title: title,
    );
    if (await File(
            "${AppConf.applicationSupportDir}\\webview_data\\enable_webview_localization_capture")
        .exists()) {
      webViewModel.enableCapture = true;
      BaseUIContainer(
              uiCreate: () => WebviewLocalizationCaptureUI(),
              modelCreate: () =>
                  WebviewLocalizationCaptureUIModel(webViewModel))
          .push(context!)
          .then((_) {
        webViewModel.enableCapture = false;
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
    await webViewModel.launch(url);
    notifyListeners();
  }

  launchRSI() async {
    if (scInstalledPath == "not_install") {
      showToast(context!, "该功能需要一个有效的安装位置");
      return;
    }

    if (AppConf.isMSE) {
      if (isCurGameRunning) {
        await Process.run(
            SystemHelper.powershellPath, ["ps \"StarCitizen\" | kill"]);
        return;
      }
      AnalyticsApi.touch("gameLaunch");
      showDialog(
          context: context!,
          dismissWithEsc: false,
          builder: (context) {
            return BaseUIContainer(
                uiCreate: () => LoginDialog(),
                modelCreate: () => LoginDialogModel(scInstalledPath, this));
          });
    } else {
      final ok = await showConfirmDialogs(
          context!,
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

  bool isRSIServerStatusOK(Map map) {
    return (map["status"] == "ok" || map["status"] == "operational");
  }

  doLaunchGame(String launchExe, List<String> args, String installPath,
      String? processorAffinity) async {
    _isGameRunning[installPath] = true;
    notifyListeners();
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
        final logs = await SCLoggerHelper.getGameRunningLogs(scInstalledPath);
        MapEntry<String, String>? exitInfo;
        bool hasUrl = false;
        if (logs != null) {
          exitInfo = SCLoggerHelper.getGameRunningLogInfo(logs);
          if (exitInfo!.value.startsWith("https://")) {
            hasUrl = true;
          }
        }
        showToast(context!,
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
    _isGameRunning[installPath] = false;
    notifyListeners();
  }

  onTapFestival() {
    if (countdownFestivalListData == null) return;
    showDialog(
        context: context!,
        builder: (context) {
          return BaseUIContainer(
              uiCreate: () => CountdownDialogUI(),
              modelCreate: () =>
                  CountdownDialogUIModel(countdownFestivalListData!));
        });
  }

  getRssImage(RssItem item) {
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

  handleTitle(String? title) {
    if (title == null) return "";
    title = title.replaceAll("【", "[ ");
    title = title.replaceAll("】", " ] ");
    return title;
  }

  Future<void> _checkLocalizationUpdate() async {
    final info = await handleError(
        () => LocalizationUIModel.checkLocalizationUpdates(scInstallPaths));
    dPrint("lUpdateInfo === $info");
    localizationUpdateInfo = info;
    notifyListeners();

    if (info?.value == true && !_isSendLocalizationUpdateNotification) {
      final toastNotifier =
          ToastNotificationManager.createToastNotifierWithId("SC汉化盒子");
      if (toastNotifier != null) {
        final toastContent = ToastNotificationManager.getTemplateContent(
            ToastTemplateType.toastText02);
        if (toastContent != null) {
          final xmlNodeList = toastContent.getElementsByTagName('text');
          const title = '汉化有新版本！';
          final content = '您在 ${info?.key} 安装的汉化有新版本啦！';
          xmlNodeList.item(0)?.appendChild(toastContent.createTextNode(title));
          xmlNodeList
              .item(1)
              ?.appendChild(toastContent.createTextNode(content));
          final toastNotification =
              ToastNotification.createToastNotification(toastContent);
          toastNotifier.show(toastNotification);
          _isSendLocalizationUpdateNotification = true;
        }
      }
    }
  }
}
