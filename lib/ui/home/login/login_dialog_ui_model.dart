import 'dart:convert';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/webview/webview.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class LoginDialogModel extends BaseUIModel {
  int loginStatus = 0;

  String nickname = "";
  String? avatarUrl;
  String? authToken;
  String? webToken;
  Map? releaseInfo;

  final String installPath;

  final HomeUIModel homeUIModel;

  // TextEditingController emailCtrl = TextEditingController();

  LoginDialogModel(this.installPath, this.homeUIModel);

  @override
  void initModel() {
    _launchWebLogin();
    super.initModel();
  }

  void _launchWebLogin() {
    goWebView("登录 RSI 账户", "https://robertsspaceindustries.com/connect",
        loginMode: true, rsiLoginCallback: (message, ok) async {
      dPrint(
          "======rsiLoginCallback=== $ok ===== data==\n${json.encode(message)}");
      if (message == null || !ok) {
        Navigator.pop(context!);
        return;
      }
      // final emailBox = await Hive.openBox("quick_login_email");
      final data = message["data"];
      authToken = data["authToken"];
      webToken = data["webToken"];
      releaseInfo = data["releaseInfo"];
      avatarUrl = data["avatar"]
          ?.toString()
          .replaceAll("url(\"", "")
          .replaceAll("\")", "");
      Map<String, dynamic> payload = Jwt.parseJwt(authToken!);
      nickname = payload["nickname"] ?? "";
      _readyForLaunch();
    }, useLocalization: true);
  }

  goWebView(String title, String url,
      {bool useLocalization = false,
      bool loginMode = false,
      RsiLoginCallback? rsiLoginCallback}) async {
    if (useLocalization) {
      const tipVersion = 2;
      final box = await Hive.openBox("app_conf");
      final skip = await box.get("skip_web_login_version", defaultValue: 0);
      if (skip != tipVersion) {
        final ok = await showConfirmDialogs(
            context!,
            "星际公民盒子一键启动",
            const Text(
              "本功能可以帮您更加便利的启动游戏。\n\n为确保账户安全 ，本功能使用汉化浏览器保留登录状态，且不会保存您的密码信息，与 RSI 启动器行为一致。"
              "\n\n使用此功能登录账号时请确保您的 星际公民盒子 是从可信任的来源下载。",
              style: TextStyle(fontSize: 16),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context!).size.width * .6));
        if (!ok) {
          if (loginMode) {
            rsiLoginCallback?.call(null, false);
          }
          return;
        }
        await box.put("skip_web_login_version", tipVersion);
      }
    }
    if (!await WebviewWindow.isWebviewAvailable()) {
      await showToast(context!, "需要安装 WebView2 Runtime");
      await launchUrlString(
          "https://developer.microsoft.com/en-us/microsoft-edge/webview2/");
      Navigator.pop(context!);
      return;
    }
    final webViewModel = WebViewModel(context!,
        loginMode: loginMode,
        loginCallback: rsiLoginCallback,
        loginChannel: getChannelID());
    if (useLocalization) {
      try {
        await webViewModel.initLocalization();
      } catch (_) {}
    }
    await webViewModel.initWebView(
      title: title,
    );
    await webViewModel.launch(url);
    notifyListeners();
  }

  // onSaveEmail() async {
  //   final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  //   if (!emailRegex.hasMatch(emailCtrl.text.trim())) {
  //     showToast(context!, "邮箱输入有误！");
  //     return;
  //   }
  //   final emailBox = await Hive.openBox("quick_login_email");
  //   await emailBox.put(nickname, emailCtrl.text.trim());
  //   _readyForLaunch();
  //   notifyListeners();
  // }

  Future<void> _readyForLaunch() async {
    loginStatus = 2;
    notifyListeners();
    final launchData = {
      "username": "",
      "token": webToken,
      "auth_token": authToken,
      "star_network": {
        "services_endpoint": releaseInfo?["servicesEndpoint"],
        "hostname": releaseInfo?["universeHost"],
        "port": releaseInfo?["universePort"],
      },
      "TMid": const Uuid().v4(),
    };
    final executable = releaseInfo?["executable"];
    final launchOptions = releaseInfo?["launchOptions"];
    dPrint("----------launch data ======  -----------\n$launchData");
    dPrint(
        "----------executable data ======  -----------\n$installPath\\$executable $launchOptions");
    final launchFile = File("$installPath\\loginData.json");
    if (await launchFile.exists()) {
      await launchFile.delete();
    }
    await launchFile.create();
    await launchFile.writeAsString(json.encode(launchData));
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    homeUIModel.doLaunchGame(
        '$installPath\\$executable',
        ["-no_login_dialog", ...launchOptions.toString().split(" ")],
        installPath);
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pop(context!);
  }

  String getChannelID() {
    if (installPath.endsWith("\\LIVE")) {
      return "LIVE";
    } else if (installPath.endsWith("\\PTU")) {
      return "PTU";
    } else if (installPath.endsWith("\\EVO")) {
      return "EVO";
    }
    return "LIVE";
  }
}
