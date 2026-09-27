import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_format.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'binding_chip.dart';
import 'device_diagram.dart';
import 'pad_glyph.dart';

/// Controller drawing box, in design pixels.
const _box = Size(850, 600);

/// Where each pad input sits on the drawing (for hit targets and highlighting).
const _spots = <String, (Offset center, double radius)>{
  'thumbl': (Offset(205, 165), 34),
  'thumbr': (Offset(538, 295), 34),
  'dpad_up': (Offset(310, 262), 18),
  'dpad_down': (Offset(310, 338), 18),
  'dpad_left': (Offset(272, 300), 18),
  'dpad_right': (Offset(348, 300), 18),
  'y': (Offset(645, 108), 28),
  'a': (Offset(645, 222), 28),
  'x': (Offset(588, 165), 28),
  'b': (Offset(702, 165), 28),
  'back': (Offset(362, 165), 18),
  'start': (Offset(486, 165), 18),
  'shoulderl': (Offset(200, 44), 28),
  'shoulderr': (Offset(650, 44), 28),
};

/// Xbox face button colors, as on the physical pad.
const _faceColors = {'a': Color(0xFF3FB950), 'b': Color(0xFFE5534B), 'x': Color(0xFF2F81F7), 'y': Color(0xFFE3B341)};

/// Steam-style gamepad view: controller outline with shoulder / menu labels on the sides and the
/// sticks, D-pad and face buttons listed underneath. Every row and part is clickable.
class GamepadDiagram extends StatelessWidget {
  const GamepadDiagram({
    super.key,
    required this.bindings,
    required this.model,
    required this.onInputTap,
    this.lit = const {},
  });

  /// Pad inputs being pressed right now.
  final Set<String> lit;

  final List<DeviceBinding> bindings;
  final KeybindingModel model;
  final ValueChanged<ScInput> onInputTap;

  @override
  Widget build(BuildContext context) {
    final byKey = <String, List<DeviceBinding>>{};
    for (final b in bindings) {
      byKey.putIfAbsent(b.input.key, () => []).add(b);
    }
    ScInput inputOf(String key) => byKey[key]?.first.input ?? ScInput(ScDeviceType.gamepad, 1, const [], key);
    Widget row(String key, {Widget? icon, String? label, bool alignEnd = false}) => _PadRow(
      key: ValueKey('pad_$key'),
      icon: icon ?? (PadGlyph.supports(key) ? PadGlyph(key) : null),
      label: label ?? scFormatBody(ScInput(ScDeviceType.gamepad, 1, const [], key)),
      bindings: byKey[key] ?? const [],
      model: model,
      alignEnd: alignEnd,
      lit: (byKey[key] ?? const []).any((b) => b.active),
      onTap: () => onInputTap(inputOf(key)),
    );

    final accent = FluentTheme.of(context).accentColor;
    final states = {for (final e in byKey.entries) e.key: _style(e.value)};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    row('shoulderl', alignEnd: true),
                    row('triggerl_btn', alignEnd: true),
                    row('back', label: S.current.keybinding_pad_view, alignEnd: true),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _box.width,
                    height: _box.height,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _PadPainter(states: states, accent: accent, lit: lit),
                          ),
                        ),
                        for (final e in _spots.entries)
                          Positioned(
                            left: e.value.$1.dx - e.value.$2,
                            top: e.value.$1.dy - e.value.$2,
                            width: e.value.$2 * 2,
                            height: e.value.$2 * 2,
                            child: HoverButton(
                              onPressed: () => onInputTap(inputOf(e.key)),
                              builder: (context, s) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: s.isHovered ? accent.withValues(alpha: .22) : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    row('shoulderr'),
                    row('triggerr_btn'),
                    row('start', label: S.current.keybinding_pad_menu),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Group(S.current.keybinding_gp_left_stick, [
                  row('thumblx'),
                  row('thumbly'),
                  row('thumbl', label: S.current.keybinding_pad_left_click),
                  for (final d in ['up', 'down', 'left', 'right'])
                    if (byKey.containsKey('thumbl_$d')) row('thumbl_$d'),
                ]),
                _Group(S.current.keybinding_gp_dpad, [
                  for (final d in ['up', 'down', 'left', 'right']) row('dpad_$d'),
                ]),
                _Group(S.current.keybinding_gp_right_stick, [
                  row('thumbrx'),
                  row('thumbry'),
                  row('thumbr', label: S.current.keybinding_pad_right_click),
                  for (final d in ['up', 'down', 'left', 'right'])
                    if (byKey.containsKey('thumbr_$d')) row('thumbr_$d'),
                ]),
                _Group(S.current.keybinding_pad_face_buttons, [
                  for (final k in ['a', 'b', 'x', 'y'])
                    row(
                      k,
                      icon: _FaceIcon(letter: k.toUpperCase(), color: _faceColors[k]!),
                    ),
                  if (byKey.containsKey('triggerl_r_btn')) row('triggerl_r_btn'),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const DiagramLegend(),
      ],
    );
  }
}

