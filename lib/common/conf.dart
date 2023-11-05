import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/rust/ffi.dart';
import 'package:starcitizen_doctor/data/app_version_data.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';

import '../base/ui.dart';

class AppConf {
  static const String appVersion = "2.9.8 Beta";
  static const int appVersionCode = 24;
  static const String appVersionDate = "2023-11-03";

  static const String gitlabHomeUrl =
      "https://jihulab.com/StarCitizenCN_Community/StarCitizenDoctor";
  static const String gitlabLocalizationUrl =
      "https://jihulab.com/StarCitizenCN_Community/LocalizationData";
  static const String apiRepoPath =
      "https://jihulab.com/StarCitizenCN_Community/api/-/raw/main/";
  static const String gitlabApiPath = "https://jihulab.com/api/v4/";

  static const String webTranslateHomeUrl =
      "https://jihulab.com/StarCitizenCN_Community/scweb_chinese_translate/-/raw/main/json/locales";

  static const String xkeycApiUrl = "https://sctoolbox.xkeyc.com";

  static late final String applicationSupportDir;

  static AppVersionData? networkVersionData;

  static bool offlineMode = false;

  static late final WindowsDeviceInfo windowsDeviceInfo;

  static const isMSE =
      String.fromEnvironment("MSE", defaultValue: "false") == "true";

  static init() async {
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

    /// init windows
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setSize(const Size(1280, 820));
      await windowManager.setMinimumSize(const Size(1280, 820));
      await windowManager.center(animate: true);
      await windowManager.setSkipTaskbar(false);
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.show();
      await Window.initialize();
      if (windowsDeviceInfo.productName.contains("Windows 11")) {
        await Window.setEffect(
          effect: WindowEffect.acrylic,
        );
      }
      await Window.hideWindowControls();
    });
    await _checkUpdate();
    AnalyticsApi.touch("launch");
  }

  static String getUpgradePath() {
    return "${AppConf.applicationSupportDir}/._upgrade";
  }

  static Future<void> _checkUpdate() async {
    // clean path
    if (!isMSE) {
      final dir = Directory(getUpgradePath());
      if (await dir.exists()) {
        dir.delete(recursive: true);
      }
    }
    try {
      networkVersionData = await Api.getAppVersion();
      dPrint(
          "lastVersion=${networkVersionData?.lastVersion}  ${networkVersionData?.lastVersionCode}");
    } catch (e) {
      dPrint("_checkUpdate Error:$e");
    }
  }
}
