// ignore_for_file: avoid_build_context_in_providers, use_build_context_synchronously
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/utils/app_hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/async.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/provider/download_manager.dart';
import 'package:starcitizen_doctor/ui/home/localization/localization_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/input_method/input_method_encoder.dart';
import 'package:starcitizen_doctor/ui/home/input_method/input_method_hotkey_service.dart';
import 'package:starcitizen_doctor/common/rust/api/ort_api.dart' as ort;

part 'input_method_dialog_ui_model.g.dart';

part 'input_method_dialog_ui_model.freezed.dart';

@freezed
abstract class InputMethodDialogUIState with _$InputMethodDialogUIState {
  factory InputMethodDialogUIState(
    Map<String, String>? keyMaps,
    Map<String, String>? worldMaps, {
    @Default(false) bool enableAutoCopy,
    @Default(false) bool isEnableAutoTranslate,
    @Default(false) bool isAutoTranslateWorking,
  }) = _InputMethodDialogUIState;
}

@riverpod
class InputMethodDialogUIModel extends _$InputMethodDialogUIModel {
  @override
  InputMethodDialogUIState build() {
    state = InputMethodDialogUIState(null, null);
    _init();
    return state;
  }

  Future<void> _init({bool skipUpdate = false}) async {
    final localizationState = ref.read(localizationUIModelProvider);
    final localizationModel = ref.read(localizationUIModelProvider.notifier);
    if (localizationState.installedCommunityInputMethodSupportVersion == null) {
      return;
    }
    if (!skipUpdate) await localizationModel.checkCommunityInputMethodUpdate();
    final keyMaps = await localizationModel.getCommunityInputMethodSupportData();
    dPrint("[InputMethodDialogUIModel] keyMapsLen: ${keyMaps?.length}");
    final worldMaps = keyMaps?.map((key, value) => MapEntry(value.trim(), key));
    final appBox = await AppHive.openBox("app_conf");
    final enableAutoCopy = appBox.get("enableAutoCopy", defaultValue: false);
    final isEnableAutoTranslate = appBox.get("isEnableAutoTranslate_v2", defaultValue: false);
    _checkAutoTranslateOnInit();
    state = state.copyWith(
      keyMaps: keyMaps,
      worldMaps: worldMaps,
      enableAutoCopy: enableAutoCopy,
      isEnableAutoTranslate: isEnableAutoTranslate,
    );
  }

  void onSwitchAutoCopy(bool value) async {
    final appBox = await AppHive.openBox("app_conf");
    appBox.put("enableAutoCopy", value);
    state = state.copyWith(enableAutoCopy: value);
  }

  String? onTextChange(String type, String str) {
    if (state.keyMaps == null || state.worldMaps == null) return null;
    if (type != "src") return "";
    final text = encodeCommunityInputMethod(str, state.worldMaps!).text;
    if (text.isEmpty) return "";
    _handleAutoCopy(text);
    return text;
  }

  Timer? _autoCopyTimer;

  // 打字结束后的1秒后自动复制，避免频繁复制
  void _handleAutoCopy(String text) {
    if (state.isEnableAutoTranslate) return;
    if (_autoCopyTimer != null) {
      _autoCopyTimer?.cancel();
      _autoCopyTimer = null;
    }
    if (!state.enableAutoCopy) return;
    _autoCopyTimer = Timer(const Duration(seconds: 1), () {
      if (state.enableAutoCopy) {
        dPrint("auto copy: $text");
        Clipboard.setData(ClipboardData(text: text));
      }
    });
  }

  TextEditingController? _srcTextCtrl;
  TextEditingController? _destTextCtrl;

  void setUpController(TextEditingController srcTextCtrl, TextEditingController destTextCtrl) {
    _srcTextCtrl = srcTextCtrl;
    _destTextCtrl = destTextCtrl;
  }