BindingChipStyle _style(List<DeviceBinding> list) {
  if (list.any((b) => b.conflicted)) return BindingChipStyle.conflict;
  return list.any((b) => b.modified) ? BindingChipStyle.custom : BindingChipStyle.byDefault;
}

class _Group extends StatelessWidget {
  const _Group(this.title, this.rows);

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: .55)),
              ),
            ),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _FaceIcon extends StatelessWidget {
  const _FaceIcon({required this.letter, required this.color});

  final String letter;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 22,
    height: 22,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Text(
      letter,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0B1118)),
    ),
  );
}

/// One input: its label and what it triggers (first action + how many more).
class _PadRow extends StatelessWidget {
  const _PadRow({
    super.key,
    required this.label,
    required this.bindings,
    required this.model,
    required this.onTap,
    this.icon,
    this.alignEnd = false,
    this.lit = false,
  });

  final bool lit;

  final String label;
  final Widget? icon;
  final List<DeviceBinding> bindings;
  final KeybindingModel model;
  final VoidCallback onTap;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final accent = FluentTheme.of(context).accentColor;
    // The combo being held (or unlocked by a held modifier) goes first, so its action is the one shown.
    final ordered = byPriority(bindings);
    final primed = !lit && bindings.any((b) => b.primed);
    final entries = [for (final b in ordered) ...b.entries];
    final style = bindings.isEmpty ? BindingChipStyle.none : _style(bindings);
    final actionText = entries.isEmpty
        ? '—'
        : (entries.length > 1
              ? '${model.actionLabel(entries.first.$1)}  +${entries.length - 1}'
              : model.actionLabel(entries.first.$1));
    final combos = ScInput.sortModifiers({for (final b in bindings) ...b.input.modifiers}.toList());
    final base =
        icon ?? BindingChip(text: label, style: style == BindingChipStyle.none ? BindingChipStyle.byDefault : style);
    final chip = combos.isEmpty
        ? base
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModifierFlag(
                modifiers: combos,
                baseColor: bindings.any((b) => b.input.modifiers.isEmpty) ? accent.withValues(alpha: .4) : null,
              ),
              const SizedBox(width: 6),
              base,
            ],
          );
    final text = Flexible(
      child: Text(
        actionText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: entries.isEmpty ? .35 : .92)),
      ),
    );
    return Tooltip(
      message: [
        label,
        for (final b in bindings)
          for (final (a, _) in b.entries) '${scFormatBody(b.input)}  →  ${model.actionLabel(a)}',
      ].join('\n'),
      child: HoverButton(
        onPressed: onTap,
        builder: (context, states) => Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: lit
                ? accent.withValues(alpha: .45)
                : primed
                ? accent.withValues(alpha: .18)
                : states.isHovered
                ? accent.withValues(alpha: .14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: alignEnd ? [text, const SizedBox(width: 10), chip] : [chip, const SizedBox(width: 10), text],
          ),
        ),
      ),
    );
  }
}

class _PadPainter extends CustomPainter {
  _PadPainter({required this.states, required this.accent, this.lit = const {}});

  final Set<String> lit;

  final Map<String, BindingChipStyle> states;
  final Color accent;

  Paint _stroke(String? key, {double width = 2}) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeJoin = StrokeJoin.round
    ..color = switch (key == null ? null : states[key]) {
      BindingChipStyle.conflict => accent,
      BindingChipStyle.custom => accent,
      BindingChipStyle.byDefault => Colors.white.withValues(alpha: .7),
      _ => Colors.white.withValues(alpha: .35),
    };

  bool _any(List<String> keys) => keys.any(states.containsKey);

  @override
  void paint(Canvas canvas, Size size) {
    final body = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: .38);

