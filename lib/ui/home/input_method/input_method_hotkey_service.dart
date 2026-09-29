import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/rust/api/ime_hotkey_api.dart' as ime;
import 'package:starcitizen_doctor/common/rust/api/ort_api.dart' as ort;
import 'package:starcitizen_doctor/common/utils/app_hive.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/input_method/input_method_dialog_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/input_method/input_method_encoder.dart';
import 'package:starcitizen_doctor/ui/home/localization/localization_ui_model.dart';

part 'input_method_hotkey_service.freezed.dart';

part 'input_method_hotkey_service.g.dart';

/// What happens with the game chat box around a message.
enum InputMethodHotkeyChatMode {
  /// Enter to open the chat, then type (and Enter to send, which closes the chat).
  openBeforeSend,

  /// The user opened the chat: type (Enter to send, then Enter again to reopen the chat).
  keepOpen,

  /// The user opened the chat: type (and Enter to send, which closes the chat).
  closeAfterSend,
}

const _defaultHotkey = ime.ImeHotkey(vk: 0x0D, ctrl: true, alt: true, shift: false, win: false);

@freezed
abstract class InputMethodHotkeyState with _$InputMethodHotkeyState {
  const factory InputMethodHotkeyState({
    @Default(false) bool enabled,
    @Default(false) bool isRunning,
    @Default(false) bool isCapturing,
    @Default(_defaultHotkey) ime.ImeHotkey hotkey,
    @Default(true) bool gameOnly,
    @Default(true) bool autoSend,
    @Default(30) int keyIntervalMs,
    @Default(InputMethodHotkeyChatMode.openBeforeSend) InputMethodHotkeyChatMode chatMode,
    int? windowX,
    int? windowY,
    String? errorMessage,
  }) = _InputMethodHotkeyState;
}

/// Global hotkey popup for the community input method: owns the settings and answers the
/// popup's submit events with encoded text (issue #322).
@riverpod
class InputMethodHotkeyService extends _$InputMethodHotkeyService {
  static const _kEnabled = "input_method_hotkey_enabled";
  static const _kHotkey = "input_method_hotkey";
  static const _kGameOnly = "input_method_hotkey_game_only";
  static const _kAutoSend = "input_method_hotkey_auto_send";
  static const _kKeyInterval = "input_method_hotkey_key_interval";
  static const _kChatMode = "input_method_hotkey_chat_mode";
  static const _kWindowPos = "input_method_hotkey_window_pos";

  StreamSubscription<ime.ImeHotkeyEvent>? _sub;

  /// Char -> code table cache, keyed by `global.ini` path + modification time.
  String? _tableKey;
  Map<String, String>? _table;

  /// Text whose unsupported characters were already reported; a second Enter sends it anyway.
  String? _warnedText;

  @override
  InputMethodHotkeyState build() {
    ref.keepAlive();
    ref.onDispose(() {
      _sub?.cancel();
      _sub = null;
      if (Platform.isWindows) ime.imeHotkeyStop();
    });
    // The table lives in the game's global.ini, readable once the install path scan is done.
    ref.listen(homeUIModelProvider.select((s) => s.scInstalledPath), (_, _) {
      if (state.enabled) _loadTable();
    });
    _init();
    return const InputMethodHotkeyState();
  }

  Future<void> _init() async {
    if (!Platform.isWindows) return;
    final box = await AppHive.openBox("app_conf");
    final hotkeyMap = box.get(_kHotkey);
    final pos = box.get(_kWindowPos);
    state = state.copyWith(
      enabled: box.get(_kEnabled, defaultValue: false),
      hotkey: hotkeyMap is Map ? _hotkeyFromMap(hotkeyMap) : _defaultHotkey,
      gameOnly: box.get(_kGameOnly, defaultValue: true),
      autoSend: box.get(_kAutoSend, defaultValue: true),
      keyIntervalMs: box.get(_kKeyInterval, defaultValue: 30),
      chatMode:
          InputMethodHotkeyChatMode.values.asNameMap()[box.get(_kChatMode)] ?? InputMethodHotkeyChatMode.openBeforeSend,
      windowX: pos is List && pos.length == 2 ? pos[0] as int? : null,
      windowY: pos is List && pos.length == 2 ? pos[1] as int? : null,
    );
    if (state.enabled) {
      await _start();
      await _preload();
    }
  }