  // ignore: duplicate_ignore
  // ignore: avoid_build_context_in_providers
  Future<void> toggleAutoTranslate(bool b, {BuildContext? context}) async {
    state = state.copyWith(isEnableAutoTranslate: b);
    final appConf = await AppHive.openBox("app_conf");
    await appConf.put("isEnableAutoTranslate_v2", b);
    if (b) {
      await mountOnnxTranslationProvider(_localTranslateModelDir, _localTranslateModelName, context: context);
    }
    // The in-game quick input keeps the model loaded (or releases it) with this switch.
    if (ref.mounted) await ref.read(inputMethodHotkeyServiceProvider.notifier).syncTranslateModel();
  }

  Timer? _translateTimer;

  Future<void> checkAutoTranslate() async {
    final sourceText = _srcTextCtrl?.text ?? "";
    final content = _destTextCtrl?.text ?? "";
    if (sourceText.trim().isEmpty) return;
    if (state.isEnableAutoTranslate) {
      if (_translateTimer != null) _translateTimer?.cancel();
      state = state.copyWith(isAutoTranslateWorking: true);
      _translateTimer = Timer(Duration(milliseconds: 400), () async {
        try {
          final inputText = sourceText.replaceAll("\n", " ");
          final r = await doTranslateText(inputText);
          if (r != null) {
            String resultText = r;
            // resultText 首字母大写
            if (content.isNotEmpty) {
              final firstChar = resultText.characters.first;
              resultText = resultText.replaceFirst(firstChar, firstChar.toUpperCase());
            }
            _destTextCtrl?.text = "$content \n[en] $resultText";
            if (state.enableAutoCopy) {
              Clipboard.setData(ClipboardData(text: _destTextCtrl?.text ?? ""));
            }
          }
        } catch (e) {
          dPrint("[InputMethodDialogUIModel] AutoTranslate error: $e");
        }
        state = state.copyWith(isAutoTranslateWorking: false);
      });
    }
  }

  String get _localTranslateModelName => inputMethodTranslateModelName;

  String get _localTranslateModelDir => inputMethodTranslateModelDir(appGlobalState.applicationSupportDir!);

  OnnxTranslationProvider get _localTranslateModelProvider =>
      inputMethodTranslateModelProvider(_localTranslateModelDir);

  void _checkAutoTranslateOnInit() {
    // 检查模型文件是否存在，不存在则关闭自动翻译
    if (state.isEnableAutoTranslate) {
      checkLocalTranslateModelAvailable().then((available) {
        if (!available) {
          toggleAutoTranslate(false);
        }
      });
    }
  }

  Future<bool> checkLocalTranslateModelAvailable() => isInputMethodTranslateModelAvailable(_localTranslateModelDir);

  Future<String> doDownloadTranslateModel() async {
    state = state.copyWith(isAutoTranslateWorking: true);
    try {
      final downloadManager = ref.read(downloadManagerProvider.notifier);
      await downloadManager.initDownloader();

      if (await downloadManager.isNameInTask(_localTranslateModelName)) {
        throw Exception("Model is already downloading");
      }

      final l = await Api.getAppTorrentDataList();
      final modelTorrent = l.firstWhere(
        (element) => element.name == _localTranslateModelName,
        orElse: () => throw Exception("Model torrent not found"),
      );
      final torrentUrl = modelTorrent.url;
      if (torrentUrl?.isEmpty ?? true) {
        throw Exception("Get model torrent url failed");
      }
      // get torrent Data
      final data = await RSHttp.get(torrentUrl!);
      final taskId = await downloadManager.addTorrent(
        data.data!,
        outputFolder: "$_localTranslateModelDir/$_localTranslateModelName",
      );
      return taskId.toString();
    } catch (e) {
      dPrint("[InputMethodDialogUIModel] doDownloadTranslateModel error: $e");
      rethrow;
    } finally {
      state = state.copyWith(isAutoTranslateWorking: false);
    }
  }

  Future<void> mountOnnxTranslationProvider(
    String localTranslateModelDir,
    String localTranslateModelName, {
    BuildContext? context,
  }) async {
    if (!ref.exists(_localTranslateModelProvider)) {
      ref.listen(_localTranslateModelProvider, ((_, _) {}));
      final err = await ref.read(_localTranslateModelProvider.notifier).initModel();
      _handleTranslateModel(context, err);
    } else {
      // 重新加载
      final err = await ref.read(_localTranslateModelProvider.notifier).initModel();
      _handleTranslateModel(context, err);
    }
  }

