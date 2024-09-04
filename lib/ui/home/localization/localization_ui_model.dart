// ignore_for_file: avoid_build_context_in_providers
import 'dart:async';
import 'package:archive/archive.dart';
import 'dart:js_interop';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';
import 'package:starcitizen_doctor/generated/no_l10n_strings.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:web/web.dart' as web;

part 'localization_ui_model.g.dart';

part 'localization_ui_model.freezed.dart';

@freezed
class LocalizationUIState with _$LocalizationUIState {
  factory LocalizationUIState({
    String? selectedLanguage,
    @Default("LIVE") String selectedChannel,
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

  StreamSubscription? _customizeDirListenSub;

  String get _scInstallPath => ref.read(homeUIModelProvider).scInstalledPath!;

  @override
  LocalizationUIState build() {
    state = LocalizationUIState(selectedLanguage: languageSupport.keys.first);
    _init();
    return state;
  }

  Future<void> _init() async {
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
    for (var lang in languageSupport.keys) {
      final l = await Api.getScLocalizationData(lang).unwrap();
      if (l != null) {
        if (lang == state.selectedLanguage) {
          final apiLocalizationData = <String, ScLocalizationData>{};
          for (var element in l) {
            final isPTU = !state.selectedChannel.contains("LIVE");
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

  Future<String> genLangCfg() async {
    final selectedLanguage = state.selectedLanguage!;
    StringBuffer newStr = StringBuffer();
    if (!newStr.toString().contains("sys_languages=$selectedLanguage")) {
      newStr.writeln("sys_languages=$selectedLanguage");
    }
    if (!newStr.toString().contains("g_language=$selectedLanguage")) {
      newStr.writeln("g_language=$selectedLanguage");
    }
    if (!newStr.toString().contains("g_languageAudio")) {
      newStr.writeln("g_languageAudio=english");
    }
    return newStr.toString();
  }

  void goFeedback() {
    launchUrlString(URLConf.feedbackUrl);
  }

  VoidCallback? doDelIniFile() {
    return () async {};
  }

  String getCustomizeFileName(String path) {
    return path.split("\\").last;
  }

  installFormString(StringBuffer globalIni, String versionName,
      {bool? advanced}) async {
    dPrint("LocalizationUIModel -> installFormString $versionName");

    if (versionName.isNotEmpty) {
      if (!globalIni.toString().endsWith("\n")) {
        globalIni.write("\n");
      }
      if (advanced ?? false) {
        globalIni.write("_starcitizen_doctor_localization_advanced=true\n");
      }
      globalIni
          .write("_starcitizen_doctor_localization_version=$versionName\n");
    }
    final selectedLanguage = state.selectedLanguage!;
    final iniFileString = "\uFEFF${globalIni.toString().trim()}";
    final cfg = await genLangCfg();
    final archive = Archive();
    archive.addFile(ArchiveFile(
        "data/Localization/$selectedLanguage/global.ini", 0, iniFileString));
    archive.addFile(ArchiveFile("data/system.cfg", 0, cfg));
    final zip = await compute(_encodeZipFile, archive);
    if (zip == null) return;
    final blob = Blob.fromBytes(zip, opt: {
      "type": "application/zip",
    });
    final url = web.URL.createObjectURL(blob);
    jsDownloadBlobFile(url, "Localization_$versionName.zip");
  }

  List<int>? _encodeZipFile(Archive archive) {
    final zip = ZipEncoder().encode(archive);
    return zip;
  }

  VoidCallback? doRemoteInstall(
      BuildContext context, ScLocalizationData value) {
    return () async {
      // AnalyticsApi.touch("install_localization");

      // final savePath =
      //     File("${_downloadDir.absolute.path}\\${value.versionName}.sclang");
      try {
        state = state.copyWith(workingVersion: value.versionName!);
        final data = await downloadLocalizationFile(value);
        await Future.delayed(const Duration(milliseconds: 300));
        // check file
        final globalIni = await compute(readArchive, data);
        if (globalIni.isEmpty) {
          throw S.current.localization_info_corrupted_file;
        }
        await installFormString(globalIni, value.versionName ?? "");
      } catch (e) {
        if (!context.mounted) return;
        await showToast(
            context, S.current.localization_info_installation_error(e));
      }
      state = state.copyWith(workingVersion: "");
    };
  }

  Future<Uint8List> downloadLocalizationFile(ScLocalizationData value) async {
    dPrint("downloading downloadLocalizationFile ...");
    final downloadUrl =
        "${URLConf.gitlabLocalizationUrl}/archive/${value.versionName}.tar.gz";
    final r = await RSHttp.get(downloadUrl);
    if (r.statusCode == 200 && r.data != null) {
      return r.data!;
    } else {
      throw "statusCode Error : ${r.statusCode}";
    }
  }

  static StringBuffer readArchive(Uint8List data) {
    final archive = TarDecoder().decodeBytes(GZipDecoder().decodeBytes(data));
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
    return updates;
  }

  void selectChannel(String v) {
    state = state.copyWith(selectedChannel: v);
    _loadData();
  }
}

@JS("Blob")
extension type Blob._(JSObject _) implements JSObject {
  external factory Blob(JSArray<JSArrayBuffer> blobParts, JSAny? options);

  factory Blob.fromBytes(List<int> bytes, {Map? opt}) {
    final data = Uint8List.fromList(bytes).buffer.toJS;

    return Blob([data].toJS, opt?.jsify());
  }

  external JSArrayBuffer? get blobParts;

  external JSObject? get options;
}

@JS()
external void jsDownloadBlobFile(String blobUrl, String filename);
