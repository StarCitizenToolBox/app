import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:starcitizen_doctor/common/keybinding/sc_input_source.dart';

import 'keyboard_keys.dart';

/// Inputs the player is pressing right now, as `kb:a`, `mo:mouse1`, `gp:a`, `js2:button3`, so the
/// device diagrams can light them up. Keys, mouse buttons and pad / stick buttons stay lit while
/// held; axes, hats and the mouse wheel only report movement, so those flash briefly.

class LiveInput extends ValueNotifier<Set<String>> {
  LiveInput() : super(const {});

  static const flashDuration = Duration(milliseconds: 450);

  /// A held input goes dark after this even without a release (a missed key-up, a stuck button).
  static const maxHold = Duration(seconds: 5);

  final _timers = <String, Timer>{};
  int _mouseButtons = 0;

  void press(String id, {Duration timeout = maxHold}) {
    _timers.remove(id)?.cancel();
    _timers[id] = Timer(timeout, () {
      _timers.remove(id);
      release(id);
    });
    if (!value.contains(id)) value = {...value, id};
  }

  void release(String id) {
    _timers.remove(id)?.cancel();
    if (value.contains(id)) value = {...value}..remove(id);
  }

  /// A press from the HID / XInput stream: held until its release for buttons, a flash otherwise.
  void feed(String id, KbInputEvent e) => e.hasRelease ? press(id) : flash(id);

  void flash(String id) => press(id, timeout: flashDuration);

  /// For [HardwareKeyboard.addHandler]; never consumes the event.
  bool onKey(KeyEvent e) {
    final key = scKeyFor(e);
    if (key == null) return false;
    if (e is KeyDownEvent || e is KeyRepeatEvent) {
      press('kb:$key');
    } else if (e is KeyUpEvent) {
      release('kb:$key');
    }
    return false;
  }

  static const _buttons = {
    kPrimaryMouseButton: 'mouse1',
    kSecondaryMouseButton: 'mouse2',
    kMiddleMouseButton: 'mouse3',
    kBackMouseButton: 'mouse4',
    kForwardMouseButton: 'mouse5',
  };

  void onPointer(PointerEvent e) {
    if (e.kind != PointerDeviceKind.mouse) return;
    if (e is PointerDownEvent || e is PointerUpEvent || e is PointerCancelEvent) {
      final now = e is PointerDownEvent ? e.buttons : 0;
      for (final entry in _buttons.entries) {
        final wasDown = _mouseButtons & entry.key != 0;
        final isDown = now & entry.key != 0;
        if (isDown && !wasDown) press('mo:${entry.value}');
        if (!isDown && wasDown) release('mo:${entry.value}');
      }
      _mouseButtons = now;
    }
  }

  void onPointerSignal(PointerSignalEvent e) {
    if (e is PointerScrollEvent && e.scrollDelta.dy != 0) {
      flash(e.scrollDelta.dy < 0 ? 'mo:mwheel_up' : 'mo:mwheel_down');
    }
  }

  @override
  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    super.dispose();
  }
}
