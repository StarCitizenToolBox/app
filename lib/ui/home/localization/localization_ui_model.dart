// ignore_for_file: avoid_build_context_in_providers
import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';
import 'package:starcitizen_doctor/generated/no_l10n_strings.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'localization_ui_model.g.dart';

part 'localization_ui_model.freezed.dart';

@freezed
class LocalizationUIState with _$LocalizationUIState {
  factory LocalizationUIState({
    String? selectedLanguage,
    Map<String, ScLocalizationData>? apiLocalizationData,
    @Default("") String workingVersion,
    MapEntry<bool, String>? patchStatus,
    List<String>? customizeList,
    @Default(false) bool enableCustomize,
  }) = _LocalizationUIState;
}

@riverpod
class LocalizationUIModel extends _$LocalizationUIModel {
  static const languageSupport = {
    "chinese_(simplified)": NoL10n.langZHS,
    "chinese_(traditional)": NoL10n.langZHT,
  };

  Directory get _downloadDir =>
      Directory("${appGlobalState.applicationSupportDir}\\Localizations");

  Directory getDownloadDir() => _downloadDir;

  Directory get _scDataDir =>
      Directory("${ref.read(homeUIModelProvider).scInstalledPath}\\data");

  File get _cfgFile => File("${_scDataDir.absolute.path}\\system.cfg");

  StreamSubscription? _customizeDirListenSub;

  String get _scInstallPath => ref.read(homeUIModelProvider).scInstalledPath!;

  @override
  LocalizationUIState build() {
    state = LocalizationUIState(selectedLanguage: languageSupport.keys.first);
    _init();
    return state;
  }

  Future<void> _init() async {
    if (_scInstallPath == "not_install") {
      return;
    }
    ref.onDispose(() {
      _customizeDirListenSub?.cancel();
      _customizeDirListenSub = null;
    });
    final appConfBox = await Hive.openBox("app_conf");
    final lang = await appConfBox.get("localization_selectedLanguage",
        defaultValue: languageSupport.keys.first);
    state = state.copyWith(selectedLanguage: lang);
    await _loadData();
  }

  final Map<String, Map<String, ScLocalizationData>>
      _allVersionLocalizationData = {};

  Future<void> _loadData() async {
    _allVersionLocalizationData.clear();
    await _updateStatus();
    for (var lang in languageSupport.keys) {
      final l = await Api.getScLocalizationData(lang).unwrap();
      if (l != null) {
        if (lang == state.selectedLanguage) {
          final apiLocalizationData = <String, ScLocalizationData>{};
          for (var element in l) {
            final isPTU = !_scInstallPath.contains("LIVE");
            if (isPTU && element.gameChannel == "PTU") {
              apiLocalizationData[element.versionName ?? ""] = element;
            } else if (!isPTU && element.gameChannel == "PU") {
              apiLocalizationData[element.versionName ?? ""] = element;
            }
          }
          state = state.copyWith(apiLocalizationData: apiLocalizationData);
        }
        final map = <String, ScLocalizationData>{};
        for (var element in l) {
          map[element.versionName ?? ""] = element;
        }
        _allVersionLocalizationData[lang] = map;
      }
    }
  }

