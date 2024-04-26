import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/rsi_game_library_data.dart';
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
    RsiGameLibraryData? libraryData,
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

  // ignore: avoid_build_context_in_providers
  Future<void> launchWebLogin(BuildContext context) async {
    final homeState = ref.read(homeUIModelProvider);
    if (!context.mounted) return;
    goWebView(context, S.current.home_action_login_rsi_account,
        "https://robertsspaceindustries.com/connect?jumpto=/connect",
        loginMode: true, rsiLoginCallback: (message, ok) async {
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
      final libraryData = RsiGameLibraryData.fromJson(data["libraryData"]);
      final avatarUrl = data["avatar"]
          ?.toString()
          .replaceAll("url(\"", "")
          .replaceAll("\")", "");
      final Map<String, dynamic> payload = Jwt.parseJwt(authToken!);
      final nickname = payload["nickname"] ?? "";

      state = state.copyWith(
        nickname: nickname,
        avatarUrl: avatarUrl,
        authToken: authToken,
        webToken: webToken,
        releaseInfo: releaseInfo,
        libraryData: libraryData,
      );

      final buildInfoFile =
          File("${homeState.scInstalledPath}\\build_manifest.id");
      if (await buildInfoFile.exists()) {
        final buildInfo =
            json.decode(await buildInfoFile.readAsString())["Data"];

        if (releaseInfo?["versionLabel"] != null &&
            buildInfo["RequestedP4ChangeNum"] != null) {
          if (!(releaseInfo!["versionLabel"]!
              .toString()
              .endsWith(buildInfo["RequestedP4ChangeNum"]!.toString()))) {
            if (!context.mounted) return;
            final ok = await showConfirmDialogs(
                context,
                S.current.home_login_info_game_version_outdated,
                Text(S.current.home_login_info_rsi_server_report(
                    releaseInfo?["versionLabel"],
                    buildInfo["RequestedP4ChangeNum"])),
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
            Text(
              S.current.home_login_info_one_click_launch_description,
              style: const TextStyle(fontSize: 16),
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
      await showToast(
          context, S.current.home_login_action_title_need_webview2_runtime);
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
    // dPrint("----------launch data ======  -----------\n$launchData");
    // dPrint(
    //     "----------executable data ======  -----------\n${homeState.scInstalledPath}\\$executable $launchOptions");

    final launchFile = File("${homeState.scInstalledPath}\\loginData.json");
    if (await launchFile.exists()) {
      await launchFile.delete();
    }
    await launchFile.create();
    await launchFile.writeAsString(json.encode(launchData));
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
    }
    return "PTU";
  }
}