  /// Loads the code table and, with bilingual translation on, the translation model up front so
  /// the first message does not wait for them.
  Future<void> _preload() async {
    await _loadTable();
    await syncTranslateModel();
  }

  ime.ImeHotkey _hotkeyFromMap(Map m) {
    final vk = m["vk"];
    if (vk is! int || vk <= 0) return _defaultHotkey;
    return ime.ImeHotkey(
      vk: vk,
      ctrl: m["ctrl"] == true,
      alt: m["alt"] == true,
      shift: m["shift"] == true,
      win: m["win"] == true,
    );
  }

  Map<String, dynamic> _hotkeyToMap(ime.ImeHotkey h) => {
    "vk": h.vk,
    "ctrl": h.ctrl,
    "alt": h.alt,
    "shift": h.shift,
    "win": h.win,
  };

  String hotkeyDisplayName([ime.ImeHotkey? hotkey]) => ime.imeHotkeyDisplayName(hotkey: hotkey ?? state.hotkey);

  ime.ImeHotkeyConfig _config() => ime.ImeHotkeyConfig(
    hotkey: state.hotkey,
    gameOnly: state.gameOnly,
    keyIntervalMs: state.keyIntervalMs,
    openChatBeforeSend: state.chatMode == InputMethodHotkeyChatMode.openBeforeSend,
    autoSend: state.autoSend,
    reopenChatAfterSend: state.chatMode == InputMethodHotkeyChatMode.keepOpen,
    windowX: state.windowX,
    windowY: state.windowY,
    hintText: state.autoSend
        ? S.current.input_method_hotkey_popup_hint
        : S.current.input_method_hotkey_popup_hint_input_only,
    sendingText: S.current.input_method_hotkey_popup_sending,
  );

  /// Bumped per start/stop so callbacks of a replaced stream (the Rust side closes the old
  /// stream when it restarts) cannot mark the new session as stopped.
  int _session = 0;

  Future<void> _start() async {
    final session = ++_session;
    // Not awaited: cancelling the bridge stream subscription can stay pending forever; the
    // Rust side drops the old stream on restart anyway.
    _sub?.cancel();
    _sub = null;
    try {
      _sub = ime
          .imeHotkeyStart(config: _config())
          .listen(
            _onEvent,
            onError: (Object e) {
              if (session != _session) return;
              dPrint("[InputMethodHotkeyService] start error: $e");
              state = state.copyWith(isRunning: false, isCapturing: false, errorMessage: e.toString());
            },
            onDone: () {
              if (session != _session) return;
              state = state.copyWith(isRunning: false, isCapturing: false);
            },
          );
      state = state.copyWith(isRunning: true, errorMessage: null);
    } catch (e) {
      dPrint("[InputMethodHotkeyService] start error: $e");
      state = state.copyWith(isRunning: false, errorMessage: e.toString());
    }
  }

  Future<void> _stop() async {
    _session++;
    _sub?.cancel();
    _sub = null;
    await ime.imeHotkeyStop();
    state = state.copyWith(isRunning: false, isCapturing: false);
    _releaseTranslateModel();
  }

  Future<void> _pushConfig() async {
    if (state.isRunning) await ime.imeHotkeyUpdateConfig(config: _config());
  }

  Future<void> setEnabled(bool enabled) async {
    if (!Platform.isWindows) return;
    state = state.copyWith(enabled: enabled, errorMessage: null);
    final box = await AppHive.openBox("app_conf");
    await box.put(_kEnabled, enabled);
    if (enabled) {
      await _start();
      await _preload();
    } else {
      await _stop();
    }
  }

  Future<void> setGameOnly(bool gameOnly) async {
    state = state.copyWith(gameOnly: gameOnly);
    final box = await AppHive.openBox("app_conf");
    await box.put(_kGameOnly, gameOnly);
    await _pushConfig();
  }

