import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_format.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

String _label(String token, {String? Function(int instance)? joystickName}) =>
    scFormatInput(ScInput.parse(token)!, joystickName: joystickName);

void main() {
  setUpAll(() async => S.load(const Locale('en')));

  test('keyboard: modifiers first in game order, named and numpad keys', () {
    expect(_label('kb1_lalt+f'), 'LAlt + F');
    expect(_label('kb1_f5+lalt'), 'LAlt + F5'); // reversed form found in defaultProfile.xml
    expect(_label('kb1_lshift+rctrl+pgup'), 'RCtrl + LShift + PgUp');
    expect(_label('kb1_np_1'), 'Num 1');
    expect(_label('kb1_np_add'), 'Num +');
    expect(_label('kb1_escape'), 'Esc');
    expect(_label('kb1_backslash'), r'\');
    expect(_label('kb1_f13'), 'F13');
  });

  test('mouse buttons, wheel and axes, also combined with keyboard modifiers', () {
    expect(_label('mo1_mouse1'), 'Left mouse');
    expect(_label('mo1_mouse4'), 'Mouse button 4');
    expect(_label('mo1_mwheel_down'), 'Wheel down');
    expect(_label('mo1_maxis_x'), 'Mouse X axis');
    expect(_label('mo1_lctrl+mouse2'), 'LCtrl + Right mouse');
    expect(_label('kb1_lalt+mouse3'), 'LAlt + Middle mouse');
  });

  test('joystick inputs carry their stick', () {
    expect(_label('js2_button3'), 'JS2 · Button 3');
    expect(_label('js1_hat1_up'), 'JS1 · Hat1 ↑');
    expect(_label('js1_slider1'), 'JS1 · Slider 1');
    expect(_label('js1_rotz'), 'JS1 · Z rotation');
    expect(_label('js1_x'), 'JS1 · X axis');
  });

  test('a joystick alias replaces the instance, unless it is blank', () {
    String? alias(int i) => {2: 'VKB Gladiator L', 3: ''}[i];

    expect(_label('js2_button3', joystickName: alias), 'VKB Gladiator L · Button 3');
    expect(_label('js3_button3', joystickName: alias), 'JS3 · Button 3');
    expect(_label('js4_button3', joystickName: alias), 'JS4 · Button 3');
  });

  test('gamepad: Xbox names, sticks, d-pad and the LB chord', () {
    expect(_label('gp1_shoulderl+a'), 'LB + A');
    expect(_label('gp1_thumblx'), 'Left stick X');
    expect(_label('gp1_thumbry'), 'Right stick Y');
    expect(_label('gp1_dpad_up'), 'D-pad ↑');
    expect(_label('gp1_triggerl_btn'), 'LT');
    expect(_label('gp1_thumbl'), 'L3');
    expect(_label('gp1_shoulderl+thumbly'), 'LB + Left stick Y');
  });
}
