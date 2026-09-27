import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_format.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_source.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'binding_chip.dart';
import 'device_diagram.dart';
import 'gamepad_diagram.dart';
import 'input_binding_dialog.dart';
import 'keybinding_styles.dart';
import 'keybinding_text.dart';
import 'keyboard_keys.dart';
import 'keyboard_mouse_diagram.dart';
import 'live_input.dart';

/// What the devices page shows on the right.
sealed class _Target {
  const _Target();
}

class _KbmTarget extends _Target {
  const _KbmTarget();

  @override
  bool operator ==(Object other) => other is _KbmTarget;

  @override
  int get hashCode => 1;
}

class _PadTarget extends _Target {
  const _PadTarget();

  @override
  bool operator ==(Object other) => other is _PadTarget;

  @override
  int get hashCode => 2;
}

class _StickTarget extends _Target {
  const _StickTarget(this.instance);

  final int instance;

  @override
  bool operator ==(Object other) => other is _StickTarget && other.instance == instance;

  @override
  int get hashCode => instance.hashCode + 10;
}

/// Every device the game binds: keyboard/mouse, gamepad and each joystick number, with a
/// diagram per device, js1/js2 swapping and naming for multi-stick setups.
class KeybindingDevicesPage extends HookConsumerWidget {
  const KeybindingDevicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(keybindingModelProvider);
    final model = ref.read(keybindingModelProvider.notifier);
    final selected = useState<_Target>(
      state.joysticks.isNotEmpty ? _StickTarget(state.joysticks.keys.first) : const _KbmTarget(),
    );
    final identifying = useState(false);
    final lastInput = useState<String?>(null);

    useEffect(() {
      final s = selected.value;
      if (s is _StickTarget && !state.joysticks.containsKey(s.instance)) selected.value = const _KbmTarget();
      return null;
    }, [state.joysticks]);

    final live = useMemoized(LiveInput.new);
    useEffect(() => live.dispose, const []);

    // Identify: listens to every device, starts half a second after the button is clicked (so that
    // click isn't caught), jumps to the first device that fires and switches itself off.
    final armedAt = useRef<DateTime?>(null);
    final pointerOnIdentifyButton = useRef(false);
    useEffect(() {
      armedAt.value = identifying.value ? DateTime.now().add(const Duration(milliseconds: 500)) : null;
      return null;
    }, [identifying.value]);
    void identified(_Target target, String text) {
      final at = armedAt.value;
      if (at == null || DateTime.now().isBefore(at)) return;
      armedAt.value = null;
      selected.value = target;
      lastInput.value = text;
      identifying.value = false;
    }

    // Keyboard: light keys while held (never swallows the event).
    useEffect(() {
      bool onKey(KeyEvent e) {
        live.onKey(e);
        final key = scKeyFor(e);
        if (e is KeyDownEvent && key != null) {
          identified(
            const _KbmTarget(),
            '${S.current.keybinding_device_keyboard} · ${scFormatBody(ScInput(ScDeviceType.keyboard, 1, const [], key))}',
          );
        }
        return false;
      }

      HardwareKeyboard.instance.addHandler(onKey);
      return () => HardwareKeyboard.instance.removeHandler(onKey);
    }, const []);

    void onPointer(PointerEvent e) {
      live.onPointer(e);
      if (e is PointerDownEvent && e.kind == PointerDeviceKind.mouse) {
        // The button's own Listener runs first and flags its clicks.
        if (pointerOnIdentifyButton.value) {
          pointerOnIdentifyButton.value = false;
          return;
        }
        identified(const _KbmTarget(), S.current.keybinding_device_mouse);
      }
    }

    void onPointerSignal(PointerSignalEvent e) {
      live.onPointerSignal(e);
      if (e is PointerScrollEvent) identified(const _KbmTarget(), S.current.keybinding_device_mouse);
    }

