import 'dart:async';
import 'dart:convert';

import 'package:dart_rss/domain/rss_item.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/api/rss.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/async.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/app_placard_data.dart';
import 'package:starcitizen_doctor/data/app_web_localization_versions_data.dart';
import 'package:starcitizen_doctor/data/countdown_festival_item_data.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as html_dom;
import 'package:url_launcher/url_launcher_string.dart';

import 'localization/localization_ui_model.dart';

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
    state = state.copyWith(scInstalledPath: "not_install", lastScreenInfo: "");
  }

  String getRssImage(RssItem item) {
    final h = html.parse(item.description ?? "");
    if (h.body == null) return "";
    for (var node in h.body!.nodes) {
      if (node is html_dom.Element) {
        if (node.localName == "img") {
          var image = node.attributes["src"]?.trim() ?? "";
          var updatedImage = image.replaceAllMapped(
              RegExp(r'http(s)?://i(\d+)\.hdslb\.com/bfs/'),
                  (match) => 'https://web-proxy.scbox.xkeyc.cn/bfs${match[2]}/bfs/'
          );
          return updatedImage;
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
  Future<void> goWebView(BuildContext context, String title, String url,
      {bool useLocalization = false, bool loginMode = false}) async {
    launchUrlString(url);
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
    }
  }

  Future<void> checkLocalizationUpdate({bool skipReload = false}) async {
    dPrint("_checkLocalizationUpdate");
    await (ref.read(localizationUIModelProvider.notifier))
        .checkLangUpdate(skipReload: skipReload)
        .unwrap<List<String>>();
  }

  // ignore: avoid_build_context_in_providers
  launchRSI(BuildContext context) async {
    if (state.scInstalledPath == "not_install") {
      showToast(context, S.current.home_info_valid_installation_required);
      return;
    }
  }

  void onChangeInstallPath(String? value) {
    if (value == null) return;
    state = state.copyWith(scInstalledPath: value);
  }
}
