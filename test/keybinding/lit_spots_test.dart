import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/ui/tools/keybinding/widgets/device_diagram.dart';

import 'fixtures.dart';

void main() {
  final profile = ScDefaultProfile.parse(kDefaultProfileXml);
  final action = profile.actionsById['player/jump']!;

  DeviceBinding combo(String body, {bool active = false}) {
    final input = ScInput.parseBody(ScDeviceType.gamepad, body);
    return DeviceBinding(input, [(action, scResolveSlot(action, ScDeviceType.gamepad, null))])..active = active;
  }

  test('combo spot lights only when the modifier is held too', () {
    final lbA = combo('shoulderl+a');
    // A alone: the LB + A binding is not active, and A is shown, so nothing lights.
    expect(litSpots([lbA], {'a'}, {'shoulderl'}), isEmpty);
    // LB held: the modifier lights by itself.
    expect(litSpots([lbA], {'shoulderl'}, {'shoulderl'}), {'shoulderl'});
    // LB + A: the binding is active, both spots light.
    lbA.active = true;
    expect(litSpots([lbA], {'shoulderl', 'a'}, {'shoulderl'}), {'shoulderl', 'a'});
  });

  test('with a modifier held, the combos it unlocks come before plain bindings', () {
    final plainA = combo('a');
    final lbA = combo('shoulderl+a')..primed = true;
    expect(byPriority([plainA, lbA]), [lbA, plainA]);
    lbA
      ..primed = false
      ..active = true;
    plainA.primed = false;
    expect(byPriority([plainA, lbA]).first, lbA);
    lbA.active = false;
    expect(byPriority([plainA, lbA]), [plainA, lbA], reason: 'nothing held: original order');
  });

  test('a pressed key with nothing shown still lights as feedback', () {
    expect(litSpots([combo('shoulderl+a')], {'b'}, {'shoulderl'}), {'b'});
  });
}
