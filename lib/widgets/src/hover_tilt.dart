import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

/// [Tilt.base] that is only mounted while the pointer is over it.
///
/// Even at rest Tilt keeps its child under a perspective transform, which the
/// raster cache cannot cache, and paints a (transparent) blurred shadow and
/// light gradient. With the animated background every frame recomposites the
/// window, so each tilt card was re-rasterised on every frame. At rest this
/// paints the same box Tilt would, without the transform or effects.
///
/// Tilt stays mounted for [unmountDelay] after the pointer leaves so its
/// revert animation can finish. The child keeps its state across the switch.
class HoverTilt extends StatefulWidget {
  const HoverTilt({
    super.key,
    required this.child,
    this.shadowConfig = const ShadowBaseConfig(),
    this.border,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.disable = false,
    this.unmountDelay = const Duration(milliseconds: 400),
  });

  final Widget child;
  final ShadowBaseConfig shadowConfig;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final Clip clipBehavior;
  final bool disable;

  /// Longer than Tilt's default 300ms leave animation.
  final Duration unmountDelay;

  @override
  State<HoverTilt> createState() => _HoverTiltState();
}

class _HoverTiltState extends State<HoverTilt> {
  final _childKey = GlobalKey();
  Timer? _unmountTimer;
  bool _tilting = false;

  @override
  void didUpdateWidget(HoverTilt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.disable && _tilting) {
      _unmountTimer?.cancel();
      _unmountTimer = null;
      _tilting = false;
    }
  }

  @override
  void dispose() {
    _unmountTimer?.cancel();
    super.dispose();
  }

  void _onEnter(PointerEnterEvent _) {
    if (widget.disable) return;
    _unmountTimer?.cancel();
    _unmountTimer = null;
    if (!_tilting) setState(() => _tilting = true);
  }

  void _onExit(PointerExitEvent _) {
    if (!_tilting) return;
    _unmountTimer?.cancel();
    _unmountTimer = Timer(widget.unmountDelay, () {
      _unmountTimer = null;
      if (mounted) setState(() => _tilting = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = KeyedSubtree(key: _childKey, child: widget.child);
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: _tilting
          ? Tilt.base(
              shadowConfig: widget.shadowConfig,
              border: widget.border,
              borderRadius: widget.borderRadius,
              clipBehavior: widget.clipBehavior,
              child: child,
            )
          : _buildAtRest(child),
    );
  }

  /// Mirrors the layout TiltBaseContainer builds around its child, so the
  /// card keeps exactly the same size when Tilt is swapped in.
  Widget _buildAtRest(Widget child) {
    final clipBehavior = widget.clipBehavior;
    return Stack(
      alignment: AlignmentDirectional.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: widget.border,
            borderRadius: widget.borderRadius,
          ),
          clipBehavior: clipBehavior,
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: clipBehavior == Clip.none
                ? Clip.hardEdge
                : clipBehavior,
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: widget.borderRadius),
                clipBehavior: clipBehavior,
                child: child,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
