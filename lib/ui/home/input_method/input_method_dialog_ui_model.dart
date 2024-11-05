import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/ui/home/localization/localization_ui_model.dart';

part 'input_method_dialog_ui_model.g.dart';

part 'input_method_dialog_ui_model.freezed.dart';

@freezed
class InputMethodDialogUIState with _$InputMethodDialogUIState {
  factory InputMethodDialogUIState(
    Map<String, String>? keyMaps,
    Map<String, String>? worldMaps, {
    @Default(false) bool enableAutoCopy,
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

  _init() async {
    final localizationState = ref.watch(localizationUIModelProvider);
    final localizationModel = ref.read(localizationUIModelProvider.notifier);
    if (localizationState.installedCommunityInputMethodSupportVersion == null) {
      return;
    }
    final keyMaps =
        await localizationModel.getCommunityInputMethodSupportData();
    dPrint("[InputMethodDialogUIModel] keyMapsLen: ${keyMaps?.length}");
    final worldMaps = keyMaps?.map((key, value) => MapEntry(value.trim(), key));
    final appBox = await Hive.openBox("app_conf");
    final enableAutoCopy = appBox.get("enableAutoCopy", defaultValue: false);
    state = state.copyWith(
      keyMaps: keyMaps,
      worldMaps: worldMaps,
      enableAutoCopy: enableAutoCopy,
    );
  }

  void onSwitchAutoCopy(bool value) async {
    final appBox = await Hive.openBox("app_conf");
    appBox.put("enableAutoCopy", value);
    state = state.copyWith(enableAutoCopy: value);
  }

  String? onTextChange(String type, String str) {
    if (state.keyMaps == null || state.worldMaps == null) return null;
    StringBuffer sb = StringBuffer();
    final r = RegExp(r'^[a-zA-Z0-9\p{P}\p{S}]+$');
    if (type == "src") {
      final map = state.worldMaps!;
      // text to code
      var leftSafe = true;
      for (var c in str.characters) {
        if (r.hasMatch((c))) {
          if (leftSafe) {
            sb.write(c);
          } else {
            sb.write(" $c");
          }
          leftSafe = true;
          continue;
        } else {
          // 特殊字符，开始转码
          final code = map[c.trim()];
          // dPrint("c:$c code: $code");
          if (code != null) {
            if (leftSafe) {
              sb.write(" ");
            }
            sb.write("@$code");
          } else {
            // 不支持转码，用空格代替
            sb.write(" ");
          }
          leftSafe = false;
        }
      }
    }
    if (sb.toString().trim().isEmpty) {
      return "";
    }
    final text = "[zh] ${sb.toString()}";
    _handleAutoCopy(text);
    return text;
  }

  Timer? _autoCopyTimer;

  // 打字结束后的1秒后自动复制，避免频繁复制
  void _handleAutoCopy(String text) {
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

}