    // Sticks and pads: one capture for the page; lights the input, and in identify mode jumps to it.
    useEffect(() {
      StreamSubscription<KbInputEvent>? sub;
      sub = model.env.captureStart().listen(
        (e) {
          if (e.released) {
            if (e.isXInput) {
              live.release('gp:${e.input}');
            } else {
              live.release(
                'js${model.joystickInstanceFor(e.deviceId, e.vendorId, e.productId, e.deviceName)}:${e.input}',
              );
            }
            return;
          }
          if (e.isXInput) {
            live.feed('gp:${e.input}', e);
            identified(
              const _PadTarget(),
              '${e.deviceName} · ${scFormatBody(ScInput.parseBody(ScDeviceType.gamepad, e.input))}',
            );
            return;
          }
          final instance = model.joystickInstanceFor(e.deviceId, e.vendorId, e.productId, e.deviceName);
          live.feed('js$instance:${e.input}', e);
          identified(
            _StickTarget(instance),
            'JS$instance · ${scFormatBody(ScInput.parseBody(ScDeviceType.joystick, e.input))}',
          );
        },
        // Capture unavailable (e.g. no HID access): the page still works for keyboard and mouse.
        onError: (Object e) => dPrint('[keybinding] device capture error: $e'),
      );
      return () {
        sub?.cancel();
        model.env.captureStop();
      };
    }, const []);

    return makeDefaultPage(
      context,
      title: S.current.keybinding_devices_title,
      useBodyContainer: false,
      content: Listener(
        onPointerDown: onPointer,
        onPointerUp: live.onPointer,
        onPointerCancel: live.onPointer,
        onPointerSignal: onPointerSignal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 320,
                child: _DeviceList(
                  state: state,
                  model: model,
                  selected: selected.value,
                  onSelect: (t) => selected.value = t,
                  identifying: identifying.value,
                  onToggleIdentify: () => identifying.value = !identifying.value,
                  onIdentifyPointerDown: () => pointerOnIdentifyButton.value = true,
                  lastInput: lastInput.value,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                // Unkeyed on purpose: layer / scene / view choices carry over when switching devices.
                child: ValueListenableBuilder<Set<String>>(
                  valueListenable: live,
                  builder: (context, lit, _) =>
                      _DeviceOverview(state: state, model: model, target: selected.value, lit: lit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({
    required this.state,
    required this.model,
    required this.selected,
    required this.onSelect,
    required this.identifying,
    required this.onToggleIdentify,
    required this.onIdentifyPointerDown,
    required this.lastInput,
  });

  final KeybindingState state;
  final KeybindingModel model;
  final _Target selected;
  final ValueChanged<_Target> onSelect;
  final bool identifying;
  final VoidCallback onToggleIdentify;
  final VoidCallback onIdentifyPointerDown;
  final String? lastInput;

  int _boundCount(Set<ScDeviceType> devices, {int? instance}) => model.allActions().where((a) {
    for (final d in devices) {
      final i = model.slotOf(a, d).input;
      if (i != null && (instance == null || i.instance == instance)) return true;
    }
    return false;
  }).length;

  Widget _tag(BuildContext context, String text, bool active) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
    decoration: BoxDecoration(
      color: active ? FluentTheme.of(context).accentColor : Colors.white.withValues(alpha: .14),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, fontFamily: 'Consolas', color: active ? Colors.black : Colors.white),
    ),
  );

  Widget _header(String text, TextStyle style) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 10, 4, 6),
    child: Text(text, style: style),
  );

  Widget _item(BuildContext context, _Target target, String tag, String title, String subtitle) {
    final active = target == selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile.selectable(
        selected: active,
        onSelectionChange: (_) => onSelect(target),
        leading: _tag(context, tag, active),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sticks = state.joysticks.values.toList();
    final muted = TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6));
    final sel = selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(S.current.keybinding_devices, style: const TextStyle(fontSize: 16))),
            IconButton(
              key: const ValueKey('kb_devices_refresh'),
              icon: const Icon(FluentIcons.refresh, size: 14),
              onPressed: model.refreshJoysticks,
            ),
            const SizedBox(width: 4),
            Listener(
              onPointerDown: (_) => onIdentifyPointerDown(),
              child: ToggleButton(
                style: kbToggleStyle(context),
                checked: identifying,
                onChanged: (_) => onToggleIdentify(),
                child: Text(identifying ? S.current.keybinding_identify_stop : S.current.keybinding_identify),
              ),
            ),
          ],
        ),
        if (identifying) ...[
          const SizedBox(height: 8),
          InfoBar(title: Text(S.current.keybinding_identify_hint), severity: InfoBarSeverity.info, isLong: true),
        ] else if (lastInput != null) ...[
          const SizedBox(height: 8),
          InfoBar(
            title: Text(S.current.keybinding_identify_found),
            content: Text(lastInput!),
            severity: InfoBarSeverity.success,
            isLong: true,
          ),
        ],
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(right: 12),
            children: [
              _header(S.current.keybinding_filter_keyboard, muted),
              _item(
                context,
                const _KbmTarget(),
                'kb1',
                S.current.keybinding_device_keyboard_mouse,
                S.current.keybinding_bound_count(_boundCount({ScDeviceType.keyboard, ScDeviceType.mouse})),
              ),
              _header(S.current.keybinding_filter_gamepad, muted),
              _item(
                context,
                const _PadTarget(),
                'gp1',
                state.gamepadName ?? S.current.keybinding_device_gamepad,
                [
                  state.gamepadName == null ? S.current.keybinding_disconnected : S.current.keybinding_connected,
                  S.current.keybinding_bound_count(_boundCount({ScDeviceType.gamepad})),
                ].join(' · '),
              ),
              _header(S.current.keybinding_joysticks, muted),
              if (sticks.isEmpty)
                InfoBar(
                  title: Text(S.current.keybinding_no_joystick_connected),
                  content: Text(S.current.keybinding_no_joystick_hint),
                  severity: InfoBarSeverity.info,
                  isLong: true,
                ),
              for (final js in sticks)
                _item(
                  context,
                  _StickTarget(js.instance),
                  'js${js.instance}',
                  js.alias.isNotEmpty
                      ? '${js.alias} · ${js.name.isEmpty ? '-' : js.name}'
                      : (js.name.isEmpty ? S.current.keybinding_unknown_stick : js.name),
                  [
                    if (js.vidPid.isNotEmpty) 'VID:PID ${js.vidPid}',
                    js.connected ? S.current.keybinding_connected : S.current.keybinding_disconnected,
                    S.current.keybinding_bound_count(_boundCount({ScDeviceType.joystick}, instance: js.instance)),
                    if (!js.fromProfile && js.vendorId != null) S.current.keybinding_guessed_number,
                  ].join(' · '),
                ),
            ],
          ),
        ),
        if (sel is _StickTarget && state.joysticks[sel.instance] != null) ...[
          const SizedBox(height: 8),
          _StickActions(state: state, model: model, instance: sel.instance),
          const SizedBox(height: 10),
          Text(S.current.keybinding_numbering_hint, style: muted),
        ],
      ],
    );
  }
}

