import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/app_advanced_localization_data.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';

import '../home_ui_model.dart';
import 'localization_ui_model.dart';

part 'advanced_localization_ui_model.g.dart';

part 'advanced_localization_ui_model.freezed.dart';

@freezed
class AdvancedLocalizationUIState with _$AdvancedLocalizationUIState {
  factory AdvancedLocalizationUIState({
    @Default("") String workingText,
    Map<String, AppAdvancedLocalizationClassKeysData>? classMap,
    String? p4kGlobalIni,
    String? serverGlobalIni,
  }) = _AdvancedLocalizationUIState;
}

@riverpod
class AdvancedLocalizationUIModel extends _$AdvancedLocalizationUIModel {
  @override
  AdvancedLocalizationUIState build() {
    final localizationUIState = ref.read(localizationUIModelProvider);
    final localizationUIModel = ref.read(localizationUIModelProvider.notifier);
    state = AdvancedLocalizationUIState(classMap: {});
    _init(localizationUIState, localizationUIModel);
    return state;
  }

  Future<void> _init(LocalizationUIState localizationUIState,
      LocalizationUIModel localizationUIModel) async {
    final (p4kGlobalIni, serverGlobalIni) =
        await _readIni(localizationUIState, localizationUIModel);
    final ald = await _readClassJson();
    if (ald.classKeys == null) return;
    state = state.copyWith(workingText: "正在分类 ...");
    final m = await compute(_doClassIni, (ald, p4kGlobalIni, serverGlobalIni));
    state = state.copyWith(
        workingText: "",
        p4kGlobalIni: p4kGlobalIni,
        serverGlobalIni: serverGlobalIni,
        classMap: m);
  }

  static Map<String, AppAdvancedLocalizationClassKeysData> _doClassIni(
    (
      AppAdvancedLocalizationData ald,
      String p4kGlobalIni,
      String serverGlobalIni
    ) v,
  ) {
    final (
      AppAdvancedLocalizationData ald,
      String p4kGlobalIni,
      String serverGlobalIni,
    ) = v;
    final unLocalization = AppAdvancedLocalizationClassKeysData(
      id: "un_localization",
      className: "未汉化",
      keys: [],
    );
    final unClass = AppAdvancedLocalizationClassKeysData(
      id: "un_class",
      className: "未分类",
      keys: [],
    );
    final classMap = <String, AppAdvancedLocalizationClassKeysData>{
      for (final keys in ald.classKeys!) keys.id ?? "": keys,
    };

    final p4kIniMap = readIniAsMap(p4kGlobalIni);
    final serverIniMap = readIniAsMap(serverGlobalIni);

    var regexList = classMap.values
        .expand((c) => c.keys!.map((k) => MapEntry(c, RegExp(k))))
        .toList();

    iniKeysLoop:
    for (var p4kIniKey in p4kIniMap.keys) {
      final serverValue = serverIniMap[p4kIniKey];
      if (serverValue == null) {
        unLocalization.valuesMap[p4kIniKey] = p4kIniMap[p4kIniKey] ?? "";
        continue iniKeysLoop;
      } else {
        for (var item in regexList) {
          if (item.value.hasMatch(p4kIniKey)) {
            item.key.valuesMap[p4kIniKey] = serverValue;
            serverIniMap.remove(p4kIniKey);
            continue iniKeysLoop;
          }
        }
      }
    }
    if (unLocalization.valuesMap.isNotEmpty) {
      classMap[unLocalization.id!] = unLocalization;
    }
    if (serverIniMap.isNotEmpty) {
      for (var element in serverIniMap.keys) {
        unClass.valuesMap[element] = serverIniMap[element] ?? "";
      }
      classMap[unClass.id!] = unClass;
    }
    return classMap;
  }

  static Map<String, String> readIniAsMap(String iniString) {
    final iniMap = <String, String>{};
    for (final line in iniString.split("\n")) {
      final index = line.indexOf("=");
      if (index == -1) continue;
      final key = line.substring(0, index).trim();
      final value = line.substring(index + 1).trim();
      iniMap[key] = value;
    }
    return iniMap;
  }

  Future<AppAdvancedLocalizationData> _readClassJson() async {
    final s = await rootBundle.loadString("assets/advanced_localization.json");
    return AppAdvancedLocalizationData.fromJson(json.decode(s));
  }

  Future<(String, String)> _readIni(LocalizationUIState localizationUIState,
      LocalizationUIModel localizationUIModel) async {
    final homeUIState = ref.read(homeUIModelProvider);
    final gameDir = homeUIState.scInstalledPath;
    if (gameDir == null) return ("", "");
    state = state.copyWith(workingText: "读取 p4k 文件 ...");
    final p4kGlobalIni = await readEnglishInI(gameDir);
    dPrint("read p4kGlobalIni => ${p4kGlobalIni.length}");
    state = state.copyWith(workingText: "获取汉化文本 ...");
    final apiLocalizationData =
        localizationUIState.apiLocalizationData?.values.firstOrNull;
    if (apiLocalizationData == null) return ("", "");
    final file = File(
        "${localizationUIModel.getDownloadDir().absolute.path}\\${apiLocalizationData.versionName}.sclang");
    if (!await file.exists()) {
      await localizationUIModel.downloadLocalizationFile(
          file, apiLocalizationData);
    }
    final serverGlobalIni =
        (await compute(LocalizationUIModel.readArchive, file.absolute.path))
            .toString();
    dPrint("read serverGlobalIni => ${serverGlobalIni.length}");
    return (p4kGlobalIni, serverGlobalIni);
  }

  Future<String> readEnglishInI(String gameDir) async {
    final data = await Unp4kCModel.unp4kTools(
        appGlobalState.applicationBinaryModuleDir!, [
      "extract_memory",
      "$gameDir\\Data.p4k",
      "Data\\Localization\\english\\global.ini"
    ]);
    final iniData = String.fromCharCodes(data);
    return iniData;
  }
}
