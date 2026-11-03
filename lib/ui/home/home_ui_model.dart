import 'dart:async';
import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starcitizen_doctor/common/utils/app_hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/api/news_api.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/app_placard_data.dart';
import 'package:starcitizen_doctor/data/app_web_localization_versions_data.dart';
import 'package:starcitizen_doctor/data/citizen_news_data.dart';
import 'package:starcitizen_doctor/data/countdown_festival_item_data.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
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
    CitizenNewsData? citizenNewsData,
    MapEntry<String, bool>? localizationUpdateInfo,
    List? scServerStatus,
    List<CountdownFestivalItemData>? countdownFestivalListData,
  }) = _HomeUIModelState;
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
    final box = await AppHive.openBox("app_conf");
    await box.put("close_placard", state.appPlacardData?.version);
    state = state.copyWith(appPlacardData: null);
  }

  /// The latest install path scan; [checkLocalizationUpdate] waits for it.
  Future<void>? _scanPathFuture;

  Future<void> reScanPath() => _scanPathFuture = _reScanPath();

  Future<void> _reScanPath() async {
    state = state.copyWith(
      scInstalledPath: "not_install",
      lastScreenInfo: S.current.home_action_info_scanning,
    );
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
      final lastScreenInfo = S.current
          .home_action_info_scan_complete_valid_directories_found(
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

  String getRssImage(String? htmlString) {
    if (htmlString == null) return "";
    final h = html.parse(htmlString);
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

  Future<void> goWebView(
    // ignore: avoid_build_context_in_providers
    BuildContext context,
    String title,
    String url, {
    bool useLocalization = false,
  }) async {
    if (useLocalization) {
      const tipVersion = 2;
      final box = await AppHive.openBox("app_conf");
      final skip = await box.get(
        "skip_web_localization_tip_version",
        defaultValue: 0,
      );
      if (skip != tipVersion) {
        if (!context.mounted) return;
        final ok = await showConfirmDialogs(
          context,
          S.current.home_action_title_star_citizen_website_localization,
          Text(
            S.current.home_action_info_web_localization_plugin_disclaimer,
            style: const TextStyle(fontSize: 16),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .6,
          ),
        );
        if (!ok) return;
        await box.put("skip_web_localization_tip_version", tipVersion);
      }
    }
    // Rust WebView using wry + tao - no WebView2 runtime check needed as wry handles it internally
    if (!context.mounted) return;
    final webViewModel = WebViewModel(context);
    if (useLocalization) {
      state = state.copyWith(
        isFixing: true,
        isFixingString: S.current.home_action_info_initializing_resources,
      );
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
      final box = await AppHive.openBox("app_conf");
      final version = box.get("close_placard", defaultValue: "");
      if (r.enable == true) {
        if (r.alwaysShow != true && version == r.version) {
        } else {
          state = state.copyWith(appPlacardData: r);
        }
      }

      final appWebLocalizationVersionsData =
          AppWebLocalizationVersionsData.fromJson(
            json.decode(
              (await RSHttp.getText(
                "${URLConf.webTranslateHomeUrl}/versions.json",
              )),
            ),
          );
      final countdownFestivalListData = await Api.getFestivalCountdownList();
      state = state.copyWith(
        webLocalizationVersionsData: appWebLocalizationVersionsData,
        countdownFestivalListData: _fixFestivalCountdownListDateTime(
          countdownFestivalListData,
        ),
      );
      _updateSCServerStatus();
      _loadNews();
    } catch (e) {
      dPrint(e);
    }
    // check Localization update
    checkLocalizationUpdate();
  }

  /// 节日已过7天时，更新为下一年的时间
  List<CountdownFestivalItemData> _fixFestivalCountdownListDateTime(
    List<CountdownFestivalItemData> list,
  ) {
    final now = DateTime.now();

    final fixedList = list.map((item) {
      if (item.time == null) return item;
      final itemDateTime = DateTime.fromMillisecondsSinceEpoch(item.time!);

      // 计算今年的节日日期
      final thisYearDate = DateTime(
        now.year,
        itemDateTime.month,
        itemDateTime.day,
        itemDateTime.hour,
        itemDateTime.minute,
        itemDateTime.second,
      );

      // 如果今年的节日日期 + 7天已经过了，使用明年的日期
      final thisYearDatePlusSeven = thisYearDate.add(const Duration(days: 7));
      if (thisYearDatePlusSeven.isBefore(now)) {
        final nextYearDate = DateTime(
          now.year + 1,
          itemDateTime.month,
          itemDateTime.day,
          itemDateTime.hour,
          itemDateTime.minute,
          itemDateTime.second,
        );
        final newTimestamp = (nextYearDate.millisecondsSinceEpoch).round();
        return CountdownFestivalItemData(
          name: item.name,
          time: newTimestamp,
          icon: item.icon,
        );
      }

      // 否则使用今年的日期
      final newTimestamp = (thisYearDate.millisecondsSinceEpoch).round();
      return CountdownFestivalItemData(
        name: item.name,
        time: newTimestamp,
        icon: item.icon,
      );
    }).toList();

    // Sort by time (ascending order - nearest festival first)
    fixedList.sort((a, b) {
      if (a.time == null && b.time == null) return 0;
      if (a.time == null) return 1;
      if (b.time == null) return -1;
      return a.time!.compareTo(b.time!);
    });

    return fixedList;
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

  Future _loadNews() async {
    final news = await NewsApi.getLatest();
    state = state.copyWith(citizenNewsData: news ?? CitizenNewsData());
  }

  Future<void> checkLocalizationUpdate({bool skipReload = false}) async {
    dPrint("_checkLocalizationUpdate");
    // On startup the path scan and the network requests run in parallel. Checking before the
    // scan finishes sees "not_install" and never loads the localization data (including the
    // community input method index).
    await _scanPathFuture;
    final updates = await (ref.read(
      localizationUIModelProvider.notifier,
    )).checkLangUpdate(skipReload: skipReload).unwrap<List<String>>();
    if (updates == null || updates.isEmpty) {
      state = state.copyWith(localizationUpdateInfo: null);
    } else {
      state = state.copyWith(
        localizationUpdateInfo: MapEntry(updates.first, true),
      );
      if (_appUpdateTimer != null) {
        _appUpdateTimer?.cancel();
        _appUpdateTimer = null;
        // 发送通知
        await win32.sendNotify(
          summary: S.current.home_localization_new_version_available,
          body: S.current.home_localization_new_version_installed(
            updates.first,
          ),
          appName: S.current.home_title_app_name,
          appId: ConstConf.win32AppId,
        );
      }
    }

    // 检查拓展更新
    final extUpdates = await (ref.read(
      localizationUIModelProvider.notifier,
    )).checkLocalizationExtensionUpdate();

    if (extUpdates.isNotEmpty) {
      await (ref.read(
        localizationUIModelProvider.notifier,
      )).sendExtensionUpdateNotification(extUpdates);
    }
  }

  void onChangeInstallPath(String? value) {
    if (value == null) return;
    state = state.copyWith(scInstalledPath: value);
    ref
        .read(localizationUIModelProvider.notifier)
        .onChangeGameInstallPath(value);
  }
}
