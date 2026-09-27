import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_format.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'binding_chip.dart';
import 'keybinding_text.dart';

/// One input of a device and the actions it triggers.
class DeviceBinding {
  DeviceBinding(this.input, this.entries);

  final ScInput input;
  final List<(ScActionDef, ScSlot)> entries;
  bool conflicted = false;

  /// Its input and modifiers are being held right now.
  bool active = false;

  /// A combo whose modifiers are all held (the key itself not yet): what the key would do now.
  bool primed = false;

  /// Display order: fully held first, then combos the held modifiers unlock, then the rest.
  int get priority => active ? 0 : (primed ? 1 : 2);

  bool get modified => entries.any((e) => e.$2.isModified);

  BindingChipStyle get style {
    if (conflicted) return BindingChipStyle.conflict;
    return modified ? BindingChipStyle.custom : BindingChipStyle.byDefault;
  }
}

/// Groups every effective binding on [devices] (optionally one joystick [instance]) by input.
List<DeviceBinding> collectDeviceBindings(
  KeybindingModel model, {
  required Set<ScDeviceType> devices,
  int? instance,
  required bool Function(ScActionDef) actionFilter,
  required bool Function(ScInput) inputFilter,
}) {
  final byInput = <String, DeviceBinding>{};
  for (final a in model.allActions()) {
    if (!actionFilter(a)) continue;
    for (final d in devices) {
      final slot = model.slotOf(a, d);
      final input = slot.input;
      if (input == null || (instance != null && input.instance != instance) || !inputFilter(input)) continue;
      byInput.putIfAbsent(input.conflictKey, () => DeviceBinding(input, [])).entries.add((a, slot));
    }
  }
  final list = byInput.values.toList();
  for (final b in list) {
    b.conflicted = b.entries.any((e) => model.conflictsOf(e.$1, b.input.device).isNotEmpty);
  }
  return list;
}

/// Keys to light on a diagram: a key lights when one of its shown bindings is fully held (key and
/// modifiers), a held modifier always lights, and a pressed key with nothing shown still lights as
/// plain feedback. So in the combo view, pressing A alone does not light the LB + A spot.
/// [bindings] sorted by [DeviceBinding.priority] (stable).
List<DeviceBinding> byPriority(Iterable<DeviceBinding> bindings) => [
  for (final p in [0, 1, 2]) ...bindings.where((b) => b.priority == p),
];

Set<String> litSpots(List<DeviceBinding> bindings, Set<String> pressed, Set<String> modifierKeys) {
  final shown = {for (final b in bindings) b.input.key};
  return {
    for (final b in bindings)
      if (b.active) ...[b.input.key, ...b.input.modifiers],
    for (final k in pressed)
      if (modifierKeys.contains(k) || !shown.contains(k)) k,
  };
}

/// A device drawing in a 896×660 design box: where inputs sit, and how to paint the device.
class DiagramTemplate {
  const DiagramTemplate({required this.anchors, required this.painter});

  final Map<String, Offset> anchors;
  final void Function(Canvas canvas, Map<String, BindingChipStyle> states, Color accent) painter;
}

const _box = Size(896, 660);
const _cardWidth = 236.0;
const _cardHeight = 58.0;
const _leftX = 20.0;
const _rightX = 896.0 - _cardWidth - 20;
const _warning = kbConflictColor;

Color _stateColor(BindingChipStyle? s, Color accent) => switch (s) {
  BindingChipStyle.conflict => accent,
  BindingChipStyle.custom => accent,
  BindingChipStyle.byDefault => Colors.white.withValues(alpha: .75),
  _ => Colors.white.withValues(alpha: .28),
};

/// Label cards around the device drawing, joined by leader lines. Every spot is clickable:
/// bound or not, [onInputTap] receives the input so the caller can edit what it does.
class ButtonDiagram extends StatelessWidget {
  const ButtonDiagram({
    super.key,
    required this.template,
    required this.bindings,
    required this.model,
    required this.onInputTap,
    required this.inputForKey,
    this.lit = const {},
  });

  /// Inputs of this stick being pressed right now.
  final Set<String> lit;

  final DiagramTemplate template;
  final List<DeviceBinding> bindings;
  final KeybindingModel model;
  final ValueChanged<ScInput> onInputTap;

  /// The input a bare spot stands for (device, instance, current layer).
  final ScInput Function(String key) inputForKey;

