import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_source.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/ui/tools/keybinding/widgets/capture_dialog.dart';

import 'fixtures.dart';

/// Drives the record dialog with scripted stick / gamepad events and real key and mouse events.
void main() {
  late FakeGame game;
  late FakeInput input;
  late ProviderContainer container;

  KeybindingModel model() => container.read(keybindingModelProvider.notifier);

  ScActionDef action(String id) => container.read(keybindingModelProvider).data!.profile.actionsById[id]!;

  String? bound(String id, ScDeviceType d) => container.read(keybindingModelProvider).rebinds[id]?[d]?.input.toXml();

  setUpAll(() async => S.load(const Locale('zh', 'CN')));

  Future<void> setUpGame(WidgetTester tester, {List<KbInputDevice>? devices}) async {
    await tester.runAsync(() async {
      game = await FakeGame.create();
      input = FakeInput(game.cacheRoot, devices: devices);
      container = ProviderContainer(overrides: [keybindingEnvironmentProvider.overrideWithValue(input.env)]);
      container.listen(keybindingModelProvider, (_, _) {});
      await model().load(game.path);
    });
    addTearDown(() async {
      container.dispose();
      await tester.runAsync(game.dispose);
    });
  }

  /// Settles the dialog's fixed-length animations; the listening ProgressRing never settles.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 60));
    }
  }

  Future<void> openCapture(WidgetTester tester, String actionId, ScDeviceType device) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: FluentApp(
          home: Builder(
            builder: (ctx) => Center(
              child: Button(
                onPressed: () => showCaptureDialog(ctx, model(), action(actionId), device),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await settle(tester);
    expect(find.text('确认绑定'), findsOneWidget);
  }

  Future<void> emit(WidgetTester tester, KbInputEvent e) async {
    input.emit(e);
    await settle(tester);
  }

  Future<void> confirm(WidgetTester tester) async {
    await tester.tap(find.text('确认绑定'));
    await settle(tester);
    expect(find.text('确认绑定'), findsNothing);
  }

  group('joystick', () {
    testWidgets('listens to every stick; the one pressed decides js1 / js2', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'spaceship_targeting/lock1', ScDeviceType.joystick);
      expect(input.capturing, isTrue);
      expect(find.textContaining('JS1 · VKB-Sim Gladiator NXT R'), findsOneWidget);
      expect(find.textContaining('JS2 · VKB-Sim Gladiator NXT L'), findsOneWidget);

      await emit(tester, eventFrom(vkbRight, 'hat1_up'));
      expect(find.text('JS1 · 帽键1 ↑'), findsOneWidget);
      // Later input is ignored until "record again".
      await emit(tester, eventFrom(vkbLeft, 'button7'));
      expect(find.text('JS1 · 帽键1 ↑'), findsOneWidget);

      await tester.tap(find.text('重新录制'));
      await settle(tester);
      await emit(tester, eventFrom(vkbLeft, 'x'));
      expect(find.text('JS2 · X 轴'), findsOneWidget);
      expect(find.text('js2_x'), findsOneWidget);

      await confirm(tester);
      expect(bound('spaceship_targeting/lock1', ScDeviceType.joystick), 'js2_x');
      expect(input.stops, greaterThanOrEqualTo(1), reason: 'capture stops when the dialog closes');
    });

    testWidgets('button releases are not recorded', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'spaceship_targeting/lock1', ScDeviceType.joystick);
      await emit(tester, eventFrom(vkbRight, 'button7', released: true));
      expect(find.text('js1_button7'), findsNothing);
      await emit(tester, eventFrom(vkbRight, 'button8'));
      expect(find.text('js1_button8'), findsOneWidget);
    });

    testWidgets('gamepad (XInput) events are ignored while recording a joystick', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'spaceship_targeting/lock1', ScDeviceType.joystick);
      await emit(tester, eventFrom(xpad, 'a'));
      expect(find.text('js1_a'), findsNothing);
      await emit(tester, eventFrom(vkbLeft, 'button3'));
      expect(find.text('JS2 · 按钮 3'), findsOneWidget);
    });

    testWidgets('a stick not in actionmaps.xml gets the next number', (tester) async {
      await setUpGame(tester, devices: [vkbRight, vkbLeft, pedals]);
      await openCapture(tester, 'spaceship_movement/v_strafe_up', ScDeviceType.joystick);
      await emit(tester, eventFrom(pedals, 'z'));
      expect(find.text('JS3 · Z 轴'), findsOneWidget);
      await confirm(tester);
      expect(bound('spaceship_movement/v_strafe_up', ScDeviceType.joystick), 'js3_z');
      expect(container.read(keybindingModelProvider).joysticks[3]!.productId, pedals.productId);
    });

    testWidgets('holding a keyboard modifier records a modifier + button combo', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'spaceship_targeting/lock1', ScDeviceType.joystick);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await emit(tester, eventFrom(vkbRight, 'button4'));
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      expect(find.text('js1_lalt+button4'), findsOneWidget);
    });
  });

  group('conflicts', () {
    testWidgets('replace takes the input away from the other action', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'spaceship_targeting/lock1', ScDeviceType.joystick);
      await emit(tester, eventFrom(vkbRight, 'button12'));
      expect(find.text('该输入已被使用'), findsOneWidget);
      expect(find.textContaining('着陆系统（切换）'), findsWidgets);
      await confirm(tester); // "replace" is preselected
      final landing = action('spaceship_movement/v_toggle_landing_system');
      expect(model().slotOf(landing, ScDeviceType.joystick).state, ScSlotState.cleared);
      expect(bound('spaceship_targeting/lock1', ScDeviceType.joystick), 'js1_button12');
      expect(model().conflictCount, 0);
    });

    testWidgets('keep both leaves both bound and flagged', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'spaceship_movement/v_strafe_up', ScDeviceType.joystick);
      await emit(tester, eventFrom(vkbRight, 'button12'));
      await tester.tap(find.text('保留两者（按下时同时触发）'));
      await settle(tester);
      await confirm(tester);
      final landing = action('spaceship_movement/v_toggle_landing_system');
      expect(model().slotOf(landing, ScDeviceType.joystick).state, ScSlotState.byDefault);
      expect(model().hasConflict(landing), isTrue);
    });

    testWidgets('tap + long press on one hat is shown as a combo, not a conflict', (tester) async {
      await setUpGame(tester);
      // lock1 (tap) and pin1_hold (long press) already share js1_hat1_left in the profile.
      await openCapture(tester, 'spaceship_targeting/pin1_hold', ScDeviceType.joystick);
      await emit(tester, eventFrom(vkbRight, 'hat1_left'));
      expect(find.text('该输入已被使用'), findsNothing);
    });
  });

  group('keyboard and mouse', () {
    testWidgets('key combo', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'player/jump', ScDeviceType.keyboard);
      expect(input.starts, 0, reason: 'no HID capture for the keyboard slot');
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyF);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyF);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      await settle(tester);
      expect(find.text('LAlt + F'), findsOneWidget);
      await confirm(tester);
      expect(bound('player/jump', ScDeviceType.keyboard), 'kb1_lalt+f');
    });

    testWidgets('a modifier pressed and released alone binds itself', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'player/jump', ScDeviceType.keyboard);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await settle(tester);
      expect(find.textContaining('已按住 LSHIFT'), findsOneWidget);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await settle(tester);
      expect(find.text('kb1_lshift'), findsOneWidget);
    });

    testWidgets('Esc is recorded, not used to close the dialog', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'player/jump', ScDeviceType.keyboard);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(tester);
      expect(find.text('kb1_escape'), findsOneWidget);
    });

    testWidgets('mouse button in the capture pad goes to the mouse slot', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'player/jump', ScDeviceType.keyboard);
      final pad = tester.getCenter(find.text('在此处点击鼠标按键或滚动滚轮'));
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse, buttons: kSecondaryMouseButton);
      await gesture.down(pad);
      await gesture.up();
      await settle(tester);
      expect(find.text('鼠标右键'), findsOneWidget);
      expect(find.text('该输入将保存到「鼠标」栏位'), findsOneWidget);
      await confirm(tester);
      expect(bound('player/jump', ScDeviceType.mouse), 'mo1_mouse2');
    });

    testWidgets('mouse wheel', (tester) async {
      await setUpGame(tester);
      await openCapture(tester, 'player/jump', ScDeviceType.keyboard);
      final pad = tester.getCenter(find.text('在此处点击鼠标按键或滚动滚轮'));
      await tester.sendEventToBinding(PointerScrollEvent(position: pad, scrollDelta: const Offset(0, -40)));
      await settle(tester);
      expect(find.text('mo1_mwheel_up'), findsOneWidget);
    });
  });

  testWidgets('gamepad slot takes XInput and ignores sticks', (tester) async {
    await setUpGame(tester);
    await openCapture(tester, 'player/gp_group', ScDeviceType.gamepad);
    await emit(tester, eventFrom(vkbRight, 'button1'));
    expect(find.text('确认绑定'), findsOneWidget);
    await emit(tester, eventFrom(xpad, 'shoulderr'));
    expect(find.text('gp1_shoulderr'), findsOneWidget);
    await confirm(tester);
    expect(bound('player/gp_group', ScDeviceType.gamepad), 'gp1_shoulderr');
  });
}
