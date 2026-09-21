import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:window_manager/window_manager.dart';

import 'dialog_move_area.dart';

/// Shared state of the nebula, so the window background and every
/// [NebulaDecoration] (dialogs) drift and follow the window together.
class NebulaClock {
  NebulaClock._();

  /// Seconds of drift elapsed; only advances while the background animates.
  static final time = ValueNotifier<double>(0);

  /// Window position on screen, used for the parallax shift.
  static final windowOffset = ValueNotifier<Offset>(Offset.zero);

  static final Listenable listenable = Listenable.merge([time, windowOffset]);
}

/// Self-drawn nebula backdrop that replaces the platform acrylic effect.
///
/// [animated] lets the nebula drift slowly and, when [trackWindow] is set,
/// shifts it against the window position while the window is dragged, so it
/// reads as a backdrop that stays put behind a moving window.
/// With [animated] off it paints a single static frame.
///
/// The drift also pauses while a dialog is open, the window is unfocused or
/// minimised: every animated frame recomposites the whole window, including
/// costly layers such as dialog shadows.
///
/// It drives [NebulaClock], so mount only one per window.
class NebulaBackground extends StatefulWidget {
  const NebulaBackground({
    super.key,
    this.animated = true,
    this.trackWindow = true,
  });

  final bool animated;
  final bool trackWindow;

  @override
  State<NebulaBackground> createState() => _NebulaBackgroundState();
}

class _NebulaBackgroundState extends State<NebulaBackground>
    with SingleTickerProviderStateMixin, WindowListener {
  /// Repaints are capped to this interval; the drift is slow enough that
  /// 30 fps looks identical to 60 fps and halves the cost.
  static const _frameInterval = Duration(milliseconds: 33);

  late final Ticker _ticker = createTicker(_onTick);
  final _openDialogs = DialogRouteObserver.instance.openDialogs;
  Duration _lastFrame = Duration.zero;
  bool _minimized = false;
  bool _focused = true;

  bool get _tracking => widget.animated && widget.trackWindow;

  @override
  void initState() {
    super.initState();
    _openDialogs.addListener(_updateTicker);
    _applyConfig();
  }

  @override
  void didUpdateWidget(NebulaBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animated != widget.animated ||
        oldWidget.trackWindow != widget.trackWindow) {
      _applyConfig();
    }
  }

  void _applyConfig() {
    windowManager.removeListener(this);
    if (widget.animated) {
      windowManager.addListener(this);
      _syncFocus();
    }
    if (_tracking) {
      _syncWindowPosition();
    } else {
      NebulaClock.windowOffset.value = Offset.zero;
    }
    _updateTicker();
  }

  void _updateTicker() {
    final shouldRun =
        widget.animated && !_minimized && _focused && _openDialogs.value == 0;
    if (shouldRun && !_ticker.isActive) {
      _lastFrame = Duration.zero;
      _ticker.start();
    } else if (!shouldRun && _ticker.isActive) {
      _ticker.stop();
    }
  }

  void _onTick(Duration elapsed) {
    if (elapsed - _lastFrame < _frameInterval) return;
    NebulaClock.time.value += (elapsed - _lastFrame).inMicroseconds / 1e6;
    _lastFrame = elapsed;
  }

  Future<void> _syncWindowPosition() async {
    try {
      final position = await windowManager.getPosition();
      if (mounted && _tracking) NebulaClock.windowOffset.value = position;
    } catch (_) {
      // Window position is a nicety; keep the last offset if it fails.
    }
  }

  Future<void> _syncFocus() async {
    try {
      final focused = await windowManager.isFocused();
      if (!mounted) return;
      _focused = focused;
      _updateTicker();
    } catch (_) {
      // Assume focused; the focus/blur events will correct it.
    }
  }

  @override
  void onWindowFocus() {
    _focused = true;
    _updateTicker();
  }

  @override
  void onWindowBlur() {
    _focused = false;
    _updateTicker();
  }

  @override
  void onWindowMove() {
    if (_tracking) _syncWindowPosition();
  }

  @override
  void onWindowMoved() {
    if (_tracking) _syncWindowPosition();
  }

  @override
  void onWindowMinimize() {
    _minimized = true;
    _updateTicker();
  }

  @override
  void onWindowRestore() {
    _minimized = false;
    _updateTicker();
    if (_tracking) _syncWindowPosition();
  }

  @override
  void dispose() {
    _openDialogs.removeListener(_updateTicker);
    windowManager.removeListener(this);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _NebulaPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _NebulaPainter extends CustomPainter {
  _NebulaPainter() : super(repaint: NebulaClock.listenable);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    // The recorded picture keeps the image alive; release our handle now.
    final image = _renderNebulaImage(size);
    _drawUpscaled(canvas, image, Offset.zero & size);
    image.dispose();
  }

  @override
  bool shouldRepaint(_NebulaPainter oldDelegate) => false;
}

