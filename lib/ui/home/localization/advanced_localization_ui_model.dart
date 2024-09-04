import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/data/app_advanced_localization_data.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';

import 'advanced_localization_ui.json.dart';
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
    String? customizeGlobalIni,
    ScLocalizationData? apiLocalizationData,
    @Default(0) int p4kGlobalIniLines,
    @Default(0) int serverGlobalIniLines,
    @Default("") String errorMessage,
  }) = _AdvancedLocalizationUIState;
}

extension AdvancedLocalizationUIStateEx on AdvancedLocalizationUIState {
  Map<AppAdvancedLocalizationClassKeysDataMode, String> get typeNames => {
        AppAdvancedLocalizationClassKeysDataMode.localization:
            S.current.home_localization_advanced_action_mod_change_localization,
        AppAdvancedLocalizationClassKeysDataMode.unLocalization: S.current
            .home_localization_advanced_action_mod_change_un_localization,
        AppAdvancedLocalizationClassKeysDataMode.mixed:
            S.current.home_localization_advanced_action_mod_change_mixed,
        AppAdvancedLocalizationClassKeysDataMode.mixedNewline: S
            .current.home_localization_advanced_action_mod_change_mixed_newline,
      };
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
    state = state.copyWith(
        workingText: S.current.home_localization_advanced_msg_classifying);
    final m = await compute(_doClassIni, (
      ald,
      p4kGlobalIni,
      serverGlobalIni,
      S.current.home_localization_advanced_json_text_un_localization,
      S.current.home_localization_advanced_json_text_others
    ));
    final p4kGlobalIniLines = p4kGlobalIni.split("\n").length;
    final serverGlobalIniLines = serverGlobalIni.split("\n").length;
    state = state.copyWith(
        workingText: "",
        p4kGlobalIni: p4kGlobalIni,
        serverGlobalIni: serverGlobalIni,
        p4kGlobalIniLines: p4kGlobalIniLines,
        serverGlobalIniLines: serverGlobalIniLines,
        classMap: m);
  }

  void setCustomizeGlobalIni(String? data) async {
    state = state.copyWith(customizeGlobalIni: data);
    final localizationUIState = ref.read(localizationUIModelProvider);
    final localizationUIModel = ref.read(localizationUIModelProvider.notifier);
    await _init(localizationUIState, localizationUIModel);
  }

  static Map<String, AppAdvancedLocalizationClassKeysData> _doClassIni(
    (
      AppAdvancedLocalizationData ald,
      String p4kGlobalIni,
      String serverGlobalIni,
      String unLocalizationClassName,
      String othersClassName,
    ) v,
  ) {
    final (
      AppAdvancedLocalizationData ald,
      String p4kGlobalIni,
      String serverGlobalIni,
      String unLocalizationClassName,
      String othersClassName,
    ) = v;
    final unLocalization = AppAdvancedLocalizationClassKeysData(
      id: "un_localization",
      className: unLocalizationClassName,
      keys: [],
    )
      ..mode = AppAdvancedLocalizationClassKeysDataMode.unLocalization
      ..lockMod = true;
    final unClass = AppAdvancedLocalizationClassKeysData(
      id: "un_class",
      className: othersClassName,
      keys: [],
    );
    final classMap = <String, AppAdvancedLocalizationClassKeysData>{
      for (final keys in ald.classKeys!) keys.id ?? "": keys,
    };

    final p4kIniMap = readIniAsMap(p4kGlobalIni);
    final serverIniMap = readIniAsMap(serverGlobalIni);

    var regexList = classMap.values
        .expand((c) =>
            c.keys!.map((k) => MapEntry(c, RegExp(k, caseSensitive: false))))
        .toList();

    iniKeysLoop:
    for (var p4kIniKey in p4kIniMap.keys) {
      final serverValue = serverIniMap[p4kIniKey];
      if (serverValue == null || serverValue.trim().isEmpty) {
        final p4kValue = p4kIniMap[p4kIniKey] ?? "";
        if (p4kValue.trim().isNotEmpty) {
          unLocalization.valuesMap[p4kIniKey] = p4kValue;
        }
        continue iniKeysLoop;
      } else {
        for (var item in regexList) {
          if (p4kIniKey.startsWith(item.value)) {
            item.key.valuesMap[p4kIniKey] = serverValue;
            serverIniMap.remove(p4kIniKey);
            continue iniKeysLoop;
          }
        }
      }
    }
    if (serverIniMap.isNotEmpty) {
      for (var element in serverIniMap.keys) {
        unClass.valuesMap[element] = serverIniMap[element] ?? "";
      }
      classMap[unClass.id!] = unClass;
    }
    if (unLocalization.valuesMap.isNotEmpty) {
      classMap[unLocalization.id!] = unLocalization;
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
    return AppAdvancedLocalizationData.fromJson(advancedLocalizationJsonData);
  }

  Future<(String, String)> _readIni(LocalizationUIState localizationUIState,
      LocalizationUIModel localizationUIModel) async {
    return ("", "");
  }

  Future<String> readEnglishInI(String gameDir) async {
    // TODO read English p4kGlobalIni
    return "";
  }

  onChangeMod(AppAdvancedLocalizationClassKeysData item,
      AppAdvancedLocalizationClassKeysDataMode mode) async {
    if (item.lockMod) return;
    item.mode = mode;
    item.isWorking = true;
    final classMap =
        Map<String, AppAdvancedLocalizationClassKeysData>.from(state.classMap!);
    classMap[item.id!] = item;
    state = state.copyWith(classMap: classMap);

    final p4kIniMap = readIniAsMap(state.p4kGlobalIni!);
    final serverIniMap = readIniAsMap(state.serverGlobalIni!);
    final newValuesMap = <String, String>{};

    for (var kv in item.valuesMap.entries) {
      switch (mode) {
        case AppAdvancedLocalizationClassKeysDataMode.localization:
          newValuesMap[kv.key] = serverIniMap[kv.key] ?? "";
          break;
        case AppAdvancedLocalizationClassKeysDataMode.unLocalization:
          newValuesMap[kv.key] = p4kIniMap[kv.key] ?? "";
          break;
        case AppAdvancedLocalizationClassKeysDataMode.mixed:
          newValuesMap[kv.key] =
              "${serverIniMap[kv.key]} [${p4kIniMap[kv.key]}]";
          break;
        case AppAdvancedLocalizationClassKeysDataMode.mixedNewline:
          newValuesMap[kv.key] =
              "${serverIniMap[kv.key]}\\n${p4kIniMap[kv.key]}";
          break;
      }
      await Future.delayed(Duration.zero);
    }
    item.valuesMap = newValuesMap;
    item.isWorking = false;
    classMap[item.id!] = item;
    state = state.copyWith(classMap: classMap);
  }

  Future<bool> doInstall() async {
    AnalyticsApi.touch("advanced_localization_apply");
    state = state.copyWith(
        workingText:
            S.current.home_localization_advanced_msg_gen_localization_text);
    final classMap = state.classMap!;
    final globalIni = StringBuffer();
    for (var item in classMap.values) {
      for (var kv in item.valuesMap.entries) {
        globalIni.write("${kv.key}=${kv.value}\n");
        await Future.delayed(Duration.zero);
      }
    }
    state = state.copyWith(
        workingText:
            S.current.home_localization_advanced_msg_gen_localization_install);
    final localizationUIModel = ref.read(localizationUIModelProvider.notifier);
    await localizationUIModel.installFormString(
        globalIni, state.apiLocalizationData?.versionName ?? "-",
        advanced: true);
    state = state.copyWith(workingText: "");
    return true;
  }
}
