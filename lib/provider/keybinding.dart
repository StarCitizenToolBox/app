import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_format.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_joystick_numbering.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_keybinding_repository.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_profile_document.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_source.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';

part 'keybinding.freezed.dart';

part 'keybinding.g.dart';

enum KeybindingDeviceFilter { all, keyboard, joystick, gamepad }

class KbGroup {
  KbGroup(this.id, this.label, this.actions);

  final String id;
  final String label;
  final List<ScActionDef> actions;
}

class KbCategory {
  KbCategory(this.id, this.label, this.groups);

  final String id;
  final String label;
  final List<KbGroup> groups;
}

/// A joystick instance (`jsN`) and the physical stick behind it.
class KbJoystick {
  const KbJoystick({
    required this.instance,
    this.vendorId,
    this.productId,
    this.name = '',
    this.alias = '',
    this.connected = false,
    this.deviceId,
    this.fromProfile = false,
  });

  final int instance;
  final int? vendorId;
  final int? productId;
  final String name;
  final String alias;
  final bool connected;
  final String? deviceId;

  /// True when the profile's `<options>` recorded this stick; false when we guessed it.
  final bool fromProfile;

  String get vidPid => vendorId == null
      ? ''
      : '${vendorId!.toRadixString(16).toUpperCase().padLeft(4, '0')}:${productId!.toRadixString(16).toUpperCase().padLeft(4, '0')}';

  String get displayName => alias.isNotEmpty ? alias : (name.isNotEmpty ? name : 'JS$instance');

  KbJoystick copyWith({int? instance, String? alias}) => KbJoystick(
    instance: instance ?? this.instance,
    vendorId: vendorId,
    productId: productId,
    name: name,
    alias: alias ?? this.alias,
    connected: connected,
    deviceId: deviceId,
    fromProfile: fromProfile,
  );
}

enum KbSaveTarget { layout, actionMaps }

/// One slot an import would change.
class KbChange {
  const KbChange(this.action, this.device, this.before, this.after);

  final ScActionDef action;
  final ScDeviceType device;
  final ScSlot before;
  final ScSlot after;
}

@freezed
abstract class KeybindingState with _$KeybindingState {
  const factory KeybindingState({
    @Default(true) bool isLoading,
    @Default('') String loadingMessage,
    String? errorMessage,
    @Default('') String gamePath,
    ScKeybindingGameData? data,
    @Default([]) List<KbCategory> categories,
    ScBindingIndex? index,

    /// Working copy of the player's overrides.
    @Default({}) ScRebindMap rebinds,

    /// What is on disk, to tell unsaved edits apart.
    @Default({}) ScRebindMap savedRebinds,
    @Default({}) Map<int, KbJoystick> joysticks,

    /// Name of the connected XInput pad (gp1), if any.
    String? gamepadName,

    /// Pending jsN renumbering (old → new) to apply to `<options>` on save.
    @Default({}) Map<int, int> joystickRenumber,
    String? selectedGroupId,
    String? selectedActionId,
    @Default('') String query,
    @Default(KeybindingDeviceFilter.all) KeybindingDeviceFilter deviceFilter,
    int? joystickInstanceFilter,
    @Default(false) bool onlyModified,
    @Default(false) bool onlyConflicts,
    @Default({}) Set<String> collapsedCategories,
  }) = _KeybindingState;
}

/// Device input and system hooks; overridden with fakes in tests.
@riverpod
KeybindingEnvironment keybindingEnvironment(Ref ref) =>
    KeybindingEnvironment.system(ref.watch(appGlobalModelProvider).applicationSupportDir ?? Directory.systemTemp.path);

@riverpod
class KeybindingModel extends _$KeybindingModel {
  ScKeybindingRepository? _repo;

  /// Base document saves are written on top of: the file as loaded, or a restored backup.
  ScProfileDocument? _doc;

  /// actionmaps.xml as it was on disk when loaded / last written, to spot edits made meanwhile.
  ScProfileDocument? _diskDoc;
  String? _diskText;

  static const _aliasConfKey = 'keybinding_joystick_alias';

  @override
  KeybindingState build() => const KeybindingState();

  ScKeybindingRepository get repo => _repo!;

  KeybindingEnvironment get env => ref.read(keybindingEnvironmentProvider);

