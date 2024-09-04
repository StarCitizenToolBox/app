import 'dart:async';
import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/ui/home/performance/performance_ui.dart';
import 'package:starcitizen_doctor/ui/splash_ui.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

import 'api/api.dart';
import 'common/io/rs_http.dart';
import 'common/rust/frb_generated.dart';
import 'data/app_version_data.dart';
import 'generated/no_l10n_strings.dart';
import 'ui/home/localization/advanced_localization_ui.dart';
import 'ui/index_ui.dart';

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
    Box? appConfBox,
    @Default("assets/backgrounds/SC_01_Wallpaper_3840x2160.webp")
    String backgroundImageAssetsPath,
  }) = _AppGlobalState;
}

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            myPageBuilder(context, state, const SplashUI()),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            myPageBuilder(context, state, const IndexUI()),
        routes: [
          GoRoute(
            path: 'performance',
            pageBuilder: (context, state) =>
                myPageBuilder(context, state, const HomePerformanceUI()),
          ),
          GoRoute(
              path: 'advanced_localization',
              pageBuilder: (context, state) =>
                  myPageBuilder(context, state, const AdvancedLocalizationUI()))
        ],
      ),
      GoRoute(path: '/tools', builder: (_, __) => const SizedBox()),
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
        const Locale("ja"): NoL10n.langJa,
      };

  @override
  AppGlobalState build() {
    return const AppGlobalState();
  }

  bool _initialized = false;

  Future<void> initApp() async {
    if (_initialized) return;
    // init Data
    // final applicationSupportDir = await _initAppDir();

    // init Rust bridge
    await RustLib.init();
    await RSHttp.init();
    dPrint("---- rust bridge init -----");

    // init Hive
    try {
      // Hive.init("$applicationSupportDir/db");
      final box = await Hive.openBox("app_conf");
      state = state.copyWith(appConfBox: box);
      if (box.get("install_id", defaultValue: "") == "") {
        await box.put("install_id", const Uuid().v4());
        // AnalyticsApi.touch("firstLaunch");
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
      // await win32.setForegroundWindow(windowName: "SCToolBox");
      dPrint("exit: db is locking ...");
      // exit(0);
    }

    dPrint("---- Window init -----");
    _startBackgroundLoop();
    _initialized = true;
    ref.keepAlive();
  }

  Timer? _loopTimer;

  _startBackgroundLoop() async {
    _loopTimer?.cancel();
    _loopTimer = null;
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final imageAssetsList = assetManifest
        .listAssets()
        .where((string) => string.startsWith("assets/backgrounds"))
        .toList();

    void rollImage() {
      final random = Random();
      final index = random.nextInt(imageAssetsList.length);
      final image = imageAssetsList[index];
      state = state.copyWith(backgroundImageAssetsPath: image);
      dPrint("rollImage: [$index] $image");
    }

    rollImage();
    // 使用 timer 每 30 秒 更换一次随机图片
    _loopTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      rollImage();
    });
  }

  String getUpgradePath() {
    return "${state.applicationSupportDir}/._upgrade";
  }

  // ignore: avoid_build_context_in_providers
  Future<bool> checkUpdate(BuildContext context) async {
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
      dPrint("changeLocale == $value localeCode=== $localeCode");
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
