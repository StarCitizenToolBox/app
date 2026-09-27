import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_format.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'binding_chip.dart';
import 'device_diagram.dart';

/// Key position in key units: x, y, width, height.
typedef _Key = (String key, double x, double y, double w, double h);

const _gap = 4.0;

/// Keys the game can't bind (shown greyed so the layout still reads as a keyboard).
const _unbindable = {'`', 'lwin', 'menu'};

List<_Key> _layout() {
  final keys = <_Key>[];
  void row(double y, double x0, List<(String, double)> items) {
    var x = x0;
    for (final (k, w) in items) {
      if (k.isNotEmpty) keys.add((k, x, y, w, 1));
      x += w;
    }
  }

  row(0, 0, [
    ('escape', 1),
    ('', 1),
    for (var i = 1; i <= 4; i++) ('f$i', 1),
    ('', .5),
    for (var i = 5; i <= 8; i++) ('f$i', 1),
    ('', .5),
    for (var i = 9; i <= 12; i++) ('f$i', 1),
  ]);
  row(1.5, 0, [
    ('`', 1),
    for (final k in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) (k, 1),
    ('minus', 1),
    ('equals', 1),
    ('backspace', 2),
  ]);
  row(2.5, 0, [
    ('tab', 1.5),
    for (final k in 'qwertyuiop'.split('')) (k, 1),
    ('lbracket', 1),
    ('rbracket', 1),
    ('backslash', 1.5),
  ]);
  row(3.5, 0, [
    ('capslock', 1.75),
    for (final k in 'asdfghjkl'.split('')) (k, 1),
    ('semicolon', 1),
    ('apostrophe', 1),
    ('enter', 2.25),
  ]);
  row(4.5, 0, [
    ('lshift', 2.25),
    for (final k in 'zxcvbnm'.split('')) (k, 1),
    ('comma', 1),
    ('period', 1),
    ('slash', 1),
    ('rshift', 2.75),
  ]);
  row(5.5, 0, [
    ('lctrl', 1.5),
    ('lwin', 1.25),
    ('lalt', 1.25),
    ('space', 6.25),
    ('ralt', 1.25),
    ('menu', 1.25),
    ('rctrl', 2.25),
  ]);
  // Navigation block.
  row(0, 15.25, [('print', 1), ('scrolllock', 1), ('pause', 1)]);
  row(1.5, 15.25, [('insert', 1), ('home', 1), ('pgup', 1)]);
  row(2.5, 15.25, [('delete', 1), ('end', 1), ('pgdn', 1)]);
  row(4.5, 16.25, [('up', 1)]);
  row(5.5, 15.25, [('left', 1), ('down', 1), ('right', 1)]);
  // Numpad.
  row(1.5, 18.5, [('numlock', 1), ('np_divide', 1), ('np_multiply', 1), ('np_subtract', 1)]);
  row(2.5, 18.5, [('np_7', 1), ('np_8', 1), ('np_9', 1)]);
  row(3.5, 18.5, [('np_4', 1), ('np_5', 1), ('np_6', 1)]);
  row(4.5, 18.5, [('np_1', 1), ('np_2', 1), ('np_3', 1)]);
  row(5.5, 18.5, [('np_0', 2), ('np_period', 1)]);
  keys.add(('np_add', 21.5, 2.5, 1, 2));
  keys.add(('np_enter', 21.5, 4.5, 1, 2));
  return keys;
}

final _keys = _layout();
const _kbUnitsW = 22.5;
const _kbUnitsH = 6.5;

const _shortCaps = {
  'backspace': 'Bksp',
  'capslock': 'Caps',
  'numlock': 'NumLk',
  'insert': 'Ins',
  'delete': 'Del',
  'print': 'PrtSc',
  'scrolllock': 'ScrLk',
  'np_enter': 'Ent',
  'np_period': '.',
  'np_add': '+',
  'np_subtract': '-',
  'np_multiply': '*',
  'np_divide': '/',
};

/// Key cap text: short forms for wide names; numpad keys drop the "Num" prefix (the block says it).
String _capLabel(ScDeviceType device, String key) {
  final short = _shortCaps[key];
  if (short != null) return short;
  if (key.startsWith('np_')) return key.substring(3);
  return scFormatBody(ScInput(device, 1, const [], key));
}

