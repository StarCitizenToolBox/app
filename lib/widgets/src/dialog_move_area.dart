import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:window_manager/window_manager.dart';

/// Tracks whether the top-most route of the navigator it is attached to is a
/// dialog (`showDialog` route), for [DialogMoveArea].
///
/// It follows the top route rather than counting open dialogs: a page can be
/// pushed over a dialog that is still open (e.g. the input-method dialog
/// navigating to the downloader), and a count would then keep the drag strip
/// over that page, covering its back button.
class DialogRouteObserver extends NavigatorObserver {
  DialogRouteObserver._();

  static final instance = DialogRouteObserver._();

  /// True while a dialog is the top-most route.
  final dialogOnTop = ValueNotifier<bool>(false);

  Route<dynamic>? _top;

  void _setTop(Route<dynamic>? route) {
    _top = route;
    dialogOnTop.value = route is RawDialogRoute;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _setTop(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (identical(route, _top)) _setTop(previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (identical(route, _top)) _setTop(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (identical(oldRoute, _top)) _setTop(newRoute);
  }
}

/// A window drag strip over the title bar, shown only while a dialog is on top:
/// the dialog's modal barrier otherwise covers the title bar's own
/// [DragToMoveArea], so the window cannot be moved.
///
/// It stays mounted for [unmountDelay] after the dialog leaves the top, so
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
  final _dialogOnTop = DialogRouteObserver.instance.dialogOnTop;
  Timer? _unmountTimer;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _active = _dialogOnTop.value;
    _dialogOnTop.addListener(_onDialogsChanged);
  }

  @override
  void dispose() {
    _dialogOnTop.removeListener(_onDialogsChanged);
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
    if (_dialogOnTop.value) {
      _unmountTimer?.cancel();
      _unmountTimer = null;
      if (!_active) setState(() => _active = true);
    } else if (_active && _unmountTimer == null) {
      _unmountTimer = Timer(widget.unmountDelay, () {
        _unmountTimer = null;
        if (mounted && !_dialogOnTop.value) {
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
