import 'sc_default_profile.dart';
import 'sc_input.dart';
import 'sc_profile_document.dart';

enum ScSlotState {
  /// Nothing bound, and no default.
  none,

  /// The game default is in effect.
  byDefault,

  /// The player bound something else.
  custom,

  /// The player removed the default.
  cleared,
}

class ScSlot {
  const ScSlot({
    required this.device,
    required this.input,
    required this.defaultInput,
    required this.state,
    required this.activationMode,
    required this.hasModeOverride,
  });

  final ScDeviceType device;

  /// Effective input; null when nothing triggers the action on this device.
  final ScInput? input;
  final ScInput? defaultInput;
  final ScSlotState state;
  final String? activationMode;
  final bool hasModeOverride;

  bool get isModified => state == ScSlotState.custom || state == ScSlotState.cleared || hasModeOverride;
}

ScSlot scResolveSlot(ScActionDef action, ScDeviceType device, Map<ScDeviceType, ScRebind>? rebinds) {
  final def = action.defaults[device];
  final rb = rebinds?[device];
  final defMode = action.modeFor(device);
  if (rb == null) {
    return ScSlot(
      device: device,
      input: def,
      defaultInput: def,
      state: def == null ? ScSlotState.none : ScSlotState.byDefault,
      activationMode: defMode,
      hasModeOverride: false,
    );
  }
  final modeOverride = rb.activationMode != null && rb.activationMode != defMode;
  if (rb.input.isUnbound) {
    return ScSlot(
      device: device,
      input: null,
      defaultInput: def,
      state: def == null ? ScSlotState.none : ScSlotState.cleared,
      activationMode: rb.activationMode ?? defMode,
      hasModeOverride: modeOverride,
    );
  }
  return ScSlot(
    device: device,
    input: rb.input,
    defaultInput: def,
    state: rb.input == def ? ScSlotState.byDefault : ScSlotState.custom,
    activationMode: rb.activationMode ?? defMode,
    hasModeOverride: modeOverride,
  );
}

/// Which gameplay situations an actionmap is live in. Two bindings can only clash when their
/// actionmaps share a situation; "global" maps are live everywhere.
const Map<String, Set<String>> _mapContexts = {
  'seat_general': {'ship', 'ground'},
  'spaceship_general': {'ship'},
  'vehicle_mfd': {'ship', 'ground'},
  'spaceship_view': {'ship'},
  'spaceship_movement': {'ship'},
  'spaceship_quantum': {'ship'},
  'spaceship_docking': {'ship'},
  'spaceship_targeting': {'ship'},
  'spaceship_targeting_advanced': {'ship'},
  'spaceship_target_hailing': {'ship'},
  'spaceship_radar': {'ship'},
  'spaceship_scanning': {'ship'},
  'spaceship_mining': {'ship'},
  'spaceship_salvage': {'ship'},
  'turret_movement': {'turret'},
  'turret_advanced': {'turret'},
  'spaceship_weapons': {'ship'},
  'spaceship_missiles': {'ship'},
  'spaceship_defensive': {'ship'},
  'spaceship_auto_weapons': {'ship'},
  'spaceship_power': {'ship'},
  'spaceship_hud': {'ship'},
  'lights_controller': {'ship', 'ground'},
  'vehicle_mobiglas': {'ship', 'ground'},
  'vehicle_general': {'ground'},
  'vehicle_driver': {'ground'},
  'player': {'fps'},
  'prone': {'fps'},
  'tractor_beam': {'fps', 'eva'},
  'incapacitated': {'fps'},
  'player_emotes': {'fps', 'eva'},
  'zero_gravity_eva': {'eva'},
  'zero_gravity_traversal': {'eva'},
  'default': {'global'},
  'ui_notification': {'global'},
  'player_choice': {'global'},
  'player_input_optical_tracking': {'global'},
  'stopwatch': {'global'},
};

Set<String> scMapContexts(String mapName) => _mapContexts[mapName] ?? {mapName};

/// Ship operator modes: only one is live at a time, so two of them never clash with each other
/// (they still clash with the always-on ship controls).
const Map<String, String> _operatorModes = {
  'spaceship_weapons': 'guns',
  'spaceship_auto_weapons': 'guns',
  'spaceship_missiles': 'missiles',
  'spaceship_mining': 'mining',
  'spaceship_salvage': 'salvage',
  'spaceship_scanning': 'scanning',
  'spaceship_quantum': 'quantum',
};

bool scContextsOverlap(String mapA, String mapB) {
  final a = scMapContexts(mapA);
  final b = scMapContexts(mapB);
  if (a.contains('global') || b.contains('global')) return true;
  final modeA = _operatorModes[mapA];
  final modeB = _operatorModes[mapB];
  if (modeA != null && modeB != null && modeA != modeB) return false;
  return a.any(b.contains);
}

enum _ModeFamily { tap, long, double, other }

_ModeFamily _family(String? mode) {
  if (mode == null) return _ModeFamily.other;
  if (mode.startsWith('tap')) return _ModeFamily.tap;
  if (mode.startsWith('delayed_')) return _ModeFamily.long;
  if (mode.startsWith('double_tap')) return _ModeFamily.double;
  return _ModeFamily.other;
}

/// Short press + long press (or double tap) on one input is a deliberate combo, not a clash.
bool scIsModePair(String? a, String? b) {
  final fa = _family(a);
  final fb = _family(b);
  return fa != fb && fa != _ModeFamily.other && fb != _ModeFamily.other;
}

class ScBindingRef {
  const ScBindingRef(this.action, this.slot);

  final ScActionDef action;
  final ScSlot slot;
}

class ScRelation {
  const ScRelation(this.other, {required this.isPair});

  final ScBindingRef other;

  /// True for a tap/hold combo that the game resolves by timing.
  final bool isPair;
}

/// Index of every effective binding, for conflict lookups.
class ScBindingIndex {
  ScBindingIndex(this.profile, this.rebinds) {
    for (final map in profile.maps) {
      for (final action in map.actions) {
        for (final device in ScDeviceType.values) {
          final slot = scResolveSlot(action, device, rebinds[action.id]);
          final input = slot.input;
          if (input == null) continue;
          _byInput.putIfAbsent(input.conflictKey, () => []).add(ScBindingRef(action, slot));
        }
      }
    }
  }

  final ScDefaultProfile profile;
  final ScRebindMap rebinds;
  final Map<String, List<ScBindingRef>> _byInput = {};

  /// Other actions triggered by [input] in a situation where [action] is also live.
  List<ScRelation> relationsFor(ScActionDef action, ScInput input, String? mode) {
    final list = _byInput[input.conflictKey] ?? const [];
    return [
      for (final ref in list)
        if (ref.action.id != action.id && scContextsOverlap(action.mapName, ref.action.mapName))
          ScRelation(ref, isPair: scIsModePair(mode, ref.slot.activationMode)),
    ];
  }

  /// Conflicts worth reporting: overlapping context, not a tap/hold pair, and at least one side
  /// changed by the player (the game ships with many deliberate default overlaps).
  List<ScRelation> conflictsFor(ScActionDef action, ScSlot slot) {
    final input = slot.input;
    if (input == null) return const [];
    return relationsFor(action, input, slot.activationMode)
        .where((r) => !r.isPair && (slot.state == ScSlotState.custom || r.other.slot.state == ScSlotState.custom))
        .toList();
  }

  bool hasConflict(ScActionDef action) {
    for (final device in ScDeviceType.values) {
      final slot = scResolveSlot(action, device, rebinds[action.id]);
      if (conflictsFor(action, slot).isNotEmpty) return true;
    }
    return false;
  }
}
