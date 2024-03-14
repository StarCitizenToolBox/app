import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cryptography/cryptography.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/common/win32/credentials.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/webview/webview.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

part 'home_game_login_dialog_ui_model.freezed.dart';

part 'home_game_login_dialog_ui_model.g.dart';

@freezed
class HomeGameLoginState with _$HomeGameLoginState {
  factory HomeGameLoginState({
    required int loginStatus,
    String? nickname,
    String? avatarUrl,
    String? authToken,
    String? webToken,
    Map? releaseInfo,
    String? installPath,
    bool? isDeviceSupportWinHello,
  }) = _LoginStatus;
}

@riverpod
class HomeGameLoginUIModel extends _$HomeGameLoginUIModel {
  @override
  HomeGameLoginState build() {
    return HomeGameLoginState(loginStatus: 0);
  }

  final LocalAuthentication _localAuth = LocalAuthentication();

  // ignore: avoid_build_context_in_providers
  Future<void> launchWebLogin(BuildContext context) async {
    final homeState = ref.read(homeUIModelProvider);
    final isDeviceSupportWinHello = await _localAuth.isDeviceSupported();
    state = state.copyWith(isDeviceSupportWinHello: isDeviceSupportWinHello);

    if (!context.mounted) return;
    goWebView(context, S.current.home_action_login_rsi_account,
        "https://robertsspaceindustries.com/connect", loginMode: true,
        rsiLoginCallback: (message, ok) async {
      // dPrint(
      //     "======rsiLoginCallback=== $ok ===== data==\n${json.encode(message)}");
      if (message == null || !ok) {
        Navigator.pop(context);
        return;
      }
      // final emailBox = await Hive.openBox("quick_login_email");
      final data = message["data"];
      final authToken = data["authToken"];
      final webToken = data["webToken"];
      final releaseInfo = data["releaseInfo"];
      final avatarUrl = data["avatar"]
          ?.toString()
          .replaceAll("url(\"", "")
          .replaceAll("\")", "");
      final Map<String, dynamic> payload = Jwt.parseJwt(authToken!);
      final nickname = payload["nickname"] ?? "";

      final inputEmail = data["inputEmail"];
      final inputPassword = data["inputPassword"];

      final userBox = await Hive.openBox("rsi_account_data");
      if (inputEmail != null && inputEmail != "") {
        await userBox.put("account_email", inputEmail);
      }
      state = state.copyWith(
        nickname: nickname,
        avatarUrl: avatarUrl,
        authToken: authToken,
        webToken: webToken,
        releaseInfo: releaseInfo,
      );

      if (isDeviceSupportWinHello) {
        if (await userBox.get("enable", defaultValue: true)) {
          if (inputEmail != null &&
              inputEmail != "" &&
              inputPassword != null &&
              inputPassword != "") {
            if (!context.mounted) return;
            final ok = await showConfirmDialogs(
                context,
                S.current.home_action_q_auto_password_fill_prompt,
                const Text(
                    "盒子将使用 PIN 与 Windows 凭据加密保存您的密码，密码只存储在您的设备中。\n\n当下次登录需要输入密码时，您只需授权PIN即可自动填充登录。"));
            if (ok == true) {
              if (await _localAuth.authenticate(
                      localizedReason:
                          S.current.home_login_info_enter_pin_to_encrypt) ==
                  true) {
                await _savePwd(inputEmail, inputPassword);
              }
            } else {
              await userBox.put("enable", false);
            }
          }
        }
      }

      final buildInfoFile =
          File("${homeState.scInstalledPath}\\build_manifest.id");
      if (await buildInfoFile.exists()) {
        final buildInfo =
            json.decode(await buildInfoFile.readAsString())["Data"];
        dPrint("buildInfo ======= $buildInfo");

        if (releaseInfo?["versionLabel"] != null &&
            buildInfo["RequestedP4ChangeNum"] != null) {
          if (!(releaseInfo!["versionLabel"]!
              .toString()
              .endsWith(buildInfo["RequestedP4ChangeNum"]!.toString()))) {
            if (!context.mounted) return;
            final ok = await showConfirmDialogs(
                context,
                S.current.home_login_info_game_version_outdated,
                Text(
                    "RSI 服务器报告版本号：${releaseInfo?["versionLabel"]} \n\n本地版本号：${buildInfo["RequestedP4ChangeNum"]} \n\n建议使用 RSI Launcher 更新游戏！"),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .4),
                cancel: S.current.home_login_info_action_ignore);
            if (ok == true) {
              if (!context.mounted) return;
              Navigator.pop(context);
              return;
            }
          }
        }
      }

      if (!context.mounted) return;
      _readyForLaunch(homeState, context);
    }, useLocalization: true, homeState: homeState);
  }

  // ignore: avoid_build_context_in_providers
  goWebView(BuildContext context, String title, String url,
      {bool useLocalization = false,
      bool loginMode = false,
      RsiLoginCallback? rsiLoginCallback,
      required HomeUIModelState homeState}) async {
    if (useLocalization) {
      const tipVersion = 2;
      final box = await Hive.openBox("app_conf");
      final skip = await box.get("skip_web_login_version", defaultValue: 0);
      if (skip != tipVersion) {
        if (!context.mounted) return;
        final ok = await showConfirmDialogs(
            context,
            S.current.home_login_action_title_box_one_click_launch,
            const Text(
              "本功能可以帮您更加便利的启动游戏。\n\n为确保账户安全 ，本功能使用汉化浏览器保留登录状态，且不会保存您的密码信息（除非你启用了自动填充功能）。"
              "\n\n使用此功能登录账号时请确保您的 SC汉化盒子 是从可信任的来源下载。",
              style: TextStyle(fontSize: 16),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6));
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
      if (!context.mounted) return;
      await showToast(context,
          S.current.home_login_action_title_need_webview2_runtime);
      if (!context.mounted) return;
      await launchUrlString(
          "https://developer.microsoft.com/en-us/microsoft-edge/webview2/");
      if (!context.mounted) return;
      Navigator.pop(context);
      return;
    }
    if (!context.mounted) return;
    final webViewModel = WebViewModel(context,
        loginMode: loginMode,
        loginCallback: rsiLoginCallback,
        loginChannel: getChannelID(homeState.scInstalledPath!));
    if (useLocalization) {
      try {
        await webViewModel
            .initLocalization(homeState.webLocalizationVersionsData!);
      } catch (_) {}
    }
    await Future.delayed(const Duration(milliseconds: 500));
    await webViewModel.initWebView(
      title: title,
      applicationSupportDir: appGlobalState.applicationSupportDir!,
      appVersionData: appGlobalState.networkVersionData!,
    );
    await webViewModel.launch(url, appGlobalState.networkVersionData!);
  }

  Future<void> _readyForLaunch(
      HomeUIModelState homeState,
      // ignore: avoid_build_context_in_providers
      BuildContext context) async {
    final userBox = await Hive.openBox("rsi_account_data");
    state = state.copyWith(loginStatus: 2);
    final launchData = {
      "username": userBox.get("account_email", defaultValue: ""),
      "token": state.webToken,
      "auth_token": state.authToken,
      "star_network": {
        "services_endpoint": state.releaseInfo?["servicesEndpoint"],
        "hostname": state.releaseInfo?["universeHost"],
        "port": state.releaseInfo?["universePort"],
      },
      "TMid": const Uuid().v4(),
    };
    final executable = state.releaseInfo?["executable"];
    final launchOptions = state.releaseInfo?["launchOptions"];
    dPrint("----------launch data ======  -----------\n$launchData");
    dPrint(
        "----------executable data ======  -----------\n${homeState.scInstalledPath}\\$executable $launchOptions");
    final launchFile = File("${homeState.scInstalledPath}\\loginData.json");
    if (await launchFile.exists()) {
      await launchFile.delete();
    }
    await launchFile.create();
    await launchFile.writeAsString(json.encode(launchData));
    await Future.delayed(const Duration(seconds: 1));

    await Future.delayed(const Duration(seconds: 3));
    final processorAffinity = await SystemHelper.getCpuAffinity();
    final homeUIModel = ref.read(homeUIModelProvider.notifier);
    if (!context.mounted) return;
    homeUIModel.doLaunchGame(
        context,
        '${homeState.scInstalledPath}\\$executable',
        ["-no_login_dialog", ...launchOptions.toString().split(" ")],
        homeState.scInstalledPath!,
        processorAffinity);
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  String getChannelID(String installPath) {
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