/// A dialog/panel background that paints the nebula inside its rounded box,
/// covered by [tint] so it reads calmer than the window background.
///
/// The nebula is a still frame taken when the box is first painted (or
/// resized): animating it would repaint the whole dialog content with every
/// tick, since a decoration cannot sit in a layer of its own.
class NebulaDecoration extends Decoration {
  const NebulaDecoration({
    required this.tint,
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.boxShadow = const [],
  });

  final Color tint;
  final BorderRadius borderRadius;
  final BorderSide? border;
  final List<BoxShadow> boxShadow;

  @override
  EdgeInsetsGeometry get padding => EdgeInsets.all(
    border?.strokeInset ?? 0,
  ).clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) =>
      borderRadius.toRRect(Offset.zero & size).contains(position);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _NebulaBoxPainter(this, onChanged);

  @override
  bool operator ==(Object other) =>
      other is NebulaDecoration &&
      other.tint == tint &&
      other.borderRadius == borderRadius &&
      other.border == border &&
      listEquals(other.boxShadow, boxShadow);

  @override
  int get hashCode =>
      Object.hash(tint, borderRadius, border, Object.hashAll(boxShadow));
}

class _NebulaBoxPainter extends BoxPainter {
  _NebulaBoxPainter(this.decoration, super.onChanged);

  final NebulaDecoration decoration;
  ui.Image? _image;
  Size? _imageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    final rect = offset & size;
    final rrect = decoration.borderRadius.toRRect(rect);

    for (final shadow in decoration.boxShadow) {
      canvas.drawRRect(
        rrect.shift(shadow.offset).inflate(shadow.spreadRadius),
        shadow.toPaint(),
      );
    }

    if (_image == null || _imageSize != size) {
      _image?.dispose();
      _image = _renderNebulaImage(size);
      _imageSize = size;
    }

    canvas.save();
    canvas.clipRRect(rrect);
    _drawUpscaled(canvas, _image!, rect);
    canvas.drawRect(rect, Paint()..color = decoration.tint);
    canvas.restore();

    final border = decoration.border;
    if (border != null && border.style != BorderStyle.none) {
      canvas.drawRRect(rrect.deflate(border.width / 2), border.toPaint());
    }
  }

  @override
  void dispose() {
    _image?.dispose();
    _image = null;
    super.dispose();
  }
}

/// The nebula has no fine detail, so it is rendered at a fraction of the
/// target resolution and stretched with bilinear filtering. Full-resolution
/// gradients cost several full-screen fills per frame, which a maximised
/// window on a high-DPI screen cannot keep up with.
const _nebulaDownscale = 6.0;

ui.Image _renderNebulaImage(Size size) {
  final width = math.max(1, (size.width / _nebulaDownscale).ceil());
  final height = math.max(1, (size.height / _nebulaDownscale).ceil());
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..scale(width / size.width, height / size.height);
  paintNebula(canvas, Offset.zero & size);
  final picture = recorder.endRecording();
  final image = picture.toImageSync(width, height);
  picture.dispose();
  return image;
}

