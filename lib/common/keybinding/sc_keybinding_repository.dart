import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:xml/xml.dart';

import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;
import 'package:starcitizen_doctor/common/utils/log.dart';

import 'sc_default_profile.dart';
import 'sc_input.dart';
import 'sc_profile_document.dart';

/// Everything the keybinding tool reads from one game installation (e.g. `...\StarCitizen\LIVE`).
class ScKeybindingGameData {
  ScKeybindingGameData({
    required this.profile,
    required this.strings,
    required this.language,
    required this.gameVersion,
  });

  final ScDefaultProfile profile;

  /// global.ini entries with lower-cased keys; the game language over English.
  final Map<String, String> strings;
  final String language;
  final String gameVersion;

  /// Resolves an `@ui_xxx` key. Returns null when the game has no text for it.
  String? text(String key) {
    var k = key.trim();
    if (k.startsWith('@')) k = k.substring(1);
    if (k.isEmpty) return null;
    final comma = k.indexOf(',');
    if (comma != -1) k = k.substring(0, comma);
    final v = strings[k.toLowerCase()];
    return (v == null || v.trim().isEmpty) ? null : v.replaceAll(r'\n', '\n');
  }
}

class ScKeybindingRepository {
  ScKeybindingRepository(this.gamePath, {required this.cacheRoot});

  static const _p4kDefaultProfile = r'Data\Libs\Config\defaultProfile.xml';
  static const _p4kEnglishIni = r'Data\Localization\english\global.ini';

  final String gamePath;
  final String cacheRoot;

  String get _userDir => '$gamePath\\user\\client\\0';

  File get actionMapsFile => File('$_userDir\\Profiles\\default\\actionmaps.xml');

  Directory get mappingsDir => Directory('$_userDir\\Controls\\Mappings');

  Directory get backupDir => Directory('$_userDir\\Profiles\\default\\sctoolbox_backup');

  Future<ScKeybindingGameData> loadGameData({void Function(String step)? onStep}) async {
    final p4k = File('$gamePath\\Data.p4k');
    if (!await p4k.exists()) throw FileSystemException('Data.p4k not found', p4k.path);
    final cacheDir = await _cacheDir(p4k);
    final profileCache = File('${cacheDir.path}\\defaultProfile.xml');
    final iniCache = File('${cacheDir.path}\\global_english.ini');

    if (!await profileCache.exists() || !await iniCache.exists()) {
      onStep?.call('p4k');
      await unp4k_api.p4KOpen(p4KPath: p4k.path);
      try {
        final profileBytes = await unp4k_api.p4KExtractToMemory(filePath: _p4kDefaultProfile);
        final iniBytes = await unp4k_api.p4KExtractToMemory(filePath: _p4kEnglishIni);
        await cacheDir.create(recursive: true);
        await profileCache.writeAsBytes(profileBytes);
        await iniCache.writeAsBytes(iniBytes);
      } finally {
        await unp4k_api.p4KClose();
      }
      await _pruneOldCaches(cacheDir);
    }

    onStep?.call('parse');
    final profile = ScDefaultProfile.parse(_decode(await profileCache.readAsBytes()));
    final strings = _parseIni(_decode(await iniCache.readAsBytes()));
    final language = await _gameLanguage();
    if (language != 'english') {
      final localized = File('$gamePath\\data\\Localization\\$language\\global.ini');
      if (await localized.exists()) {
        strings.addAll(_parseIni(_decode(await localized.readAsBytes())));
      }
    }
    return ScKeybindingGameData(
      profile: profile,
      strings: strings,
      language: language,
      gameVersion: await _gameVersion(),
    );
  }

  /// Per-game-version cache folder, keyed by the Data.p4k size and date.
  Future<Directory> _cacheDir(File p4k) async {
    final stat = await p4k.stat();
    // Per channel, so pruning one channel's old versions keeps the other channels' caches.
    return Directory('$cacheRoot\\keybinding_cache\\$channel\\${stat.size}_${stat.modified.millisecondsSinceEpoch}');
  }

