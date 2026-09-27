import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_source.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'binding_chip.dart';
import 'keyboard_keys.dart';
import 'keybinding_text.dart';

/// Records one input for [device]'s slot of [action] and binds it on confirm.
/// Joystick capture listens to every connected stick at once; the stick that fires decides js1/js2.
Future<void> showCaptureDialog(
  BuildContext context,
  KeybindingModel model,
  ScActionDef action,
  ScDeviceType device,
) async {
  await model.refreshJoysticks();
  if (!context.mounted) return;
  await showDialog(
    context: context,
    dismissWithEsc: false,
    barrierDismissible: false,
    builder: (dialogContext) => _CaptureDialog(model: model, action: action, device: device),
  );
}

class _CaptureDialog extends StatefulWidget {
  const _CaptureDialog({required this.model, required this.action, required this.device});

  final KeybindingModel model;
  final ScActionDef action;
  final ScDeviceType device;

  @override
  State<_CaptureDialog> createState() => _CaptureDialogState();
}

class _CaptureDialogState extends State<_CaptureDialog> {
  final _focus = FocusNode();
  StreamSubscription<KbInputEvent>? _sub;
  ScInput? _captured;
  String _source = '';
  String? _activeDeviceId;
  String? _modifierOnly;
  bool _replace = true;
  String? _error;

  bool get _listensKeyboard => widget.device == ScDeviceType.keyboard || widget.device == ScDeviceType.mouse;

  bool get _listensHid => widget.device == ScDeviceType.joystick || widget.device == ScDeviceType.gamepad;

  @override
  void initState() {
    super.initState();
    if (_listensHid) _startHid();
  }

