import 'package:xml/xml.dart';

import 'sc_input.dart';

class ScRebind {
  const ScRebind(this.input, {this.activationMode, this.multiTap});

  final ScInput input;
  final String? activationMode;
  final int? multiTap;

  ScRebind copyWith({ScInput? input, String? activationMode, bool clearMode = false}) => ScRebind(
    input ?? this.input,
    activationMode: clearMode ? null : (activationMode ?? this.activationMode),
    multiTap: clearMode ? null : multiTap,
  );
}

/// A device line from `<options type="joystick" instance="1" Product="...">`.
class ScDeviceOption {
  const ScDeviceOption(this.device, this.instance, this.product);

  final ScDeviceType device;
  final int instance;
  final String? product;
}

/// Player overrides keyed by action id (`actionmap/action`), one slot per device class,
/// mirroring how the game stores them.
typedef ScRebindMap = Map<String, Map<ScDeviceType, ScRebind>>;

/// Round-trips a player profile: `Profiles/default/actionmaps.xml` (wrapped in `<ActionProfiles>`)
/// or an exported layout from `Controls/Mappings/*.xml` (rebinds directly under `<ActionMaps>`).
/// Only `<actionmap>` elements and joystick `Product` attributes are rewritten; everything else
/// (axis inversion, curves, `<modifiers>`, unknown attributes) is kept as-is.
class ScProfileDocument {
  ScProfileDocument._(this.document, this.container);

  final XmlDocument document;
  final XmlElement container;

  factory ScProfileDocument.parse(String xml) {
    final doc = XmlDocument.parse(xml);
    final root = doc.rootElement;
    final profile = root.findElements('ActionProfiles').firstOrNull;
    return ScProfileDocument._(doc, profile ?? root);
  }

  /// A new, empty `actionmaps.xml` in the shape the game writes.
  factory ScProfileDocument.emptyProfile() => ScProfileDocument.parse(
    '<ActionMaps>\n <ActionProfiles version="1" optionsVersion="2" rebindVersion="2" profileName="default">\n'
    '  <options type="keyboard" instance="1" Product="Keyboard  {6F1D2B61-D5A0-11CF-BFC7-444553540000}"/>\n'
    '  <modifiers />\n </ActionProfiles>\n</ActionMaps>',
  );

  bool get isLayout => container == document.rootElement;

  String get profileName => container.getAttribute('profileName') ?? '';

  List<ScDeviceOption> readOptions() {
    final result = <ScDeviceOption>[];
    for (final e in container.findElements('options')) {
      final device = ScDeviceType.fromXmlName(e.getAttribute('type') ?? '');
      final instance = int.tryParse(e.getAttribute('instance') ?? '');
      if (device == null || instance == null) continue;
      final product = e.getAttribute('Product');
      result.add(ScDeviceOption(device, instance, (product?.trim().isEmpty ?? true) ? null : product));
    }
    return result;
  }

  ScRebindMap readRebinds() {
    final result = <String, Map<ScDeviceType, ScRebind>>{};
    for (final map in container.findElements('actionmap')) {
      final mapName = map.getAttribute('name');
      if (mapName == null) continue;
      for (final action in map.findElements('action')) {
        final name = action.getAttribute('name');
        if (name == null) continue;
        final slots = <ScDeviceType, ScRebind>{};
        for (final rb in action.findElements('rebind')) {
          final raw = rb.getAttribute('input') ?? '';
          var input = ScInput.parse(raw);
          if (input == null && raw.trim().isEmpty) {
            // Blank-layout form: <rebind device="joystick" input=" "/>
            final device = ScDeviceType.fromXmlName(rb.getAttribute('device') ?? '');
            if (device != null) input = ScInput.unbound(device);
          }
          if (input == null) continue;
          final existing = slots[input.device];
          // A layout may clear js1_, js2_ and js3_ separately; a real binding wins over a clear.
          if (existing != null && !existing.input.isUnbound && input.isUnbound) continue;
          slots[input.device] = ScRebind(
            input,
            activationMode: rb.getAttribute('activationMode'),
            multiTap: int.tryParse(rb.getAttribute('multiTap') ?? ''),
          );
        }
        if (slots.isNotEmpty) result['$mapName/$name'] = slots;
      }
    }
    return result;
  }