  Future<void> load(String gamePath) async {
    state = KeybindingState(gamePath: gamePath, loadingMessage: S.current.keybinding_loading_game_data);
    try {
      _repo = ScKeybindingRepository(gamePath, cacheRoot: env.cacheRoot);
      final data = await repo.loadGameData(
        onStep: (step) {
          if (step == 'p4k' && ref.mounted) state = state.copyWith(loadingMessage: S.current.keybinding_loading_p4k);
        },
      );
      _diskText = await repo.readActionMapsText();
      _doc = _diskDoc = await repo.readActionMaps();
      // The page may have been closed while Data.p4k was being read.
      if (!ref.mounted) return;
      final rebinds = _doc!.readRebinds();
      final categories = _buildCatalog(data);
      state = state.copyWith(
        isLoading: false,
        data: data,
        categories: categories,
        rebinds: rebinds,
        savedRebinds: rebinds,
        joystickRenumber: const {},
        selectedGroupId: allScopeId,
        selectedActionId: categories.firstOrNull?.groups.firstOrNull?.actions.firstOrNull?.id,
      );
      _reindex();
      await refreshJoysticks();
    } catch (e, s) {
      dPrint('[keybinding] load error: $e\n$s');
      if (ref.mounted) state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // ---------------------------------------------------------------- catalog

  List<KbCategory> _buildCatalog(ScKeybindingGameData data) {
    final categories = <String, KbCategory>{};
    final groups = <String, KbGroup>{};
    for (final map in data.profile.maps) {
      final groupLabel = data.text(map.uiLabel);
      if (groupLabel == null) continue;
      final actions = map.actions
          .where((a) => a.uiLabel.isNotEmpty && a.uiLabel != '@' && a.devices.isNotEmpty)
          .toList();
      if (actions.isEmpty) continue;
      final dash = groupLabel.indexOf(' - ');
      final catLabel = data.text(map.uiCategory) ?? (dash > 0 ? groupLabel.substring(0, dash) : groupLabel);
      final category = categories.putIfAbsent(catLabel, () => KbCategory(catLabel, catLabel, []));
      final groupId = '$catLabel/$groupLabel';
      final group = groups[groupId];
      if (group == null) {
        final g = KbGroup(groupId, groupLabel, actions);
        groups[groupId] = g;
        category.groups.add(g);
      } else {
        group.actions.addAll(actions);
      }
    }
    return categories.values.toList();
  }

  String actionLabel(ScActionDef a) => state.data?.text(a.uiLabel) ?? a.name;

  String? actionDescription(ScActionDef a) => state.data?.text(a.uiDescription);

  String groupLabelOf(ScActionDef a) {
    final map = state.data?.profile.mapsByName[a.mapName];
    return state.data?.text(map?.uiLabel ?? '') ?? a.mapName;
  }

  String? joystickName(int instance) {
    final js = state.joysticks[instance];
    if (js == null || js.alias.isEmpty) return null;
    return 'JS$instance ${js.alias}';
  }

  String formatInput(ScInput input) => scFormatInput(input, joystickName: joystickName);

  ScSlot slotOf(ScActionDef a, ScDeviceType device) => scResolveSlot(a, device, state.rebinds[a.id]);

  bool isModified(ScActionDef a) => ScDeviceType.values.any((d) => slotOf(a, d).isModified);

  bool hasConflict(ScActionDef a) => state.index?.hasConflict(a) ?? false;

  bool get isDirty =>
      _rebindsSignature(state.rebinds) != _rebindsSignature(state.savedRebinds) ||
      state.joystickRenumber.isNotEmpty ||
      !identical(_doc, _diskDoc);

  int get modifiedCount {
    var n = 0;
    for (final c in state.categories) {
      for (final g in c.groups) {
        for (final a in g.actions) {
          for (final d in ScDeviceType.values) {
            if (slotOf(a, d).isModified) n++;
          }
        }
      }
    }
    return n;
  }

  int get conflictCount {
    var n = 0;
    for (final c in state.categories) {
      for (final g in c.groups) {
        n += g.actions.where(hasConflict).length;
      }
    }
    return n;
  }

  List<ScActionDef> allActions() => [
    for (final c in state.categories)
      for (final g in c.groups) ...g.actions,
  ];

  /// Tree selection ids besides plain group ids: every action, or one whole category.
  static const allScopeId = '__all__';
  static const categoryScopePrefix = 'cat:';

  /// Actions in the tree selection ("all", a category, or one group).
  List<ScActionDef> scopeActions() {
    final id = state.selectedGroupId;
    if (id == allScopeId) return allActions();
    if (id != null && id.startsWith(categoryScopePrefix)) {
      final c = state.categories.where((c) => c.id == id.substring(categoryScopePrefix.length)).firstOrNull;
      return [for (final g in c?.groups ?? const <KbGroup>[]) ...g.actions];
    }
    return _selectedGroup()?.actions ?? const <ScActionDef>[];
  }

  /// Heading for the tree selection.
  String scopeLabel() {
    final id = state.selectedGroupId;
    if (id == allScopeId) return S.current.keybinding_scope_all;
    if (id != null && id.startsWith(categoryScopePrefix)) {
      return state.categories.where((c) => c.id == id.substring(categoryScopePrefix.length)).firstOrNull?.label ?? '';
    }
    return _selectedGroup()?.label ?? '';
  }

  /// Whether the tree selection lists actions from more than one group.
  bool get scopeSpansGroups {
    final id = state.selectedGroupId;
    return id == allScopeId || (id?.startsWith(categoryScopePrefix) ?? false);
  }

  /// Actions to list for the current group / search / filters.
  List<ScActionDef> visibleActions() {
    final q = state.query.trim().toLowerCase();
    final source = q.isNotEmpty ? allActions() : scopeActions();
    return source.where((a) {
      if (state.onlyModified && !isModified(a)) return false;
      if (state.onlyConflicts && !hasConflict(a)) return false;
      if (state.joystickInstanceFilter != null) {
        final js = slotOf(a, ScDeviceType.joystick).input;
        if (js == null || js.instance != state.joystickInstanceFilter) return false;
      }
      if (q.isEmpty) return true;
      if (actionLabel(a).toLowerCase().contains(q) || a.name.toLowerCase().contains(q)) return true;
      for (final d in ScDeviceType.values) {
        final input = slotOf(a, d).input;
        if (input == null) continue;
        if (input.toXml().toLowerCase().contains(q) || formatInput(input).toLowerCase().contains(q)) return true;
      }
      return false;
    }).toList();
  }

  KbGroup? _selectedGroup() {
    for (final c in state.categories) {
      for (final g in c.groups) {
        if (g.id == state.selectedGroupId) return g;
      }
    }
    return null;
  }

  ScActionDef? get selectedAction => state.data?.profile.actionsById[state.selectedActionId];

  List<ScRelation> relationsOf(ScActionDef a, ScDeviceType d) {
    final slot = slotOf(a, d);
    if (slot.input == null) return const [];
    return state.index?.relationsFor(a, slot.input!, slot.activationMode) ?? const [];
  }

  List<ScRelation> conflictsOf(ScActionDef a, ScDeviceType d) => state.index?.conflictsFor(a, slotOf(a, d)) ?? const [];

  /// Conflicts [input] would create if bound to [a].
  List<ScRelation> conflictsIfBound(ScActionDef a, ScInput input) {
    final mode = slotOf(a, input.device).activationMode;
    return state.index?.relationsFor(a, input, mode).where((r) => !r.isPair).toList() ?? const [];
  }

  // ---------------------------------------------------------------- UI state

  /// Selects a group, a whole category (`cat:<id>`) or everything ([allScopeId]).
  void selectGroup(String id) {
    state = state.copyWith(selectedGroupId: id, query: '');
    state = state.copyWith(selectedActionId: scopeActions().firstOrNull?.id);
  }

  void selectAction(String id) => state = state.copyWith(selectedActionId: id);

  /// Whether [a] is in the catalog (the game hides some actions; those can still clash with others).
  bool isListed(ScActionDef a) => state.categories.any((c) => c.groups.any((g) => g.actions.any((x) => x.id == a.id)));

  void revealAction(ScActionDef a) {
    // Stay in "all" / category views that already contain the action.
    if (scopeSpansGroups && scopeActions().any((x) => x.id == a.id)) {
      state = state.copyWith(selectedActionId: a.id, query: '');
      return;
    }
    final group = state.categories.expand((c) => c.groups).where((g) => g.actions.any((x) => x.id == a.id)).firstOrNull;
    if (group == null) return;
    state = state.copyWith(selectedGroupId: group.id, selectedActionId: a.id, query: '');
  }

  void setQuery(String q) => state = state.copyWith(query: q);

  void setDeviceFilter(KeybindingDeviceFilter f) => state = state.copyWith(
    deviceFilter: f,
    joystickInstanceFilter: f == KeybindingDeviceFilter.joystick ? state.joystickInstanceFilter : null,
  );

  void setJoystickInstanceFilter(int? instance) => state = state.copyWith(
    joystickInstanceFilter: instance,
    deviceFilter: instance == null ? state.deviceFilter : KeybindingDeviceFilter.joystick,
  );

  void toggleOnlyModified() => state = state.copyWith(onlyModified: !state.onlyModified);

  void toggleOnlyConflicts() => state = state.copyWith(onlyConflicts: !state.onlyConflicts);

  void toggleCategory(String id) {
    final set = {...state.collapsedCategories};
    if (!set.remove(id)) set.add(id);
    state = state.copyWith(collapsedCategories: set);
  }

  // ---------------------------------------------------------------- editing

  void _setRebinds(ScRebindMap rebinds) {
    state = state.copyWith(rebinds: rebinds);
    _reindex();
  }

  void _reindex() {
    final data = state.data;
    if (data == null) return;
    state = state.copyWith(index: ScBindingIndex(data.profile, state.rebinds));
  }

  Map<int, KbJoystick> get joysticks => state.joysticks;

  ScRebindMap _copy() => {
    for (final e in state.rebinds.entries) e.key: {...e.value},
  };

  /// Drops overrides that restate the default, so they don't count as changes.
  void _normalize(ScRebindMap map, ScActionDef a) {
    final slots = map[a.id];
    if (slots == null) return;
    slots.removeWhere((d, rb) {
      final def = a.defaults[d];
      final sameInput = rb.input.isUnbound ? def == null : rb.input == def;
      final sameMode = rb.activationMode == null || rb.activationMode == a.modeFor(d);
      return sameInput && sameMode;
    });
    if (slots.isEmpty) map.remove(a.id);
  }

  void _clearSlot(ScRebindMap map, ScActionDef a, ScDeviceType d) {
    final slots = map.putIfAbsent(a.id, () => {});
    final mode = slots[d]?.activationMode;
    if (a.defaults[d] != null) {
      slots[d] = ScRebind(ScInput.unbound(d, a.defaults[d]!.instance), activationMode: mode);
    } else {
      slots.remove(d);
    }
    _normalize(map, a);
  }

  /// Binds [input] to [a]; with [replaceConflicts] the clashing actions lose that input.
  void bind(ScActionDef a, ScInput input, {bool replaceConflicts = false}) {
    final conflicts = replaceConflicts ? conflictsIfBound(a, input) : const <ScRelation>[];
    final map = _copy();
    final slots = map.putIfAbsent(a.id, () => {});
    slots[input.device] = ScRebind(input, activationMode: slots[input.device]?.activationMode);
    _normalize(map, a);
    for (final c in conflicts) {
      _clearSlot(map, c.other.action, c.other.slot.device);
    }
    _setRebinds(map);
  }

  void clearBinding(ScActionDef a, ScDeviceType d) {
    final map = _copy();
    _clearSlot(map, a, d);
    _setRebinds(map);
  }

  void resetBinding(ScActionDef a, ScDeviceType d) {
    final map = _copy();
    map[a.id]?.remove(d);
    if (map[a.id]?.isEmpty ?? false) map.remove(a.id);
    _setRebinds(map);
  }

  void resetAction(ScActionDef a) {
    final map = _copy()..remove(a.id);
    _setRebinds(map);
  }

  void setActivationMode(ScActionDef a, ScDeviceType d, String? mode) {
    final map = _copy();
    final slots = map.putIfAbsent(a.id, () => {});
    final current = slots[d];
    if (current != null) {
      slots[d] = ScRebind(current.input, activationMode: mode, multiTap: null);
    } else if (a.defaults[d] != null && mode != null) {
      slots[d] = ScRebind(a.defaults[d]!, activationMode: mode);
    }
    _normalize(map, a);
    _setRebinds(map);
  }

  void resetAllToDefaults() => _setRebinds({});

  /// A copy of the working rebinds, for [restoreRebinds].
  ScRebindMap snapshotRebinds() => {
    for (final e in state.rebinds.entries) e.key: {...e.value},
  };

  /// Puts back a working copy taken earlier (e.g. when an edit dialog is cancelled).
  void restoreRebinds(ScRebindMap snapshot) => _setRebinds(snapshot);

  void discardChanges() {
    _doc = _diskDoc;
    // Unrecorded sticks keep their number across refreshes; drop it so a discarded swap is undone too.
    state = state.copyWith(joystickRenumber: const {}, joysticks: const {});
    _setRebinds(state.savedRebinds);
    refreshJoysticks();
  }

  /// Rebinds stored in a layout / profile file (not applied).
  Future<ScRebindMap> readLayoutRebinds(File file) async => (await repo.readLayout(file)).readRebinds();

  Future<List<ScPreset>> listPresets({void Function(String step)? onStep}) => repo.listPresets(onStep: onStep);

  String presetLabel(ScPreset p) =>
      state.data?.text(p.labelKey) ?? (p.profileName.isNotEmpty ? p.profileName : p.fileName);

  String? presetDescription(ScPreset p) => state.data?.text(p.descriptionKey);

  /// The working copy after importing [incoming]: replace everything, or [merge] it over the
  /// current overrides (incoming wins per device slot).
  ScRebindMap importResult(ScRebindMap incoming, {required bool merge}) {
    final result = merge ? _copy() : <String, Map<ScDeviceType, ScRebind>>{};
    for (final e in incoming.entries) {
      result.putIfAbsent(e.key, () => {}).addAll(e.value);
    }
    // Drop overrides for actions this game version doesn't have, and ones that restate defaults.
    final known = state.data!.profile.actionsById;
    result.removeWhere((id, _) => !known.containsKey(id));
    for (final id in result.keys.toList()) {
      _normalize(result, known[id]!);
    }
    return result;
  }

  /// What importing [incoming] would change, per action and device, against the working copy.
  List<KbChange> previewImport(ScRebindMap incoming, {required bool merge}) {
    final after = importResult(incoming, merge: merge);
    final changes = <KbChange>[];
    for (final a in allActions()) {
      for (final d in ScDeviceType.values) {
        if (!a.devices.contains(d)) continue;
        final before = scResolveSlot(a, d, state.rebinds[a.id]);
        final next = scResolveSlot(a, d, after[a.id]);
        if (before.input != next.input || before.activationMode != next.activationMode) {
          changes.add(KbChange(a, d, before, next));
        }
      }
    }
    return changes;
  }

  void applyImport(ScRebindMap incoming, {required bool merge}) => _setRebinds(importResult(incoming, merge: merge));

  /// Restores a whole backed-up profile: its bindings plus its `<options>` (stick numbering, axis
  /// settings) and `<modifiers>`. Written to disk on the next save.
  Future<void> restoreProfile(ScProfileDocument backup) async {
    _doc = backup;
    state = state.copyWith(joystickRenumber: const {}, joysticks: const {});
    _setRebinds(importResult(backup.readRebinds(), merge: false));
    await refreshJoysticks();
  }

  // ---------------------------------------------------------------- joysticks

  Future<List<KbInputDevice>> listInputDevices() async {
    try {
      return await env.listDevices();
    } catch (e) {
      dPrint('[keybinding] list input devices error: $e');
      return [];
    }
  }

  /// Rebuilds the jsN ↔ stick table from the profile's `<options>` and the connected sticks.
  Future<void> refreshJoysticks() async {
    final aliases = Map<String, dynamic>.from(appConfBox?.get(_aliasConfKey, defaultValue: <String, dynamic>{}) ?? {});
    final identities = scJoystickIdentities(_doc?.readOptions() ?? const []);
    // Apply pending renumbering to the recorded identities.
    final recorded = <int, ({int vendorId, int productId, String name})>{};
    identities.forEach((instance, id) => recorded[state.joystickRenumber[instance] ?? instance] = id);

    final all = await listInputDevices();
    if (!ref.mounted) return;
    final devices = all.where((d) => !d.isXInput).toList();
    final pad = all.where((d) => d.isXInput).firstOrNull;
    final used = <String>{};
    final result = <int, KbJoystick>{};
    String aliasFor(String? deviceId, int? vid, int? pid, int instance) =>
        (aliases[_aliasKey(deviceId, vid, pid, instance)] ?? aliases[_aliasKey(null, vid, pid, instance)] ?? '')
            .toString();

    for (final entry in recorded.entries) {
      final dev = devices
          .where(
            (d) => !used.contains(d.id) && d.vendorId == entry.value.vendorId && d.productId == entry.value.productId,
          )
          .firstOrNull;
      if (dev != null) used.add(dev.id);
      result[entry.key] = KbJoystick(
        instance: entry.key,
        vendorId: entry.value.vendorId,
        productId: entry.value.productId,
        name: dev?.name ?? entry.value.name,
        alias: aliasFor(dev?.id, entry.value.vendorId, entry.value.productId, entry.key),
        connected: dev != null,
        deviceId: dev?.id,
        fromProfile: true,
      );
    }
    // Sticks not in <options> keep the number they already have here (it may have been swapped).
    final unrecorded = devices.where((d) => !used.contains(d.id)).toList();
    for (final dev in [...unrecorded]) {
      final known = state.joysticks.values.where((j) => !j.fromProfile && j.deviceId == dev.id).firstOrNull;
      if (known == null || result.containsKey(known.instance)) continue;
      unrecorded.remove(dev);
      result[known.instance] = KbJoystick(
        instance: known.instance,
        vendorId: dev.vendorId,
        productId: dev.productId,
        name: dev.name,
        alias: aliasFor(dev.id, dev.vendorId, dev.productId, known.instance),
        connected: true,
        deviceId: dev.id,
      );
    }
    var next = 1;
    for (final dev in unrecorded) {
      while (result.containsKey(next)) {
        next++;
      }
      result[next] = KbJoystick(
        instance: next,
        vendorId: dev.vendorId,
        productId: dev.productId,
        name: dev.name,
        alias: aliasFor(dev.id, dev.vendorId, dev.productId, next),
        connected: true,
        deviceId: dev.id,
      );
    }
    // Instances used by bindings but with no known stick still get a row.
    for (final slots in state.rebinds.values) {
      final js = slots[ScDeviceType.joystick]?.input;
      if (js != null && !js.isUnbound) result.putIfAbsent(js.instance, () => KbJoystick(instance: js.instance));
    }
    state = state.copyWith(
      joysticks: Map.fromEntries(result.entries.toList()..sort((a, b) => a.key.compareTo(b.key))),
      gamepadName: pad?.name,
    );
  }

  /// Instance for a stick that produced input during capture; unknown sticks get the next free number.
  int joystickInstanceFor(String deviceId, int vendorId, int productId, String name) {
    for (final js in state.joysticks.values) {
      if (js.deviceId == deviceId) return js.instance;
    }
    for (final js in state.joysticks.values) {
      if (js.deviceId == null && js.vendorId == vendorId && js.productId == productId) return js.instance;
    }
    var next = 1;
    while (state.joysticks[next]?.vendorId != null) {
      next++;
    }
    state = state.copyWith(
      joysticks: Map.fromEntries(
        ({
          ...state.joysticks,
          next: KbJoystick(
            instance: next,
            vendorId: vendorId,
            productId: productId,
            name: name,
            connected: true,
            deviceId: deviceId,
          ),
        }).entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
    );
    return next;
  }

  /// Swaps two joystick numbers everywhere: bindings, stick table and (on save) `<options>`.
  void swapJoysticks(int a, int b) {
    final map = scSwapJoystickInstances(state.rebinds, a, b);
    final renumber = scComposeRenumber(state.joystickRenumber, a, b);
    final joysticks = <int, KbJoystick>{};
    for (final js in state.joysticks.values) {
      final ni = js.instance == a ? b : (js.instance == b ? a : js.instance);
      joysticks[ni] = js.copyWith(instance: ni);
    }
    state = state.copyWith(
      joystickRenumber: renumber,
      joysticks: Map.fromEntries(joysticks.entries.toList()..sort((x, y) => x.key.compareTo(y.key))),
    );
    _setRebinds(map);
  }

  /// Alias storage key: the physical device when connected (two identical sticks share VID/PID),
  /// else the stick model, else the number.
  static String _aliasKey(String? deviceId, int? vid, int? pid, int instance) => deviceId != null
      ? 'dev:$deviceId'
      : vid == null
      ? 'js$instance'
      : '${vid}_$pid';

  Future<void> setJoystickAlias(int instance, String alias) async {
    final js = state.joysticks[instance];
    if (js == null) return;
    final aliases = Map<String, dynamic>.from(appConfBox?.get(_aliasConfKey, defaultValue: <String, dynamic>{}) ?? {});
    aliases[_aliasKey(js.deviceId, js.vendorId, js.productId, instance)] = alias.trim();
    // Also by model, so the name survives unplugging / another USB port (the device key wins when present).
    if (js.deviceId != null) aliases[_aliasKey(null, js.vendorId, js.productId, instance)] = alias.trim();
    await appConfBox?.put(_aliasConfKey, aliases);
    state = state.copyWith(
      joysticks: {
        ...state.joysticks,
        instance: js.copyWith(alias: alias.trim()),
      },
    );
  }

  // ---------------------------------------------------------------- saving

  Future<bool> isGameRunning() => env.isGameRunning();

  ScProfileDocument _applyToDocument(ScProfileDocument source) {
    final doc = ScProfileDocument.parse(source.toXmlString());
    doc.writeRebinds(state.rebinds, state.data!.profile.maps.map((m) => m.name).toList());
    final products = <int, String?>{
      for (final js in state.joysticks.values)
        if (js.vendorId != null) js.instance: scBuildProduct(js.name, js.vendorId!, js.productId!),
    };
    doc.writeJoystickOptions(products, renumber: state.joystickRenumber);
    return doc;
  }

  String layoutXml(String name) {
    final doc = _applyToDocument(_doc ?? ScProfileDocument.emptyProfile());
    return ScProfileDocument.buildLayout(
      profileName: name,
      rebinds: state.rebinds,
      mapOrder: state.data!.profile.maps.map((m) => m.name).toList(),
      options: doc.optionElements(),
    );
  }

  /// Exports the layout into every channel in [channels] (default: this one). Returns the written files.
  Future<List<File>> exportLayout(String name, {List<String>? channels}) async {
    final xml = layoutXml(name);
    return [
      for (final c in channels ?? [repo.channel]) await repo.sibling(c).writeLayout(name, xml),
    ];
  }

  /// Whether actionmaps.xml changed on disk since it was loaded or last written here (e.g. the
  /// player rebound keys in-game meanwhile); saving would overwrite those changes.
  Future<bool> actionMapsChangedOnDisk() async => await repo.readActionMapsText() != _diskText;

  /// Layout files that exporting [name] into [channels] would overwrite.
  Future<List<File>> existingLayouts(String name, {List<String>? channels}) async => [
    for (final c in channels ?? [repo.channel])
      if (await repo.sibling(c).layoutFile(name).exists()) repo.sibling(c).layoutFile(name),
  ];

  /// Writes the live profile into every channel in [channels] (game must be closed); each channel's
  /// current actionmaps.xml is backed up first. Returns channel → backup path.
  Future<Map<String, String?>> writeActionMaps({List<String>? channels}) async {
    final doc = _applyToDocument(_doc ?? ScProfileDocument.emptyProfile());
    final targets = channels ?? [repo.channel];
    final backups = <String, String?>{};
    // This channel first, and its baseline updated right away, so a failing sibling can't leave
    // the tool thinking its own write never happened.
    if (targets.contains(repo.channel)) {
      backups[repo.channel] = await repo.writeActionMaps(doc);
      _doc = _diskDoc = doc;
      _diskText = await repo.readActionMapsText();
      state = state.copyWith(savedRebinds: state.rebinds, joystickRenumber: const {});
    }
    for (final c in targets.where((c) => c != repo.channel)) {
      backups[c] = await repo.sibling(c).writeActionMaps(doc);
    }
    if (targets.contains(repo.channel)) await refreshJoysticks();
    return backups;
  }

  Future<List<File>> listBackups() => repo.listBackups();

  static String _rebindsSignature(ScRebindMap map) {
    final keys = map.keys.toList()..sort();
    final b = StringBuffer();
    for (final k in keys) {
      for (final d in ScDeviceType.values) {
        final rb = map[k]![d];
        if (rb == null) continue;
        b.write('$k:${rb.input.toXml()}:${rb.activationMode};');
      }
    }
    return b.toString();
  }
}
