import 'sc_input.dart';
import 'sc_profile_document.dart';

/// Swaps joystick numbers [a] and [b] in every joystick binding.
ScRebindMap scSwapJoystickInstances(ScRebindMap rebinds, int a, int b) {
  final result = <String, Map<ScDeviceType, ScRebind>>{};
  for (final e in rebinds.entries) {
    final slots = {...e.value};
    final js = slots[ScDeviceType.joystick];
    if (js != null && (js.input.instance == a || js.input.instance == b)) {
      slots[ScDeviceType.joystick] = ScRebind(
        js.input.withInstance(js.input.instance == a ? b : a),
        activationMode: js.activationMode,
        multiTap: js.multiTap,
      );
    }
    result[e.key] = slots;
  }
  return result;
}

/// Adds an a⇄b swap to [pending] (original number → current number) and returns the new map,
/// so several swaps before saving still rewrite each `<options>` line once, to its final number.
Map<int, int> scComposeRenumber(Map<int, int> pending, int a, int b) {
  // current number → original number
  final origin = {for (final e in pending.entries) e.value: e.key};
  final result = <int, int>{};
  for (final current in {a, b, ...pending.keys, ...pending.values}) {
    final original = origin[current] ?? current;
    final next = current == a ? b : (current == b ? a : current);
    if (original != next) result[original] = next;
  }
  return result;
}
