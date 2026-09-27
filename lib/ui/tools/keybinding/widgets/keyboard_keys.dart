import 'package:flutter/services.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';

/// Physical key → Star Citizen keyboard token.
final scPhysicalKeys = <PhysicalKeyboardKey, String>{
  PhysicalKeyboardKey.escape: 'escape', PhysicalKeyboardKey.tab: 'tab', PhysicalKeyboardKey.capsLock: 'capslock', //
  PhysicalKeyboardKey.shiftLeft: 'lshift', PhysicalKeyboardKey.shiftRight: 'rshift',
  PhysicalKeyboardKey.controlLeft: 'lctrl', PhysicalKeyboardKey.controlRight: 'rctrl',
  PhysicalKeyboardKey.altLeft: 'lalt', PhysicalKeyboardKey.altRight: 'ralt',
  PhysicalKeyboardKey.space: 'space', PhysicalKeyboardKey.enter: 'enter', PhysicalKeyboardKey.backspace: 'backspace',
  PhysicalKeyboardKey.insert: 'insert', PhysicalKeyboardKey.delete: 'delete', PhysicalKeyboardKey.home: 'home',
  PhysicalKeyboardKey.end: 'end', PhysicalKeyboardKey.pageUp: 'pgup', PhysicalKeyboardKey.pageDown: 'pgdn',
  PhysicalKeyboardKey.printScreen: 'print',
  PhysicalKeyboardKey.scrollLock: 'scrolllock',
  PhysicalKeyboardKey.pause: 'pause',
  PhysicalKeyboardKey.arrowUp: 'up', PhysicalKeyboardKey.arrowDown: 'down', PhysicalKeyboardKey.arrowLeft: 'left',
  PhysicalKeyboardKey.arrowRight: 'right', PhysicalKeyboardKey.numLock: 'numlock',
  PhysicalKeyboardKey.numpadDivide: 'np_divide', PhysicalKeyboardKey.numpadMultiply: 'np_multiply',
  PhysicalKeyboardKey.numpadSubtract: 'np_subtract', PhysicalKeyboardKey.numpadAdd: 'np_add',
  PhysicalKeyboardKey.numpadDecimal: 'np_period', PhysicalKeyboardKey.numpadEnter: 'np_enter',
  PhysicalKeyboardKey.numpad0: 'np_0', PhysicalKeyboardKey.numpad1: 'np_1', PhysicalKeyboardKey.numpad2: 'np_2',
  PhysicalKeyboardKey.numpad3: 'np_3', PhysicalKeyboardKey.numpad4: 'np_4', PhysicalKeyboardKey.numpad5: 'np_5',
  PhysicalKeyboardKey.numpad6: 'np_6', PhysicalKeyboardKey.numpad7: 'np_7', PhysicalKeyboardKey.numpad8: 'np_8',
  PhysicalKeyboardKey.numpad9: 'np_9', PhysicalKeyboardKey.minus: 'minus', PhysicalKeyboardKey.equal: 'equals',
  PhysicalKeyboardKey.bracketLeft: 'lbracket', PhysicalKeyboardKey.bracketRight: 'rbracket',
  PhysicalKeyboardKey.backslash: 'backslash', PhysicalKeyboardKey.semicolon: 'semicolon',
  PhysicalKeyboardKey.quote: 'apostrophe', PhysicalKeyboardKey.comma: 'comma', PhysicalKeyboardKey.period: 'period',
  PhysicalKeyboardKey.slash: 'slash', PhysicalKeyboardKey.intlBackslash: 'oem_102',
  PhysicalKeyboardKey.f1: 'f1',
  PhysicalKeyboardKey.f2: 'f2',
  PhysicalKeyboardKey.f3: 'f3',
  PhysicalKeyboardKey.f4: 'f4',
  PhysicalKeyboardKey.f5: 'f5',
  PhysicalKeyboardKey.f6: 'f6',
  PhysicalKeyboardKey.f7: 'f7',
  PhysicalKeyboardKey.f8: 'f8',
  PhysicalKeyboardKey.f9: 'f9',
  PhysicalKeyboardKey.f10: 'f10',
  PhysicalKeyboardKey.f11: 'f11',
  PhysicalKeyboardKey.f12: 'f12',
  PhysicalKeyboardKey.keyA: 'a',
  PhysicalKeyboardKey.keyB: 'b',
  PhysicalKeyboardKey.keyC: 'c',
  PhysicalKeyboardKey.keyD: 'd',
  PhysicalKeyboardKey.keyE: 'e',
  PhysicalKeyboardKey.keyF: 'f',
  PhysicalKeyboardKey.keyG: 'g',
  PhysicalKeyboardKey.keyH: 'h',
  PhysicalKeyboardKey.keyI: 'i',
  PhysicalKeyboardKey.keyJ: 'j',
  PhysicalKeyboardKey.keyK: 'k',
  PhysicalKeyboardKey.keyL: 'l',
  PhysicalKeyboardKey.keyM: 'm',
  PhysicalKeyboardKey.keyN: 'n',
  PhysicalKeyboardKey.keyO: 'o',
  PhysicalKeyboardKey.keyP: 'p',
  PhysicalKeyboardKey.keyQ: 'q',
  PhysicalKeyboardKey.keyR: 'r',
  PhysicalKeyboardKey.keyS: 's',
  PhysicalKeyboardKey.keyT: 't',
  PhysicalKeyboardKey.keyU: 'u',
  PhysicalKeyboardKey.keyV: 'v',
  PhysicalKeyboardKey.keyW: 'w',
  PhysicalKeyboardKey.keyX: 'x',
  PhysicalKeyboardKey.keyY: 'y',
  PhysicalKeyboardKey.keyZ: 'z',
  PhysicalKeyboardKey.digit0: '0',
  PhysicalKeyboardKey.digit1: '1',
  PhysicalKeyboardKey.digit2: '2',
  PhysicalKeyboardKey.digit3: '3',
  PhysicalKeyboardKey.digit4: '4',
  PhysicalKeyboardKey.digit5: '5',
  PhysicalKeyboardKey.digit6: '6',
  PhysicalKeyboardKey.digit7: '7',
  PhysicalKeyboardKey.digit8: '8',
  PhysicalKeyboardKey.digit9: '9',
};

/// Modifiers by logical key. On Windows, Flutter reports Right Shift with an unmapped physical id
/// (0x1600000036, the raw scan code), so modifiers are also recognised by their logical key.
final _logicalModifiers = <LogicalKeyboardKey, String>{
  LogicalKeyboardKey.shiftLeft: 'lshift',
  LogicalKeyboardKey.shiftRight: 'rshift',
  LogicalKeyboardKey.controlLeft: 'lctrl',
  LogicalKeyboardKey.controlRight: 'rctrl',
  LogicalKeyboardKey.altLeft: 'lalt',
  LogicalKeyboardKey.altRight: 'ralt',
};

/// Star Citizen token for a key event: by physical key, else by logical key for modifiers.
String? scKeyFor(KeyEvent e) => scPhysicalKeys[e.physicalKey] ?? _logicalModifiers[e.logicalKey];

/// Keyboard modifiers held right now, in write-back order.
List<String> scHeldKeyboardModifiers() => ScInput.sortModifiers(
  {
    for (final k in HardwareKeyboard.instance.physicalKeysPressed)
      if (scKeyboardModifiers.contains(scPhysicalKeys[k])) scPhysicalKeys[k]!,
    for (final k in HardwareKeyboard.instance.logicalKeysPressed)
      if (_logicalModifiers[k] != null) _logicalModifiers[k]!,
  }.toList(),
);
