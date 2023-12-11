import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:local_auth/local_auth.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/win32/credentials.dart';
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

  final LocalAuthentication localAuth = LocalAuthentication();

  var isDeviceSupportWinHello = false;

  @override
  void initModel() {
    _launchWebLogin();
    super.initModel();
  }

  Future<void> _launchWebLogin() async {
    isDeviceSupportWinHello = await localAuth.isDeviceSupported();
    notifyListeners();
    goWebView("登录 RSI 账户", "https://robertsspaceindustries.com/connect",
        loginMode: true, rsiLoginCallback: (message, ok) async {
      // dPrint(
      //     "======rsiLoginCallback=== $ok ===== data==\n${json.encode(message)}");
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

      final inputEmail = data["inputEmail"];
      final inputPassword = data["inputPassword"];

      final userBox = await Hive.openBox("rsi_account_data");
      if (inputEmail != null && inputEmail != "") {
        await userBox.put("account_email", inputEmail);
      }
      if (isDeviceSupportWinHello) {
        if (await userBox.get("enable", defaultValue: true)) {
          if (inputEmail != null &&
              inputEmail != "" &&
              inputPassword != null &&
              inputPassword != "") {
            final ok = await showConfirmDialogs(
                context!,
                "是否开启自动密码填充？",
                const Text(
                    "盒子将使用 PIN 与 Windows 凭据加密保存您的密码，密码只存储在您的设备中。\n\n当下次登录需要输入密码时，您只需授权PIN即可自动填充登录。"));
            if (ok == true) {
              if (await localAuth.authenticate(localizedReason: "输入PIN以启用加密") ==
                  true) {
                await _savePwd(inputEmail, inputPassword);
              }
            } else {
              await userBox.put("enable", false);
            }
          }
        }
      }

      final buildInfoFile = File("$installPath\\build_manifest.id");
      if (await buildInfoFile.exists()) {
        final buildInfo =
            json.decode(await buildInfoFile.readAsString())["Data"];
        dPrint("buildInfo ======= $buildInfo");

        if (releaseInfo?["versionLabel"] != null &&
            buildInfo["RequestedP4ChangeNum"] != null) {
          if (!(releaseInfo!["versionLabel"]!
              .toString()
              .endsWith(buildInfo["RequestedP4ChangeNum"]!.toString()))) {
            final ok = await showConfirmDialogs(
                context!,
                "游戏版本过期",
                Text(
                    "RSI 服务器报告版本号：${releaseInfo?["versionLabel"]} \n\n本地版本号：${buildInfo["RequestedP4ChangeNum"]} \n\n建议使用 RSI Launcher 更新游戏！"),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context!).size.width * .4),
                cancel: "忽略");
            if (ok == true) {
              Navigator.pop(context!);
              return;
            }
          }
        }
      }

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
            "盒子一键启动",
            const Text(
              "本功能可以帮您更加便利的启动游戏。\n\n为确保账户安全 ，本功能使用汉化浏览器保留登录状态，且不会保存您的密码信息（除非你启用了自动填充功能）。"
              "\n\n使用此功能登录账号时请确保您的 SC汉化盒子 是从可信任的来源下载。",
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
        await webViewModel
            .initLocalization(homeUIModel.appWebLocalizationVersionsData!);
      } catch (_) {}
    }
    await Future.delayed(const Duration(milliseconds: 500));
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
    final userBox = await Hive.openBox("rsi_account_data");
    loginStatus = 2;
    notifyListeners();
    final launchData = {
      "username": userBox.get("account_email", defaultValue: ""),
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

    await Future.delayed(const Duration(seconds: 3));
    final processorAffinity = await SystemHelper.getCpuAffinity();

    homeUIModel.doLaunchGame(
        '$installPath\\$executable',
        ["-no_login_dialog", ...launchOptions.toString().split(" ")],
        installPath,
        processorAffinity);
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context!);
  }

  String getChannelID() {
    if (installPath.endsWith("\\LIVE")) {
      return "LIVE";
    } else if (installPath.endsWith("\\PTU")) {
      return "PTU";
    } else if (installPath.endsWith("\\EPTU")) {
      return "EPTU";
    }
    return "LIVE";
  }

  _savePwd(String inputEmail, String inputPassword) async {
    final algorithm = AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKey();
    final nonce = algorithm.newNonce();

    final secretBox = await algorithm.encrypt(utf8.encode(inputPassword),
        secretKey: secretKey, nonce: nonce);

    await algorithm.decrypt(
        SecretBox(secretBox.cipherText,
            nonce: secretBox.nonce, mac: secretBox.mac),
        secretKey: secretKey);

    final pwdEncrypted = base64.encode(secretBox.cipherText);

    final userBox = await Hive.openBox("rsi_account_data");
    await userBox.put("account_email", inputEmail);
    await userBox.put("account_pwd_encrypted", pwdEncrypted);
    await userBox.put("nonce", base64.encode(secretBox.nonce));
    await userBox.put("mac", base64.encode(secretBox.mac.bytes));

    final secretKeyStr = base64.encode((await secretKey.extractBytes()));

    Win32Credentials.write(
        credentialName: "SCToolbox_RSI_Account_secret",
        userName: inputEmail,
        password: secretKeyStr);
  }
}