  /// The game's own layout presets (`Data\Libs\Config\Mappings\layout_*.xml`), extracted once per
  /// game version. [onStep] reports `p4k` when the archive has to be read.
  Future<List<ScPreset>> listPresets({void Function(String step)? onStep}) async {
    final p4k = File('$gamePath\\Data.p4k');
    final dir = Directory('${(await _cacheDir(p4k)).path}\\presets');
    final done = File('${dir.path}\\.done');
    if (!await done.exists()) {
      onStep?.call('p4k');
      await dir.create(recursive: true);
      await unp4k_api.p4KOpen(p4KPath: p4k.path);
      try {
        final bytes = (await unp4k_api.p4KGetFileIndex()).names;
        // Over a million '\n'-separated lower-case paths: pick the presets off the UI thread.
        final names = await Isolate.run(() => _presetPaths(bytes));
        for (final name in names) {
          final path = name.startsWith('\\') ? name.substring(1) : name;
          final bytes = await unp4k_api.p4KExtractToMemory(filePath: path);
          await File('${dir.path}\\${path.split('\\').last}').writeAsBytes(bytes);
        }
      } finally {
        await unp4k_api.p4KClose();
      }
      await done.writeAsString('ok');
    }
    final presets = <ScPreset>[];
    await for (final e in dir.list()) {
      if (e is! File || !e.path.toLowerCase().endsWith('.xml')) continue;
      try {
        presets.add(ScPreset.fromDocument(e, ScProfileDocument.parse(_decode(await e.readAsBytes()))));
      } catch (err) {
        dPrint('[keybinding] skip preset ${e.path}: $err');
      }
    }
    presets.sort((a, b) => a.fileName.compareTo(b.fileName));
    return presets;
  }

  /// The live profile, or an empty one when the game has not written it yet.
  /// Raw actionmaps.xml, or null when the game has not written one yet.
  Future<String?> readActionMapsText() async {
    final f = actionMapsFile;
    return await f.exists() ? _decode(await f.readAsBytes()) : null;
  }

  Future<ScProfileDocument> readActionMaps() async {
    final f = actionMapsFile;
    if (!await f.exists()) return ScProfileDocument.emptyProfile();
    return ScProfileDocument.parse(_decode(await f.readAsBytes()));
  }

  Future<List<File>> listLayouts() async {
    if (!await mappingsDir.exists()) return [];
    final files = await mappingsDir
        .list()
        .where((e) => e is File && e.path.toLowerCase().endsWith('.xml'))
        .cast<File>()
        .toList();
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    return files;
  }

  Future<ScProfileDocument> readLayout(File file) async => ScProfileDocument.parse(_decode(await file.readAsBytes()));

  /// Writes the live profile after copying the current one into [backupDir]. Returns the backup path.
  Future<String?> writeActionMaps(ScProfileDocument doc) async {
    String? backupPath;
    final f = actionMapsFile;
    if (await f.exists()) {
      await backupDir.create(recursive: true);
      final ts = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-').substring(0, 19);
      backupPath = '${backupDir.path}\\actionmaps_$ts.xml';
      await f.copy(backupPath);
    } else {
      await f.parent.create(recursive: true);
    }
    await _writeAtomic(f, doc.toXmlString());
    return backupPath;
  }

  File layoutFile(String name) => File('${mappingsDir.path}\\$name.xml');

  Future<File> writeLayout(String name, String xml) async {
    await mappingsDir.create(recursive: true);
    final f = layoutFile(name);
    await _writeAtomic(f, xml);
    return f;
  }

  /// This channel's folder name (`LIVE`, `PTU`, …).
  String get channel => gamePath.split(RegExp(r'[\\/]')).lastWhere((e) => e.isNotEmpty);

  /// Installed channels next to this one (`...\StarCitizen\LIVE`, `...\PTU`, …), this one first.
  Future<List<String>> listSiblingChannels() async {
    final parent = Directory(gamePath).parent;
    final result = <String>[channel];
    if (!await parent.exists()) return result;
    await for (final e in parent.list()) {
      if (e is! Directory) continue;
      final name = e.path.split(RegExp(r'[\\/]')).last;
      if (name == channel || name.startsWith('.')) continue;
      if (await File('${e.path}\\Data.p4k').exists() || await Directory('${e.path}\\user').exists()) {
        result.add(name);
      }
    }
    return result;
  }

  /// A repository for a sibling channel, sharing this one's cache.
  ScKeybindingRepository sibling(String name) => name == channel
      ? this
      : ScKeybindingRepository('${Directory(gamePath).parent.path}\\$name', cacheRoot: cacheRoot);

