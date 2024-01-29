// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/win32/credentials.dart';
import 'package:starcitizen_doctor/data/app_web_localization_versions_data.dart';

import '../../../api/api.dart';
import '../../../base/ui.dart';

typedef RsiLoginCallback = void Function(Map? data, bool success);

class WebViewModel {
  late Webview webview;
  final BuildContext context;

  bool _isClosed = false;

  bool get isClosed => _isClosed;

  WebViewModel(this.context,
      {this.loginMode = false, this.loginCallback, this.loginChannel = "LIVE"});

  String url = "";
  bool canGoBack = false;

  final localizationResource = <String, dynamic>{};

  var localizationScript = "";

  bool enableCapture = false;

  Map<String, String>? _curReplaceWords;

  Map<String, String>? get curReplaceWords => _curReplaceWords;

  final bool loginMode;
  final String loginChannel;

  bool _loginModeSuccess = false;

  final RsiLoginCallback? loginCallback;

  initWebView({String title = ""}) async {
    try {
      webview = await WebviewWindow.create(
          configuration: CreateConfiguration(
              windowWidth: loginMode ? 960 : 1920,
              windowHeight: loginMode ? 720 : 1080,
              userDataFolderWindows:
                  "${AppConf.applicationSupportDir}/webview_data",
              title: title));
      // webview.openDevToolsWindow();
      webview.isNavigating.addListener(() async {
        if (!webview.isNavigating.value && localizationResource.isNotEmpty) {
          final uri = Uri.parse(url);
          dPrint("webview Navigating uri === $uri");
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
              replaceWords.clear();
              replaceWords.addAll(_getLocalizationResource("concierge"));
            }
            if (url.startsWith(hangar)) {
              replaceWords.addAll(_getLocalizationResource("hangar"));
            }

            _curReplaceWords = {};
            for (var element in replaceWords) {
              _curReplaceWords?[element["word"] ?? ""] =
                  element["replacement"] ?? "";
            }
            await Future.delayed(const Duration(milliseconds: 100));
            await webview.evaluateJavaScript(
                "WebLocalizationUpdateReplaceWords(${json.encode(replaceWords)},$enableCapture)");

            /// loginMode
            if (loginMode) {
              dPrint(
                  "--- do rsi login ---\n run === getRSILauncherToken(\"$loginChannel\");");
              await Future.delayed(const Duration(milliseconds: 200));
              webview.evaluateJavaScript(
                  "getRSILauncherToken(\"$loginChannel\");");
            }
          } else if (uri.host.contains("www.erkul.games")) {
            dPrint("load script");
            await Future.delayed(const Duration(milliseconds: 100));
            await webview.evaluateJavaScript(localizationScript);
            dPrint("update replaceWords");
            final replaceWords = _getLocalizationResource("DPS");
            await webview.evaluateJavaScript(
                "WebLocalizationUpdateReplaceWords(${json.encode(replaceWords)},$enableCapture)");
          } else if (uri.host.contains("uexcorp.space")) {
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
      webview.onClose.whenComplete(dispose);
      if (loginMode) {
        webview.addOnWebMessageReceivedCallback((messageString) {
          final message = json.decode(messageString);
          if (message["action"] == "webview_rsi_login_show_window") {
            webview.setWebviewWindowVisibility(true);
            _checkAutoLogin(webview);
          } else if (message["action"] == "webview_rsi_login_success") {
            _loginModeSuccess = true;
            loginCallback?.call(message, true);
            webview.close();
          }
        });
        Future.delayed(const Duration(seconds: 1))
            .then((value) => {webview.setWebviewWindowVisibility(false)});
      }
    } catch (e) {
      showToast(context, "初始化失败：$e");
    }
  }

  launch(String url) async {
    webview.launch(url);
  }

  initLocalization(AppWebLocalizationVersionsData v) async {
    localizationScript = await rootBundle.loadString('assets/web_script.js');

    /// https://github.com/CxJuice/Uex_Chinese_Translate
    // get versions
    const hostUrl = URLConf.webTranslateHomeUrl;
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
    localizationResource["DPS"] = await _getJson("$hostUrl/zh-CN-dps.json",
        cacheKey: "dps", version: v.dps);
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

  FutureOr<void> dispose() {
    if (loginMode && !_loginModeSuccess) {
      loginCallback?.call(null, false);
    }
    _isClosed = true;
  }

  Future<void> _checkAutoLogin(Webview webview) async {
    final LocalAuthentication localAuth = LocalAuthentication();
    if (!await localAuth.isDeviceSupported()) return;

    final userBox = await Hive.openBox("rsi_account_data");
    final email = await userBox.get("account_email", defaultValue: "");

    final pwdE = await userBox.get("account_pwd_encrypted", defaultValue: "");
    final nonceStr = await userBox.get("nonce", defaultValue: "");
    final macStr = await userBox.get("mac", defaultValue: "");
    if (email == "") return;
    webview.evaluateJavaScript("RSIAutoLogin(\"$email\",\"\")");
    if (pwdE != "" && nonceStr != "" && macStr != "") {
      // send toast
      webview.evaluateJavaScript("SCTShowToast(\"请完成 Windows Hello 验证以填充密码\")");
      // decrypt
      if (await localAuth.authenticate(localizedReason: "请输入设备PIN以自动登录RSI账户") !=
          true) return;
      final kv = Win32Credentials.read("SCToolbox_RSI_Account_secret");
      if (kv == null || kv.key != email) return;

      final algorithm = AesGcm.with256bits();
      final r = await algorithm.decrypt(
          SecretBox(base64.decode(pwdE),
              nonce: base64.decode(nonceStr), mac: Mac(base64.decode(macStr))),
          secretKey: SecretKey(base64.decode(kv.value)));
      final decryptedPwd = utf8.decode(r);
      webview.evaluateJavaScript("RSIAutoLogin(\"$email\",\"$decryptedPwd\")");
    }
  }
}