  Future<void> setAutoSend(bool autoSend) async {
    state = state.copyWith(autoSend: autoSend);
    final box = await AppHive.openBox("app_conf");
    await box.put(_kAutoSend, autoSend);
    await _pushConfig();
  }

  Future<void> setKeyInterval(int ms) async {
    state = state.copyWith(keyIntervalMs: ms.clamp(5, 200));
    final box = await AppHive.openBox("app_conf");
    await box.put(_kKeyInterval, state.keyIntervalMs);
    await _pushConfig();
  }

  Future<void> setChatMode(InputMethodHotkeyChatMode mode) async {
    state = state.copyWith(chatMode: mode);
    final box = await AppHive.openBox("app_conf");
    await box.put(_kChatMode, mode.name);
    await _pushConfig();
  }

  Future<void> resetWindowPosition() async {
    state = state.copyWith(windowX: null, windowY: null);
    final box = await AppHive.openBox("app_conf");
    await box.delete(_kWindowPos);
    await _pushConfig();
  }

  /// The next key combination pressed is stored as the hotkey (Esc cancels).
  Future<void> beginCapture() async {
    if (!state.isRunning) return;
    await ime.imeHotkeyBeginCapture();
    state = state.copyWith(isCapturing: true);
  }

  Future<void> cancelCapture() async {
    await ime.imeHotkeyCancelCapture();
    state = state.copyWith(isCapturing: false);
  }

  Future<void> _onEvent(ime.ImeHotkeyEvent event) async {
    switch (event) {
      case ime.ImeHotkeyEvent_Submit(:final id, :final text):
        await _onSubmit(id, text);
      case ime.ImeHotkeyEvent_Sent():
        _warnedText = null;
      case ime.ImeHotkeyEvent_SendFailed(:final reason):
        await _showMessage(_failureText(reason), isError: true);
      case ime.ImeHotkeyEvent_WindowMoved(:final x, :final y):
        state = state.copyWith(windowX: x, windowY: y);
        final box = await AppHive.openBox("app_conf");
        await box.put(_kWindowPos, [x, y]);
      case ime.ImeHotkeyEvent_HotkeyCaptured(:final hotkey):
        state = state.copyWith(hotkey: hotkey, isCapturing: false);
        final box = await AppHive.openBox("app_conf");
        await box.put(_kHotkey, _hotkeyToMap(hotkey));
        await _pushConfig();
    }
  }

  Future<void> _onSubmit(BigInt id, String text) async {
    try {
      await _handleSubmit(id, text);
    } catch (e) {
      dPrint("[InputMethodHotkeyService] submit error: $e");
      await _showMessage(e.toString(), isError: true);
    }
  }

  Future<void> _showMessage(String message, {required bool isError, bool busy = false}) =>
      ime.imeHotkeyShowMessage(message: message, isError: isError, busy: busy);

  Future<void> _handleSubmit(BigInt id, String text) async {
    final table = await _loadTable();
    if (table == null || table.isEmpty) {
      await _showMessage(S.current.input_method_hotkey_error_no_table, isError: true);
      return;
    }
    final result = encodeCommunityInputMethod(text, table);
    if (result.text.isEmpty) {
      await _showMessage(S.current.input_method_hotkey_error_nothing_to_send, isError: true);
      return;
    }
    if (result.unsupported.isNotEmpty && _warnedText != text) {
      _warnedText = text;
      await _showMessage(S.current.input_method_hotkey_unsupported_chars(result.unsupported.join(" ")), isError: true);
      return;
    }
    var output = result.text;
    if (await _isTranslateEnabled()) {
      await _showMessage(S.current.input_method_hotkey_translating, isError: false, busy: true);
      final translated = await _translate(text);
      if (translated != null) {
        // Same format as the input method dialog, on one line since a typed newline would be
        // a key press in the game.
        output = "$output [en] $translated";
      } else if (_translateFailedText != text) {
        _translateFailedText = text;
        await _showMessage(S.current.input_method_hotkey_translate_failed, isError: true);
        return;
      }
    }
    _translateFailedText = null;
    await ime.imeHotkeySend(id: id, encoded: output);
  }