  Future<List<File>> listBackups() async {
    if (!await backupDir.exists()) return [];
    final files = await backupDir.list().where((e) => e is File).cast<File>().toList();
    files.sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  static Future<void> _writeAtomic(File target, String content) async {
    final tmp = File('${target.path}.sctoolbox.tmp');
    await tmp.writeAsString(content, flush: true);
    if (await target.exists()) await target.delete();
    await tmp.rename(target.path);
  }

  Future<String> _gameLanguage() async {
    for (final name in ['user.cfg', 'data\\system.cfg']) {
      final f = File('$gamePath\\$name');
      if (!await f.exists()) continue;
      for (final line in await f.readAsLines()) {
        final m = RegExp(r'^\s*g_language\s*=\s*(\S+)').firstMatch(line);
        if (m != null) return m.group(1)!.toLowerCase();
      }
    }
    return 'english';
  }

  Future<String> _gameVersion() async {
    try {
      final f = File('$gamePath\\build_manifest.id');
      if (!await f.exists()) return '';
      final json = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      return (json['Data'] as Map<String, dynamic>?)?['Version']?.toString() ?? '';
    } catch (e) {
      dPrint('[keybinding] read build_manifest.id error: $e');
      return '';
    }
  }

  Future<void> _pruneOldCaches(Directory keep) async {
    try {
      await for (final e in keep.parent.list()) {
        if (e is Directory && e.path != keep.path) await e.delete(recursive: true);
      }
    } catch (e) {
      dPrint('[keybinding] prune cache error: $e');
    }
  }

  static String _decode(List<int> bytes) {
    var b = bytes;
    if (b.length >= 3 && b[0] == 0xEF && b[1] == 0xBB && b[2] == 0xBF) b = b.sublist(3);
    return utf8.decode(b, allowMalformed: true);
  }

  static Map<String, String> _parseIni(String text) {
    final map = <String, String>{};
    for (final line in const LineSplitter().convert(text)) {
      final i = line.indexOf('=');
      if (i <= 0) continue;
      var key = line.substring(0, i).trim().toLowerCase();
      // Keys may carry a suffix: `ui_CIMiningMode,P=Toggle Mining Operator Mode`.
      final comma = key.indexOf(',');
      if (comma != -1) key = key.substring(0, comma);
      map[key] = line.substring(i + 1);
    }
    return map;
  }
}

/// Joystick instance → HID identity, as recorded in the profile's `<options>`.
Map<int, ({int vendorId, int productId, String name})> scJoystickIdentities(List<ScDeviceOption> options) => {
  for (final o in options)
    if (o.device == ScDeviceType.joystick && scParseProductGuid(o.product) != null)
      o.instance: (
        vendorId: scParseProductGuid(o.product)!.vendorId,
        productId: scParseProductGuid(o.product)!.productId,
        name: scProductName(o.product),
      ),
};

/// Layout presets (`libs\config\mappings\*.xml`) among the P4K index's '\n'-separated paths.
List<String> _presetPaths(Uint8List names) =>
    utf8.decode(names).split('\n').where((n) => n.contains('libs\\config\\mappings\\') && n.endsWith('.xml')).toList();

/// One of the game's bundled layouts.
class ScPreset {
  ScPreset({
    required this.file,
    required this.labelKey,
    required this.descriptionKey,
    required this.profileName,
    required this.document,
  });

  factory ScPreset.fromDocument(File file, ScProfileDocument doc) {
    final header = doc.document.rootElement.findElements('CustomisationUIHeader').firstOrNull;
    return ScPreset(
      file: file,
      labelKey: header?.getAttribute('label') ?? '',
      descriptionKey: header?.getAttribute('description') ?? '',
      profileName: doc.document.rootElement.getAttribute('profileName') ?? '',
      document: doc,
    );
  }

  final File file;
  final String labelKey;
  final String descriptionKey;
  final String profileName;
  final ScProfileDocument document;

  String get fileName => file.path.split('\\').last;

  /// Joystick instance → product name the preset was made for.
  Map<int, String> get joysticks => {
    for (final o in document.readOptions())
      if (o.device == ScDeviceType.joystick && o.product != null) o.instance: scProductName(o.product),
  };
}
