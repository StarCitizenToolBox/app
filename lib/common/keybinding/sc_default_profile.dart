import 'package:xml/xml.dart';

import 'sc_input.dart';

/// One `<ActivationMode>` from defaultProfile.xml.
class ScActivationMode {
  const ScActivationMode({
    required this.name,
    this.onPress = false,
    this.onHold = false,
    this.onRelease = false,
    this.multiTap = 1,
    this.multiTapBlock = true,
    this.pressTriggerThreshold = -1,
    this.releaseTriggerThreshold = -1,
    this.releaseTriggerDelay = 0,
    this.retriggerable = false,
  });

  final String name;
  final bool onPress;
  final bool onHold;
  final bool onRelease;
  final int multiTap;
  final bool multiTapBlock;
  final double pressTriggerThreshold;
  final double releaseTriggerThreshold;
  final double releaseTriggerDelay;
  final bool retriggerable;
}

class ScActionDef {
  ScActionDef({
    required this.mapName,
    required this.name,
    required this.uiLabel,
    required this.uiDescription,
    required this.pitCategory,
    required this.activationMode,
    required this.optionGroup,
    required this.defaults,
    required this.defaultModes,
    required this.devices,
  });

  final String mapName;
  final String name;

  /// Raw localization key, e.g. `@ui_CIPitchUp`. Empty when the game hides the action.
  final String uiLabel;
  final String uiDescription;
  final String? pitCategory;

  /// Null for actions that only use onPress/onRelease flags or are axes.
  final String? activationMode;
  final String? optionGroup;

  /// Bound defaults only; a device missing here has no default.
  final Map<ScDeviceType, ScInput> defaults;

  /// Per-device activation modes from `<gamepad activationMode="..."/>` children.
  final Map<ScDeviceType, String> defaultModes;

  /// Devices the game lets the player bind for this action.
  final Set<ScDeviceType> devices;

  String get id => '$mapName/$name';

  String? modeFor(ScDeviceType device) => defaultModes[device] ?? activationMode;
}

class ScActionMapDef {
  ScActionMapDef({required this.name, required this.uiLabel, required this.uiCategory, required this.actions});

  final String name;
  final String uiLabel;
  final String uiCategory;
  final List<ScActionDef> actions;
}

class ScDefaultProfile {
  ScDefaultProfile({required this.maps, required this.activationModes});

  final List<ScActionMapDef> maps;
  final Map<String, ScActivationMode> activationModes;

  late final Map<String, ScActionDef> actionsById = {
    for (final m in maps)
      for (final a in m.actions) a.id: a,
  };

  late final Map<String, ScActionMapDef> mapsByName = {for (final m in maps) m.name: m};

  /// Parses defaultProfile.xml (already converted from CryXML to text).
  static ScDefaultProfile parse(String xml) {
    final root = XmlDocument.parse(xml).rootElement;
    final modes = <String, ScActivationMode>{};
    for (final e in root.findAllElements('ActivationMode')) {
      final name = e.getAttribute('name');
      if (name == null) continue;
      bool b(String a) => e.getAttribute(a) == '1';
      double d(String a) => double.tryParse(e.getAttribute(a) ?? '') ?? -1;
      modes[name] = ScActivationMode(
        name: name,
        onPress: b('onPress'),
        onHold: b('onHold'),
        onRelease: b('onRelease'),
        multiTap: int.tryParse(e.getAttribute('multiTap') ?? '') ?? 1,
        multiTapBlock: e.getAttribute('multiTapBlock') != '0',
        pressTriggerThreshold: d('pressTriggerThreshold'),
        releaseTriggerThreshold: d('releaseTriggerThreshold'),
        releaseTriggerDelay: d('releaseTriggerDelay') < 0 ? 0 : d('releaseTriggerDelay'),
        retriggerable: b('retriggerable'),
      );
    }

    final maps = <ScActionMapDef>[];
    for (final m in root.findElements('actionmap')) {
      final mapName = m.getAttribute('name');
      if (mapName == null) continue;
      final actions = <ScActionDef>[];
      for (final a in m.findElements('action')) {
        final def = _parseAction(mapName, a);
        if (def != null) actions.add(def);
      }
      maps.add(
        ScActionMapDef(
          name: mapName,
          uiLabel: m.getAttribute('UILabel') ?? '',
          uiCategory: m.getAttribute('UICategory') ?? '',
          actions: actions,
        ),
      );
    }
    return ScDefaultProfile(maps: maps, activationModes: modes);
  }

  static ScActionDef? _parseAction(String mapName, XmlElement a) {
    final name = a.getAttribute('name');
    if (name == null) return null;
    final defaults = <ScDeviceType, ScInput>{};
    final modes = <ScDeviceType, String>{};
    final devices = <ScDeviceType>{};

    void addDefault(ScDeviceType device, String? body) {
      if (body == null) return;
      devices.add(device);
      final input = ScInput.parseBody(device, body);
      if (input.isUnbound || defaults.containsKey(device)) return;
      defaults[device] = input;
    }

    for (final device in ScDeviceType.values) {
      addDefault(device, a.getAttribute(device.xmlName));
    }
    for (final child in a.childElements) {
      final device = ScDeviceType.fromXmlName(child.name.local);
      if (device == null) continue;
      final mode = child.getAttribute('activationMode');
      if (mode != null) modes[device] = mode;
      final input = child.getAttribute('input');
      if (input != null) {
        defaults.remove(device);
        addDefault(device, input);
      } else {
        final data = child.findElements('inputdata').map((e) => e.getAttribute('input')).nonNulls.toList();
        if (data.isNotEmpty) {
          defaults.remove(device);
          addDefault(device, data.first);
        }
      }
    }

    // defaultProfile.xml keeps mouse buttons under the keyboard attribute (keyboard="mouse3");
    // the game binds those through the mouse slot.
    final kb = defaults[ScDeviceType.keyboard];
    if (kb != null && scIsMouseKey(kb.key)) {
      defaults.remove(ScDeviceType.keyboard);
      defaults.putIfAbsent(ScDeviceType.mouse, () => ScInput(ScDeviceType.mouse, 1, kb.modifiers, kb.key));
    }
    // Keyboard and mouse share one column in the game's options screen.
    if (devices.contains(ScDeviceType.keyboard)) devices.add(ScDeviceType.mouse);
    if (devices.contains(ScDeviceType.mouse) &&
        !devices.contains(ScDeviceType.keyboard) &&
        defaults[ScDeviceType.mouse]?.isAxis != true) {
      devices.add(ScDeviceType.keyboard);
    }

    return ScActionDef(
      mapName: mapName,
      name: name,
      uiLabel: (a.getAttribute('UILabel') ?? '').trim(),
      uiDescription: (a.getAttribute('UIDescription') ?? '').trim(),
      pitCategory: a.getAttribute('Category'),
      activationMode: a.getAttribute('activationMode') ?? a.getAttribute('ActivationMode'),
      optionGroup: a.getAttribute('optionGroup'),
      defaults: defaults,
      defaultModes: modes,
      devices: devices,
    );
  }
}
