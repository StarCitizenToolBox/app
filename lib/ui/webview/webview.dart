// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:starcitizen_doctor/common/utils/app_hive.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/rust/rust_webview_controller.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/data/app_version_data.dart';
import 'package:starcitizen_doctor/data/app_web_localization_versions_data.dart';

typedef OnWebMessageReceivedCallback = void Function(String message);

class WebViewModel {
  late RustWebViewController webview;
  final BuildContext context;

  bool _isClosed = false;

  bool get isClosed => _isClosed;

  WebViewModel(this.context);

  String url = "";
  bool canGoBack = false;

  final localizationResource = <String, dynamic>{};

  var localizationScript = "";

  bool enableCapture = false;

  bool isEnableToolSiteMirrors = false;

  Map<String, String>? _curReplaceWords;

  Map<String, String>? get curReplaceWords => _curReplaceWords;

  late AppVersionData _appVersionData;

  Future<void> initWebView({
    String title = "",
    required String applicationSupportDir,
    required AppVersionData appVersionData,
  }) async {
    try {
      final userBox = await AppHive.openBox("app_conf");
      isEnableToolSiteMirrors = userBox.get(
        "isEnableToolSiteMirrors",
        defaultValue: false,
      );
      _appVersionData = appVersionData;

      webview = await RustWebViewController.create(
        title: Platform.isMacOS ? "" : title,
        width: 1920,
        height: 1080,
        userDataFolder: "$applicationSupportDir/webview_data",
        enableDevtools: kDebugMode,
        userAgent:
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0",
      );

      // 添加导航完成回调（用于注入脚本）
      webview.addOnNavigationCompletedCallback(_onNavigationCompleted);

      // 添加关闭回调
      webview.addOnCloseCallback(dispose);
    } catch (e) {
      showToast(context, S.current.app_init_failed_with_reason(e));
    }
  }

  Future<void> _onNavigationCompleted(String newUrl) async {
    dPrint("Navigation completed: $newUrl");
    url = newUrl;

    if (localizationResource.isEmpty) return;

    dPrint("webview Navigating url === $url");
    if (url.contains("robertsspaceindustries.com")) {
      // SC 官网
      final replaceWords = _getLocalizationResource("zh-CN");
      const org = "https://robertsspaceindustries.com/orgs";
      const citizens = "https://robertsspaceindustries.com/citizens";
      const organization =
          "https://robertsspaceindustries.com/account/organization";
      const concierge = "https://robertsspaceindustries.com/account/concierge";
      const referral =
          "https://robertsspaceindustries.com/account/referral-program";
      const address = "https://robertsspaceindustries.com/account/addresses";

      const hangar = "https://robertsspaceindustries.com/account/pledges";

      const spectrum = "https://robertsspaceindustries.com/spectrum";
      // 跳过光谱论坛 https://github.com/StarCitizenToolBox/StarCitizenBoxBrowserEx/issues/1
      if (url.startsWith(spectrum)) {
        return;
      }

      dPrint("load script");
      await Future.delayed(const Duration(milliseconds: 100));
      webview.injectLocalizationScript();

      if (url.startsWith(org) ||
          url.startsWith(citizens) ||
          url.startsWith(organization)) {
        replaceWords.add({
          "word": 'members',
          "replacement": S.current.webview_localization_name_member,
        });
        replaceWords.addAll(_getLocalizationResource("orgs"));
      }

      if (address.startsWith(address)) {
        replaceWords.addAll(_getLocalizationResource("address"));
      }

      if (url.startsWith(referral)) {
        replaceWords.addAll([
          {
            "word": 'Total recruits: ',
            "replacement": S.current.webview_localization_total_invitations,
          },
          {
            "word": 'Prospects ',
            "replacement":
                S.current.webview_localization_unfinished_invitations,
          },
          {
            "word": 'Recruits',
            "replacement": S.current.webview_localization_finished_invitations,
          },
        ]);
      }

      if (url.startsWith(concierge)) {
        replaceWords.clear();
        replaceWords.addAll(_getLocalizationResource("concierge"));
      }
      if (url.startsWith(hangar)) {
        replaceWords.addAll(_getLocalizationResource("hangar"));
      }

      _curReplaceWords = {};
      for (var element in replaceWords) {
        _curReplaceWords?[element["word"] ?? ""] = element["replacement"] ?? "";
      }
      webview.initWebLocalization();
      await Future.delayed(const Duration(milliseconds: 100));
      dPrint("update replaceWords");
      webview.updateReplaceWords(replaceWords, enableCapture);
    } else if (await _isSiteUrl(url, const [
      "https://erkul.games",
      "https://www.erkul.games",
    ])) {
      dPrint("load script");
      await Future.delayed(const Duration(milliseconds: 100));
      webview.injectLocalizationScript();
      dPrint("update replaceWords");
      final replaceWords = _getLocalizationResource("DPS");
      webview.updateReplaceWords(replaceWords, enableCapture);
    } else if (url.startsWith(
      await _handleMirrorsUrl("https://uexcorp.space", _appVersionData),
    )) {
      dPrint("load script");
      await Future.delayed(const Duration(milliseconds: 100));
      webview.injectLocalizationScript();
      dPrint("update replaceWords");
      final replaceWords = _getLocalizationResource("UEX");
      webview.updateReplaceWords(replaceWords, enableCapture);
    }
  }

