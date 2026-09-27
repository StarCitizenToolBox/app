import 'package:starcitizen_doctor/generated/l10n.dart';

import 'sc_input.dart';

const _keyboardNames = {
  'lalt': 'LAlt', 'ralt': 'RAlt', 'lshift': 'LShift', 'rshift': 'RShift', 'lctrl': 'LCtrl', 'rctrl': 'RCtrl', //
  'space': 'Space', 'enter': 'Enter', 'escape': 'Esc', 'tab': 'Tab', 'backspace': 'Backspace', 'capslock': 'CapsLock',
  'insert': 'Insert', 'delete': 'Delete', 'home': 'Home', 'end': 'End', 'pgup': 'PgUp', 'pgdn': 'PgDn',
  'print': 'PrtSc', 'scrolllock': 'ScrLk', 'pause': 'Pause', 'numlock': 'NumLock',
  'up': '↑', 'down': '↓', 'left': '←', 'right': '→',
  'minus': '-', 'underline': '_', 'equals': '=', 'semicolon': ';', 'colon': ':', 'apostrophe': "'",
  'lbracket': '[', 'rbracket': ']', 'backslash': r'\', 'comma': ',', 'period': '.', 'slash': '/', 'oem_102': 'OEM 102',
  'np_divide': 'Num /', 'np_multiply': 'Num *', 'np_subtract': 'Num -', 'np_add': 'Num +', 'np_period': 'Num .',
  'np_enter': 'Num Enter',
};

const _gamepadNames = {
  'a': 'A', 'b': 'B', 'x': 'X', 'y': 'Y', 'shoulderl': 'LB', 'shoulderr': 'RB', //
  'triggerl_btn': 'LT', 'triggerr_btn': 'RT', 'triggerl': 'LT', 'triggerr': 'RT', 'triggerl_r_btn': 'LT + RT',
  'thumbl': 'L3', 'thumbr': 'R3', 'back': 'Back', 'start': 'Start',
};

const _arrows = {'up': '↑', 'down': '↓', 'left': '←', 'right': '→'};

String _keyboardKey(String k) {
  final named = _keyboardNames[k];
  if (named != null) return named;
  if (k.startsWith('np_')) return 'Num ${k.substring(3)}';
  return k.toUpperCase();
}

String _mouseKey(String k) {
  switch (k) {
    case 'mouse1':
      return S.current.keybinding_mouse_left;
    case 'mouse2':
      return S.current.keybinding_mouse_right;
    case 'mouse3':
      return S.current.keybinding_mouse_middle;
    case 'mwheel_up':
      return S.current.keybinding_mouse_wheel_up;
    case 'mwheel_down':
      return S.current.keybinding_mouse_wheel_down;
  }
  if (k.startsWith('maxis_')) return S.current.keybinding_mouse_axis(k.substring(6).toUpperCase());
  final m = RegExp(r'^mouse(\d+)$').firstMatch(k);
  if (m != null) return S.current.keybinding_mouse_button(m.group(1)!);
  return k;
}

String _joystickKey(String k) {
  var m = RegExp(r'^button(\d+)$').firstMatch(k);
  if (m != null) return S.current.keybinding_js_button(m.group(1)!);
  m = RegExp(r'^hat(\d+)_(\w+)$').firstMatch(k);
  if (m != null) return S.current.keybinding_js_hat(m.group(1)!, _arrows[m.group(2)] ?? m.group(2)!);
  m = RegExp(r'^slider(\d+)$').firstMatch(k);
  if (m != null) return S.current.keybinding_js_slider(m.group(1)!);
  if (k.startsWith('rot') && k.length == 4) return S.current.keybinding_js_rotation(k.substring(3).toUpperCase());
  if (k.length == 1) return S.current.keybinding_js_axis(k.toUpperCase());
  return k;
}

String _gamepadKey(String k) {
  final named = _gamepadNames[k];
  if (named != null) return named;
  final m = RegExp(r'^(thumb|dpad)(l|r)?_?(x|y|up|down|left|right)$').firstMatch(k);
  if (m != null) {
    final stick = m.group(1) == 'dpad'
        ? S.current.keybinding_gp_dpad
        : (m.group(2) == 'l' ? S.current.keybinding_gp_left_stick : S.current.keybinding_gp_right_stick);
    final part = m.group(3)!;
    return '$stick ${_arrows[part] ?? part.toUpperCase()}';
  }
  return k.toUpperCase();
}

String scFormatModifier(ScDeviceType device, String m) =>
    device == ScDeviceType.gamepad ? (_gamepadNames[m] ?? m) : _keyboardKey(m);

/// The key part only, e.g. `LAlt + F`, `Button 3`, `LB + Left stick Y`.
String scFormatBody(ScInput input) {
  final key = switch (input.device) {
    ScDeviceType.keyboard => scIsMouseKey(input.key) ? _mouseKey(input.key) : _keyboardKey(input.key),
    ScDeviceType.mouse => _mouseKey(input.key),
    ScDeviceType.joystick => _joystickKey(input.key),
    ScDeviceType.gamepad => _gamepadKey(input.key),
  };
  return [...input.modifiers.map((m) => scFormatModifier(input.device, m)), key].join(' + ');
}

/// Full label; joystick inputs carry their stick (`JS2 · Button 3`, or the player's alias).
String scFormatInput(ScInput input, {String? Function(int instance)? joystickName}) {
  final body = scFormatBody(input);
  if (input.device != ScDeviceType.joystick) return body;
  final name = joystickName?.call(input.instance);
  return '${name == null || name.isEmpty ? 'JS${input.instance}' : name} · $body';
}