  /// Text whose translation failed; a second Enter sends it without the translation.
  String? _translateFailedText;

  /// Keeps the translation model loaded while the hotkey uses it.
  ProviderSubscription<bool>? _translateModelSub;
  OnnxTranslationProvider? _translateModelProvider;

  /// Follows the bilingual translation switch of the input method dialog.
  Future<bool> _isTranslateEnabled() async {
    final box = await AppHive.openBox("app_conf");
    return box.get("isEnableAutoTranslate_v2", defaultValue: false) == true;
  }

  void _releaseTranslateModel() {
    _translateModelSub?.close();
    _translateModelSub = null;
    _translateModelProvider = null;
  }

  /// Keeps the translation model loaded while quick input and bilingual translation are both
  /// on, and releases it otherwise. Called at startup and when either switch changes.
  Future<void> syncTranslateModel() async {
    if (state.enabled && await _isTranslateEnabled()) {
      await _ensureTranslateModel();
    } else {
      _releaseTranslateModel();
    }
  }

  Future<bool> _ensureTranslateModel() async {
    final modelDir = inputMethodTranslateModelDir(appGlobalState.applicationSupportDir!);
    if (!await isInputMethodTranslateModelAvailable(modelDir)) return false;
    final provider = inputMethodTranslateModelProvider(modelDir);
    if (provider != _translateModelProvider) {
      _translateModelSub?.close();
      _translateModelSub = ref.listen(provider, (_, _) {});
      _translateModelProvider = provider;
    }
    if (!ref.read(provider)) {
      final error = await ref.read(provider.notifier).initModel();
      if (error != null) return false;
    }
    return true;
  }

  Future<String?> _translate(String text) async {
    if (!await _ensureTranslateModel()) return null;
    try {
      final r = await ort.translateText(modelKey: inputMethodTranslateModelName, text: text.replaceAll("\n", " "));
      if (r.trim().isEmpty) return null;
      // 首字母大写，与输入法窗口一致
      return r.replaceFirst(r.characters.first, r.characters.first.toUpperCase());
    } catch (e) {
      dPrint("[InputMethodHotkeyService] translate error: $e");
      return null;
    }
  }

  String _failureText(ime.ImeSendFailure reason) => switch (reason) {
    ime.ImeSendFailure.targetWindowGone => S.current.input_method_hotkey_error_target_gone,
    ime.ImeSendFailure.focusFailed => S.current.input_method_hotkey_error_focus_failed,
    ime.ImeSendFailure.focusLost => S.current.input_method_hotkey_error_focus_lost,
    ime.ImeSendFailure.busy => S.current.input_method_hotkey_error_busy,
  };

  /// Reads the input method table the localization installed into the game's `global.ini`
  /// (the same data the input method dialog uses), inverted to character -> code.
  Future<Map<String, String>?> _loadTable() async {
    final scInstalledPath = ref.read(homeUIModelProvider).scInstalledPath;
    if (scInstalledPath == null || scInstalledPath == "not_install") return null;
    final box = await AppHive.openBox("app_conf");
    final lang = box.get("localization_selectedLanguage", defaultValue: LocalizationUIModel.languageSupport.keys.first);
    final file = File("$scInstalledPath\\data\\Localization\\$lang\\global.ini".platformPath);
    try {
      if (!await file.exists()) return null;
      final key = "${file.path}|${(await file.lastModified()).millisecondsSinceEpoch}";
      if (key == _tableKey) return _table;
      final keyMaps = LocalizationUIModel.parseCommunityInputMethodSupportData(await file.readAsString());
      _table = keyMaps?.map((key, value) => MapEntry(value.trim(), key));
      _tableKey = key;
      dPrint("[InputMethodHotkeyService] table loaded: ${_table?.length} entries");
      return _table;
    } catch (e) {
      dPrint("[InputMethodHotkeyService] load table error: $e");
      return null;
    }
  }
}