  /// 按 hostname 匹配站点，同时兼容工具站镜像地址
  Future<bool> _isSiteUrl(String url, List<String> siteUrls) async {
    final host = Uri.tryParse(url)?.host.toLowerCase();
    for (final siteUrl in siteUrls) {
      if (host != null && host == Uri.parse(siteUrl).host) return true;
      final mirrorUrl = await _handleMirrorsUrl(siteUrl, _appVersionData);
      if (mirrorUrl != siteUrl && url.startsWith(mirrorUrl)) return true;
    }
    return false;
  }

  Future<String> _handleMirrorsUrl(
    String url,
    AppVersionData appVersionData,
  ) async {
    var finalUrl = url;
    if (isEnableToolSiteMirrors) {
      for (var kv in appVersionData.webMirrors!.entries) {
        if (url.startsWith(kv.key)) {
          finalUrl = url.replaceFirst(kv.key, kv.value);
          AnalyticsApi.touch("webLocalization_with_boost_mirror");
        }
      }
    }
    return finalUrl;
  }

  Future<void> launch(String url, AppVersionData appVersionData) async {
    webview.navigate(await _handleMirrorsUrl(url, appVersionData));
  }

  Future<void> initLocalization(AppWebLocalizationVersionsData v) async {
    localizationScript = await rootBundle.loadString('assets/web_script.js');

    /// https://github.com/CxJuice/Uex_Chinese_Translate
    // get versions
    final hostUrl = URLConf.webTranslateHomeUrl;
    dPrint("AppWebLocalizationVersionsData === ${v.toJson()}");

    localizationResource["zh-CN"] = await _getJson(
      "$hostUrl/zh-CN-rsi.json",
      cacheKey: "rsi",
      version: v.rsi,
    );
    localizationResource["concierge"] = await _getJson(
      "$hostUrl/concierge.json",
      cacheKey: "concierge",
      version: v.concierge,
    );
    localizationResource["orgs"] = await _getJson(
      "$hostUrl/orgs.json",
      cacheKey: "orgs",
      version: v.orgs,
    );
    localizationResource["address"] = await _getJson(
      "$hostUrl/addresses.json",
      cacheKey: "addresses",
      version: v.addresses,
    );
    localizationResource["hangar"] = await _getJson(
      "$hostUrl/hangar.json",
      cacheKey: "hangar",
      version: v.hangar,
    );
    localizationResource["UEX"] = await _getJson(
      "$hostUrl/zh-CN-uex.json",
      cacheKey: "uex",
      version: v.uex,
    );
    localizationResource["DPS"] = await _getJson(
      "$hostUrl/zh-CN-dps.json",
      cacheKey: "dps",
      version: v.dps,
    );
  }

  List<Map<String, String>> _getLocalizationResource(String key) {
    final List<Map<String, String>> localizations = [];
    final dict = localizationResource[key];
    if (dict is Map) {
      for (var element in dict.entries) {
        final k = element.key
            .toString()
            .trim()
            .toLowerCase()
            .replaceAll(RegExp("/\xa0/g"), ' ')
            .replaceAll(RegExp("/s{2,}/g"), ' ');
        localizations.add({
          "word": k,
          "replacement": element.value.toString().trim(),
        });
      }
    }
    return localizations;
  }

  Future<Map> _getJson(
    String url, {
    String cacheKey = "",
    String? version,
  }) async {
    final box = await AppHive.openBox("web_localization_cache_data");
    if (cacheKey.isNotEmpty) {
      final localVersion = box.get("${cacheKey}_version", defaultValue: "");
      var data = box.get(cacheKey, defaultValue: {});
      if (data is Map && data.isNotEmpty && localVersion == version) {
        return data;
      }
    }
    final startTime = DateTime.now();
    final r = await RSHttp.getText(url);
    final endTime = DateTime.now();
    final data = json.decode(r);
    if (cacheKey.isNotEmpty) {
      dPrint(
        "update $cacheKey v == $version  time == ${(endTime.microsecondsSinceEpoch - startTime.microsecondsSinceEpoch) / 1000 / 1000}s",
      );
      await box.put(cacheKey, data);
      await box.put("${cacheKey}_version", version);
    }
    return data;
  }

  void addOnWebMessageReceivedCallback(OnWebMessageReceivedCallback callback) {
    webview.addOnWebMessageCallback(callback);
  }

  void removeOnWebMessageReceivedCallback(
    OnWebMessageReceivedCallback callback,
  ) {
    webview.removeOnWebMessageCallback(callback);
  }

  FutureOr<void> dispose() {
    webview.removeOnNavigationCompletedCallback(_onNavigationCompleted);
    _isClosed = true;
    webview.dispose();
  }
}