    // Outer shell with grips.
    canvas.drawPath(
      Path()
        ..moveTo(130, 70)
        ..cubicTo(160, 30, 230, 8, 280, 8)
        ..lineTo(300, 20)
        ..lineTo(550, 20)
        ..lineTo(570, 8)
        ..cubicTo(620, 8, 690, 30, 720, 70)
        ..cubicTo(790, 110, 832, 320, 846, 480)
        ..cubicTo(856, 575, 808, 598, 760, 594)
        ..cubicTo(722, 590, 690, 540, 642, 468)
        ..cubicTo(612, 428, 592, 424, 560, 424)
        ..lineTo(290, 424)
        ..cubicTo(258, 424, 238, 428, 208, 468)
        ..cubicTo(160, 540, 128, 590, 90, 594)
        ..cubicTo(42, 598, -6, 575, 4, 480)
        ..cubicTo(18, 320, 60, 110, 130, 70)
        ..close(),
      body,
    );
    // Bumper plate.
    canvas.drawPath(
      Path()
        ..moveTo(130, 70)
        ..cubicTo(200, 44, 250, 36, 292, 40)
        ..cubicTo(330, 96, 360, 118, 425, 118)
        ..cubicTo(490, 118, 520, 96, 558, 40)
        ..cubicTo(600, 36, 650, 44, 720, 70),
      body,
    );
    // Bumpers light up when bound.
    canvas.drawPath(
      Path()
        ..moveTo(150, 58)
        ..cubicTo(190, 34, 240, 18, 280, 16),
      _stroke(
        _any(['shoulderl', 'triggerl_btn']) ? (states.containsKey('shoulderl') ? 'shoulderl' : 'triggerl_btn') : null,
        width: 4,
      ),
    );
    canvas.drawPath(
      Path()
        ..moveTo(700, 58)
        ..cubicTo(660, 34, 610, 18, 570, 16),
      _stroke(
        _any(['shoulderr', 'triggerr_btn']) ? (states.containsKey('shoulderr') ? 'shoulderr' : 'triggerr_btn') : null,
        width: 4,
      ),
    );

    // Guide button.
    canvas.drawCircle(const Offset(425, 70), 30, Paint()..color = Colors.white.withValues(alpha: .08));
    canvas.drawCircle(const Offset(425, 70), 30, body);

    // Sticks.
    for (final (prefix, c) in [('thumbl', const Offset(205, 165)), ('thumbr', const Offset(538, 295))]) {
      final key =
          _any([
            prefix,
            '${prefix}x',
            '${prefix}y',
            '${prefix}_up',
            '${prefix}_down',
            '${prefix}_left',
            '${prefix}_right',
          ])
          ? [
              prefix,
              '${prefix}x',
              '${prefix}y',
              '${prefix}_up',
              '${prefix}_down',
              '${prefix}_left',
              '${prefix}_right',
            ].firstWhere(states.containsKey)
          : null;
      canvas.drawCircle(c, 62, body);
      canvas.drawCircle(c, 50, _stroke(key, width: 1.5));
      canvas.drawCircle(c, 32, _stroke(key));
    }

    // D-pad.
    canvas.drawCircle(const Offset(310, 300), 70, body);
    final cross = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: const Offset(310, 300), width: 34, height: 110),
          const Radius.circular(6),
        ),
      )
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: const Offset(310, 300), width: 110, height: 34),
          const Radius.circular(6),
        ),
      );
    canvas.drawPath(cross, Paint()..color = Colors.white.withValues(alpha: .04));
    canvas.drawPath(cross, body);
    for (final (d, c) in [
      ('dpad_up', const Offset(310, 262)),
      ('dpad_down', const Offset(310, 338)),
      ('dpad_left', const Offset(272, 300)),
      ('dpad_right', const Offset(348, 300)),
    ]) {
      if (states.containsKey(d)) canvas.drawCircle(c, 6, Paint()..color = _stroke(d).color);
    }

    // View / Menu.
    canvas.drawCircle(const Offset(362, 165), 18, _stroke('back', width: 1.5));
    canvas.drawCircle(const Offset(486, 165), 18, _stroke('start', width: 1.5));

    // Face buttons.
    for (final (k, c) in [
      ('y', const Offset(645, 108)),
      ('a', const Offset(645, 222)),
      ('x', const Offset(588, 165)),
      ('b', const Offset(702, 165)),
    ]) {
      final bound = states.containsKey(k);
      canvas.drawCircle(c, 28, Paint()..color = (_faceColors[k]!).withValues(alpha: bound ? .22 : .06));
      canvas.drawCircle(c, 28, _stroke(bound ? k : null));
      final tp = TextPainter(
        text: TextSpan(
          text: k.toUpperCase(),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: bound ? _faceColors[k] : Colors.white.withValues(alpha: .45),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }
    // Pressed right now.
    for (final key in lit) {
      final spot = _spots[key] ?? _spots[key.replaceAll(RegExp(r'(x|y|_up|_down|_left|_right)$'), '')];
      if (spot == null) continue;
      canvas.drawCircle(spot.$1, spot.$2 + 6, Paint()..color = accent.withValues(alpha: .3));
      canvas.drawCircle(
        spot.$1,
        spot.$2,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PadPainter old) => true;
}
