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
import 'localization/localization_ui.dart';
import 'performance/performance_ui.dart';
import 'webview/webview_localization_capture_ui.dart';

class HomeUIModel extends BaseUIModel {
  var scInstalledPath = "not_install";

  List<String> scInstallPaths = [];

  String _lastScreenInfo = "";

  String get lastScreenInfo => _lastScreenInfo;

  bool isChecking = false;

  bool isFixing = false;
  String isFixingString = "";

  final Map<String, bool> _isGameRunning = {};

  bool get isCurGameRunning => _isGameRunning[scInstalledPath] ?? false;

  List<RssItem>? rssVideoItems;
  List<RssItem>? rssTextItems;

  set lastScreenInfo(String info) {
    _lastScreenInfo = info;
    notifyListeners();
  }

  List<MapEntry<String, String>>? checkResult;

  AppWebLocalizationVersionsData? appWebLocalizationVersionsData;

  List<CountdownFestivalItemData>? countdownFestivalListData;

  MapEntry<String, bool>? localizationUpdateInfo;

  bool _isSendLocalizationUpdateNotification = false;

  final cnExp = RegExp(r"[^\x00-\xff]");

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
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (URLConf.isUsingFallback) {
        if (!mounted) return;
        showToast(context!, "因源服务器异常（机房故障或遭受攻击），当前正在使用备用线路，可能会出现访问速度下降，敬请谅解。");
      }
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
    await _checkPreInstall();
    await _checkEAC();
    // TODO for debug
    // checkResult?.add(const MapEntry("unSupport_system", "android"));
    // checkResult?.add(const MapEntry("nvme_PhysicalBytes", "c"));
    // checkResult?.add(const MapEntry("no_live_path", ""));

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

  void resetCheck() {
    checkResult = null;
    reScanPath();
    notifyListeners();
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

  openDir(rsiLauncherInstalledPath) async {
    await Process.run(SystemHelper.powershellPath,
        ["explorer.exe", "/select,\"$rsiLauncherInstalledPath\""]);
  }

  onMenuTap(String key) async {
    switch (key) {
      case "auto_check":
        doCheck()?.call();
        return;
      case "localization":
        if (scInstalledPath == "not_install") {
          showToast(context!, "该功能需要一个有效的安装位置");
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
          showToast(context!, "该功能需要一个有效的安装位置");
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
        showToast(context!,
            "游戏非正常退出\nexitCode=${result.exitCode}\nstdout=${result.stdout}\nstderr=${result.stderr}");
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
