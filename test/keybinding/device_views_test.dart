import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/ui/tools/keybinding/widgets/device_diagram.dart';
import 'package:starcitizen_doctor/ui/tools/keybinding/widgets/gamepad_diagram.dart';
import 'package:starcitizen_doctor/ui/tools/keybinding/widgets/input_binding_dialog.dart';
import 'package:starcitizen_doctor/ui/tools/keybinding/widgets/keyboard_mouse_diagram.dart';

import 'fixtures.dart';

/// Device diagrams and the input editor: taps on inputs and edits made from the device side.
void main() {
  late FakeGame game;
  late ProviderContainer container;

  KeybindingModel model() => container.read(keybindingModelProvider.notifier);

  ScActionDef action(String id) => container.read(keybindingModelProvider).data!.profile.actionsById[id]!;

  setUpAll(() async => S.load(const Locale('zh', 'CN')));

  Future<void> setUpGame(WidgetTester tester) async {
    await tester.runAsync(() async {
      game = await FakeGame.create();
      final input = FakeInput(game.cacheRoot);
      container = ProviderContainer(overrides: [keybindingEnvironmentProvider.overrideWithValue(input.env)]);
      container.listen(keybindingModelProvider, (_, _) {});
      await model().load(game.path);
    });
    addTearDown(() async {
      container.dispose();
      await tester.runAsync(game.dispose);
    });
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 60));
    }
  }

  Future<void> pumpHost(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: FluentApp(home: SizedBox(width: 1200, height: 800, child: child)),
      ),
    );
    await settle(tester);
  }

  List<DeviceBinding> bindingsFor(Set<ScDeviceType> devices, {int? instance}) => collectDeviceBindings(
    model(),
    devices: devices,
    instance: instance,
    actionFilter: (_) => true,
    inputFilter: (i) => i.modifiers.isEmpty,
  );

  group('input editor', () {
    Future<void> open(WidgetTester tester, ScInput input, {ValueChanged<ScActionDef>? onReveal}) async {
      await pumpHost(
        tester,
        Builder(
          builder: (ctx) => Center(
            child: Button(
              onPressed: () => showInputBindingDialog(ctx, input: input, onReveal: onReveal ?? (_) {}),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await settle(tester);
    }

    testWidgets('lists every action on the input and removes one', (tester) async {
      await setUpGame(tester);
      await open(tester, ScInput.parse('kb1_n')!);
      expect(find.text('当前绑定 2 个动作'), findsOneWidget);
      expect(find.text('着陆系统（切换）'), findsOneWidget);
      expect(find.text('Jump'), findsOneWidget);

      await tester.tap(find.text('解除').first);
      await settle(tester);
      expect(find.text('当前绑定 1 个动作'), findsOneWidget);
      final landing = action('spaceship_movement/v_toggle_landing_system');
      final jump = action('player/jump');
      expect([
        model().slotOf(landing, ScDeviceType.keyboard).state,
        model().slotOf(jump, ScDeviceType.keyboard).state,
      ], contains(ScSlotState.cleared));
    });

    testWidgets('cancel undoes everything done in the editor; done keeps it', (tester) async {
      await setUpGame(tester);
      await open(tester, ScInput.parse('kb1_n')!);
      await tester.tap(find.text('解除').first);
      await settle(tester);
      expect(
        model().isModified(action('spaceship_movement/v_toggle_landing_system')) ||
            model().isModified(action('player/jump')),
        isTrue,
      );
      await tester.tap(find.text('取消'));
      await settle(tester);
      expect(model().isModified(action('spaceship_movement/v_toggle_landing_system')), isFalse);
      expect(model().isModified(action('player/jump')), isFalse);

      await tester.tap(find.text('open'));
      await settle(tester);
      await tester.tap(find.text('解除').first);
      await settle(tester);
      await tester.tap(find.text('完成'));
      await settle(tester);
      expect(
        model().isModified(action('spaceship_movement/v_toggle_landing_system')) ||
            model().isModified(action('player/jump')),
        isTrue,
      );
    });

    testWidgets('modifier toggles switch the edited input', (tester) async {
      await setUpGame(tester);
      await open(tester, ScInput.parse('kb1_n')!);
      await tester.tap(find.text('LAlt'));
      await settle(tester);
      expect(find.text('LAlt + N'), findsOneWidget);
      expect(find.text('当前绑定 0 个动作'), findsOneWidget);
    });

    testWidgets('binds a searched action to the input', (tester) async {
      await setUpGame(tester);
      await open(tester, ScInput.parse('kb1_lalt+j')!);
      await tester.enterText(find.byType(TextBox), 'Self');
      await settle(tester);
      await tester.tap(find.textContaining('Self Destruct').last);
      await settle(tester);
      expect(
        model().slotOf(action('spaceship_movement/v_self_destruct'), ScDeviceType.keyboard).input!.toXml(),
        'kb1_lalt+j',
      );
      expect(find.text('当前绑定 1 个动作'), findsOneWidget);
    });

    testWidgets('"view" closes the editor and reports the action', (tester) async {
      await setUpGame(tester);
      ScActionDef? revealed;
      await open(tester, ScInput.parse('kb1_n')!, onReveal: (a) => revealed = a);
      await tester.tap(find.text('查看').first);
      await settle(tester);
      expect(revealed, isNotNull);
      expect(find.text('绑定新动作'), findsNothing);
    });
  });

  group('diagrams', () {
    testWidgets('keyboard load map counts actions per key and opens keys on tap', (tester) async {
      await setUpGame(tester);
      ScInput? tapped;
      await pumpHost(
        tester,
        KeyboardMouseDiagram(
          bindings: bindingsFor({ScDeviceType.keyboard, ScDeviceType.mouse}),
          model: model(),
          modifierLayer: false,
          onInputTap: (i) => tapped = i,
        ),
      );
      // `n` carries landing + jump.
      await tester.tap(find.text('N'));
      expect(tapped!.toXml(), 'kb1_n');
      // An unused key still opens, so something can be bound to it.
      await tester.tap(find.text('F3'));
      expect(tapped!.toXml(), 'kb1_f3');
      // Mouse caps are short; the middle button carries a default.
      await tester.tap(find.text('M3'));
      expect(tapped!.toXml(), 'mo1_mouse3');
      await tester.pump(const Duration(seconds: 3)); // let tooltip timers finish
    });

    testWidgets('combo layer shows the modifier color legend', (tester) async {
      await setUpGame(tester);
      await pumpHost(
        tester,
        KeyboardMouseDiagram(
          bindings: collectDeviceBindings(
            model(),
            devices: {ScDeviceType.keyboard, ScDeviceType.mouse},
            actionFilter: (_) => true,
            inputFilter: (i) => i.modifiers.isNotEmpty,
          ),
          model: model(),
          modifierLayer: true,
          onInputTap: (_) {},
        ),
      );
      expect(find.text('键帽条纹颜色表示与之组合的修饰键'), findsOneWidget);
      expect(find.text('LShift'), findsWidgets); // legend + key
    });

    testWidgets('stick diagram labels bound inputs; bare spots are clickable too', (tester) async {
      await setUpGame(tester);
      ScInput? tapped;
      await pumpHost(
        tester,
        ButtonDiagram(
          template: stickTemplate,
          bindings: bindingsFor({ScDeviceType.joystick}, instance: 1),
          model: model(),
          onInputTap: (i) => tapped = i,
          inputForKey: (k) => ScInput(ScDeviceType.joystick, 1, const [], k),
        ),
      );
      // lock1 (tap) and pin1_hold (long press) share hat1 ←: one card, "+1".
      final card = find.textContaining('标记光标 1 - 锁定/解除已标记目标  +1');
      expect(card, findsOneWidget);
      await tester.tap(card);
      expect(tapped!.toXml(), 'js1_hat1_left');
      // button12 (landing default) has a spot on the drawing template? No: listed under "other inputs".
      expect(find.text('其他输入（示意图上没有对应位置）'), findsOneWidget);
      // Tapping the unbound trigger spot proposes js1_button1.
      await tester.tap(find.byTooltip('按钮 1'));
      expect(tapped!.toXml(), 'js1_button1');
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('a held input with no spot on the stick drawing lights its card under "other inputs"', (tester) async {
      await setUpGame(tester);
      final bindings = bindingsFor({ScDeviceType.joystick}, instance: 1);
      bindings.firstWhere((b) => b.input.key == 'button12').active = true;
      await pumpHost(
        tester,
        ButtonDiagram(
          template: stickTemplate,
          bindings: bindings,
          model: model(),
          onInputTap: (_) {},
          inputForKey: (k) => ScInput(ScDeviceType.joystick, 1, const [], k),
        ),
      );
      expect(stickTemplate.anchors.containsKey('button12'), isFalse);
      final card = tester.widget<InputLabelCard>(
        find.byWidgetPredicate((w) => w is InputLabelCard && w.binding.input.key == 'button12'),
      );
      expect(card.lit, isTrue);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('gamepad diagram renders XInput-style inputs', (tester) async {
      await setUpGame(tester);
      ScInput? tapped;
      await pumpHost(
        tester,
        GamepadDiagram(bindings: bindingsFor({ScDeviceType.gamepad}), model: model(), onInputTap: (i) => tapped = i),
      );
      // gp_group defaults to dpad_up, landing to dpad_down.
      expect(find.text('着陆系统（切换）'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('pad_dpad_down')));
      expect(tapped!.toXml(), 'gp1_dpad_down');
      // Unbound face button still opens.
      await tester.tap(find.byKey(const ValueKey('pad_a')));
      expect(tapped!.toXml(), 'gp1_a');
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
