// ignore_for_file: avoid_build_context_in_providers
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

part 'settings_ui_model.g.dart';

part 'settings_ui_model.freezed.dart';

@freezed
abstract class SettingsUIState with _$SettingsUIState {
  factory SettingsUIState({
    @Default(false) bool isEnableToolSiteMirrors,
    @Default("0") String inputGameLaunchECore,
    String? customLauncherPath,
    String? customGamePath,
    @Default(0) int locationCacheSize,
    @Default(false) bool isUseInternalDNS,
    @Default(true) bool isEnableOnnxXnnPack,
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
    await _updateGameLaunchECore();
    await _loadCustomPath();
    await _loadLocationCacheSize();
    await _loadToolSiteMirrorState();
    await _loadUseInternalDNS();
    await _loadOnnxXnnPackState();
  }

  Future<void> setGameLaunchECore(BuildContext context) async {
    final userBox = await Hive.openBox("app_conf");
    final defaultInput = userBox.get("gameLaunch_eCore_count", defaultValue: "0");
    if (!context.mounted) return;
    final input = await showInputDialogs(
      context,
      title: S.current.setting_action_info_enter_cpu_core_to_ignore,
      content: S.current.setting_action_info_cpu_core_tip,
      initialValue: defaultInput,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
    if (input == null) return;
    userBox.put("gameLaunch_eCore_count", input);
    _initState();
  }

  Future _updateGameLaunchECore() async {
    final userBox = await Hive.openBox("app_conf");
    final inputGameLaunchECore = userBox.get("gameLaunch_eCore_count", defaultValue: "0");
    state = state.copyWith(inputGameLaunchECore: inputGameLaunchECore);
  }

  Future<void> setLauncherPath(BuildContext context) async {
    await showToast(context, S.current.setting_toast_select_launcher_exe);
    final r = await FilePicker.platform.pickFiles(
      dialogTitle: S.current.setting_action_info_select_rsi_launcher_location,
      type: FileType.custom,
      allowedExtensions: ["exe"],
      lockParentWindow: true,
    );
    if (r == null || r.files.firstOrNull?.path == null) return;
    final fileName = r.files.first.path!.platformPath;
    if (fileName.toLowerCase().endsWith('\\rsi launcher.exe'.platformPath)) {
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
    await showToast(context, S.current.setting_toast_select_game_file);
    final r = await FilePicker.platform.pickFiles(
      dialogTitle: S.current.setting_action_info_select_game_install_location,
      type: FileType.custom,
      allowedExtensions: ["exe"],
      lockParentWindow: true,
    );
    if (r == null || r.files.firstOrNull?.path == null) return;
    final fileName = r.files.first.path!.platformPath;
    dPrint(fileName);
    final fileNameRegExp = RegExp(
      r'^(.*[/\\]starcitizen[/\\].*[/\\])bin64[/\\]starcitizen\.exe$',
      caseSensitive: false,
    );
    if (fileNameRegExp.hasMatch(fileName)) {
      RegExp pathRegex = RegExp(r'[/\\][^/\\]+[/\\]bin64[/\\]starcitizen\.exe$', caseSensitive: false);
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

  Future<void> _saveCustomPath(String pathKey, String dir) async {
    final confBox = await Hive.openBox("app_conf");
    await confBox.put(pathKey, dir);
  }

  Future _loadCustomPath() async {
    final confBox = await Hive.openBox("app_conf");
    final customLauncherPath = confBox.get("custom_launcher_path");
    final customGamePath = confBox.get("custom_game_path");
    state = state.copyWith(customLauncherPath: customLauncherPath, customGamePath: customGamePath);
  }

  Future<void> delName(String key) async {
    final confBox = await Hive.openBox("app_conf");
    await confBox.delete(key);
    _initState();
  }

  Future _loadLocationCacheSize() async {
    final len1 = await SystemHelper.getDirLen("${appGlobalState.applicationSupportDir}/Localizations");
    final len2 = await SystemHelper.getDirLen("${appGlobalState.applicationSupportDir}/launcher_enhance_data");
    final locationCacheSize = len1 + len2;
    state = state.copyWith(locationCacheSize: locationCacheSize);
  }

  Future<void> cleanLocationCache(BuildContext context) async {
    final ok = await showConfirmDialogs(
      context,
      S.current.setting_action_info_confirm_clear_cache,
      Text(S.current.setting_action_info_clear_cache_warning),
    );
    if (ok == true) {
      final dir1 = Directory("${appGlobalState.applicationSupportDir}/Localizations");
      final dir2 = Directory("${appGlobalState.applicationSupportDir}/launcher_enhance_data");
      if (!context.mounted) return;
      if (await dir1.exists()) {
        if (!context.mounted) return;
        await dir1.delete(recursive: true).unwrap(context: context);
      }
      if (!context.mounted) return;
      if (await dir2.exists()) {
        if (!context.mounted) return;
        await dir2.delete(recursive: true).unwrap(context: context);
      }
      _initState();
    }
  }

  Future<void> addShortCut(BuildContext context) async {
    if (ConstConf.isMSE) {
      showToast(context, S.current.setting_action_info_microsoft_version_limitation);
      await Future.delayed(const Duration(seconds: 1));
      Process.run("explorer.exe", ["shell:AppsFolder"]);
      return;
    }
    dPrint(Platform.resolvedExecutable);
    final shortcutName = S.current.app_shortcut_name;
    try {
      await win32.createDesktopShortcut(targetPath: Platform.resolvedExecutable, shortcutName: shortcutName);
      if (!context.mounted) return;
      showToast(context, S.current.setting_action_info_shortcut_created);
    } catch (e) {
      dPrint("createDesktopShortcut error: $e");
      if (!context.mounted) return;
      showToast(context, "Failed to create shortcut: $e");
    }
  }

  Future _loadToolSiteMirrorState() async {
    final userBox = await Hive.openBox("app_conf");
    final isEnableToolSiteMirrors = userBox.get("isEnableToolSiteMirrors", defaultValue: false);
    state = state.copyWith(isEnableToolSiteMirrors: isEnableToolSiteMirrors);
  }

  void onChangeToolSiteMirror(bool? b) async {
    final userBox = await Hive.openBox("app_conf");
    final isEnableToolSiteMirrors = b == true;
    await userBox.put("isEnableToolSiteMirrors", isEnableToolSiteMirrors);
    _initState();
  }

  Future<void> showLogs() async {
    SystemHelper.openDir(getDPrintFile()?.absolute.path.replaceAll("/", "\\"), isFile: true);
  }

  void onChangeUseInternalDNS(bool? b) {
    final userBox = Hive.box("app_conf");
    userBox.put("isUseInternalDNS", b ?? false);
    _initState();
  }

  Future _loadUseInternalDNS() async {
    final userBox = await Hive.openBox("app_conf");
    final isUseInternalDNS = userBox.get("isUseInternalDNS", defaultValue: false);
    state = state.copyWith(isUseInternalDNS: isUseInternalDNS);
  }

  void onChangeOnnxXnnPack(bool? b) {
    final userBox = Hive.box("app_conf");
    userBox.put("isEnableOnnxXnnPack", b ?? true);
    _initState();
  }

  Future _loadOnnxXnnPackState() async {
    final userBox = await Hive.openBox("app_conf");
    final isEnableOnnxXnnPack = userBox.get("isEnableOnnxXnnPack", defaultValue: true);
    state = state.copyWith(isEnableOnnxXnnPack: isEnableOnnxXnnPack);
  }
}
