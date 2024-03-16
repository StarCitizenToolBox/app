// ignore_for_file: avoid_build_context_in_providers
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/common/win32/credentials.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

part 'settings_ui_model.g.dart';

part 'settings_ui_model.freezed.dart';

@freezed
class SettingsUIState with _$SettingsUIState {
  factory SettingsUIState({
    @Default(false) isDeviceSupportWinHello,
    @Default("-") String autoLoginEmail,
    @Default(false) bool isEnableAutoLogin,
    @Default(false) bool isEnableAutoLoginPwd,
    @Default(false) bool isEnableToolSiteMirrors,
    @Default("0") String inputGameLaunchECore,
    String? customLauncherPath,
    String? customGamePath,
    @Default(0) int locationCacheSize,
  }) = _SettingsUIState;
}

@riverpod
class SettingsUIModel extends _$SettingsUIModel {
  @override
  SettingsUIState build() {
    state = SettingsUIState();
    _initState();
    return state;
  }

  void _initState() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    final isDeviceSupportWinHello = await localAuth.isDeviceSupported();
    state = state.copyWith(isDeviceSupportWinHello: isDeviceSupportWinHello);
    _updateGameLaunchECore();
    if (ConstConf.isMSE) {
      _updateAutoLoginAccount();
    }
    _loadCustomPath();
    _loadLocationCacheSize();
    _loadToolSiteMirrorState();
  }

  Future<void> onResetAutoLogin(BuildContext context) async {
    final ok = await showConfirmDialogs(
        context,
        S.current.setting_action_info_confirm_reset_autofill,
        Text(S.current.setting_action_info_delete_local_account_warning));
    if (ok) {
      final userBox = await Hive.openBox("rsi_account_data");
      await userBox.deleteFromDisk();
      Win32Credentials.delete("SCToolbox_RSI_Account_secret");
      if (!context.mounted) return;

      showToast(context, S.current.setting_action_info_autofill_data_cleared);
      _initState();
    }
  }

  Future _updateAutoLoginAccount() async {
    final userBox = await Hive.openBox("rsi_account_data");
    final autoLoginEmail = userBox.get("account_email", defaultValue: "-");
    final isEnableAutoLogin = userBox.get("enable", defaultValue: true);
    final isEnableAutoLoginPwd =
        userBox.get("account_pwd_encrypted", defaultValue: "") != "";

    state = state.copyWith(
        autoLoginEmail: autoLoginEmail,
        isEnableAutoLogin: isEnableAutoLogin,
        isEnableAutoLoginPwd: isEnableAutoLoginPwd);
  }

  Future<void> setGameLaunchECore(BuildContext context) async {
    final userBox = await Hive.openBox("app_conf");
    final defaultInput =
        userBox.get("gameLaunch_eCore_count", defaultValue: "0");
    if (!context.mounted) return;
    final input = await showInputDialogs(context,
        title: S.current.setting_action_info_enter_cpu_core_to_ignore,
        content: S.current.setting_action_info_cpu_core_tip,
        initialValue: defaultInput,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly]);
    if (input == null) return;
    userBox.put("gameLaunch_eCore_count", input);
    _initState();
  }

  Future _updateGameLaunchECore() async {
    final userBox = await Hive.openBox("app_conf");
    final inputGameLaunchECore =
        userBox.get("gameLaunch_eCore_count", defaultValue: "0");
    state = state.copyWith(inputGameLaunchECore: inputGameLaunchECore);
  }

  Future<void> setLauncherPath(BuildContext context) async {
    final r = await FilePicker.platform.pickFiles(
        dialogTitle: S.current.setting_action_info_select_rsi_launcher_location,
        type: FileType.custom,
        allowedExtensions: ["exe"]);
    if (r == null || r.files.firstOrNull?.path == null) return;
    final fileName = r.files.first.path!;
    if (fileName.endsWith("\\RSI Launcher.exe")) {
      await _saveCustomPath("custom_launcher_path", fileName);
      if (!context.mounted) return;
      showToast(context, S.current.setting_action_info_setting_success);
      _initState();
    } else {
      if (!context.mounted) return;
      showToast(context, S.current.setting_action_info_file_error);
    }
  }

  Future<void> setGamePath(BuildContext context) async {
    final r = await FilePicker.platform.pickFiles(
        dialogTitle: S.current.setting_action_info_select_game_install_location,
        type: FileType.custom,
        allowedExtensions: ["exe"]);
    if (r == null || r.files.firstOrNull?.path == null) return;
    final fileName = r.files.first.path!;
    dPrint(fileName);
    final fileNameRegExp =
        RegExp(r"^(.*\\StarCitizen\\.*\\)Bin64\\StarCitizen\.exe$");
    if (fileNameRegExp.hasMatch(fileName)) {
      RegExp pathRegex = RegExp(r"\\[^\\]+\\Bin64\\StarCitizen\.exe$");
      String extractedPath = fileName.replaceFirst(pathRegex, '');
      await _saveCustomPath("custom_game_path", extractedPath);
      if (!context.mounted) return;
      showToast(context, S.current.setting_action_info_setting_success);
      _initState();
    } else {
      if (!context.mounted) return;
      showToast(context, S.current.setting_action_info_file_error);
    }
  }

  _saveCustomPath(String pathKey, String dir) async {
    final confBox = await Hive.openBox("app_conf");
    await confBox.put(pathKey, dir);
  }

  _loadCustomPath() async {
    final confBox = await Hive.openBox("app_conf");
    final customLauncherPath = confBox.get("custom_launcher_path");
    final customGamePath = confBox.get("custom_game_path");
    state = state.copyWith(
        customLauncherPath: customLauncherPath, customGamePath: customGamePath);
  }

  Future<void> delName(String key) async {
    final confBox = await Hive.openBox("app_conf");
    await confBox.delete(key);
    _initState();
  }

  _loadLocationCacheSize() async {
    final len = await SystemHelper.getDirLen(
        "${appGlobalState.applicationSupportDir}/Localizations");
    final locationCacheSize = len;
    state = state.copyWith(locationCacheSize: locationCacheSize);
  }

  Future<void> cleanLocationCache(BuildContext context) async {
    final ok = await showConfirmDialogs(
        context,
        S.current.setting_action_info_confirm_clear_cache,
        Text(S.current.setting_action_info_clear_cache_warning));
    if (ok == true) {
      final dir =
          Directory("${appGlobalState.applicationSupportDir}/Localizations");
      if (!context.mounted) return;
      await dir.delete(recursive: true).unwrap(context: context);
      _initState();
    }
  }

  Future<void> addShortCut(BuildContext context) async {
    if (ConstConf.isMSE) {
      showToast(
          context, S.current.setting_action_info_microsoft_version_limitation);
      await Future.delayed(const Duration(seconds: 1));
      Process.run("explorer.exe", ["shell:AppsFolder"]);
      return;
    }
    dPrint(Platform.resolvedExecutable);
    final shortCuntName = S.current.app_shortcut_name;
    final script = """
    \$targetPath = "${Platform.resolvedExecutable}";
    \$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::DesktopDirectory), "$shortCuntName");
    \$shell = New-Object -ComObject WScript.Shell
    \$shortcut = \$shell.CreateShortcut(\$shortcutPath)
    if (\$shortcut -eq \$null) {
        Write-Host "Failed to create shortcut."
    } else {
        \$shortcut.TargetPath = \$targetPath
        \$shortcut.Save()
        Write-Host "Shortcut created successfully."
    }
""";
    await Process.run(SystemHelper.powershellPath, [script]);
    if (!context.mounted) return;
    showToast(context, S.current.setting_action_info_shortcut_created);
  }

  _loadToolSiteMirrorState() async {
    final userBox = await Hive.openBox("app_conf");
    final isEnableToolSiteMirrors =
        userBox.get("isEnableToolSiteMirrors", defaultValue: false);
    state = state.copyWith(isEnableToolSiteMirrors: isEnableToolSiteMirrors);
  }

  void onChangeToolSiteMirror(bool? b) async {
    final userBox = await Hive.openBox("app_conf");
    final isEnableToolSiteMirrors = b == true;
    await userBox.put("isEnableToolSiteMirrors", isEnableToolSiteMirrors);
    _initState();
  }

  showLogs() async {
    SystemHelper.openDir(getDPrintFile()?.absolute.path.replaceAll("/", "\\"));
  }
}