/// Mouse parts, in a 200×286 design box beside the keyboard, with short cap labels.
const _mouseBox = Size(200, 286);
const _mouseParts = <(String key, Rect rect, String label)>[
  ('mouse1', Rect.fromLTWH(30, 12, 52, 100), 'L'),
  ('mouse2', Rect.fromLTWH(118, 12, 52, 100), 'R'),
  ('mwheel_up', Rect.fromLTWH(84, 14, 32, 28), '↑'),
  ('mouse3', Rect.fromLTWH(84, 46, 32, 30), 'M3'),
  ('mwheel_down', Rect.fromLTWH(84, 80, 32, 28), '↓'),
  ('mouse4', Rect.fromLTWH(4, 124, 28, 38), 'M4'),
  ('mouse5', Rect.fromLTWH(4, 168, 28, 38), 'M5'),
  ('maxis_x', Rect.fromLTWH(30, 246, 66, 34), 'X'),
  ('maxis_y', Rect.fromLTWH(104, 246, 66, 34), 'Y'),
];

/// Design canvas: keys at a readable size; the viewer scales it to fit and lets the user zoom / pan.
const _uW = 96.0;
const _uH = 76.0;
const _mouseGap = 48.0;

/// Zoom range: from fit-to-panel up to this.
const _maxScale = 2.5;
const _mouseScale = _kbUnitsH * _uH / 286;
const _canvas = Size(_kbUnitsW * _uW + _mouseGap + 200 * _mouseScale, _kbUnitsH * _uH);

/// Keyboard + mouse map: every key tinted by how many actions it carries and labelled with them.
/// Wheel / pinch zooms, drag pans, the buttons in the corner zoom and fit.
class KeyboardMouseDiagram extends StatefulWidget {
  const KeyboardMouseDiagram({
    super.key,
    required this.bindings,
    required this.model,
    required this.modifierLayer,
    required this.onInputTap,
    this.litKeys = const {},
    this.litMouse = const {},
  });

  final List<DeviceBinding> bindings;
  final KeybindingModel model;
  final bool modifierLayer;

  /// Keyboard / mouse tokens being pressed right now.
  final Set<String> litKeys;
  final Set<String> litMouse;
  final ValueChanged<ScInput> onInputTap;

  @override
  State<KeyboardMouseDiagram> createState() => _KeyboardMouseDiagramState();
}

class _KeyboardMouseDiagramState extends State<KeyboardMouseDiagram> {
  final _controller = TransformationController();
  Size? _viewport;
  bool _clamping = false;

  List<DeviceBinding> get bindings => widget.bindings;

  KeybindingModel get model => widget.model;

  bool get modifierLayer => widget.modifierLayer;

