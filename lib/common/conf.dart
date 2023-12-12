import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/rust/ffi.dart';
import 'package:starcitizen_doctor/data/app_version_data.dart';
import 'package:starcitizen_doctor/global_ui_model.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';

import '../base/ui.dart';

class AppConf {
  static const String appVersion = "2.10.0+1 Beta";
  static const int appVersionCode = 35;
  static const String appVersionDate = "2023-12-06";

  static const String giteaAttachmentsUrl =
      "https://git.sctoolbox.sccsgo.com/SCToolBox/Release";
  static const String gitlabLocalizationUrl =
      "https://git.sctoolbox.sccsgo.com/SCToolBox/LocalizationData";
  static const String apiRepoPath =
      "https://git.sctoolbox.sccsgo.com/SCToolBox/api/raw/branch/main/";

  static const String gitlabApiPath =
      "https://git.sctoolbox.sccsgo.com/api/v1/";

  static const String webTranslateHomeUrl =
      "https://git.sctoolbox.sccsgo.com/SCToolBox/ScWeb_Chinese_Translate/raw/branch/main/json/locales";

  static const String xkeycApiUrl = "https://sctoolbox.xkeyc.com";

  static const _rssHomeUrl = "https://rss.sctoolbox.sccsgo.com";

  static const rssVideoUrl =
      "$_rssHomeUrl/bilibili/user/channel/27976358/290653";

  static const rssTextUrl1 = "$_rssHomeUrl/bilibili/user/article/40102960";
  static const rssTextUrl2 =
      "$_rssHomeUrl/baidu/tieba/user/%E7%81%AC%E7%81%ACG%E7%81%AC%E7%81%AC&";

  static const gameChannels = ["LIVE", "PTU", "EPTU"];

  static late final String applicationSupportDir;

  static AppVersionData? networkVersionData;

  static bool offlineMode = false;

  static late final WindowsDeviceInfo windowsDeviceInfo;

  static Color? colorBackground;
  static Color? colorMenu;
  static Color? colorMica;

  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";

  static init(List<String> args) async {
    dPrint("launch args == $args");
    WidgetsFlutterBinding.ensureInitialized();

    /// init device info
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      windowsDeviceInfo = await deviceInfo.windowsInfo;
    } catch (_) {}

    /// init Data
    applicationSupportDir =
        (await getApplicationSupportDirectory()).absolute.path;
    dPrint("applicationSupportDir == $applicationSupportDir");
    try {
      Hive.init("$applicationSupportDir/db");
      final box = await Hive.openBox("app_conf");
      if (box.get("install_id", defaultValue: "") == "") {
        await box.put("install_id", const Uuid().v4());
        AnalyticsApi.touch("firstLaunch");
      }
    } catch (e) {
      exit(1);
    }

    /// check Rust bridge
    if (await rustFii.ping() != "PONG") {
      dPrint("Rust bridge Error");
      exit(1);
    }
    dPrint("---- rust bridge inited -----");
    await SystemHelper.initPowershellPath();

    /// init defaultColor
    colorBackground = HexColor("#132431").withOpacity(.75);
    colorMenu = HexColor("#132431").withOpacity(.95);
    colorMica = HexColor("#0A3142");

    /// init windows
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setSize(const Size(1280, 810));
      await windowManager.setMinimumSize(const Size(1280, 810));
      await windowManager.center(animate: true);
      await windowManager.setSkipTaskbar(false);
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.show();
      await Window.initialize();
      await Window.hideWindowControls();
      if (windowsDeviceInfo.productName.contains("Windows 11")) {
        await Window.setEffect(
          effect: WindowEffect.acrylic,
        );
      }
    });
    await checkUpdate();
    AnalyticsApi.touch("launch");
  }

  static String getUpgradePath() {
    return "${AppConf.applicationSupportDir}/._upgrade";
  }

  static Future<void> checkUpdate() async {
    // clean path
    if (!isMSE) {
      final dir = Directory(getUpgradePath());
      if (await dir.exists()) {
        dir.delete(recursive: true);
      }
    }
    try {
      networkVersionData = await Api.getAppVersion();
      globalUIModel.checkActivityThemeColor();
      if (isMSE) {
        dPrint(
            "lastVersion=${networkVersionData?.mSELastVersion}  ${networkVersionData?.mSELastVersionCode}");
      } else {
        dPrint(
            "lastVersion=${networkVersionData?.lastVersion}  ${networkVersionData?.lastVersionCode}");
      }
    } catch (e) {
      dPrint("_checkUpdate Error:$e");
    }
  }
}
