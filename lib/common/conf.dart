import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/data/app_version_data.dart';
import 'package:window_manager/window_manager.dart';

import '../base/ui.dart';

class AppConf {
  static const String appVersion = "2.9.2 Beta";
  static const int appVersionCode = 15;
  static const String appVersionDate = "2023-10-12";

  static const String gitlabHomeUrl =
      "https://jihulab.com/StarCitizenCN_Community/StarCitizenDoctor";
  static const String gitlabLocalizationUrl =
      "https://jihulab.com/StarCitizenCN_Community/LocalizationData";
  static const String apiRepoPath =
      "https://jihulab.com/StarCitizenCN_Community/api/-/raw/main/";
  static const String gitlabApiPath = "https://jihulab.com/api/v4/";

  static late final String applicationSupportDir;

  static AppVersionData? networkVersionData;

  static bool offlineMode = false;

  static late final WindowsDeviceInfo windowsDeviceInfo;

  static init() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// init device info
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    windowsDeviceInfo = await deviceInfo.windowsInfo;

    /// init Data
    applicationSupportDir =
        (await getApplicationSupportDirectory()).absolute.path;
    dPrint("applicationSupportDir == $applicationSupportDir");
    try {
      Hive.init("$applicationSupportDir/db");
      await Hive.openBox("app_conf");
    } catch (e) {
      exit(1);
    }

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
  }

  static String getUpgradePath() {
    return "${AppConf.applicationSupportDir}/._upgrade";
  }

  static Future<void> _checkUpdate() async {
    // clean path
    final dir = Directory(getUpgradePath());
    if (await dir.exists()) {
      dir.delete(recursive: true);
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