void _drawUpscaled(Canvas canvas, ui.Image image, Rect destination) {
  canvas.drawImageRect(
    image,
    Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    destination,
    Paint()..filterQuality = FilterQuality.low,
  );
}

class _NebulaCloud {
  const _NebulaCloud({
    required this.anchor,
    required this.radius,
    required this.color,
    required this.drift,
    required this.speed,
    required this.phase,
  });

  /// Rest position as a fraction of the view size.
  final Offset anchor;

  /// Radius as a fraction of the longer view side.
  final double radius;
  final Color color;

  /// Drift amplitude in logical pixels.
  final Offset drift;

  /// Angular speed in radians per second.
  final double speed;
  final double phase;
}

const _nebulaBase = Color(0xff05080d);

/// How far the nebula moves against the window: 1 would pin it to the
/// screen; lower values read as a more distant layer.
const _cloudParallax = 0.35;

// Palette taken from the design mock: teal, ember and violet clouds.
const _clouds = [
  _NebulaCloud(
    anchor: Offset(0.14, 0.18),
    radius: 0.62,
    color: Color(0x99268caa),
    drift: Offset(220, 150),
    speed: 0.17,
    phase: 0,
  ),
  _NebulaCloud(
    anchor: Offset(0.86, 0.26),
    radius: 0.52,
    color: Color(0x80d66e30),
    drift: Offset(180, 200),
    speed: 0.14,
    phase: 2.1,
  ),
  _NebulaCloud(
    anchor: Offset(0.55, 1.05),
    radius: 0.64,
    color: Color(0x8c5040aa),
    drift: Offset(260, 130),
    speed: 0.12,
    phase: 4.2,
  ),
  _NebulaCloud(
    anchor: Offset(0.38, 0.55),
    radius: 0.38,
    color: Color(0x401e5a8c),
    drift: Offset(240, 160),
    speed: 0.2,
    phase: 1.1,
  ),
];

/// Paints the nebula filling [rect], at the current [NebulaClock] state.
/// Cloud positions scale with [rect], so a dialog gets its own full nebula.
void paintNebula(Canvas canvas, Rect rect) {
  canvas.drawRect(rect, Paint()..color = _nebulaBase);

  final size = rect.size;
  final t = NebulaClock.time.value;
  final cloudShift = -NebulaClock.windowOffset.value * _cloudParallax;
  final longSide = math.max(size.width, size.height);

  for (final cloud in _clouds) {
    // Slow breathing on top of the drift so the motion is easy to notice.
    final radius =
        cloud.radius *
        longSide *
        (1 + 0.08 * math.sin(t * cloud.speed * 1.3 + cloud.phase * 2));
    final center =
        rect.topLeft +
        Offset(
          _wrap(
            cloud.anchor.dx * size.width +
                cloud.drift.dx * math.sin(t * cloud.speed + cloud.phase) +
                cloudShift.dx,
            size.width,
            radius,
          ),
          _wrap(
            cloud.anchor.dy * size.height +
                cloud.drift.dy * math.cos(t * cloud.speed * 0.8 + cloud.phase) +
                cloudShift.dy,
            size.height,
            radius,
          ),
        );
    final paint = Paint()
      ..shader = ui.Gradient.radial(center, radius, [
        cloud.color,
        cloud.color.withValues(alpha: 0),
      ]);
    canvas.drawRect(rect, paint);
  }
}

/// Wraps a cloud centre into a period wider than the view plus the cloud's
/// radius on both sides, so a cloud leaving one edge re-enters from the
/// other while fully out of sight instead of popping.
double _wrap(double value, double extent, double radius) {
  final period = extent + radius * 2;
  return ((value + radius) % period + period) % period - radius;
}
