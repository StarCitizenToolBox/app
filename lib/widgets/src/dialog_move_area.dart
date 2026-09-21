import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:window_manager/window_manager.dart';

/// Counts the dialogs (`showDialog` routes) open on the navigator it is
/// attached to, for [DialogMoveArea].
class DialogRouteObserver extends NavigatorObserver {
  DialogRouteObserver._();

  static final instance = DialogRouteObserver._();

  final openDialogs = ValueNotifier<int>(0);

  static bool _isDialog(Route<dynamic>? route) => route is RawDialogRoute;

  void _update(int delta) {
    openDialogs.value = (openDialogs.value + delta).clamp(0, 1 << 20);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isDialog(route)) _update(1);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isDialog(route)) _update(-1);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_isDialog(route)) _update(-1);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (_isDialog(oldRoute)) _update(-1);
    if (_isDialog(newRoute)) _update(1);
  }
}

/// A window drag strip over the title bar, shown only while a dialog is open:
/// the dialog's modal barrier otherwise covers the title bar's own
/// [DragToMoveArea], so the window cannot be moved.
///
/// It stays mounted for [unmountDelay] after the last dialog closes, so
/// removing it does not land in the middle of the dialog's exit animation.
class DialogMoveArea extends StatefulWidget {
  const DialogMoveArea({
    super.key,
    this.height = 50,
    this.unmountDelay = const Duration(milliseconds: 400),
  });

  /// Matches the title bar height in IndexUI.
  final double height;
  final Duration unmountDelay;

  @override
  State<DialogMoveArea> createState() => _DialogMoveAreaState();
}

class _DialogMoveAreaState extends State<DialogMoveArea> {
  final _openDialogs = DialogRouteObserver.instance.openDialogs;
  Timer? _unmountTimer;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _active = _openDialogs.value > 0;
    _openDialogs.addListener(_onDialogsChanged);
  }

  @override
  void dispose() {
    _openDialogs.removeListener(_onDialogsChanged);
    _unmountTimer?.cancel();
    super.dispose();
  }

  void _onDialogsChanged() {
    // Routes can be pushed while the tree is building; defer to a safe point.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => _onDialogsChanged(),
      );
      return;
    }
    if (!mounted) return;
    if (_openDialogs.value > 0) {
      _unmountTimer?.cancel();
      _unmountTimer = null;
      if (!_active) setState(() => _active = true);
    } else if (_active && _unmountTimer == null) {
      _unmountTimer = Timer(widget.unmountDelay, () {
        _unmountTimer = null;
        if (mounted && _openDialogs.value == 0) {
          setState(() => _active = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_active) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        // The opaque box claims the hit, so the drag does not also reach the
        // modal barrier underneath (which could dismiss the dialog).
        child: const DragToMoveArea(
          child: ColoredBox(color: Color(0x00000000)),
        ),
      ),
    );
  }
}