  @override
  Widget build(BuildContext context) {
    final anchors = template.anchors;
    final placed = bindings.where((b) => anchors.containsKey(b.input.key)).toList();
    int byY(DeviceBinding a, DeviceBinding b) => anchors[a.input.key]!.dy.compareTo(anchors[b.input.key]!.dy);
    final left = placed.where((b) => anchors[b.input.key]!.dx < _box.width / 2).toList()..sort(byY);
    final right = placed.where((b) => anchors[b.input.key]!.dx >= _box.width / 2).toList()..sort(byY);
    final maxPerSide = (_box.height / (_cardHeight + 12)).floor();
    final overflow = [...left.skip(maxPerSide), ...right.skip(maxPerSide)];
    final cards = <(DeviceBinding, Offset)>[];
    for (final (list, x) in [(left.take(maxPerSide).toList(), _leftX), (right.take(maxPerSide).toList(), _rightX)]) {
      final gap = list.isEmpty ? 0.0 : (_box.height - list.length * _cardHeight) / (list.length + 1);
      for (var i = 0; i < list.length; i++) {
        cards.add((list[i], Offset(x, gap + i * (_cardHeight + gap))));
      }
    }
    // Held inputs first, so a lit card is never scrolled out of the short list.
    final unplaced = byPriority([...bindings.where((b) => !anchors.containsKey(b.input.key)), ...overflow]);
    final accent = FluentTheme.of(context).accentColor;
    final states = <String, BindingChipStyle>{for (final b in placed) b.input.key: b.style};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _box.width,
              height: _box.height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DiagramPainter(
                        template: template,
                        accent: accent,
                        states: states,
                        lit: lit,
                        leaders: [
                          for (final (b, pos) in cards)
                            (
                              pos.dx < _box.width / 2
                                  ? Offset(pos.dx + _cardWidth, pos.dy + _cardHeight / 2)
                                  : Offset(pos.dx, pos.dy + _cardHeight / 2),
                              anchors[b.input.key]!,
                              b.style,
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Hit targets on the drawing itself, including unbound spots.
                  for (final e in anchors.entries)
                    Positioned(
                      left: e.value.dx - 13,
                      top: e.value.dy - 13,
                      width: 26,
                      height: 26,
                      child: Tooltip(
                        message: scFormatBody(inputForKey(e.key)),
                        child: HoverButton(
                          onPressed: () {
                            final bound = placed.where((b) => b.input.key == e.key).firstOrNull;
                            onInputTap(bound?.input ?? inputForKey(e.key));
                          },
                          builder: (context, s) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: s.isHovered ? accent.withValues(alpha: .25) : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  for (final (b, pos) in cards)
                    Positioned(
                      left: pos.dx,
                      top: pos.dy,
                      width: _cardWidth,
                      height: _cardHeight,
                      child: InputLabelCard(binding: b, model: model, lit: b.active, onTap: () => onInputTap(b.input)),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (unplaced.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
            child: Text(
              S.current.keybinding_diagram_other_inputs,
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55)),
            ),
          ),
          SizedBox(
            height: 128,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final b in unplaced)
                    SizedBox(
                      width: _cardWidth,
                      height: _cardHeight,
                      child: InputLabelCard(binding: b, model: model, lit: b.active, onTap: () => onInputTap(b.input)),
                    ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        const DiagramLegend(),
      ],
    );
  }
}

class InputLabelCard extends StatelessWidget {
  const InputLabelCard({super.key, required this.binding, required this.model, required this.onTap, this.lit = false});

  final bool lit;

  final DeviceBinding binding;
  final KeybindingModel model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = binding.style;
    final accent = FluentTheme.of(context).accentColor;
    final border = switch (style) {
      BindingChipStyle.conflict => _warning.withValues(alpha: .65),
      BindingChipStyle.custom => accent.withValues(alpha: .45),
      _ => Colors.white.withValues(alpha: .14),
    };
    final first = binding.entries.first;
    final more = binding.entries.length - 1;
    return HoverButton(
      onPressed: onTap,
      builder: (context, states) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Color.lerp(const Color(0xEB141B29), accent, states.isHovered ? .08 : 0),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: lit ? 2 : 1,
            color: lit ? Colors.white : (states.isHovered ? accent.withValues(alpha: .7) : border),
          ),
          boxShadow: lit ? [BoxShadow(color: accent.withValues(alpha: .6), blurRadius: 10)] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (binding.input.modifiers.isNotEmpty) ...[
                  ModifierFlag(modifiers: binding.input.modifiers),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: BindingChip(text: scFormatBody(binding.input), style: style, fontSize: 11),
                ),
                const SizedBox(width: 6),
                Text(
                  activationModeShortLabel(first.$2.activationMode, first.$1),
                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .55)),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              more > 0 ? '${model.actionLabel(first.$1)}  +$more' : model.actionLabel(first.$1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagramLegend extends StatelessWidget {
  const DiagramLegend({super.key, this.extra = const []});

  final List<Widget> extra;

  @override
  Widget build(BuildContext context) {
    final muted = TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .62));
    Widget item(BindingChipStyle s, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 10,
          height: 10,
          child: BindingChip(text: '', style: s),
        ),
        const SizedBox(width: 6),
        Text(text, style: muted),
      ],
    );
    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        item(BindingChipStyle.custom, S.current.keybinding_state_modified),
        item(BindingChipStyle.byDefault, S.current.keybinding_state_default),
        item(BindingChipStyle.conflict, S.current.keybinding_state_conflict),
        Text(S.current.keybinding_diagram_click_hint, style: muted),
        ...extra,
      ],
    );
  }
}

