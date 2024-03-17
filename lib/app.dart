import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/ui/home/performance/performance_ui.dart';
import 'package:starcitizen_doctor/ui/splash_ui.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';

import 'api/analytics.dart';
import 'api/api.dart';
import 'common/helper/system_helper.dart';
import 'common/io/rs_http.dart';
import 'common/rust/frb_generated.dart';
import 'data/app_version_data.dart';
import 'generated/no_l10n_strings.dart';
import 'ui/home/downloader/home_downloader_ui.dart';
import 'ui/home/game_doctor/game_doctor_ui.dart';
import 'ui/index_ui.dart';
import 'ui/settings/upgrade_dialog.dart';

part 'app.g.dart';

part 'app.freezed.dart';

@freezed
class AppGlobalState with _$AppGlobalState {
  const factory AppGlobalState({
    String? deviceUUID,
    String? applicationSupportDir,
    String? applicationBinaryModuleDir,
    AppVersionData? networkVersionData,
    @Default(ThemeConf()) ThemeConf themeConf,
    Locale? appLocale,
  }) = _AppGlobalState;
}

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            myPageBuilder(context, state, const SplashUI()),
      ),
      GoRoute(
        path: '/index',
        pageBuilder: (context, state) =>
            myPageBuilder(context, state, const IndexUI()),
        routes: [
          GoRoute(
              path: "downloader",
              pageBuilder: (context, state) =>
                  myPageBuilder(context, state, const HomeDownloaderUI())),
          GoRoute(
            path: 'game_doctor',
            pageBuilder: (context, state) =>
                myPageBuilder(context, state, const HomeGameDoctorUI()),
          ),
          GoRoute(
            path: 'performance',
            pageBuilder: (context, state) =>
                myPageBuilder(context, state, const HomePerformanceUI()),
          ),
        ],
      ),
    ],
  );
}

@riverpod
class AppGlobalModel extends _$AppGlobalModel {
  static Map<Locale, String> get appLocaleSupport => {
        const Locale("auto"): S.current.settings_app_language_auto,
        const Locale("zh", "CN"): NoL10n.langZHS,
        const Locale("zh", "TW"): NoL10n.langZHT,
        const Locale("en"): NoL10n.langEn,
      };

  @override
  AppGlobalState build() {
    return const AppGlobalState();
  }

  bool _initialized = false;

  Future<void> initApp() async {
    if (_initialized) return;
    // init Data
    final userProfileDir = Platform.environment["USERPROFILE"];
    final applicationSupportDir =
        (await getApplicationSupportDirectory()).absolute.path;
    String? applicationBinaryModuleDir;
    final logFile = File(
        "$applicationSupportDir\\logs\\${DateTime.now().millisecondsSinceEpoch}.log");
    await logFile.create(recursive: true);
    setDPrintFile(logFile);
    if (ConstConf.isMSE && userProfileDir != null) {
      applicationBinaryModuleDir =
          "$userProfileDir\\AppData\\Local\\Temp\\SCToolbox\\modules";
    } else {
      applicationBinaryModuleDir = "$applicationSupportDir\\modules";
    }
    dPrint("applicationSupportDir == $applicationSupportDir");
    dPrint("applicationBinaryModuleDir == $applicationBinaryModuleDir");
    state = state.copyWith(
      applicationSupportDir: applicationSupportDir,
      applicationBinaryModuleDir: applicationBinaryModuleDir,
    );

    // init Hive
    try {
      Hive.init("$applicationSupportDir/db");
      final box = await Hive.openBox("app_conf");
      if (box.get("install_id", defaultValue: "") == "") {
        await box.put("install_id", const Uuid().v4());
        AnalyticsApi.touch("firstLaunch");
      }
      final deviceUUID = box.get("install_id", defaultValue: "");
      final localeCode = box.get("app_locale", defaultValue: null);
      Locale? locale;
      if (localeCode != null) {
        final localeSplit = localeCode.toString().split("_");
        if (localeSplit.length == 2 && localeSplit[1].isNotEmpty) {
          locale = Locale(localeSplit[0], localeSplit[1]);
        } else {
          locale = Locale(localeSplit[0]);
        }
      }
      state = state.copyWith(deviceUUID: deviceUUID, appLocale: locale);
    } catch (e) {
      exit(1);
    }

    // init Rust bridge
    await RustLib.init();
    await RSHttp.init();
    dPrint("---- rust bridge inited -----");

    // init powershell
    await SystemHelper.initPowershellPath();

    // get windows info
    WindowsDeviceInfo? windowsDeviceInfo;
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      windowsDeviceInfo = await deviceInfo.windowsInfo;
    } catch (e) {
      dPrint("DeviceInfo.windowsInfo error: $e");
    }