  ValueChanged<ScInput> get onInputTap => widget.onInputTap;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_keepInView);
  }

  @override
  void dispose() {
    _controller.removeListener(_keepInView);
    _controller.dispose();
    super.dispose();
  }

  double _fitScale(Size viewport) => (viewport.width / _canvas.width) < (viewport.height / _canvas.height)
      ? viewport.width / _canvas.width
      : viewport.height / _canvas.height;

  /// Keeps the content on screen: an axis narrower than the viewport is centred, a wider one can
  /// only be dragged until its edge meets the viewport's edge.
  Matrix4 _clamped(Matrix4 m, Size v) {
    final scale = m.getMaxScaleOnAxis().clamp(_fitScale(v), _maxScale);
    double axis(double t, double content, double view) =>
        content <= view ? (view - content) / 2 : t.clamp(view - content, 0.0);
    final tx = axis(m.storage[12], _canvas.width * scale, v.width);
    final ty = axis(m.storage[13], _canvas.height * scale, v.height);
    return Matrix4.identity()
      ..translateByDouble(tx, ty, 0, 1)
      ..scaleByDouble(scale, scale, scale, 1);
  }

  void _keepInView() {
    final v = _viewport;
    if (v == null || _clamping) return;
    final fixed = _clamped(_controller.value, v);
    if (fixed == _controller.value) return;
    _clamping = true;
    _controller.value = fixed;
    _clamping = false;
  }

  void _fit() {
    final v = _viewport;
    if (v == null) return;
    final scale = _fitScale(v);
    _controller.value = _clamped(Matrix4.identity()..scaleByDouble(scale, scale, scale, 1), v);
  }

  void _zoom(double factor) {
    final v = _viewport;
    if (v == null) return;
    final center = Offset(v.width / 2, v.height / 2);
    final focal = _controller.toScene(center);
    final current = _controller.value.getMaxScaleOnAxis();
    final next = (current * factor).clamp(_fitScale(v), _maxScale);
    final m = Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..scaleByDouble(next, next, next, 1)
      ..translateByDouble(-focal.dx, -focal.dy, 0, 1);
    _controller.value = _clamped(m, v);
  }

  @override
  Widget build(BuildContext context) {
    final byKey = <String, List<DeviceBinding>>{};
    for (final b in bindings) {
      byKey.putIfAbsent(b.input.key, () => []).add(b);
    }
    int loadOf(List<DeviceBinding> l) => l.fold<int>(0, (n, b) => n + b.entries.length);
    final maxLoad = byKey.values.fold<int>(1, (m, l) => loadOf(l) > m ? loadOf(l) : m);

    Widget cap(String key, Rect rect, ScDeviceType device, {bool round = false, String? shortLabel}) {
      final list = byKey[key] ?? const [];
      final combos = ScInput.sortModifiers({for (final b in list) ...b.input.modifiers}.toList());
      return Positioned.fromRect(
        rect: rect.deflate(_gap / 2),
        child: _KeyCap(
          label:
              shortLabel ??
              (_unbindable.contains(key)
                  ? (key == '`'
                        ? '`'
                        : key == 'lwin'
                        ? 'Win'
                        : 'Menu')
                  : _capLabel(device, key)),
          names: [
            for (final b in byPriority(list))
              for (final (a, _) in b.entries) model.actionLabel(a),
          ],
          activeCount: list.where((b) => b.priority < 2).fold(0, (n, b) => n + b.entries.length),
          load: loadOf(list),
          maxLoad: maxLoad,
          conflict: list.any((b) => b.conflicted),
          modified: list.any((b) => b.modified),
          enabled: !_unbindable.contains(key),
          tooltip: [
            if (shortLabel != null) scFormatBody(ScInput(device, 1, const [], key)),
            for (final b in list)
              for (final (a, _) in b.entries) '${scFormatBody(b.input)}  →  ${model.actionLabel(a)}',
          ].join('\n'),
          round: round,
          lit: (device == ScDeviceType.mouse ? widget.litMouse : widget.litKeys).contains(key),
          stripes: modifierLayer ? combos : const [],
          ownColor: modifierLayer && scKeyboardModifiers.contains(key) ? modifierColor(key) : null,
          ownColorBorderOnly: list.any((b) => b.input.modifiers.isEmpty),
          baseStripe: combos.isNotEmpty && list.any((b) => b.input.modifiers.isEmpty),
          onTap: () => onInputTap(list.firstOrNull?.input ?? ScInput(device, 1, const [], key)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) {
              final viewport = Size(box.maxWidth, box.maxHeight);
              if (_viewport != viewport) {
                _viewport = viewport;
                // Window resized (or first layout): back to the best fit.
                WidgetsBinding.instance.addPostFrameCallback((_) => mounted ? _fit() : null);
              }
              final mouseLeft = _kbUnitsW * _uW + _mouseGap;
              return ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InteractiveViewer(
                        transformationController: _controller,
                        constrained: false,
                        minScale: _fitScale(viewport),
                        maxScale: _maxScale,
                        boundaryMargin: const EdgeInsets.all(double.infinity),
                        child: SizedBox(
                          width: _canvas.width,
                          height: _canvas.height,
                          child: Stack(
                            children: [
                              for (final (k, x, y, w, h) in _keys)
                                cap(k, Rect.fromLTWH(x * _uW, y * _uH, w * _uW, h * _uH), ScDeviceType.keyboard),
                              Positioned(
                                left: mouseLeft,
                                top: 0,
                                width: 200 * _mouseScale,
                                height: _canvas.height,
                                child: CustomPaint(painter: _MousePainter()),
                              ),
                              for (final (k, r, l) in _mouseParts)
                                cap(
                                  k,
                                  Rect.fromLTWH(
                                    mouseLeft + r.left * _mouseScale,
                                    r.top * _mouseScale,
                                    r.width * _mouseScale,
                                    r.height * _mouseScale,
                                  ),
                                  ScDeviceType.mouse,
                                  round: true,
                                  shortLabel: l,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Card(
                        padding: const EdgeInsets.all(2),
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Tooltip(
                              message: S.current.keybinding_zoom_out,
                              child: IconButton(
                                icon: const Icon(FluentIcons.remove, size: 12),
                                onPressed: () => _zoom(1 / 1.25),
                              ),
                            ),
                            Tooltip(
                              message: S.current.keybinding_zoom_in,
                              child: IconButton(
                                icon: const Icon(FluentIcons.add, size: 12),
                                onPressed: () => _zoom(1.25),
                              ),
                            ),
                            Tooltip(
                              message: S.current.keybinding_zoom_fit,
                              child: IconButton(icon: const Icon(FluentIcons.fit_page, size: 12), onPressed: _fit),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        DiagramLegend(
          extra: [
            Text(
              modifierLayer ? S.current.keybinding_kb_legend_modifier : S.current.keybinding_kb_legend_base,
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .62)),
            ),
            Text(
              S.current.keybinding_zoom_hint,
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .62)),
            ),
            if (modifierLayer)
              ModifierLegend(
                modifiers: scKeyboardModifiers,
                labelOf: (m) => scFormatModifier(ScDeviceType.keyboard, m),
              ),
          ],
        ),
      ],
    );
  }
}

class _KeyCap extends StatelessWidget {
  const _KeyCap({
    required this.label,
    required this.names,
    required this.load,
    required this.maxLoad,
    required this.conflict,
    required this.modified,
    required this.enabled,
    required this.tooltip,
    required this.round,
    required this.onTap,
    this.stripes = const [],
    this.baseStripe = false,
    this.ownColor,
    this.lit = false,
    this.ownColorBorderOnly = false,
    this.activeCount = 0,
  });

  /// The first [activeCount] names belong to the combo being held or unlocked by held modifiers.
  final int activeCount;

  /// Being pressed right now.
  final bool lit;

  /// A modifier key that also has its own bindings: tint by load, mark the modifier with the border.
  final bool ownColorBorderOnly;

  final String label;

  /// Actions the key triggers, shown on the cap when there is room.
  final List<String> names;

  /// Combo layer: the modifiers this key is used with, drawn as stripes.
  final List<String> stripes;

  /// "All" view, a key with both plain and combo bindings: its own (accent) stripe goes with the
  /// modifier stripes.
  final bool baseStripe;

  /// Combo layer: a modifier key shows its own color.
  final Color? ownColor;

  final int load;
  final int maxLoad;
  final bool conflict;
  final bool modified;
  final bool enabled;
  final String tooltip;
  final bool round;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = FluentTheme.of(context).accentColor;
    const warning = kbConflictColor;
    // Heat: more actions on a key → stronger accent tint.
    final heat = load == 0 ? 0.0 : .12 + .38 * (load / maxLoad).clamp(0, 1);
    final labelStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: Colors.white.withValues(alpha: enabled ? .92 : .3),
    );
    final countText = load > 0
        ? Text(
            '$load',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: accent.lightest),
          )
        : null;
    final child = HoverButton(
      onPressed: enabled ? onTap : null,
      builder: (context, states) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: lit
              ? accent.withValues(alpha: .75)
              : ownColor != null && !ownColorBorderOnly
              ? ownColor!.withValues(alpha: .35)
              : load == 0
              ? Colors.white.withValues(alpha: enabled ? .04 : .015)
              : accent.withValues(alpha: heat),
          borderRadius: BorderRadius.circular(round ? 10 : 4),
          boxShadow: lit ? [BoxShadow(color: accent.withValues(alpha: .7), blurRadius: 10, spreadRadius: 1)] : null,
          border: Border.all(
            width: lit ? 2 : 1,
            color: lit
                ? Colors.white
                : conflict
                ? warning.withValues(alpha: .8)
                : states.isHovered
                ? accent.withValues(alpha: .8)
                : ownColor != null
                ? ownColor!
                : modified
                ? accent.withValues(alpha: .6)
                : Colors.white.withValues(alpha: enabled ? .12 : .05),
          ),
        ),
        child: Stack(
          children: [
            if (stripes.isNotEmpty)
              Positioned.fill(
                child: ModifierFlag(
                  modifiers: stripes,
                  baseColor: baseStripe ? accent.withValues(alpha: .4) : null,
                  alpha: .34,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            LayoutBuilder(
              builder: (context, c) {
                // Short caps: just the key name; taller ones list what the key does.
                if (c.maxHeight < 36 || names.isEmpty) {
                  return Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(label, maxLines: 1, overflow: TextOverflow.clip, style: labelStyle),
                        ),
                      ),
                      if (countText != null) Positioned(right: 3, top: 1, child: countText),
                    ],
                  );
                }
                final lines = ((c.maxHeight - 22) / 12.5).floor().clamp(1, 8);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4, 3, 3, 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(label, maxLines: 1, overflow: TextOverflow.clip, style: labelStyle),
                          ),
                          ?countText,
                        ],
                      ),
                      const SizedBox(height: 2),
                      // One line per action; what doesn't fit is counted.
                      for (final (i, n) in names.take(names.length > lines ? lines - 1 : lines).indexed)
                        Text(
                          n,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.25,
                            fontWeight: i < activeCount ? FontWeight.w700 : null,
                            color: i < activeCount ? Colors.white : Colors.white.withValues(alpha: .85),
                          ),
                        ),
                      if (names.length > lines)
                        Text(
                          '+${names.length - lines + 1}',
                          maxLines: 1,
                          style: TextStyle(fontSize: 10, height: 1.25, color: accent.lightest),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
    return tooltip.isEmpty ? child : Tooltip(message: tooltip, child: child);
  }
}

class _MousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _mouseBox.width, size.height / _mouseBox.height);
    final body = RRect.fromRectAndCorners(
      const Rect.fromLTWH(26, 6, 148, 232),
      topLeft: const Radius.circular(70),
      topRight: const Radius.circular(70),
      bottomLeft: const Radius.circular(64),
      bottomRight: const Radius.circular(64),
    );
    canvas.drawRRect(body, Paint()..color = Colors.white.withValues(alpha: .05));
    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: .28),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
