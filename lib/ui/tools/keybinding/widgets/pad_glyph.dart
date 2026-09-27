import 'dart:math' as math;

import 'package:fluent_ui/fluent_ui.dart';

/// Steam-style glyph for one gamepad input (`shoulderl`, `triggerr_btn`, `dpad_up`, `thumblx`, …):
/// white shapes on the dark UI, the part that is meant highlighted.
class PadGlyph extends StatelessWidget {
  const PadGlyph(this.input, {super.key, this.size = 24});

  final String input;
  final double size;

  static bool supports(String input) => _GlyphPainter.kind(input) != null;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size * (input == 'triggerl_r_btn' ? 2.1 : 1.3),
    height: size,
    child: CustomPaint(painter: _GlyphPainter(input)),
  );
}

enum _Kind { bumper, trigger, bothTriggers, view, menu, dpad, stickClick, stickAxis, stickDir }

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.input);

  final String input;

  static const _fg = Color(0xFFF2F4F8);
  static const _ink = Color(0xFF0D1117);

  static _Kind? kind(String i) {
    if (i == 'shoulderl' || i == 'shoulderr') return _Kind.bumper;
    if (i == 'triggerl_btn' || i == 'triggerr_btn' || i == 'triggerl' || i == 'triggerr') return _Kind.trigger;
    if (i == 'triggerl_r_btn') return _Kind.bothTriggers;
    if (i == 'back') return _Kind.view;
    if (i == 'start') return _Kind.menu;
    if (i.startsWith('dpad_')) return _Kind.dpad;
    if (i == 'thumbl' || i == 'thumbr') return _Kind.stickClick;
    if (RegExp(r'^thumb[lr][xy]$').hasMatch(i)) return _Kind.stickAxis;
    if (RegExp(r'^thumb[lr]_(up|down|left|right)$').hasMatch(i)) return _Kind.stickDir;
    return null;
  }

  void _text(Canvas c, String t, Offset center, double size, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(fontSize: size, fontWeight: FontWeight.w800, color: color, height: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _trigger(Canvas c, Rect r, String label, {required bool left}) {
    // Rounded top, one slanted lower corner — the shape Steam uses for LT / RT.
    final p = Path()
      ..moveTo(r.left + r.width * .18, r.top)
      ..lineTo(r.right - r.width * .18, r.top)
      ..quadraticBezierTo(r.right, r.top, r.right, r.top + r.height * .22)
      ..lineTo(r.right - (left ? 0 : r.width * .22), r.bottom)
      ..lineTo(r.left + (left ? r.width * .22 : 0), r.bottom)
      ..lineTo(r.left, r.top + r.height * .22)
      ..quadraticBezierTo(r.left, r.top, r.left + r.width * .18, r.top)
      ..close();
    c.drawPath(p, Paint()..color = _fg);
    _text(c, label, r.center, r.height * .36, _ink);
  }

  void _arrow(Canvas c, Offset tip, double angle, double len, Color color) {
    final a = Offset(math.cos(angle), math.sin(angle));
    final n = Offset(-a.dy, a.dx);
    c.drawPath(
      Path()..addPolygon([tip, tip - a * len + n * len * .7, tip - a * len - n * len * .7], true),
      Paint()..color = color,
    );
  }

  @override
  void paint(Canvas c, Size s) {
    final h = s.height;
    final box = Rect.fromCenter(center: s.center(Offset.zero), width: h * 1.25, height: h);
    switch (kind(input)) {
      case _Kind.bumper:
        final r = RRect.fromRectAndRadius(
          Rect.fromCenter(center: box.center, width: box.width, height: h * .62),
          Radius.circular(h * .31),
        );
        c.drawRRect(r, Paint()..color = _fg);
        _text(c, input == 'shoulderl' ? 'LB' : 'RB', box.center, h * .34, _ink);
      case _Kind.trigger:
        _trigger(
          c,
          Rect.fromCenter(center: box.center, width: h * .9, height: h),
          input.startsWith('triggerl') ? 'LT' : 'RT',
          left: input.startsWith('triggerl'),
        );
      case _Kind.bothTriggers:
        final w = h * .9;
        _trigger(c, Rect.fromLTWH(s.width / 2 - w - 2, 0, w, h), 'LT', left: true);
        _trigger(c, Rect.fromLTWH(s.width / 2 + 2, 0, w, h), 'RT', left: false);
      case _Kind.view:
        final stroke = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = h * .1
          ..color = _fg;
        final u = h * .5;
        c.drawRect(Rect.fromLTWH(box.center.dx - u * .75, box.center.dy - u * .75, u, u), stroke);
        c.drawRect(Rect.fromLTWH(box.center.dx - u * .25, box.center.dy - u * .25, u, u), Paint()..color = _fg);
      case _Kind.menu:
        final paint = Paint()
          ..strokeWidth = h * .11
          ..strokeCap = StrokeCap.round
          ..color = _fg;
        for (final dy in [-.28, 0.0, .28]) {
          c.drawLine(box.center + Offset(-h * .42, h * dy), box.center + Offset(h * .42, h * dy), paint);
        }
      case _Kind.dpad:
        final arm = h * .34;
        final cross = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: box.center, width: arm, height: h),
              Radius.circular(h * .08),
            ),
          )
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: box.center, width: h, height: arm),
              Radius.circular(h * .08),
            ),
          );
        c.drawPath(cross, Paint()..color = _fg);
        final dir = input.substring(5);
        final (tip, angle) = switch (dir) {
          'up' => (box.center + Offset(0, -h * .44), -math.pi / 2),
          'down' => (box.center + Offset(0, h * .44), math.pi / 2),
          'left' => (box.center + Offset(-h * .44, 0), math.pi),
          _ => (box.center + Offset(h * .44, 0), 0.0),
        };
        _arrow(c, tip, angle, h * .2, _ink);
      case _Kind.stickClick || _Kind.stickAxis || _Kind.stickDir:
        final r = h * .4;
        final center = box.center + Offset(0, h * .06);
        c.drawCircle(center, r, Paint()..color = _fg);
        _text(c, input[5].toUpperCase(), center, h * .36, _ink);
        final k = kind(input)!;
        if (k == _Kind.stickClick) {
          _arrow(c, center + Offset(0, -r - h * .02), math.pi / 2, h * .2, _fg);
        } else if (k == _Kind.stickAxis) {
          final horizontal = input.endsWith('x');
          for (final sign in [-1.0, 1.0]) {
            _arrow(
              c,
              center + (horizontal ? Offset(sign * (r + h * .22), 0) : Offset(0, sign * (r + h * .12))),
              horizontal ? (sign < 0 ? math.pi : 0) : (sign < 0 ? -math.pi / 2 : math.pi / 2),
              h * .16,
              _fg,
            );
          }
        } else {
          final dir = input.substring(7);
          final (off, angle) = switch (dir) {
            'up' => (Offset(0, -(r + h * .12)), -math.pi / 2),
            'down' => (Offset(0, r + h * .12), math.pi / 2),
            'left' => (Offset(-(r + h * .22), 0), math.pi),
            _ => (Offset(r + h * .22, 0), 0.0),
          };
          _arrow(c, center + off, angle, h * .18, _fg);
        }
      case null:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter old) => old.input != input;
}
