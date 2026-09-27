/// Star Citizen input tokens, e.g. `kb1_lalt+f`, `mo1_mouse1`, `js2_button3`, `gp1_shoulderl+a`.
///
/// Grammar: `<prefix><instance>_<body>`, where body is `(modifier "+")* key`,
/// and a body of a single space means "explicitly unbound".
/// defaultProfile.xml stores bodies without the prefix; mapping files always carry it.
library;

enum ScDeviceType {
  keyboard('kb', 'keyboard'),
  mouse('mo', 'mouse'),
  joystick('js', 'joystick'),
  gamepad('gp', 'gamepad');

  const ScDeviceType(this.prefix, this.xmlName);

  final String prefix;
  final String xmlName;

  static ScDeviceType? fromXmlName(String name) {
    for (final d in values) {
      if (d.xmlName == name) return d;
    }
    return null;
  }
}

/// Keyboard modifiers, in the order they are written back.
const scKeyboardModifiers = ['lalt', 'ralt', 'lctrl', 'rctrl', 'lshift', 'rshift'];

/// Gamepad buttons the game treats as chord modifiers (`gp_shoulderl` in defaultProfile.xml).
const scGamepadModifiers = ['shoulderl'];

const _mouseKeys = {
  'mouse1', 'mouse2', 'mouse3', 'mouse4', 'mouse5', //
  'mwheel_up', 'mwheel_down', 'mwheel_left', 'mwheel_right', //
  'maxis_x', 'maxis_y', 'maxis_z',
};

bool scIsMouseKey(String key) => _mouseKeys.contains(key);

bool scIsAxisKey(ScDeviceType device, String key) {
  switch (device) {
    case ScDeviceType.joystick:
      return const {'x', 'y', 'z', 'rotx', 'roty', 'rotz', 'slider1', 'slider2'}.contains(key);
    case ScDeviceType.gamepad:
      return const {'thumblx', 'thumbly', 'thumbrx', 'thumbry', 'triggerl', 'triggerr'}.contains(key);
    case ScDeviceType.mouse:
      return key.startsWith('maxis_');
    case ScDeviceType.keyboard:
      return false;
  }
}

class ScInput {
  const ScInput(this.device, this.instance, this.modifiers, this.key);

  const ScInput.unbound(this.device, [this.instance = 1]) : modifiers = const [], key = '';

  final ScDeviceType device;
  final int instance;
  final List<String> modifiers;

  /// Empty means explicitly unbound.
  final String key;

  bool get isUnbound => key.isEmpty;

  bool get isAxis => scIsAxisKey(device, key);

  String get body => isUnbound ? ' ' : [...modifiers, key].join('+');

  String get deviceId => '${device.prefix}$instance';

  /// Full token as written to mapping files.
  String toXml() => '${deviceId}_$body';

  /// Identity used for conflict detection (modifier order does not matter).
  String get conflictKey => '$deviceId|${([...modifiers]..sort()).join('+')}|$key';

  ScInput withInstance(int newInstance) => ScInput(device, newInstance, modifiers, key);

  @override
  bool operator ==(Object other) => other is ScInput && other.conflictKey == conflictKey;

  @override
  int get hashCode => conflictKey.hashCode;

  @override
  String toString() => toXml();

  /// Parses a prefixed token (`js2_button3`, `kb1_ `). Returns null when it is not a recognised token.
  static ScInput? parse(String raw) {
    final m = RegExp(r'^(kb|mo|mouse|js|gp)(\d*)_(.*)$', caseSensitive: false).firstMatch(raw);
    if (m == null) return null;
    final prefix = m.group(1)!.toLowerCase();
    final device = switch (prefix) {
      'kb' => ScDeviceType.keyboard,
      'mo' || 'mouse' => ScDeviceType.mouse,
      'js' => ScDeviceType.joystick,
      _ => ScDeviceType.gamepad,
    };
    final instance = int.tryParse(m.group(2) ?? '') ?? 1;
    return parseBody(device, m.group(3)!, instance: instance);
  }

  /// Parses an unprefixed body as found in defaultProfile.xml. Blank means unbound.
  static ScInput parseBody(ScDeviceType device, String body, {int instance = 1}) {
    final trimmed = body.trim().toLowerCase();
    if (trimmed.isEmpty) return ScInput.unbound(device, instance);
    final parts = trimmed.split('+').where((p) => p.isNotEmpty).toList();
    if (parts.length == 1) return ScInput(device, instance, const [], parts.single);
    final modifierSet = device == ScDeviceType.gamepad ? scGamepadModifiers : scKeyboardModifiers;
    // The key is the last non-modifier part; defaults also contain reversed forms like `f5+lalt`.
    var keyIndex = parts.lastIndexWhere((p) => !modifierSet.contains(p));
    if (keyIndex == -1) keyIndex = parts.length - 1;
    final mods = [
      for (var i = 0; i < parts.length; i++)
        if (i != keyIndex) parts[i],
    ];
    return ScInput(device, instance, sortModifiers(mods), parts[keyIndex]);
  }

  static List<String> sortModifiers(List<String> mods) {
    int rank(String m) {
      final k = scKeyboardModifiers.indexOf(m);
      if (k != -1) return k;
      final g = scGamepadModifiers.indexOf(m);
      return g != -1 ? 100 + g : 200;
    }

    return [...mods]..sort((a, b) => rank(a).compareTo(rank(b)));
  }
}

/// Extracts `{vid, pid}` from a joystick `Product` attribute such as
/// `" VKB-Sim Gladiator NXT R   {0200231D-0000-0000-0000-504944564944}"` (PPPPVVVV-...-"PIDVID").
({int vendorId, int productId})? scParseProductGuid(String? product) {
  if (product == null) return null;
  final m = RegExp(r'\{([0-9A-Fa-f]{4})([0-9A-Fa-f]{4})-0000-0000-0000-504944564944\}').firstMatch(product);
  if (m == null) return null;
  return (vendorId: int.parse(m.group(2)!, radix: 16), productId: int.parse(m.group(1)!, radix: 16));
}

/// Product name without the trailing `{GUID}`.
String scProductName(String? product) {
  if (product == null) return '';
  return product.replaceAll(RegExp(r'\{[^}]*\}\s*$'), '').trim();
}

/// Builds the `Product` attribute the game writes for a HID joystick.
String scBuildProduct(String name, int vendorId, int productId) {
  String hex(int v) => v.toRadixString(16).toUpperCase().padLeft(4, '0');
  return ' $name  {${hex(productId)}${hex(vendorId)}-0000-0000-0000-504944564944}';
}
