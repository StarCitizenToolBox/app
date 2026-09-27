import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

/// The 18 modes the game defines, in the order its data lists them.
const scActivationModeNames = [
  'press',
  'press_quicker',
  'delayed_press',
  'delayed_press_quicker',
  'delayed_press_medium',
  'delayed_press_long',
  'tap',
  'tap_quicker',
  'double_tap',
  'double_tap_nonblocking',
  'hold',
  'hold_no_retrigger',
  'delayed_hold',
  'delayed_hold_long',
  'delayed_hold_no_retrigger',
  'hold_toggle',
  'smart_toggle',
  'all',
];

String deviceLabel(ScDeviceType d) => switch (d) {
  ScDeviceType.keyboard => S.current.keybinding_device_keyboard,
  ScDeviceType.mouse => S.current.keybinding_device_mouse,
  ScDeviceType.joystick => S.current.keybinding_device_joystick,
  ScDeviceType.gamepad => S.current.keybinding_device_gamepad,
};

bool _isAxisAction(ScActionDef a) => a.defaults.values.isNotEmpty && a.defaults.values.every((i) => i.isAxis);

String activationModeShortLabel(String? mode, [ScActionDef? action]) {
  if (mode == null) {
    if (action != null && (action.optionGroup != null || _isAxisAction(action))) return S.current.keybinding_mode_axis;
    return S.current.keybinding_mode_default_press;
  }
  return switch (mode) {
    'press' => S.current.keybinding_mode_press,
    'press_quicker' => S.current.keybinding_mode_press_quicker,
    'delayed_press' => S.current.keybinding_mode_delayed_press,
    'delayed_press_quicker' => S.current.keybinding_mode_delayed_press_quicker,
    'delayed_press_medium' => S.current.keybinding_mode_delayed_press_medium,
    'delayed_press_long' => S.current.keybinding_mode_delayed_press_long,
    'tap' => S.current.keybinding_mode_tap,
    'tap_quicker' => S.current.keybinding_mode_tap_quicker,
    'double_tap' => S.current.keybinding_mode_double_tap,
    'double_tap_nonblocking' => S.current.keybinding_mode_double_tap_nonblocking,
    'hold' => S.current.keybinding_mode_hold,
    'hold_no_retrigger' => S.current.keybinding_mode_hold_no_retrigger,
    'delayed_hold' => S.current.keybinding_mode_delayed_hold,
    'delayed_hold_long' => S.current.keybinding_mode_delayed_hold_long,
    'delayed_hold_no_retrigger' => S.current.keybinding_mode_delayed_hold_no_retrigger,
    'hold_toggle' => S.current.keybinding_mode_hold_toggle,
    'smart_toggle' => S.current.keybinding_mode_smart_toggle,
    'all' => S.current.keybinding_mode_all,
    _ => mode,
  };
}

/// Explains a mode from its thresholds in defaultProfile.xml, so the text follows game updates.
String activationModeDescription(String? mode, Map<String, ScActivationMode> modes) {
  if (mode == null) return S.current.keybinding_mode_desc_default;
  final m = modes[mode];
  if (m == null) return mode;
  String s(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  final parts = <String>[];
  if (m.multiTap > 1) {
    parts.add(S.current.keybinding_mode_desc_multi_tap(m.multiTap));
    if (!m.multiTapBlock) parts.add(S.current.keybinding_mode_desc_non_blocking);
  } else if (m.pressTriggerThreshold > 0) {
    parts.add(S.current.keybinding_mode_desc_hold_for(s(m.pressTriggerThreshold)));
    if (m.onRelease) parts.add(S.current.keybinding_mode_desc_until_release);
  } else if (!m.onPress && m.onRelease && m.releaseTriggerThreshold > 0) {
    parts.add(S.current.keybinding_mode_desc_tap_within(s(m.releaseTriggerThreshold)));
  } else if (m.releaseTriggerDelay > 0) {
    parts.add(S.current.keybinding_mode_desc_smart_toggle(s(m.releaseTriggerDelay)));
  } else if (m.onPress && m.onHold && m.onRelease) {
    parts.add(S.current.keybinding_mode_desc_all);
  } else if (m.onPress && m.onRelease) {
    parts.add(S.current.keybinding_mode_desc_press_release);
  } else {
    parts.add(S.current.keybinding_mode_desc_press);
  }
  if (m.onPress && m.onRelease && m.retriggerable && m.pressTriggerThreshold <= 0 && m.multiTap == 1) {
    parts.add(S.current.keybinding_mode_desc_retrigger);
  }
  return parts.join(S.current.keybinding_mode_desc_separator);
}