class _StickActions extends HookWidget {
  const _StickActions({required this.state, required this.model, required this.instance});

  final KeybindingState state;
  final KeybindingModel model;
  final int instance;

  @override
  Widget build(BuildContext context) {
    final js = state.joysticks[instance]!;
    final alias = useTextEditingController(text: js.alias);
    useEffect(() {
      alias.text = js.alias;
      return null;
    }, [instance, js.alias]);
    final others = state.joysticks.keys.where((k) => k != instance).toList();
    return Card(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoLabel(
            label: S.current.keybinding_stick_alias,
            child: Row(
              children: [
                Expanded(
                  child: TextBox(controller: alias, placeholder: S.current.keybinding_stick_alias_hint),
                ),
                const SizedBox(width: 6),
                Button(
                  onPressed: () => model.setJoystickAlias(instance, alias.text),
                  child: Text(S.current.keybinding_apply),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropDownButton(
            disabled: others.isEmpty,
            title: Text(S.current.keybinding_swap_with),
            items: [
              for (final o in others)
                MenuFlyoutItem(
                  text: Text(
                    'js$instance ⇄ js$o${state.joysticks[o]!.name.isEmpty ? '' : '  (${state.joysticks[o]!.displayName})'}',
                  ),
                  onPressed: () => model.swapJoysticks(instance, o),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _OverviewMode { diagram, list }

/// Base = keys pressed alone, combos = with a modifier, all = both (combo colors overlaid).
enum _Layer { base, combo, all }

enum _Scene { all, flight, onFoot, eva }

bool _inScene(String mapName, _Scene scene) {
  if (scene == _Scene.all) return true;
  final ctx = scMapContexts(mapName);
  if (ctx.contains('global')) return true;
  return switch (scene) {
    _Scene.flight => ctx.any(const {'ship', 'ground', 'turret'}.contains),
    _Scene.onFoot => ctx.contains('fps'),
    _Scene.eva => ctx.contains('eva'),
    _Scene.all => true,
  };
}

int _inputOrder(String key) {
  final b = RegExp(r'^(?:button|mouse)(\d+)$').firstMatch(key);
  if (b != null) return 1000 + int.parse(b.group(1)!);
  final h = RegExp(r'^hat(\d+)_(\w+)$').firstMatch(key);
  if (h != null) {
    return 500 + int.parse(h.group(1)!) * 10 + const ['up', 'right', 'down', 'left'].indexOf(h.group(2)!);
  }
  final axis = const ['x', 'y', 'z', 'rotx', 'roty', 'rotz', 'slider1', 'slider2'].indexOf(key);
  return axis >= 0 ? axis : 2000 + key.codeUnitAt(0);
}

/// Diagram or list of everything one device triggers; clicking an input edits its bindings.
class _DeviceOverview extends HookWidget {
  const _DeviceOverview({required this.state, required this.model, required this.target, required this.lit});

  final KeybindingState state;
  final KeybindingModel model;
  final _Target target;

  /// Inputs being pressed right now (`kb:a`, `gp:a`, `js2:button3`, …).
  final Set<String> lit;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    Set<String> litFor(String prefix) => {
      for (final id in lit)
        if (id.startsWith('$prefix:')) id.substring(prefix.length + 1),
    };
    final mode = useState(_OverviewMode.diagram);
    final layer = useState(_Layer.base);
    final scene = useState(_Scene.all);
    final t = target;

    final (Set<ScDeviceType> devices, int? instance, String title, String subtitle) = switch (t) {
      _KbmTarget() => (
        {ScDeviceType.keyboard, ScDeviceType.mouse},
        null,
        'kb1 · mo1',
        S.current.keybinding_device_keyboard_mouse,
      ),
      _PadTarget() => ({ScDeviceType.gamepad}, null, 'gp1', state.gamepadName ?? S.current.keybinding_device_gamepad),
      _StickTarget(:final instance) => (
        {ScDeviceType.joystick},
        instance,
        'JS$instance',
        state.joysticks[instance]?.displayName ?? '',
      ),
    };
    final bindings = collectDeviceBindings(
      model,
      devices: devices,
      instance: instance,
      actionFilter: (a) => _inScene(a.mapName, scene.value),
      inputFilter: (i) => switch (layer.value) {
        _Layer.base => i.modifiers.isEmpty,
        _Layer.combo => i.modifiers.isNotEmpty,
        _Layer.all => true,
      },
    )..sort((a, b) => _inputOrder(a.input.key).compareTo(_inputOrder(b.input.key)));
    // A binding is active when its input and every modifier it needs are held right now.
    String litId(ScInput i) => i.device == ScDeviceType.joystick ? 'js${i.instance}' : i.device.prefix;
    String modifierId(ScInput i, String m) => i.device == ScDeviceType.gamepad ? 'gp:$m' : 'kb:$m';
    for (final b in bindings) {
      b.active =
          lit.contains('${litId(b.input)}:${b.input.key}') &&
          b.input.modifiers.every((m) => lit.contains(modifierId(b.input, m)));
      b.primed = b.input.modifiers.isNotEmpty && b.input.modifiers.every((m) => lit.contains(modifierId(b.input, m)));
    }

    void openInput(ScInput input) => showInputBindingDialog(
      context,
      input: input,
      onReveal: (ScActionDef a) {
        model.revealAction(a);
        context.pop();
      },
    );

    ScInput inputForKey(String key) => ScInput(devices.first, instance ?? 1, const [], key);

    final Widget diagram = switch (t) {
      _KbmTarget() => KeyboardMouseDiagram(
        litKeys: litSpots(
          bindings.where((b) => b.input.device == ScDeviceType.keyboard).toList(),
          litFor('kb'),
          scKeyboardModifiers.toSet(),
        ),
        litMouse: litSpots(
          bindings.where((b) => b.input.device == ScDeviceType.mouse).toList(),
          litFor('mo'),
          const {},
        ),
        bindings: bindings,
        model: model,
        modifierLayer: layer.value != _Layer.base,
        onInputTap: openInput,
      ),
      _PadTarget() => GamepadDiagram(
        bindings: bindings,
        model: model,
        onInputTap: openInput,
        lit: litSpots(bindings, litFor('gp'), scGamepadModifiers.toSet()),
      ),
      _StickTarget(:final instance) => ButtonDiagram(
        lit: litSpots(bindings, litFor('js$instance'), const {}),
        template: stickTemplate,
        bindings: bindings,
        model: model,
        onInputTap: openInput,
        inputForKey: inputForKey,
      ),
    };

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: .035),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.resources.cardStrokeColorDefault.withValues(alpha: .35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: .06))),
            ),
            child: Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .62)),
                  ),
                ),
                KbSegmented<_Layer>(
                  value: layer.value,
                  items: [
                    (_Layer.base, S.current.keybinding_layer_base),
                    (_Layer.combo, S.current.keybinding_layer_modifier),
                    (_Layer.all, S.current.keybinding_layer_all),
                  ],
                  onChanged: (v) => layer.value = v,
                ),
                const SizedBox(width: 8),
                KbSegmented<_Scene>(
                  value: scene.value,
                  items: [
                    (_Scene.all, S.current.keybinding_filter_all),
                    (_Scene.flight, S.current.keybinding_scene_flight),
                    (_Scene.onFoot, S.current.keybinding_scene_on_foot),
                    (_Scene.eva, 'E.V.A.'),
                  ],
                  onChanged: (v) => scene.value = v,
                ),
                const SizedBox(width: 8),
                KbSegmented<_OverviewMode>(
                  value: mode.value,
                  items: [
                    (_OverviewMode.diagram, S.current.keybinding_view_diagram),
                    (_OverviewMode.list, S.current.keybinding_view_list),
                  ],
                  onChanged: (v) => mode.value = v,
                ),
              ],
            ),
          ),
          Expanded(
            child: mode.value == _OverviewMode.diagram
                ? Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 10), child: diagram)
                : bindings.isEmpty
                ? Center(
                    child: Text(
                      S.current.keybinding_stick_no_bindings,
                      style: TextStyle(color: Colors.white.withValues(alpha: .55)),
                    ),
                  )
                : _InputList(bindings: bindings, model: model, onInputTap: openInput),
          ),
        ],
      ),
    );
  }
}