class _DiagramPainter extends CustomPainter {
  _DiagramPainter({
    required this.template,
    required this.accent,
    required this.states,
    required this.leaders,
    this.lit = const {},
  });

  final Set<String> lit;

  final DiagramTemplate template;
  final Color accent;
  final Map<String, BindingChipStyle> states;
  final List<(Offset from, Offset to, BindingChipStyle style)> leaders;

  @override
  void paint(Canvas canvas, Size size) {
    template.painter(canvas, states, accent);
    for (final key in lit) {
      final p = template.anchors[key];
      if (p == null) continue;
      canvas.drawCircle(p, 18, Paint()..color = accent.withValues(alpha: .35));
      canvas.drawCircle(p, 11, Paint()..color = accent);
      canvas.drawCircle(
        p,
        11,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white,
      );
    }
    for (final (from, to, _) in leaders) {
      final elbowX = from.dx < to.dx ? from.dx + 70 : from.dx - 70;
      canvas.drawPath(
        Path()
          ..moveTo(from.dx, from.dy)
          ..lineTo(elbowX, from.dy)
          ..lineTo(to.dx, to.dy),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.white.withValues(alpha: .35),
      );
      canvas.drawCircle(to, 3, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _DiagramPainter old) => true;
}

// ---------------------------------------------------------------- shared drawing helpers

Paint _outline() => Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1.5
  ..strokeJoin = StrokeJoin.round
  ..color = Colors.white.withValues(alpha: .28);

void _shape(Canvas canvas, Path p, double alpha) {
  canvas.drawPath(p, Paint()..color = Colors.white.withValues(alpha: alpha));
  canvas.drawPath(p, _outline());
}

void _button(Canvas canvas, Offset c, double r, BindingChipStyle? s, Color accent, {String? label}) {
  final color = _stateColor(s, accent);
  canvas.drawCircle(c, r, Paint()..color = color.withValues(alpha: s == null ? .05 : .2));
  canvas.drawCircle(
    c,
    r,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color,
  );
  if (label != null) {
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(fontSize: r, color: color, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }
}

void _arrow(Canvas canvas, Offset tip, Offset a, Offset b, Color color) =>
    canvas.drawPath(Path()..addPolygon([tip, a, b], true), Paint()..color = color);

void _directions(Canvas canvas, Offset c, double r, String prefix, Map<String, BindingChipStyle> s, Color accent) {
  _arrow(
    canvas,
    c + Offset(0, -r),
    c + Offset(-5, -r + 8),
    c + Offset(5, -r + 8),
    _stateColor(s['${prefix}_up'], accent),
  );
  _arrow(
    canvas,
    c + Offset(0, r),
    c + Offset(-5, r - 8),
    c + Offset(5, r - 8),
    _stateColor(s['${prefix}_down'], accent),
  );
  _arrow(
    canvas,
    c + Offset(-r, 0),
    c + Offset(-r + 8, -5),
    c + Offset(-r + 8, 5),
    _stateColor(s['${prefix}_left'], accent),
  );
  _arrow(
    canvas,
    c + Offset(r, 0),
    c + Offset(r - 8, -5),
    c + Offset(r - 8, 5),
    _stateColor(s['${prefix}_right'], accent),
  );
}

// ---------------------------------------------------------------- joystick

const stickTemplate = DiagramTemplate(anchors: _stickAnchors, painter: _paintStick);

const _stickAnchors = <String, Offset>{
  'hat1_up': Offset(448, 128),
  'hat1_down': Offset(448, 172),
  'hat1_left': Offset(426, 150),
  'hat1_right': Offset(470, 150),
  'button1': Offset(354, 312),
  'button2': Offset(492, 212),
  'button3': Offset(404, 206),
  'button4': Offset(506, 246),
  'button5': Offset(398, 372),
  'button6': Offset(470, 360),
  'button8': Offset(512, 315),
  'x': Offset(600, 590),
  'y': Offset(448, 628),
  'rotz': Offset(392, 520),
};

void _paintStick(Canvas canvas, Map<String, BindingChipStyle> states, Color accent) {
  final outline = _outline();
  canvas.drawOval(
    Rect.fromCenter(center: const Offset(448, 590), width: 340, height: 60),
    Paint()..color = Colors.white.withValues(alpha: .04),
  );
  canvas.drawOval(Rect.fromCenter(center: const Offset(448, 590), width: 340, height: 60), outline);
  _shape(
    canvas,
    Path()
      ..moveTo(318, 590)
      ..lineTo(318, 568)
      ..cubicTo(318, 558, 376, 542, 448, 542)
      ..cubicTo(520, 542, 578, 558, 578, 568)
      ..lineTo(578, 590),
    .03,
  );
  _shape(
    canvas,
    Path()
      ..moveTo(420, 548)
      ..lineTo(414, 478)
      ..lineTo(482, 478)
      ..lineTo(476, 548)
      ..close(),
    .05,
  );
  _shape(
    canvas,
    Path()
      ..moveTo(396, 478)
      ..cubicTo(388, 418, 382, 358, 388, 300)
      ..cubicTo(392, 266, 406, 242, 448, 242)
      ..cubicTo(490, 242, 506, 266, 510, 300)
      ..cubicTo(516, 358, 510, 418, 502, 478)
      ..close(),
    .06,
  );
  _shape(
    canvas,
    Path()
      ..moveTo(378, 128)
      ..cubicTo(378, 106, 396, 90, 418, 90)
      ..lineTo(478, 90)
      ..cubicTo(500, 90, 518, 106, 518, 128)
      ..lineTo(518, 232)
      ..cubicTo(518, 246, 506, 256, 492, 256)
      ..lineTo(404, 256)
      ..cubicTo(390, 256, 378, 246, 378, 232)
      ..close(),
    .08,
  );
  canvas.drawPath(
    Path()
      ..moveTo(386, 262)
      ..cubicTo(360, 268, 348, 292, 352, 320)
      ..cubicTo(354, 332, 364, 338, 374, 334),
    outline,
  );

  final hatBound = ['hat1_up', 'hat1_down', 'hat1_left', 'hat1_right'].any(states.containsKey);
  canvas.drawCircle(const Offset(448, 150), 24, Paint()..color = accent.withValues(alpha: hatBound ? .14 : .04));
  canvas.drawCircle(
    const Offset(448, 150),
    24,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = hatBound ? accent.withValues(alpha: .8) : Colors.white.withValues(alpha: .28),
  );
  _directions(canvas, const Offset(448, 150), 30, 'hat1', states, accent);

  canvas.drawPath(
    Path()
      ..moveTo(358, 300)
      ..cubicTo(350, 306, 348, 316, 352, 326),
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = _stateColor(states['button1'], accent).withValues(alpha: .7),
  );
  for (final key in ['button2', 'button3', 'button4', 'button5', 'button6', 'button8']) {
    _button(canvas, _stickAnchors[key]!, 9, states[key], accent);
  }

  final axis = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..strokeCap = StrokeCap.round;
  axis.color = _stateColor(states['rotz'], accent);
  canvas.drawArc(Rect.fromCenter(center: const Offset(448, 514), width: 136, height: 28), 0.2, 2.7, false, axis);
  axis.color = _stateColor(states['x'], accent);
  canvas.drawLine(const Offset(596, 590), const Offset(636, 590), axis);
  _arrow(canvas, const Offset(642, 590), const Offset(632, 584), const Offset(632, 596), axis.color);
  axis.color = _stateColor(states['y'], accent);
  canvas.drawLine(const Offset(448, 622), const Offset(448, 646), axis);
  _arrow(canvas, const Offset(448, 652), const Offset(442, 642), const Offset(454, 642), axis.color);
}
