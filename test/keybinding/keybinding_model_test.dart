import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_source.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_profile_document.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:xml/xml.dart';

import 'fixtures.dart';

void main() {
  late FakeGame game;
  late FakeInput input;
  late ProviderContainer container;

  KeybindingModel model() => container.read(keybindingModelProvider.notifier);

  KeybindingState state() => container.read(keybindingModelProvider);

  setUpAll(() async => S.load(const Locale('zh', 'CN')));

  setUp(() async {
    game = await FakeGame.create();
    input = FakeInput(game.cacheRoot);
    container = ProviderContainer(overrides: [keybindingEnvironmentProvider.overrideWithValue(input.env)]);
    container.listen(keybindingModelProvider, (_, _) {});
    await model().load(game.path);
  });

  tearDown(() async {
    container.dispose();
    await game.dispose();
  });

  test('loads cached game data, localized labels with English fallback, and the player profile', () {
    final s = state();
    expect(s.errorMessage, isNull);
    expect(s.data!.gameVersion, '4.9.186.58667');
    expect(s.data!.language, 'chinese_(simplified)');
    // Unlabelled maps (debug) are hidden; groups keep the game's labels.
    final groups = s.categories.expand((c) => c.groups).map((g) => g.label).toList();
    expect(groups, containsAll(['航行 - 移动', '载具 - 瞄准', 'Vehicles - Seats and Operator Modes', 'On Foot - General']));
    expect(s.categories.map((c) => c.label), containsAll(['航行', 'VEHICLES', 'ON FOOT']));
    final up = s.data!.profile.actionsById['spaceship_movement/v_strafe_up']!;
    expect(model().actionLabel(up), '平移：向上（绝对值）');
    // `ui_x,P=` style keys resolve too.
    expect(
      model().actionLabel(s.data!.profile.actionsById['seat_general/v_operator_mode_cycle_forward']!),
      'Next Operator Mode',
    );
    expect(model().slotOf(up, ScDeviceType.joystick).input!.toXml(), 'js2_button5');
    expect(model().isDirty, isFalse);
  });

  test('sticks recorded in actionmaps.xml keep their numbers and match connected hardware', () {
    final js = state().joysticks;
    expect(js.keys, [1, 2]);
    expect(js[1]!.deviceId, 'dev-r');
    expect(js[2]!.deviceId, 'dev-l');
    expect(js[1]!.fromProfile && js[2]!.fromProfile, isTrue);
    expect(js.values.every((j) => j.connected), isTrue);
  });

  test('an unrecorded stick gets the next free number and is remembered', () async {
    input.devices = [vkbRight, vkbLeft, pedals];
    await model().refreshJoysticks();
    expect(state().joysticks[3]!.deviceId, 'dev-p');
    expect(state().joysticks[3]!.fromProfile, isFalse);
    // Capturing from it resolves to the same number.
    expect(model().joystickInstanceFor('dev-p', pedals.vendorId, pedals.productId, pedals.name), 3);
  });

  test('bind with replace removes the input from clashing actions; clear and reset round-trip', () {
    final p = state().data!.profile;
    final lock = p.actionsById['spaceship_targeting/lock1']!;
    final landing = p.actionsById['spaceship_movement/v_toggle_landing_system']!;
    final input = ScInput.parse('js1_button12')!;

    expect(model().conflictsIfBound(lock, input).map((r) => r.other.action.name), ['v_toggle_landing_system']);
    model().bind(lock, input, replaceConflicts: true);
    expect(model().slotOf(lock, ScDeviceType.joystick).input, input);
    expect(model().slotOf(landing, ScDeviceType.joystick).state, ScSlotState.cleared);
    expect(model().conflictCount, 0);
    expect(model().isDirty, isTrue);

    model().resetBinding(landing, ScDeviceType.joystick);
    expect(model().slotOf(landing, ScDeviceType.joystick).state, ScSlotState.byDefault);
    expect(model().conflictsOf(lock, ScDeviceType.joystick), isNotEmpty);
    expect(model().conflictCount, 2);

    model().clearBinding(lock, ScDeviceType.joystick);
    // No default to clear, so the override disappears instead of becoming "js1_ ".
    expect(state().rebinds[lock.id]?[ScDeviceType.joystick], isNull);
  });

  test('keep-both binding stays flagged as a conflict; restating the default is not a change', () {
    final p = state().data!.profile;
    final exit = p.actionsById['seat_general/v_emergency_exit']!;
    model().bind(exit, ScInput.parse('kb1_lshift+u')!);
    expect(state().rebinds[exit.id], isNull, reason: 'same as the default');
    final jump = p.actionsById['player/jump']!;
    model().bind(jump, ScInput.parse('kb1_backspace')!);
    // Different contexts (on foot vs ship): not a conflict with self destruct.
    expect(model().hasConflict(jump), isFalse);
    // Tap (landing) on self destruct's long-press key is a timing combo, not a conflict.
    final landing = p.actionsById['spaceship_movement/v_toggle_landing_system']!;
    model().bind(landing, ScInput.parse('kb1_backspace')!);
    expect(model().hasConflict(landing), isFalse);
    expect(model().relationsOf(landing, ScDeviceType.keyboard).single.isPair, isTrue);
    // A plain press/release action on the same key does clash.
    final up = p.actionsById['spaceship_movement/v_strafe_up']!;
    model().bind(up, ScInput.parse('kb1_backspace')!);
    expect(model().hasConflict(up), isTrue);
    expect(
      model().conflictsOf(up, ScDeviceType.keyboard).map((c) => c.other.action.name),
      unorderedEquals(['v_self_destruct', 'v_toggle_landing_system']),
    );
  });

  test('activation mode on a default binding is saved as a rebind of the default input', () {
    final exit = state().data!.profile.actionsById['seat_general/v_emergency_exit']!;
    model().setActivationMode(exit, ScDeviceType.keyboard, 'double_tap');
    final rb = state().rebinds[exit.id]![ScDeviceType.keyboard]!;
    expect(rb.input.toXml(), 'kb1_lshift+u');
    expect(rb.activationMode, 'double_tap');
    expect(model().isModified(exit), isTrue);
    model().setActivationMode(exit, ScDeviceType.keyboard, null);
    expect(state().rebinds[exit.id], isNull);
  });

  test('search matches labels, action names and input codes', () {
    model().setQuery('js2_button5');
    expect(model().visibleActions().map((a) => a.name), ['v_strafe_up']);
    model().setQuery('着陆');
    expect(model().visibleActions().map((a) => a.name), ['v_toggle_landing_system']);
    model().setQuery('');
    model().setJoystickInstanceFilter(1);
    model().selectGroup(state().categories.expand((c) => c.groups).firstWhere((g) => g.label == '载具 - 瞄准').id);
    expect(model().visibleActions().map((a) => a.name), ['lock1', 'pin1_hold']);
  });

  test('"all" is the default view; a category lists every group under it', () {
    expect(state().selectedGroupId, KeybindingModel.allScopeId);
    expect(model().scopeSpansGroups, isTrue);
    expect(model().visibleActions().length, model().allActions().length);

    final flight = state().categories.firstWhere((c) => c.groups.length > 1);
    model().selectGroup('${KeybindingModel.categoryScopePrefix}${flight.id}');
    expect(model().scopeLabel(), flight.label);
    expect(model().visibleActions().map((a) => a.id), [for (final g in flight.groups) ...g.actions.map((a) => a.id)]);
    expect(state().selectedActionId, flight.groups.first.actions.first.id);

    // Revealing an action already in the category keeps the category view.
    model().revealAction(flight.groups.last.actions.first);
    expect(state().selectedGroupId, '${KeybindingModel.categoryScopePrefix}${flight.id}');
    // One outside it jumps to its group.
    final other = model().allActions().firstWhere((a) => a.mapName == 'player');
    model().revealAction(other);
    expect(model().scopeSpansGroups, isFalse);
    expect(model().visibleActions(), contains(other));
  });

  test('swapping js1/js2 then writing actionmaps.xml renumbers bindings and options, with a backup', () async {
    model().swapJoysticks(1, 2);
    final up = state().data!.profile.actionsById['spaceship_movement/v_strafe_up']!;
    expect(model().slotOf(up, ScDeviceType.joystick).input!.toXml(), 'js1_button5');
    expect(state().joysticks[1]!.deviceId, 'dev-l');
    expect(model().isDirty, isTrue);

    final backups = await model().writeActionMaps();
    expect(backups.keys, ['LIVE']);
    expect(await File(backups['LIVE']!).readAsString(), contains('js2_button5'));
    expect(model().isDirty, isFalse);

    final written = ScProfileDocument.parse(await game.actionMaps.readAsString());
    expect(
      written.readRebinds()['spaceship_movement/v_strafe_up']![ScDeviceType.joystick]!.input.toXml(),
      'js1_button5',
    );
    final js1 = written.container
        .findElements('options')
        .firstWhere((e) => e.getAttribute('type') == 'joystick' && e.getAttribute('instance') == '1');
    expect(js1.getAttribute('Product'), contains('{0201231D-0000-0000-0000-504944564944}'));
    // The left stick's invert setting moved with it.
    expect(js1.findElements('flight_move_strafe_longitudinal'), isNotEmpty);
    expect(written.container.findElements('modifiers'), isNotEmpty);
  });

  test('export writes a layout the game can load and does not touch actionmaps.xml', () async {
    final before = await game.actionMaps.readAsString();
    final lock = state().data!.profile.actionsById['spaceship_targeting/lock1']!;
    model().bind(lock, ScInput.parse('kb1_lalt+f')!);
    final file = (await model().exportLayout('sctoolbox_test')).single;
    expect(file.path, '${game.mappings.path}\\sctoolbox_test.xml');
    final layout = ScProfileDocument.parse(await file.readAsString());
    expect(layout.isLayout, isTrue);
    expect(layout.profileName, 'sctoolbox_test');
    expect(layout.readRebinds()['spaceship_targeting/lock1']![ScDeviceType.keyboard]!.input.toXml(), 'kb1_lalt+f');
    expect(await file.readAsString(), contains('<joystick instance="2"/>'));
    expect(await game.actionMaps.readAsString(), before);
    expect(model().isDirty, isTrue, reason: 'export does not change the live profile');
  });

  test('sync install writes the layout and actionmaps.xml into other channels too', () async {
    final ptu = Directory('${game.root.parent.path}\\PTU');
    await File('${ptu.path}\\Data.p4k').create(recursive: true);
    await Directory('${game.root.parent.path}\\.cache').create();
    expect(await model().repo.listSiblingChannels(), ['LIVE', 'PTU']);

    final jump = state().data!.profile.actionsById['player/jump']!;
    model().bind(jump, ScInput.parse('kb1_lalt+j')!);
    final files = await model().exportLayout('synced', channels: ['LIVE', 'PTU']);
    expect(files.map((f) => f.path), [
      '${game.mappings.path}\\synced.xml',
      '${ptu.path}\\user\\client\\0\\Controls\\Mappings\\synced.xml',
    ]);

    final backups = await model().writeActionMaps(channels: ['LIVE', 'PTU']);
    expect(backups['PTU'], isNull, reason: 'PTU had no actionmaps.xml to back up');
    final ptuDoc = ScProfileDocument.parse(
      await File('${ptu.path}\\user\\client\\0\\Profiles\\default\\actionmaps.xml').readAsString(),
    );
    expect(ptuDoc.readRebinds()['player/jump']![ScDeviceType.keyboard]!.input.toXml(), 'kb1_lalt+j');
    expect(model().isDirty, isFalse);
  });

  test('import a layout and restore a backup replace the working copy', () async {
    final layout = File('${game.path}\\import.xml');
    await layout.writeAsString(
      ScProfileDocument.buildLayout(
        profileName: 'x',
        rebinds: {
          'player/jump': {ScDeviceType.keyboard: ScRebind(ScInput.parse('kb1_space')!)},
        },
        mapOrder: const ['player'],
        options: const [],
      ),
    );
    final incoming = await model().readLayoutRebinds(layout);
    // Replace: the three current overrides go back to default, jump gets its new key.
    final changes = model().previewImport(incoming, merge: false);
    expect(changes.map((c) => c.action.name).toSet(), {'v_strafe_up', 'lock1', 'pin1_hold', 'jump'});
    // Merge: only jump changes.
    expect(model().previewImport(incoming, merge: true).map((c) => c.action.name), ['jump']);
    model().applyImport(incoming, merge: false);
    expect(state().rebinds.keys, ['player/jump']);

    model().discardChanges();
    expect(state().rebinds.length, 3);
    await model().writeActionMaps(); // creates a backup of the original
    final backups = await model().listBackups();
    expect(backups, isNotEmpty);
    model().resetAllToDefaults();
    expect(state().rebinds, isEmpty);
    model().applyImport(await model().readLayoutRebinds(backups.first), merge: false);
    expect(state().rebinds.length, 3);
  });

  test('restoring a backup brings back its stick numbering too, not just the bindings', () async {
    model().swapJoysticks(1, 2);
    await model().writeActionMaps(); // backs up the original, writes the swapped profile
    final backup = (await model().listBackups()).first;

    await model().restoreProfile(await model().repo.readLayout(backup));
    expect(model().isDirty, isTrue);
    expect(
      model()
          .slotOf(state().data!.profile.actionsById['spaceship_movement/v_strafe_up']!, ScDeviceType.joystick)
          .input!
          .toXml(),
      'js2_button5',
    );
    expect(state().joysticks[1]!.deviceId, 'dev-r');
    await model().writeActionMaps();

    final written = ScProfileDocument.parse(await game.actionMaps.readAsString());
    final js1 = written.readOptions().firstWhere((o) => o.device == ScDeviceType.joystick && o.instance == 1);
    expect(js1.product, contains('NXT R'));
    expect(
      written.readRebinds()['spaceship_movement/v_strafe_up']![ScDeviceType.joystick]!.input.toXml(),
      'js2_button5',
    );
    expect(model().isDirty, isFalse);
  });

  test('swapped sticks that are not in the profile keep their numbers across a device refresh', () async {
    const throttle = KbInputDevice(id: 'dev-t', name: 'Throttle', vendorId: 0x044F, productId: 0x0404);
    input.devices = [vkbRight, vkbLeft, pedals, throttle];
    await model().refreshJoysticks();
    expect(state().joysticks[3]!.deviceId, 'dev-p');
    expect(state().joysticks[4]!.deviceId, 'dev-t');
    model().swapJoysticks(3, 4);
    await model().refreshJoysticks();
    expect(state().joysticks[3]!.deviceId, 'dev-t');
    expect(state().joysticks[4]!.deviceId, 'dev-p');
  });

  test('discarding a swap of unrecorded sticks puts their numbers back', () async {
    const throttle = KbInputDevice(id: 'dev-t', name: 'Throttle', vendorId: 0x044F, productId: 0x0404);
    input.devices = [vkbRight, vkbLeft, pedals, throttle];
    await model().refreshJoysticks();
    model().swapJoysticks(3, 4);
    model().discardChanges();
    await model().refreshJoysticks();
    expect(state().joysticks[3]!.deviceId, 'dev-p');
    expect(state().joysticks[4]!.deviceId, 'dev-t');
    expect(model().isDirty, isFalse);
  });

  test('a failing sibling channel still leaves this channel saved', () async {
    final ptu = Directory('${game.root.parent.path}\\PTU');
    await Directory('${ptu.path}\\user').create(recursive: true);
    // A directory where PTU's actionmaps.xml should go makes that write fail.
    await Directory('${ptu.path}\\user\\client\\0\\Profiles\\default\\actionmaps.xml').create(recursive: true);
    model().resetAllToDefaults();
    await expectLater(model().writeActionMaps(channels: ['LIVE', 'PTU']), throwsA(anything));
    expect(model().isDirty, isFalse);
    expect(await model().actionMapsChangedOnDisk(), isFalse);
  });

  test('saving notices actionmaps.xml changed on disk since loading', () async {
    expect(await model().actionMapsChangedOnDisk(), isFalse);
    await game.actionMaps.writeAsString(
      (await game.actionMaps.readAsString()).replaceAll('js2_button5', 'js2_button6'),
    );
    expect(await model().actionMapsChangedOnDisk(), isTrue);
    await model().writeActionMaps();
    expect(await model().actionMapsChangedOnDisk(), isFalse);
  });

  test('export reports layouts it would overwrite', () async {
    expect(await model().existingLayouts('mine'), isEmpty);
    await model().exportLayout('mine');
    expect((await model().existingLayouts('mine')).single.path, endsWith('mine.xml'));
  });

  test('game-running check comes from the environment', () async {
    expect(await model().isGameRunning(), isFalse);
    input.gameRunning = true;
    expect(await model().isGameRunning(), isTrue);
  });
}
