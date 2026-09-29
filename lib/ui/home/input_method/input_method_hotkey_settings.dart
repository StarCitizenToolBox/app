import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/ui/home/input_method/input_method_hotkey_service.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

/// Switch of the in-game hotkey popup, shown next to the other input method switches
/// (Windows only). Enabling it opens [InputMethodHotkeySettingsDialog].
class InputMethodHotkeyToggle extends ConsumerWidget {
  const InputMethodHotkeyToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inputMethodHotkeyServiceProvider);
    final model = ref.read(inputMethodHotkeyServiceProvider.notifier);
    return Row(
      children: [
        Text(S.current.input_method_hotkey_switch),
        SizedBox(width: 6),
        ToggleSwitch(checked: state.enabled, onChanged: (b) => _onSwitch(context, model, b)),
        if (state.enabled) ...[
          SizedBox(width: 6),
          Tooltip(
            message: S.current.input_method_hotkey_settings,
            child: IconButton(
              icon: Icon(FluentIcons.settings, size: 16, color: state.errorMessage != null ? Colors.red : null),
              onPressed: () => _showSettings(context),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _onSwitch(BuildContext context, InputMethodHotkeyService model, bool value) async {
    if (value) {
      final userOK = await showConfirmDialogs(
        context,
        S.current.input_method_hotkey_confirm_title,
        Text(S.current.input_method_hotkey_confirm_content),
      );
      if (!userOK) return;
    }
    await model.setEnabled(value);
    if (value && context.mounted) await _showSettings(context);
  }

  Future<void> _showSettings(BuildContext context) =>
      showDialog(context: context, builder: (_) => const InputMethodHotkeySettingsDialog());
}

class InputMethodHotkeySettingsDialog extends HookConsumerWidget {
  const InputMethodHotkeySettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inputMethodHotkeyServiceProvider);
    final model = ref.read(inputMethodHotkeyServiceProvider.notifier);
    final interval = useState(state.keyIntervalMs.toDouble());
    useEffect(() {
      interval.value = state.keyIntervalMs.toDouble();
      return null;
    }, [state.keyIntervalMs]);
    // Leaving the dialog while waiting for a key combination would leave the hook capturing.
    useEffect(
      () =>
          () => model.cancelCapture(),
      const [],
    );

    final hotkeyName = model.hotkeyDisplayName();
    final secondaryStyle = TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .6));

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 640),
      title: Text(S.current.input_method_hotkey_title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(S.current.input_method_hotkey_description, style: secondaryStyle),
          if (state.errorMessage != null) ...[
            SizedBox(height: 12),
            InfoBar(
              title: Text(S.current.input_method_hotkey_start_failed(state.errorMessage!)),
              severity: InfoBarSeverity.error,
            ),
          ],
          SizedBox(height: 12),
          InfoBar(title: Text(S.current.input_method_hotkey_usage(hotkeyName)), severity: InfoBarSeverity.info),
          SizedBox(height: 16),
          _item(
            S.current.input_method_hotkey_hotkey,
            Button(
              onPressed: state.isRunning
                  ? () => state.isCapturing ? model.cancelCapture() : model.beginCapture()
                  : null,
              child: Text(state.isCapturing ? S.current.input_method_hotkey_press_keys : hotkeyName),
            ),
          ),
          _item(
            S.current.input_method_hotkey_game_only,
            ToggleSwitch(checked: state.gameOnly, onChanged: model.setGameOnly),
            info: Text(S.current.input_method_hotkey_game_only_info, style: secondaryStyle),
          ),
          _item(
            S.current.input_method_hotkey_auto_send,
            ToggleSwitch(checked: state.autoSend, onChanged: model.setAutoSend),
            info: Text(S.current.input_method_hotkey_auto_send_info, style: secondaryStyle),
          ),
          _item(
            S.current.input_method_hotkey_chat_mode,
            ComboBox<InputMethodHotkeyChatMode>(
              value: _visibleChatMode(state.chatMode, state.autoSend),
              items: [
                for (final mode in InputMethodHotkeyChatMode.values)
                  if (_visibleChatMode(mode, state.autoSend) == mode)
                    ComboBoxItem(value: mode, child: Text(_chatModeText(mode, state.autoSend))),
              ],
              onChanged: (mode) {
                if (mode != null && mode != _visibleChatMode(state.chatMode, state.autoSend)) model.setChatMode(mode);
              },
            ),
            info: Text(S.current.input_method_hotkey_chat_mode_tips, style: secondaryStyle),
          ),
          _item(
            S.current.input_method_hotkey_key_interval,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 180,
                  child: Slider(
                    value: interval.value,
                    min: 5,
                    max: 200,
                    divisions: 39,
                    onChanged: (v) => interval.value = v,
                    onChangeEnd: (v) => model.setKeyInterval(v.round()),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(width: 32, child: Text("${interval.value.round()}")),
              ],
            ),
            info: Text(S.current.input_method_hotkey_key_interval_tips, style: secondaryStyle),
          ),
          _item(
            S.current.input_method_hotkey_window_position,
            Button(onPressed: model.resetWindowPosition, child: Text(S.current.input_method_hotkey_reset_position)),
          ),
        ],
      ),
      actions: [FilledButton(child: Text(S.current.action_close), onPressed: () => Navigator.of(context).pop())],
    );
  }

  Widget _item(String label, Widget control, {Widget? info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                if (info != null) ...[SizedBox(height: 2), info],
              ],
            ),
          ),
          SizedBox(width: 16),
          control,
        ],
      ),
    );
  }

  /// Without auto-send nothing happens after typing, so the two "user opens the chat" modes
  /// are the same and shown as one.
  InputMethodHotkeyChatMode _visibleChatMode(InputMethodHotkeyChatMode mode, bool autoSend) =>
      !autoSend && mode == InputMethodHotkeyChatMode.keepOpen ? InputMethodHotkeyChatMode.closeAfterSend : mode;

  String _chatModeText(InputMethodHotkeyChatMode mode, bool autoSend) => switch (mode) {
    InputMethodHotkeyChatMode.openBeforeSend => S.current.input_method_hotkey_chat_mode_open_before_send,
    _ when !autoSend => S.current.input_method_hotkey_chat_mode_manual,
    InputMethodHotkeyChatMode.keepOpen => S.current.input_method_hotkey_chat_mode_keep_open,
    InputMethodHotkeyChatMode.closeAfterSend => S.current.input_method_hotkey_chat_mode_close_after_send,
  };
}
