import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_joystick_numbering.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_profile_document.dart';
import 'package:xml/xml.dart';

import 'fixtures.dart';

void main() {
  group('ScInput', () {
    test('parses prefixed tokens', () {
      final i = ScInput.parse('kb1_lalt+f')!;
      expect(i.device, ScDeviceType.keyboard);
      expect(i.modifiers, ['lalt']);
      expect(i.key, 'f');
      expect(i.toXml(), 'kb1_lalt+f');
      expect(ScInput.parse('js2_button13')!.deviceId, 'js2');
      expect(ScInput.parse('mo1_mwheel_up')!.device, ScDeviceType.mouse);
      expect(ScInput.parse('mouse1_mouse2')!.toXml(), 'mo1_mouse2');
      expect(ScInput.parse('gp1_shoulderl+thumbly')!.modifiers, ['shoulderl']);
    });

    test('explicit unbind round-trips with trailing space', () {
      final i = ScInput.parse('js1_ ')!;
      expect(i.isUnbound, isTrue);
      expect(i.toXml(), 'js1_ ');
    });

    test('reversed default modifiers normalise', () {
      final a = ScInput.parseBody(ScDeviceType.keyboard, 'u+lshift');
      expect(a.key, 'u');
      expect(a.modifiers, ['lshift']);
      expect(ScInput.parseBody(ScDeviceType.keyboard, 'f5+lalt').body, 'lalt+f5');
      expect(ScInput.parseBody(ScDeviceType.keyboard, 'lctrl').key, 'lctrl');
    });

    test('conflict key ignores modifier order', () {
      expect(ScInput.parse('kb1_lshift+lalt+x'), ScInput.parse('kb1_lalt+lshift+x'));
      expect(ScInput.parse('js1_button1') == ScInput.parse('js2_button1'), isFalse);
    });

    test('product guid gives vid/pid', () {
      final id = scParseProductGuid(' VKB-Sim Gladiator NXT R   {0200231D-0000-0000-0000-504944564944}')!;
      expect(id.vendorId, 0x231D);
      expect(id.productId, 0x0200);
      expect(
        scProductName(' VKB-Sim Gladiator NXT R   {0200231D-0000-0000-0000-504944564944}'),
        'VKB-Sim Gladiator NXT R',
      );
      expect(scParseProductGuid(scBuildProduct('X', 0x044F, 0xB10A)), (vendorId: 0x044F, productId: 0xB10A));
    });
  });

  group('ScDefaultProfile', () {
    final profile = ScDefaultProfile.parse(kDefaultProfileXml);

    test('reads maps, modes and defaults', () {
      expect(profile.maps.map((m) => m.name), containsAll(['seat_general', 'spaceship_movement']));
      expect(profile.activationModes['delayed_press']!.pressTriggerThreshold, 0.25);
      final exit = profile.actionsById['seat_general/v_emergency_exit']!;
      expect(exit.defaults[ScDeviceType.keyboard]!.body, 'lshift+u');
      expect(exit.defaults.containsKey(ScDeviceType.joystick), isFalse);
      expect(exit.devices, containsAll([ScDeviceType.keyboard, ScDeviceType.mouse, ScDeviceType.joystick]));
    });

    test('mouse keys under keyboard move to the mouse slot', () {
      final a = profile.actionsById['seat_general/v_operator_mode_cycle_forward']!;
      expect(a.defaults[ScDeviceType.keyboard], isNull);
      expect(a.defaults[ScDeviceType.mouse]!.key, 'mouse3');
    });

    test('nested device defaults and modes', () {
      final sd = profile.actionsById['spaceship_movement/v_self_destruct']!;
      expect(sd.defaults.containsKey(ScDeviceType.gamepad), isFalse);
      expect(sd.modeFor(ScDeviceType.gamepad), 'delayed_press_medium');
      final g = profile.actionsById['player/gp_group']!;
      expect(g.defaults[ScDeviceType.gamepad]!.key, 'dpad_up');
    });
  });

  group('ScProfileDocument', () {
    test('reads options and rebinds; a real binding beats a clear', () {
      final doc = ScProfileDocument.parse(kActionMapsXml);
      expect(doc.isLayout, isFalse);
      final js = doc.readOptions().where((o) => o.device == ScDeviceType.joystick).toList();
      expect(js.length, 2);
      final rb = doc.readRebinds();
      expect(rb['spaceship_movement/v_strafe_up']![ScDeviceType.joystick]!.input.toXml(), 'js2_button5');
      expect(rb['spaceship_movement/v_strafe_up']![ScDeviceType.joystick]!.activationMode, 'tap');
    });

    test('write keeps options children and round-trips rebinds', () {
      final doc = ScProfileDocument.parse(kActionMapsXml);
      final rb = doc.readRebinds();
      rb['player/jump'] = {ScDeviceType.keyboard: ScRebind(ScInput.parse('kb1_lalt+j')!)};
      doc.writeRebinds(rb, ['spaceship_movement', 'spaceship_targeting', 'player']);
      doc.writeJoystickOptions({1: null, 2: null}, renumber: {1: 2, 2: 1});
      final out = ScProfileDocument.parse(doc.toXmlString());
      expect(out.readRebinds()['player/jump']![ScDeviceType.keyboard]!.input.toXml(), 'kb1_lalt+j');
      final js1 = out.container
          .findElements('options')
          .firstWhere((e) => e.getAttribute('instance') == '1' && e.getAttribute('type') == 'joystick');
      expect(js1.getAttribute('Product'), contains('NXT L'));
      expect(js1.findElements('flight_move_strafe_longitudinal'), isNotEmpty);
      expect(doc.toXmlString(), contains('<modifiers/>'));
    });

    test('layout export is re-readable', () {
      final doc = ScProfileDocument.parse(kActionMapsXml);
      final xml = ScProfileDocument.buildLayout(
        profileName: 'sctoolbox_test',
        rebinds: doc.readRebinds(),
        mapOrder: const ['spaceship_movement', 'spaceship_targeting'],
        options: doc.optionElements(),
      );
      final layout = ScProfileDocument.parse(xml);
      expect(layout.isLayout, isTrue);
      expect(layout.profileName, 'sctoolbox_test');
      expect(layout.readRebinds().length, 3);
      expect(xml, contains('<joystick instance="2"/>'));
    });
  });

  group('resolver', () {
    final profile = ScDefaultProfile.parse(kDefaultProfileXml);
    final rebinds = ScProfileDocument.parse(kActionMapsXml).readRebinds();
    final index = ScBindingIndex(profile, rebinds);

    test('slot states', () {
      final up = profile.actionsById['spaceship_movement/v_strafe_up']!;
      final js = scResolveSlot(up, ScDeviceType.joystick, rebinds[up.id]);
      expect(js.state, ScSlotState.custom);
      expect(js.input!.toXml(), 'js2_button5');
      expect(js.hasModeOverride, isTrue);
      final kb = scResolveSlot(up, ScDeviceType.keyboard, rebinds[up.id]);
      expect(kb.state, ScSlotState.byDefault);
      final cleared = scResolveSlot(up, ScDeviceType.joystick, {
        ScDeviceType.joystick: ScRebind(ScInput.parse('js1_ ')!),
      });
      expect(cleared.state, ScSlotState.cleared);
      expect(cleared.input, isNull);
    });

    test('tap + long press on one hat is a pair, not a conflict', () {
      final lock = profile.actionsById['spaceship_targeting/lock1']!;
      final slot = scResolveSlot(lock, ScDeviceType.joystick, rebinds[lock.id]);
      final rel = index.relationsFor(lock, slot.input!, slot.activationMode);
      expect(rel.single.isPair, isTrue);
      expect(index.conflictsFor(lock, slot), isEmpty);
    });

    test('custom binding clashing in the same context is reported; other contexts are not', () {
      final custom = {
        ...rebinds,
        'spaceship_targeting/lock1': {ScDeviceType.joystick: ScRebind(ScInput.parse('js1_button12')!)},
        'player/jump': {ScDeviceType.joystick: ScRebind(ScInput.parse('js1_button12')!)},
      };
      final idx = ScBindingIndex(profile, custom);
      final lock = profile.actionsById['spaceship_targeting/lock1']!;
      final slot = scResolveSlot(lock, ScDeviceType.joystick, custom[lock.id]);
      final conflicts = idx.conflictsFor(lock, slot);
      expect(conflicts.map((c) => c.other.action.name), ['v_toggle_landing_system']);
    });

    test('default-only overlaps are not reported', () {
      final landing = profile.actionsById['spaceship_movement/v_toggle_landing_system']!;
      final kb = scResolveSlot(landing, ScDeviceType.keyboard, null);
      // `n` is also the on-foot jump default, but different context and both are defaults.
      expect(index.conflictsFor(landing, kb), isEmpty);
    });
  });

  test('ship operator modes never clash with each other, but do with always-on ship controls', () {
    expect(scContextsOverlap('spaceship_weapons', 'spaceship_mining'), isFalse);
    expect(scContextsOverlap('spaceship_salvage', 'spaceship_scanning'), isFalse);
    expect(scContextsOverlap('spaceship_weapons', 'spaceship_auto_weapons'), isTrue);
    expect(scContextsOverlap('spaceship_mining', 'spaceship_movement'), isTrue);
    expect(scContextsOverlap('spaceship_mining', 'player'), isFalse);
    expect(scContextsOverlap('spaceship_mining', 'default'), isTrue);
  });

  group('dual stick numbering', () {
    test('swap moves joystick bindings between js1 and js2 only', () {
      final rb = ScProfileDocument.parse(kActionMapsXml).readRebinds();
      final swapped = scSwapJoystickInstances(rb, 1, 2);
      expect(swapped['spaceship_movement/v_strafe_up']![ScDeviceType.joystick]!.input.toXml(), 'js1_button5');
      expect(swapped['spaceship_movement/v_strafe_up']![ScDeviceType.joystick]!.activationMode, 'tap');
      expect(swapped['spaceship_targeting/lock1']![ScDeviceType.joystick]!.input.toXml(), 'js2_hat1_left');
      // Swapping back restores the original.
      final back = scSwapJoystickInstances(swapped, 1, 2);
      expect(back['spaceship_targeting/lock1']![ScDeviceType.joystick]!.input.toXml(), 'js1_hat1_left');
    });

    test('renumbering composes across several swaps', () {
      var r = scComposeRenumber(const {}, 1, 2);
      expect(r, {1: 2, 2: 1});
      r = scComposeRenumber(r, 1, 2);
      expect(r, isEmpty);
      r = scComposeRenumber(const {}, 1, 2);
      r = scComposeRenumber(r, 2, 3); // original 1 now at 2 → moves to 3
      expect(r, {1: 3, 2: 1, 3: 2});
    });
  });

  // Optional smoke test against real game files extracted from Data.p4k:
  // set SC_KEYBIND_TEST_DIR to a folder holding defaultProfile.xml and Mappings/*.xml.
  final realDir = Platform.environment['SC_KEYBIND_TEST_DIR'];
  test('real defaultProfile.xml and official layouts parse', () {
    final profile = ScDefaultProfile.parse(File('$realDir/defaultProfile.xml').readAsStringSync());
    expect(profile.maps.length, greaterThan(40));
    expect(profile.actionsById.length, greaterThan(1000));
    expect(profile.activationModes.length, greaterThanOrEqualTo(18));
    for (final f in Directory('$realDir/Mappings').listSync().whereType<File>()) {
      final doc = ScProfileDocument.parse(f.readAsStringSync());
      final rb = doc.readRebinds();
      for (final id in rb.keys) {
        expect(id.contains('/'), isTrue);
      }
      final idx = ScBindingIndex(profile, rb);
      expect(idx, isNotNull);
    }
  }, skip: realDir == null ? 'SC_KEYBIND_TEST_DIR not set' : false);
}