class _InputList extends StatelessWidget {
  const _InputList({required this.bindings, required this.model, required this.onInputTap});

  final List<DeviceBinding> bindings;
  final KeybindingModel model;
  final ValueChanged<ScInput> onInputTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      itemCount: bindings.length,
      itemBuilder: (context, i) {
        final b = bindings[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: HoverButton(
            onPressed: () => onInputTap(b.input),
            builder: (context, states) => Card(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              borderRadius: BorderRadius.circular(6),
              backgroundColor: b.active
                  ? FluentTheme.of(context).accentColor.withValues(alpha: .35)
                  : b.primed
                  ? FluentTheme.of(context).accentColor.withValues(alpha: .15)
                  : states.isHovered
                  ? Colors.white.withValues(alpha: .06)
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 170,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BindingChip(text: scFormatBody(b.input), style: b.style),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (a, slot) in b.entries)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                if (model.conflictsOf(a, b.input.device).isNotEmpty) ...[
                                  Icon(FluentIcons.warning, size: 12, color: kbConflictColor),
                                  const SizedBox(width: 6),
                                ],
                                Flexible(child: Text(model.actionLabel(a), overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Text(
                                  '${model.groupLabelOf(a)} · ${activationModeShortLabel(slot.activationMode, a)}',
                                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .5)),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
