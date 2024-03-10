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
  const factory SettingsUIState({
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
    state = const SettingsUIState();
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
    final ok = await showConfirmDialogs(context, "确认重置自动填充？",
        const Text("这将会删除本地的账号记录，或在下次启动游戏时将自动填充选择 ‘否’ 以禁用自动填充。"));
    if (ok) {
      final userBox = await Hive.openBox("rsi_account_data");
      await userBox.deleteFromDisk();
      Win32Credentials.delete("SCToolbox_RSI_Account_secret");
      if (!context.mounted) return;

      showToast(context, "已清理自动填充数据");
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
        title: "请输入要忽略的 CPU 核心数",
        content:
            "Tip：您的设备拥有几个能效核心就输入几，非大小核设备请保持 0\n\n此功能适用于首页的盒子一键启动 或 工具中的 RSI启动器管理员模式，当为 0 时不启用此功能。",
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
        dialogTitle: "请选择RSI启动器位置（RSI Launcher.exe）",
        type: FileType.custom,
        allowedExtensions: ["exe"]);
    if (r == null || r.files.firstOrNull?.path == null) return;
    final fileName = r.files.first.path!;
    if (fileName.endsWith("\\RSI Launcher.exe")) {
      await _saveCustomPath("custom_launcher_path", fileName);
      if (!context.mounted) return;
      showToast(context, "设置成功，在对应页面点击刷新即可扫描出新路径");
      _initState();
    } else {
      if (!context.mounted) return;
      showToast(context, "文件有误！");
    }
  }

  Future<void> setGamePath(BuildContext context) async {
    final r = await FilePicker.platform.pickFiles(
        dialogTitle: "请选择游戏安装位置（StarCitizen.exe）",
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
      showToast(context, "设置成功，在对应页面点击刷新即可扫描出新路径");
      _initState();
    } else {
      if (!context.mounted) return;
      showToast(context, "文件有误！");
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
        context, "确认清理汉化缓存？", const Text("这不会影响已安装的汉化。"));
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
      showToast(context, "因微软版功能限制，请在接下来打开的窗口中 手动将《SC汉化盒子》拖动到桌面，即可创建快捷方式。");
      await Future.delayed(const Duration(seconds: 1));
      Process.run("explorer.exe", ["shell:AppsFolder"]);
      return;
    }
    dPrint(Platform.resolvedExecutable);
    final script = """
    \$targetPath = "${Platform.resolvedExecutable}";
    \$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::DesktopDirectory), "SC汉化盒子DEV.lnk");
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
    showToast(context, "创建完毕，请返回桌面查看");
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