  Future<void> _handleTranslateModel(BuildContext? context, String? err) async {
    if (err != null) {
      dPrint("[InputMethodDialogUIModel] mountOnnxTranslationProvider failed to init model");
      if (context != null) {
        if (!context.mounted) return;
        final userOK = await showConfirmDialogs(
          context,
          S.current.input_method_auto_translate_model_load_failed_title,
          Text(S.current.input_method_auto_translate_model_load_failed_content(err)),
        );
        if (userOK) {
          // 删除文件，并禁用开关
          final dir = Directory("$_localTranslateModelDir/$_localTranslateModelName");
          if (await dir.exists()) {
            await dir.delete(recursive: true);
            dPrint("[InputMethodDialogUIModel] Deleted local translate model files.");
            toggleAutoTranslate(false);
          }
        }
      } else {
        // 禁用开关
        toggleAutoTranslate(false);
      }
    }
  }

  Future<String?> doTranslateText(String text) async {
    if (!ref.exists(_localTranslateModelProvider)) {
      await mountOnnxTranslationProvider(_localTranslateModelDir, _localTranslateModelName);
    }
    final onnxTranslationState = ref.read(_localTranslateModelProvider);
    if (!onnxTranslationState) {
      return null;
    }
    try {
      final result = await ort.translateText(modelKey: _localTranslateModelName, text: text);
      return result;
    } catch (e) {
      dPrint("[InputMethodDialogUIModel] doTranslateText error: $e");
      return null;
    }
  }

  Future<bool> isTranslateModelDownloading() async {
    final downloadManager = ref.read(downloadManagerProvider.notifier);
    return await downloadManager.isNameInTask(_localTranslateModelName);
  }
}

/// Local zh -> en model used by the bilingual translation of the input method dialog and the
/// in-game hotkey popup.
const inputMethodTranslateModelName = "Opus-MT-StarCitizen-zh-en";

String inputMethodTranslateModelDir(String applicationSupportDir) => "$applicationSupportDir/onnx_models";

OnnxTranslationProvider inputMethodTranslateModelProvider(String modelDir) => onnxTranslationProvider(
  modelDir,
  inputMethodTranslateModelName,
  Hive.box("app_conf").get("isEnableOnnxXnnPack", defaultValue: true),
);

Future<bool> isInputMethodTranslateModelAvailable(String modelDir) async {
  const fileCheckList = [
    "config.json",
    "tokenizer.json",
    "vocab.json",
    "onnx/decoder_model_q4f16.onnx",
    "onnx/encoder_model_q4f16.onnx",
  ];
  for (final fileName in fileCheckList) {
    if (!await File("$modelDir/$inputMethodTranslateModelName/$fileName").exists()) return false;
  }
  return true;
}

@riverpod
class OnnxTranslation extends _$OnnxTranslation {
  @override
  bool build(String modelDir, String modelName, bool useXnnPack) {
    dPrint("[OnnxTranslation] Build provider for model: $modelName, useXnnPack: $useXnnPack");
    ref.onDispose(disposeModel);
    return false;
  }

  Future<String?> initModel() async {
    dPrint("[OnnxTranslation] Load model: $modelName from $modelDir, useXnnPack: $useXnnPack");
    String? errorMessage;
    try {
      await ort.loadTranslationModel(
        modelPath: "$modelDir/$modelName",
        modelKey: modelName,
        quantizationSuffix: "_q4f16",
        useXnnpack: useXnnPack,
      );
      if (!ref.mounted) {
        // Released while loading: the dispose hook already ran, so unload here.
        await ort.unloadTranslationModel(modelKey: modelName);
        return "disposed";
      }
      state = true;
    } catch (e) {
      dPrint("[OnnxTranslation] Load model error: $e");
      errorMessage = e.toString();
      if (ref.mounted) state = false;
    }
    return errorMessage;
  }

  Future<void> disposeModel() async {
    await ort.unloadTranslationModel(modelKey: modelName).unwrap();
    dPrint("[OnnxTranslation] Unload model: $modelName");
  }
}