  /// Replaces every `<actionmap>` with [rebinds]. [mapOrder] keeps the game's actionmap order.
  void writeRebinds(ScRebindMap rebinds, List<String> mapOrder) {
    for (final e in container.findElements('actionmap').toList()) {
      e.remove();
    }
    final byMap = <String, Map<String, Map<ScDeviceType, ScRebind>>>{};
    for (final entry in rebinds.entries) {
      if (entry.value.isEmpty) continue;
      final slash = entry.key.indexOf('/');
      byMap.putIfAbsent(entry.key.substring(0, slash), () => {})[entry.key.substring(slash + 1)] = entry.value;
    }
    int rank(String m) {
      final i = mapOrder.indexOf(m);
      return i == -1 ? mapOrder.length : i;
    }

    final mapNames = byMap.keys.toList()..sort((a, b) => rank(a).compareTo(rank(b)));
    for (final mapName in mapNames) {
      final mapEl = XmlElement(XmlName.parts('actionmap'), [XmlAttribute(XmlName.parts('name'), mapName)]);
      final actions = byMap[mapName]!;
      for (final actionName in actions.keys.toList()..sort()) {
        final actionEl = XmlElement(XmlName.parts('action'), [XmlAttribute(XmlName.parts('name'), actionName)]);
        for (final device in ScDeviceType.values) {
          final rb = actions[actionName]![device];
          if (rb == null) continue;
          actionEl.children.add(
            XmlElement(XmlName.parts('rebind'), [
              XmlAttribute(XmlName.parts('input'), rb.input.toXml()),
              if (rb.activationMode != null) XmlAttribute(XmlName.parts('activationMode'), rb.activationMode!),
              if (rb.multiTap != null) XmlAttribute(XmlName.parts('multiTap'), rb.multiTap.toString()),
            ]),
          );
        }
        mapEl.children.add(actionEl);
      }
      container.children.add(mapEl);
    }
  }

  /// Sets the joystick `<options>` lines. Existing option children (e.g. invert) move with their
  /// instance number, so a js1/js2 swap keeps each stick's axis settings.
  void writeJoystickOptions(Map<int, String?> products, {Map<int, int> renumber = const {}}) {
    final existing = container.findElements('options').where((e) => e.getAttribute('type') == 'joystick').toList();
    for (final e in existing) {
      final instance = int.tryParse(e.getAttribute('instance') ?? '');
      if (instance != null && renumber.containsKey(instance)) {
        e.setAttribute('instance', renumber[instance].toString());
      }
    }
    for (final entry in products.entries) {
      var el = container
          .findElements('options')
          .where((e) => e.getAttribute('type') == 'joystick' && e.getAttribute('instance') == entry.key.toString())
          .firstOrNull;
      if (el == null) {
        el = XmlElement(XmlName.parts('options'), [
          XmlAttribute(XmlName.parts('type'), 'joystick'),
          XmlAttribute(XmlName.parts('instance'), entry.key.toString()),
        ]);
        final anchor =
            container.findElements('modifiers').firstOrNull ?? container.findElements('actionmap').firstOrNull;
        if (anchor != null) {
          container.children.insert(container.children.indexOf(anchor), el);
        } else {
          container.children.add(el);
        }
      }
      if (entry.value != null) el.setAttribute('Product', entry.value);
    }
  }

  String toXmlString() => document.toXmlString(pretty: true, indent: ' ');

  /// Builds a layout file for `Controls/Mappings/<name>.xml` that the game's "load profile"
  /// screen and `pp_RebindKeys` accept.
  static String buildLayout({
    required String profileName,
    required ScRebindMap rebinds,
    required List<String> mapOrder,
    required List<XmlElement> options,
  }) {
    final instances = <ScDeviceType, Set<int>>{
      ScDeviceType.keyboard: {1},
      ScDeviceType.mouse: {1},
    };
    for (final slots in rebinds.values) {
      for (final rb in slots.values) {
        instances.putIfAbsent(rb.input.device, () => {}).add(rb.input.instance);
      }
    }
    final builder = XmlBuilder();
    builder.element(
      'ActionMaps',
      attributes: {'version': '1', 'optionsVersion': '2', 'rebindVersion': '2', 'profileName': profileName},
      nest: () {
        builder.element(
          'CustomisationUIHeader',
          attributes: {'label': profileName, 'description': '', 'image': ''},
          nest: () {
            builder.element(
              'devices',
              nest: () {
                for (final device in ScDeviceType.values) {
                  for (final i in (instances[device] ?? <int>{}).toList()..sort()) {
                    builder.element(device.xmlName, attributes: {'instance': '$i'});
                  }
                }
              },
            );
          },
        );
        for (final o in options) {
          builder.xml(o.toXmlString());
        }
        builder.element('modifiers', isSelfClosing: true);
      },
    );
    final doc = ScProfileDocument.parse(builder.buildDocument().toXmlString());
    doc.writeRebinds(rebinds, mapOrder);
    return '<?xml version="1.0" encoding="utf-8"?>\n${doc.toXmlString()}';
  }

  List<XmlElement> optionElements() => container.findElements('options').toList();
}