    // init windows

    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setSize(const Size(1280, 810));
      await windowManager.setMinimumSize(const Size(1280, 810));
      await windowManager.setSkipTaskbar(false);
      await windowManager.show();
      await Window.initialize();
      await Window.hideWindowControls();
      if (windowsDeviceInfo?.productName.contains("Windows 11") ?? false) {
        await Window.setEffect(
          effect: WindowEffect.acrylic,
        );
      }
    });

    _initialized = true;
    ref.keepAlive();
  }

  String getUpgradePath() {
    return "${state.applicationSupportDir}/._upgrade";
  }

  // ignore: avoid_build_context_in_providers
  Future<bool> checkUpdate(BuildContext context) async {
    if (!ConstConf.isMSE) {
      final dir = Directory(getUpgradePath());
      if (await dir.exists()) {
        dir.delete(recursive: true);
      }
    }

    dynamic checkUpdateError;

    try {
      final networkVersionData = await Api.getAppVersion();
      checkActivityThemeColor(networkVersionData);
      if (ConstConf.isMSE) {
        dPrint(
            "lastVersion=${networkVersionData.mSELastVersion}  ${networkVersionData.mSELastVersionCode}");
      } else {
        dPrint(
            "lastVersion=${networkVersionData.lastVersion}  ${networkVersionData.lastVersionCode}");
      }
      state = state.copyWith(networkVersionData: networkVersionData);
    } catch (e) {
      checkUpdateError = e;
      dPrint("_checkUpdate Error:$e");
    }

    await Future.delayed(const Duration(milliseconds: 100));
    if (state.networkVersionData == null) {
      if (!context.mounted) return false;
      await showToast(
          context,
          S.current.app_common_network_error(
              ConstConf.appVersionDate, checkUpdateError.toString()));
      return false;
    }
    final lastVersion = ConstConf.isMSE
        ? state.networkVersionData?.mSELastVersionCode
        : state.networkVersionData?.lastVersionCode;
    if ((lastVersion ?? 0) > ConstConf.appVersionCode) {
      // need update
      if (!context.mounted) return false;

      final r = await showDialog(
          dismissWithEsc: false,
          context: context,
          builder: (context) => const UpgradeDialogUI());

      if (r != true) {
        if (!context.mounted) return false;
        await showToast(context, S.current.app_common_upgrade_info_error);
        return false;
      }
      return true;
    }
    return false;
  }

  Timer? _activityThemeColorTimer;

  checkActivityThemeColor(AppVersionData networkVersionData) {
    if (_activityThemeColorTimer != null) {
      _activityThemeColorTimer?.cancel();
      _activityThemeColorTimer = null;
    }

    final startTime = networkVersionData.activityColors?.startTime;
    final endTime = networkVersionData.activityColors?.endTime;
    if (startTime == null || endTime == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;

    dPrint("now == $now  start == $startTime end == $endTime");
    if (now < startTime) {
      _activityThemeColorTimer = Timer(Duration(milliseconds: startTime - now),
          () => checkActivityThemeColor(networkVersionData));
      dPrint("start Timer ....");
    } else if (now >= startTime && now <= endTime) {
      dPrint("update Color ....");
      // update Color
      final colorCfg = networkVersionData.activityColors;
      state = state.copyWith(
        themeConf: ThemeConf(
          backgroundColor:
              HexColor(colorCfg?.background ?? "#132431").withOpacity(.75),
          menuColor: HexColor(colorCfg?.menu ?? "#132431").withOpacity(.95),
          micaColor: HexColor(colorCfg?.mica ?? "#0A3142"),
        ),
      );

      // wait for end
      _activityThemeColorTimer = Timer(Duration(milliseconds: endTime - now),
          () => checkActivityThemeColor(networkVersionData));
    } else {
      dPrint("reset Color ....");
      state = state.copyWith(
        themeConf: ThemeConf(
          backgroundColor: HexColor("#132431").withOpacity(.75),
          menuColor: HexColor("#132431").withOpacity(.95),
          micaColor: HexColor("#0A3142"),
        ),
      );
    }
  }

  void changeLocale(value) async {
    final appConfBox = await Hive.openBox("app_conf");
    if (value is Locale) {
      if (value.languageCode == "auto") {
        state = state.copyWith(appLocale: null);
        await appConfBox.put("app_locale", null);
        return;
      }
      final localeCode = value.countryCode != null
          ? "${value.languageCode}_${value.countryCode ?? ""}"
          : value.languageCode;
      await appConfBox.put("app_locale", localeCode);
      state = state.copyWith(appLocale: value);
    }
  }
}

@freezed
class ThemeConf with _$ThemeConf {
  const factory ThemeConf({
    @Default(Color(0xbf132431)) Color backgroundColor,
    @Default(Color(0xf2132431)) Color menuColor,
    @Default(Color(0xff0a3142)) Color micaColor,
  }) = _ThemeConf;
}