  void checkUserCfg(BuildContext context) async {
    final userCfgFile = File("$_scInstallPath\\USER.cfg");
    if (await userCfgFile.exists()) {
      final cfgString = await userCfgFile.readAsString();
      if (cfgString.contains("g_language") &&
          !cfgString.contains("g_language=${state.selectedLanguage}")) {
        if (!context.mounted) return;
        final ok = await showConfirmDialogs(
            context,
            S.current.localization_info_remove_incompatible_translation_params,
            Text(S.current
                .localization_info_incompatible_translation_params_warning),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .35));
        if (ok == true) {
          var finalString = "";
          for (var item in cfgString.split("\n")) {
            if (!item.trim().startsWith("g_language")) {
              finalString = "$finalString$item\n";
            }
          }
          await userCfgFile.delete();
          await userCfgFile.create();
          await userCfgFile.writeAsString(finalString, flush: true);
          _loadData();
        }
      }
    }
  }

  Future<void> updateLangCfg(bool enable) async {
    final selectedLanguage = state.selectedLanguage!;
    final status = await _getLangCfgEnableLang(lang: selectedLanguage);
    final exists = await _cfgFile.exists();
    if (status == enable) {
      await _updateStatus();
      return;
    }
    StringBuffer newStr = StringBuffer();
    var str = <String>[];
    if (exists) {
      str = (await _cfgFile.readAsString()).replaceAll(" ", "").split("\n");
    }
    if (enable) {
      if (exists) {
        for (var value in str) {
          if (value.contains("sys_languages")) {
            value = "sys_languages=$selectedLanguage";
          } else if (value.contains("g_language")) {
            value = "g_language=$selectedLanguage";
          } else if (value.contains("g_languageAudio")) {
            value = "g_language=english";
          }
          if (value.trim().isNotEmpty) newStr.writeln(value);
        }
      }
      if (!newStr.toString().contains("sys_languages=$selectedLanguage")) {
        newStr.writeln("sys_languages=$selectedLanguage");
      }
      if (!newStr.toString().contains("g_language=$selectedLanguage")) {
        newStr.writeln("g_language=$selectedLanguage");
      }
      if (!newStr.toString().contains("g_languageAudio")) {
        newStr.writeln("g_languageAudio=english");
      }
    } else {
      if (exists) {
        for (var value in str) {
          if (value.contains("sys_languages=")) {
            continue;
          } else if (value.contains("g_language")) {
            continue;
          }
          newStr.writeln(value);
        }
      }
    }
    if (exists) await _cfgFile.delete(recursive: true);
    await _cfgFile.create(recursive: true);
    await _cfgFile.writeAsString(newStr.toString());
    await _updateStatus();
  }

  void goFeedback() {
    launchUrlString(URLConf.feedbackUrl);
  }

  VoidCallback? doDelIniFile() {
    return () async {
      final iniFile = File(
          "${_scDataDir.absolute.path}\\Localization\\${state.selectedLanguage}\\global.ini");
      if (await iniFile.exists()) await iniFile.delete();
      await updateLangCfg(false);
      await _updateStatus();
    };
  }

  void toggleCustomize() {
    state = state.copyWith(enableCustomize: !state.enableCustomize);
  }

  String getCustomizeFileName(String path) {
    return path.split("\\").last;
  }

  VoidCallback? doLocalInstall(String filePath) {
    if (state.workingVersion.isNotEmpty) return null;
    return () async {
      final f = File(filePath);
      if (!await f.exists()) return;
      state = state.copyWith(workingVersion: filePath);
      final str = await f.readAsString();
      await _installFormString(
          StringBuffer(str),
          S.current
              .localization_info_custom_file(getCustomizeFileName(filePath)));
      state = state.copyWith(workingVersion: "");
    };
  }

  _installFormString(StringBuffer globalIni, String versionName) async {
    final iniFile = File(
        "${_scDataDir.absolute.path}\\Localization\\${state.selectedLanguage}\\global.ini");
    if (versionName.isNotEmpty) {
      if (!globalIni.toString().endsWith("\n")) {
        globalIni.write("\n");
      }
      globalIni.write("_starcitizen_doctor_localization_version=$versionName");
    }

    /// write cfg
    if (await _cfgFile.exists()) {}

    /// write ini
    if (await iniFile.exists()) {
      await iniFile.delete();
    }
    await iniFile.create(recursive: true);
    await iniFile.writeAsString("\uFEFF${globalIni.toString().trim()}",
        flush: true);
    await updateLangCfg(true);
    await _updateStatus();
  }

  VoidCallback? doRemoteInstall(
      BuildContext context, ScLocalizationData value) {
    return () async {
      AnalyticsApi.touch("install_localization");

      final savePath =
          File("${_downloadDir.absolute.path}\\${value.versionName}.sclang");
      try {
        state = state.copyWith(workingVersion: value.versionName!);
        if (!await savePath.exists()) {
          // download
          await downloadLocalizationFile(savePath, value);
        } else {
          dPrint("use cache $savePath");
        }
        await Future.delayed(const Duration(milliseconds: 300));
        // check file
        final globalIni = await compute(readArchive, savePath.absolute.path);
        if (globalIni.isEmpty) {
          throw S.current.localization_info_corrupted_file;
        }
        await _installFormString(globalIni, value.versionName ?? "");
      } catch (e) {
        if (!context.mounted) return;
        await showToast(
            context, S.current.localization_info_installation_error(e));
        if (await savePath.exists()) await savePath.delete();
      }
      state = state.copyWith(workingVersion: "");
    };
  }

  Future<void> downloadLocalizationFile(
      File savePath, ScLocalizationData value) async {
    dPrint("downloading file to $savePath");
    final downloadUrl =
        "${URLConf.gitlabLocalizationUrl}/archive/${value.versionName}.tar.gz";
    final r = await RSHttp.get(downloadUrl);
    if (r.statusCode == 200 && r.data != null) {
      await savePath.writeAsBytes(r.data!);
    } else {
      throw "statusCode Error : ${r.statusCode}";
    }
  }

  static StringBuffer readArchive(String savePath) {
    final inputStream = InputFileStream(savePath);
    final archive =
        TarDecoder().decodeBytes(GZipDecoder().decodeBuffer(inputStream));
    StringBuffer globalIni = StringBuffer("");
    for (var element in archive.files) {
      if (element.name.contains("global.ini")) {
        for (var value
            in (element.rawContent?.readString() ?? "").split("\n")) {
          final tv = value.trim();
          if (tv.isNotEmpty) globalIni.writeln(tv);
        }
      }
    }
    archive.clear();
    return globalIni;
  }

  String? getScInstallPath() {
    return ref.read(homeUIModelProvider).scInstalledPath;
  }

  void selectLang(String v) async {
    state = state.copyWith(selectedLanguage: v);
    _loadData();
    final appConfBox = await Hive.openBox("app_conf");
    await appConfBox.put("localization_selectedLanguage", v);
  }

  VoidCallback? onBack(BuildContext context) {
    if (state.workingVersion.isNotEmpty) return null;
    return () {
      Navigator.pop(context);
    };
  }

  VoidCallback? doRefresh() {
    if (state.workingVersion.isNotEmpty) return null;
    return () {
      state = state.copyWith(apiLocalizationData: null);
      _loadData();
    };
  }

  _updateStatus() async {
    final patchStatus = MapEntry(
        await _getLangCfgEnableLang(lang: state.selectedLanguage!),
        await _getInstalledIniVersion(
            "${_scDataDir.absolute.path}\\Localization\\${state.selectedLanguage}\\global.ini"));
    state = state.copyWith(patchStatus: patchStatus);
  }

  Future<bool> _getLangCfgEnableLang({String lang = ""}) async {
    if (!await _cfgFile.exists()) return false;
    final str = (await _cfgFile.readAsString()).replaceAll(" ", "");
    return str.contains("sys_languages=$lang") &&
        str.contains("g_language=$lang") &&
        str.contains("g_languageAudio=english");
  }

  static Future<String> _getInstalledIniVersion(String iniPath) async {
    final iniFile = File(iniPath);
    if (!await iniFile.exists()) {
      return S.current.home_action_info_game_built_in;
    }
    final iniStringSplit = (await iniFile.readAsString()).split("\n");
    for (var i = iniStringSplit.length - 1; i > 0; i--) {
      if (iniStringSplit[i]
          .contains("_starcitizen_doctor_localization_version=")) {
        final v = iniStringSplit[i]
            .trim()
            .split("_starcitizen_doctor_localization_version=")[1];
        return v;
      }
    }
    return S.current.localization_info_custom_files;
  }

  Future<List<String>> checkLangUpdate({bool skipReload = false}) async {
    if (_scInstallPath == "not_install") {
      return [];
    }
    if (!skipReload || (state.apiLocalizationData?.isEmpty ?? true)) {
      await _init();
    }

    final homeState = ref.read(homeUIModelProvider);
    if (homeState.scInstallPaths.isEmpty) return [];

    List<String> updates = [];

    for (var scInstallPath in homeState.scInstallPaths) {
      // 读取游戏安装文件夹
      final scDataDir = Directory("$scInstallPath\\data\\Localization");
      // 扫描目录确认已安装的语言
      final dirList = await scDataDir.list().toList();
      for (var element in dirList) {
        for (var lang in languageSupport.keys) {
          if (element.path.contains(lang)) {
            final installedVersion =
                await _getInstalledIniVersion("${element.path}\\global.ini");
            if (installedVersion == S.current.home_action_info_game_built_in ||
                installedVersion == S.current.localization_info_custom_files) {
              continue;
            }
            final curData = _allVersionLocalizationData[lang];
            dPrint("check Localization update $scInstallPath");
            if (!(curData?.keys.contains(installedVersion) ?? false)) {
              // has update
              for (var channel in ConstConf.gameChannels) {
                if (scInstallPath.contains(channel)) {
                  dPrint("check Localization update: has update -> $channel");
                  updates.add(channel);
                }
              }
            } else {
              dPrint("check Localization update: up to date");
            }
          }
        }
      }
    }
    return updates;
  }
}
