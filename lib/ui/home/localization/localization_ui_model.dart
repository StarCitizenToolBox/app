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
import 'package:starcitizen_doctor/data/input_method_api_data.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';
import 'package:starcitizen_doctor/generated/no_l10n_strings.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;

part 'localization_ui_model.g.dart';

part 'localization_ui_model.freezed.dart';

@freezed
class LocalizationUIState with _$LocalizationUIState {
  factory LocalizationUIState({
    String? selectedLanguage,
    String? installedCommunityInputMethodSupportVersion,
    InputMethodApiLanguageData? communityInputMethodLanguageData,
    Map<String, ScLocalizationData>? apiLocalizationData,
    @Default("") String workingVersion,
    MapEntry<bool, String>? patchStatus,
    bool? isInstalledAdvanced,
    List<String>? customizeList,
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

  Future<void> _loadCommunityInputMethodData() async {
    try {
      final data = await Api.getCommunityInputMethodIndexData();
      if (data.enable ?? false) {
        final lang = state.selectedLanguage;
        if (lang != null) {
          final l = data.languages?[lang];
          if (l != null) {
            state = state.copyWith(communityInputMethodLanguageData: l);
            dPrint("loadCommunityInputMethodData: ${l.toJson()}");
          }
        }
      }
    } catch (e) {
      dPrint("loadCommunityInputMethodData error: $e");
    }
  }

  Future<void> _loadData() async {
    _allVersionLocalizationData.clear();
    await _updateStatus();
    await _loadCommunityInputMethodData();
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

  String getCustomizeFileName(String path) {
    return path.split("\\").last;
  }

  Future<void> installFormString(
    StringBuffer globalIni,
    String versionName, {
    bool? advanced,
    bool isEnableCommunityInputMethod = false,
  }) async {
    dPrint("LocalizationUIModel -> installFormString $versionName");
    final iniFile = File(
        "${_scDataDir.absolute.path}\\Localization\\${state.selectedLanguage}\\global.ini");
    if (versionName.isNotEmpty) {
      if (!globalIni.toString().endsWith("\n")) {
        globalIni.write("\n");
      }
      String? communityInputMethodVersion;
      String? communityInputMethodSupportData;

      if (isEnableCommunityInputMethod) {
        final data = state.communityInputMethodLanguageData;
        if (data != null) {
          communityInputMethodVersion = data.version;
          final str =
              await downloadOrGetCachedCommunityInputMethodSupportFile(data);
          if (str.trim().isNotEmpty) {
            communityInputMethodSupportData = str;
          }
        }
      }

      if (communityInputMethodVersion != null) {
        globalIni.write(
            "_starcitizen_doctor_localization_community_input_method_version=$communityInputMethodVersion\n");
      }
      if (communityInputMethodSupportData != null) {
        for (var line in communityInputMethodSupportData.split("\n")) {
          globalIni.write("$line\n");
        }
      }
      if (advanced ?? false) {
        globalIni.write("_starcitizen_doctor_localization_advanced=true\n");
      }
      globalIni
          .write("_starcitizen_doctor_localization_version=$versionName\n");
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

  Future<Map<String, String>?> getCommunityInputMethodSupportData() async {
    final iniPath =
        "${_scDataDir.absolute.path}\\Localization\\${state.selectedLanguage}\\global.ini";
    final iniFile = File(iniPath);
    if (!await iniFile.exists()) {
      return {};
    }
    final iniStringSplit = (await iniFile.readAsString()).split("\n");
    final communityInputMethodSupportData = <String, String>{};
    var b = false;
    for (var i = 0; i < iniStringSplit.length; i++) {
      final line = iniStringSplit[i];

      if (line.trim().startsWith(
          "_starcitizen_doctor_localization_community_input_method_version=")) {
        b = true;
        continue;
      } else if (line
          .trim()
          .startsWith("_starcitizen_doctor_localization_version=")) {
        b = false;
        return communityInputMethodSupportData;
      } else if (b) {
        final kv = line.split("=");
        if (kv.length == 2) {
          communityInputMethodSupportData[kv[0]] = kv[1];
        }
      }
    }
    return null;
  }

  Future<(String, String)>
      getIniContentWithoutCommunityInputMethodSupportData() async {
    final iniPath =
        "${_scDataDir.absolute.path}\\Localization\\${state.selectedLanguage}\\global.ini";
    final iniFile = File(iniPath);
    if (!await iniFile.exists()) {
      return ("", "");
    }
    final iniStringSplit = (await iniFile.readAsString()).split("\n");
    final sb = StringBuffer();
    var b = false;
    for (var i = 0; i < iniStringSplit.length; i++) {
      final line = iniStringSplit[i];

      if (line.trim().startsWith(
          "_starcitizen_doctor_localization_community_input_method_version=")) {
        b = true;
        continue;
      } else if (line
          .trim()
          .startsWith("_starcitizen_doctor_localization_version=")) {
        b = false;
        return (sb.toString(), line.split("=").last.trim());
      } else if (!b) {
        sb.writeln(line);
      }
    }
    return ("", "");
  }

  Future? doRemoteInstall(BuildContext context, ScLocalizationData value,
      {bool isEnableCommunityInputMethod = false}) async {
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
      await installFormString(
        globalIni,
        value.versionName ?? "",
        isEnableCommunityInputMethod: isEnableCommunityInputMethod,
      );
    } catch (e) {
      if (!context.mounted) return;
      await showToast(
          context, S.current.localization_info_installation_error(e));
      if (await savePath.exists()) await savePath.delete();
    }
    state = state.copyWith(workingVersion: "");
  }

  Future<String> downloadOrGetCachedCommunityInputMethodSupportFile(
      InputMethodApiLanguageData communityInputMethodData) async {
    final lang = state.selectedLanguage ?? "_";
    final box = await Hive.openBox("community_input_method_data");
    final cachedVersion = box.get("${lang}_version");

    if (cachedVersion != communityInputMethodData.version) {
      final data = await Api.getCommunityInputMethodData(
          communityInputMethodData.file ?? "");
      await box.put("${lang}_data", data);
      return data;
    }
    return box.get("${lang}_data").toString();
  }

  Future<void> downloadLocalizationFile(
      File savePath, ScLocalizationData value) async {
    dPrint("downloading file to $savePath");
    final downloadUrl =
        "${URLConf.gitlabLocalizationUrl}/archive/${value.versionName}.tar.gz";
    final r = await RSHttp.get(downloadUrl);
    if (r.statusCode == 200 && r.data != null) {
      await savePath.create(recursive: true);
      await savePath.writeAsBytes(r.data!, flush: true);
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
          if (tv.isNotEmpty) globalIni.writeln(value);
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
    state = state.copyWith(
        selectedLanguage: v, communityInputMethodLanguageData: null);
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
    final iniPath =
        "${_scDataDir.absolute.path}\\Localization\\${state.selectedLanguage}\\global.ini";
    final patchStatus = MapEntry(
        await _getLangCfgEnableLang(lang: state.selectedLanguage!),
        await _getInstalledIniVersion(iniPath));
    final isInstalledAdvanced = await _checkAdvancedStatus(iniPath);
    final installedCommunityInputMethodSupportVersion =
        await getInstalledCommunityInputMethodSupportVersion(iniPath);

    dPrint(
        "_updateStatus updateStatus: $patchStatus , isInstalledAdvanced: $isInstalledAdvanced ,installedCommunityInputMethodSupportVersion: $installedCommunityInputMethodSupportVersion");

    state = state.copyWith(
      patchStatus: patchStatus,
      isInstalledAdvanced: isInstalledAdvanced,
      installedCommunityInputMethodSupportVersion:
          installedCommunityInputMethodSupportVersion,
    );
  }

  Future<String?> getInstalledCommunityInputMethodSupportVersion(
      String path) async {
    final iniFile = File(path);
    if (!await iniFile.exists()) {
      return null;
    }
    final iniStringSplit = (await iniFile.readAsString()).split("\n");
    for (var i = iniStringSplit.length - 1; i > 0; i--) {
      if (iniStringSplit[i].contains(
          "_starcitizen_doctor_localization_community_input_method_version=")) {
        final v = iniStringSplit[i].trim().split(
            "_starcitizen_doctor_localization_community_input_method_version=")[1];
        return v;
      }
    }
    return null;
  }

  Future<bool> _checkAdvancedStatus(String path) async {
    final iniFile = File(path);
    if (!await iniFile.exists()) {
      return false;
    }
    final iniString = (await iniFile.readAsString());
    return iniString.contains("_starcitizen_doctor_localization_advanced=true");
  }

  Future<bool> _getLangCfgEnableLang(
      {String lang = "", String gamePath = ""}) async {
    if (gamePath.isEmpty) {
      gamePath = _scInstallPath;
    }
    final cfgFile = File("${_scDataDir.absolute.path}\\system.cfg");
    if (!await cfgFile.exists()) return false;
    final str = (await cfgFile.readAsString()).replaceAll(" ", "");
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
          if (element.path.contains(lang) &&
              await _getLangCfgEnableLang(
                  lang: lang, gamePath: scInstallPath)) {
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
    await checkCommunityInputMethodUpdate();
    return updates;
  }

  Future<void> checkCommunityInputMethodUpdate() async {
    final cloudVersion = state.communityInputMethodLanguageData?.version;
    final localVersion = state.installedCommunityInputMethodSupportVersion;
    if (cloudVersion == null || localVersion == null) return;
    if (localVersion != cloudVersion) {
      // 版本不一致，自动检查更新
      final (localIniString, versioName) =
          await getIniContentWithoutCommunityInputMethodSupportData();
      if (localIniString.trim().isEmpty) {
        dPrint(
            "[InputMethodDialogUIModel] check update Error localIniString is empty");
        return;
      }
      await installFormString(StringBuffer(localIniString), versioName,
          isEnableCommunityInputMethod: true);
      await win32.sendNotify(
          summary: S.current.input_method_support_updated,
          body: S.current.input_method_support_updated_to_version(cloudVersion),
          appName: S.current.home_title_app_name,
          appId: ConstConf.isMSE
              ? "56575xkeyC.MSE_bsn1nexg8e4qe!starcitizendoctor"
              : "{6D809377-6AF0-444B-8957-A3773F02200E}\\Starcitizen_Doctor\\starcitizen_doctor.exe");
    }
  }

  Future<void> onChangeGameInstallPath(String value) async {
    await _loadData();
  }

  Future<void> onRemoteInsTall(
      BuildContext context,
      MapEntry<String, ScLocalizationData> item,
      LocalizationUIState state) async {
    bool enableCommunityInputMethod =
        state.communityInputMethodLanguageData != null;
    final userOK = await showConfirmDialogs(
      context,
      "${item.value.info}",
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.localization_info_version_number(
                    item.value.versionName ?? ""),
                style: TextStyle(color: Colors.white.withOpacity(.6)),
              ),
              const SizedBox(height: 4),
              Text(
                S.current
                    .localization_info_channel(item.value.gameChannel ?? ""),
                style: TextStyle(color: Colors.white.withOpacity(.6)),
              ),
              const SizedBox(height: 4),
              Text(
                S.current
                    .localization_info_update_time(item.value.updateAt ?? ""),
                style: TextStyle(color: Colors.white.withOpacity(.6)),
              ),
              const SizedBox(height: 12),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor,
                borderRadius: BorderRadius.circular(7)),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.value.note ?? S.current.home_localization_msg_no_note,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                S.current.input_method_install_community_input_method_support,
              ),
              Spacer(),
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return ToggleSwitch(
                    checked: enableCommunityInputMethod,
                    onChanged: state.communityInputMethodLanguageData == null
                        ? null
                        : (v) {
                            enableCommunityInputMethod = v;
                            setState(() {});
                          },
                  );
                },
              )
            ],
          )
        ],
      ),
      confirm: S.current.localization_action_install,
      cancel: S.current.home_action_cancel,
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .45),
    );
    if (userOK) {
      if (!context.mounted) return;
      dPrint("doRemoteInstall ${item.value} $enableCommunityInputMethod");
      await doRemoteInstall(context, item.value,
          isEnableCommunityInputMethod: enableCommunityInputMethod);
    }
  }

  Future<void> checkReinstall(BuildContext context) async {
    final installedVersion = state.patchStatus?.value;
    if (installedVersion == null) return;
    final curData = state.apiLocalizationData;
    if (curData == null) return;
    if (curData.keys.contains(installedVersion)) {
      final data = curData[installedVersion];
      if (data != null) {
        await onRemoteInsTall(context, MapEntry(installedVersion, data), state);
      }
    }
  }
}