  void _startHid() {
    try {
      _sub = widget.model.env.captureStart().listen(
        _onHidEvent,
        onError: (Object e) {
          dPrint('[keybinding] capture stream error: $e');
          if (mounted) setState(() => _error = e.toString());
        },
      );
    } catch (e) {
      _error = e.toString();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    if (_listensHid) widget.model.env.captureStop();
    _focus.dispose();
    super.dispose();
  }

  void _finish(ScInput input, String source) {
    setState(() {
      _captured = input;
      _source = source;
      _modifierOnly = null;
    });
  }

  void _onHidEvent(KbInputEvent e) {
    if (!mounted || e.released) return;
    setState(() => _activeDeviceId = e.deviceId);
    if (_captured != null) return;
    final isXInput = e.isXInput;
    if (widget.device == ScDeviceType.gamepad && isXInput) {
      _finish(ScInput(ScDeviceType.gamepad, 1, const [], e.input), e.deviceName);
    } else if (widget.device == ScDeviceType.joystick && !isXInput) {
      final instance = widget.model.joystickInstanceFor(e.deviceId, e.vendorId, e.productId, e.deviceName);
      _finish(
        ScInput(ScDeviceType.joystick, instance, scHeldKeyboardModifiers(), e.input),
        'js$instance · ${e.deviceName}',
      );
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_listensKeyboard || _captured != null) return KeyEventResult.handled;
    final name = scKeyFor(event);
    if (name == null) return KeyEventResult.handled;
    final isModifier = scKeyboardModifiers.contains(name);
    if (event is KeyDownEvent) {
      if (isModifier) {
        setState(() => _modifierOnly = name);
      } else {
        final mods = scHeldKeyboardModifiers()..remove(name);
        _finish(ScInput(ScDeviceType.keyboard, 1, mods, name), S.current.keybinding_device_keyboard);
      }
    } else if (event is KeyUpEvent && isModifier && _modifierOnly == name) {
      // A modifier pressed and released on its own binds that key itself.
      final mods = scHeldKeyboardModifiers()..remove(name);
      _finish(ScInput(ScDeviceType.keyboard, 1, mods, name), S.current.keybinding_device_keyboard);
    }
    return KeyEventResult.handled;
  }

  void _onPointerDown(PointerDownEvent e) {
    if (_captured != null || e.kind != PointerDeviceKind.mouse) return;
    final key = switch (e.buttons) {
      kPrimaryMouseButton => 'mouse1',
      kSecondaryMouseButton => 'mouse2',
      kMiddleMouseButton => 'mouse3',
      kBackMouseButton => 'mouse4',
      kForwardMouseButton => 'mouse5',
      _ => null,
    };
    if (key != null) {
      _finish(ScInput(ScDeviceType.mouse, 1, scHeldKeyboardModifiers(), key), S.current.keybinding_device_mouse);
    }
  }

  void _onPointerSignal(PointerSignalEvent e) {
    if (_captured != null || e is! PointerScrollEvent || e.scrollDelta.dy == 0) return;
    _finish(
      ScInput(ScDeviceType.mouse, 1, scHeldKeyboardModifiers(), e.scrollDelta.dy < 0 ? 'mwheel_up' : 'mwheel_down'),
      S.current.keybinding_device_mouse,
    );
  }

  void _retry() {
    setState(() {
      _captured = null;
      _source = '';
      _replace = true;
    });
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final captured = _captured;
    final conflicts = captured == null ? const <ScRelation>[] : model.conflictsIfBound(widget.action, captured);
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: ContentDialog(
        constraints: const BoxConstraints(maxWidth: 580),
        title: Text(S.current.keybinding_record_title(deviceLabel(widget.device))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.keybinding_record_action(model.actionLabel(widget.action)),
              style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .66)),
            ),
            const SizedBox(height: 16),
            if (captured == null) _buildListening(context) else _buildResult(context, captured, conflicts),
          ],
        ),
        actions: [
          if (captured != null) Button(onPressed: _retry, child: Text(S.current.keybinding_record_again)),
          Button(onPressed: () => closeDialog(context), child: Text(S.current.app_common_tip_cancel)),
          FilledButton(
            onPressed: captured == null
                ? null
                : () {
                    model.bind(widget.action, captured, replaceConflicts: _replace && conflicts.isNotEmpty);
                    closeDialog(context);
                  },
            child: Text(S.current.keybinding_record_confirm),
          ),
        ],
      ),
    );
  }

  Widget _buildListening(BuildContext context) {
    final theme = FluentTheme.of(context);
    final hint = switch (widget.device) {
      ScDeviceType.keyboard || ScDeviceType.mouse => S.current.keybinding_record_hint_keyboard,
      ScDeviceType.joystick => S.current.keybinding_record_hint_joystick,
      ScDeviceType.gamepad => S.current.keybinding_record_hint_gamepad,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const SizedBox(width: 28, height: 28, child: ProgressRing(strokeWidth: 3)),
            const SizedBox(width: 12),
            Expanded(child: Text(hint, style: const TextStyle(fontSize: 14))),
          ],
        ),
        if (_modifierOnly != null) ...[
          const SizedBox(height: 8),
          Text(
            S.current.keybinding_record_modifier_held(_modifierOnly!.toUpperCase()),
            style: TextStyle(fontSize: 12, color: theme.accentColor.lighter),
          ),
        ],
        if (widget.device == ScDeviceType.joystick) ...[
          const SizedBox(height: 14),
          Text(
            S.current.keybinding_record_listening_sticks,
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55)),
          ),
          const SizedBox(height: 6),
          if (widget.model.joysticks.values.where((j) => j.connected).isEmpty)
            Text(
              S.current.keybinding_no_joystick_connected,
              style: TextStyle(fontSize: 12, color: Colors.warningPrimaryColor),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final js in widget.model.joysticks.values.where((j) => j.connected))
                  BindingChip(
                    text: 'JS${js.instance}${js.alias.isEmpty ? '' : ' ${js.alias}'} · ${js.name}',
                    style: js.deviceId == _activeDeviceId ? BindingChipStyle.custom : BindingChipStyle.byDefault,
                  ),
              ],
            ),
          const SizedBox(height: 8),
          Text(
            S.current.keybinding_record_axis_hint,
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55)),
          ),
        ],
        if (_listensKeyboard) ...[
          const SizedBox(height: 14),
          Listener(
            onPointerDown: _onPointerDown,
            onPointerSignal: _onPointerSignal,
            child: Container(
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.cardColor.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withValues(alpha: .14)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FluentIcons.touch_pointer, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    S.current.keybinding_record_mouse_pad,
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .7)),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 10),
          InfoBar(
            title: Text(S.current.keybinding_record_failed),
            content: Text(_error!),
            severity: InfoBarSeverity.error,
            isLong: true,
          ),
        ],
      ],
    );
  }

  Widget _buildResult(BuildContext context, ScInput captured, List<ScRelation> conflicts) {
    final model = widget.model;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          padding: const EdgeInsets.all(14),
          borderRadius: BorderRadius.circular(6),
          child: Row(
            children: [
              BindingChip(text: model.formatInput(captured), style: BindingChipStyle.custom, fontSize: 16),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_source, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(
                      captured.toXml(),
                      style: TextStyle(fontSize: 11, fontFamily: 'Consolas', color: Colors.white.withValues(alpha: .5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (captured.device != widget.device) ...[
          const SizedBox(height: 8),
          Text(
            S.current.keybinding_record_goes_to(deviceLabel(captured.device)),
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
          ),
        ],
        if (conflicts.isNotEmpty) ...[
          const SizedBox(height: 12),
          InfoBar(
            title: Text(S.current.keybinding_record_conflict_title),
            content: Text(
              S.current.keybinding_record_conflict_body(
                conflicts
                    .map(
                      (c) => S.current.keybinding_conflict_item(
                        model.actionLabel(c.other.action),
                        model.groupLabelOf(c.other.action),
                      ),
                    )
                    .join(S.current.keybinding_list_separator),
              ),
            ),
            severity: InfoBarSeverity.warning,
            isLong: true,
          ),
          const SizedBox(height: 10),
          RadioGroup<bool>(
            groupValue: _replace,
            onChanged: (v) => setState(() => _replace = v ?? true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioButton<bool>(value: true, content: Text(S.current.keybinding_record_replace)),
                const SizedBox(height: 8),
                RadioButton<bool>(value: false, content: Text(S.current.keybinding_record_keep_both)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
