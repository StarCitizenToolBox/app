// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/data/app_web_localization_versions_data.dart';

import '../../../api/api.dart';
import '../../../base/ui.dart';

class WebViewModel {
  late Webview webview;
  final BuildContext context;

  bool _isClosed = false;

  bool get isClosed => _isClosed;

  WebViewModel(this.context);

  String url = "";
  bool canGoBack = false;

  final localizationResource = <String, dynamic>{};

  var localizationScript = "";

  bool enableCapture = false;

  initWebView({String title = ""}) async {
    try {
      webview = await WebviewWindow.create(
          configuration: CreateConfiguration(
              windowWidth: 1920,
              windowHeight: 1080,
              userDataFolderWindows:
                  "${AppConf.applicationSupportDir}/webview_data",
              title: title));
      // webview.openDevToolsWindow();
      webview.isNavigating.addListener(() async {
        if (!webview.isNavigating.value && localizationResource.isNotEmpty) {
          final uri = Uri.parse(url);
          if (uri.host.contains("robertsspaceindustries.com")) {
            // SC 官网
            dPrint("load script");
            await Future.delayed(const Duration(milliseconds: 100));
            await webview.evaluateJavaScript(localizationScript);
            dPrint("update replaceWords");
            final replaceWords = _getLocalizationResource("zh-CN");

            const org = "https://robertsspaceindustries.com/orgs";
            const citizens = "https://robertsspaceindustries.com/citizens";
            const organization =
                "https://robertsspaceindustries.com/account/organization";
            const concierge =
                "https://robertsspaceindustries.com/account/concierge";
            const referral =
                "https://robertsspaceindustries.com/account/referral-program";
            const address =
                "https://robertsspaceindustries.com/account/addresses";

            const hangar = "https://robertsspaceindustries.com/account/pledges";

            if (url.startsWith(org) ||
                url.startsWith(citizens) ||
                url.startsWith(organization)) {
              replaceWords.add({"word": 'members', "replacement": '名成员'});
              replaceWords.addAll(_getLocalizationResource("orgs"));
            }

            if (address.startsWith(address)) {
              replaceWords.addAll(_getLocalizationResource("address"));
            }

            if (url.startsWith(referral)) {
              replaceWords.addAll([
                {"word": 'Total recruits: ', "replacement": '总邀请数：'},
                {"word": 'Prospects ', "replacement": '未完成的邀请'},
                {"word": 'Recruits', "replacement": '已完成的邀请'},
              ]);
            }

            if (url.startsWith(concierge)) {
              replaceWords.addAll(_getLocalizationResource("concierge"));
            }
            if (url.startsWith(hangar)) {
              replaceWords.addAll(_getLocalizationResource("hangar"));
            }
            await Future.delayed(const Duration(milliseconds: 100));
            await webview.evaluateJavaScript(
                "WebLocalizationUpdateReplaceWords(${json.encode(replaceWords)},$enableCapture)");
          } else if (uri.host.contains("www.erkul.games") ||
              uri.host.contains("uexcorp.space") ||
              uri.host.contains("ccugame.app")) {
            // 工具网站
            dPrint("load script");
            await Future.delayed(const Duration(milliseconds: 100));
            await webview.evaluateJavaScript(localizationScript);
            dPrint("update replaceWords");
            final replaceWords = _getLocalizationResource("UEX");
            await webview.evaluateJavaScript(
                "WebLocalizationUpdateReplaceWords(${json.encode(replaceWords)},$enableCapture)");
          }
        }
      });
      webview.addOnUrlRequestCallback((url) {
        dPrint("OnUrlRequestCallback === $url");
        this.url = url;
      });
      webview.onClose.whenComplete(() {
        _isClosed = true;
      });
    } catch (e) {
      showToast(context, "初始化失败：$e");
    }
  }

  launch(String url) async {
    webview.launch(url);
  }

  initLocalization() async {
    localizationScript =
        await rootBundle.loadString('assets/localization_web_script.js');

    /// https://github.com/CxJuice/Uex_Chinese_Translate
    // get versions
    const hostUrl = "https://ch.citizenwiki.cn/json-files";

    final v = AppWebLocalizationVersionsData.fromJson(
        await _getJson("$hostUrl/versions.json"));
    dPrint("AppWebLocalizationVersionsData === ${v.toJson()}");

    localizationResource["zh-CN"] = await _getJson("$hostUrl/zh-CN-rsi.json",
        cacheKey: "rsi", version: v.rsi);
    localizationResource["concierge"] = await _getJson(
        "$hostUrl/concierge.json",
        cacheKey: "concierge",
        version: v.concierge);
    localizationResource["orgs"] =
        await _getJson("$hostUrl/orgs.json", cacheKey: "orgs", version: v.orgs);
    localizationResource["address"] = await _getJson("$hostUrl/addresses.json",
        cacheKey: "addresses", version: v.addresses);
    localizationResource["hangar"] = await _getJson("$hostUrl/hangar.json",
        cacheKey: "hangar", version: v.hangar);
    localizationResource["UEX"] = await _getJson("$hostUrl/zh-CN-uex.json",
        cacheKey: "uex", version: v.uex);
  }

  List<Map<String, String>> _getLocalizationResource(String key) {
    final List<Map<String, String>> localizations = [];
    final dict = localizationResource[key]?["dict"];
    if (dict is Map) {
      for (var element in dict.entries) {
        final k = element.key
            .toString()
            .trim()
            .toLowerCase()
            .replaceAll(RegExp("/\xa0/g"), ' ')
            .replaceAll(RegExp("/s{2,}/g"), ' ');
        localizations
            .add({"word": k, "replacement": element.value.toString().trim()});
      }
    }
    return localizations;
  }

  Future<Map> _getJson(String url,
      {String cacheKey = "", String? version}) async {
    final box = await Hive.openBox("web_localization_cache_data");
    if (cacheKey.isNotEmpty) {
      final localVersion = box.get("${cacheKey}_version}", defaultValue: "");
      var data = box.get(cacheKey, defaultValue: {});
      if (data is Map && data.isNotEmpty && localVersion == version) {
        return data;
      }
    }
    final startTime = DateTime.now();
    final r = await Api.dio
        .get(url, options: Options(responseType: ResponseType.plain));
    final endTime = DateTime.now();
    final data = json.decode(r.data);
    if (cacheKey.isNotEmpty) {
      dPrint(
          "update $cacheKey v == $version  time == ${(endTime.microsecondsSinceEpoch - startTime.microsecondsSinceEpoch) / 1000 / 1000}s");
      await box.put(cacheKey, data);
      await box.put("${cacheKey}_version}", version);
    }
    return data;
  }

  void addOnWebMessageReceivedCallback(OnWebMessageReceivedCallback callback) {
    webview.addOnWebMessageReceivedCallback(callback);
  }

  void removeOnWebMessageReceivedCallback(
      OnWebMessageReceivedCallback callback) {
    webview.removeOnWebMessageReceivedCallback(callback);
  }
}
