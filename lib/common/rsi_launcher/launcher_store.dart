import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:pointycastle/export.dart';

const _launcherStoreSecret = 'OjPs60LNS7LbbroAuPXDkwLRipgfH6hIFA6wvuBxkg4=';
const _ivLength = 16;
const _separator = 0x3a;
const _aesBlockSize = 16;

class RsiLauncherStoreCodec {
  RsiLauncherStoreCodec({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  Map<String, dynamic> decrypt(Uint8List payload) {
    if (payload.length <= _ivLength + 1 || payload[_ivLength] != _separator) {
      throw const FormatException('Unknown RSI Launcher store format');
    }
    final iv = Uint8List.sublistView(payload, 0, _ivLength);
    final ciphertext = Uint8List.sublistView(payload, _ivLength + 1);
    if (ciphertext.isEmpty || ciphertext.length % _aesBlockSize != 0) {
      throw const FormatException('Invalid RSI Launcher store ciphertext');
    }
    final plaintext = _aesCbc(
      encrypting: false,
      key: _deriveKey(iv),
      iv: iv,
      input: ciphertext,
    );
    final decoded = json.decode(utf8.decode(_removePkcs7Padding(plaintext)));
    if (decoded is! Map) {
      throw const FormatException('RSI Launcher store root must be an object');
    }
    return Map<String, dynamic>.from(decoded);
  }

  Uint8List encrypt(Map<String, dynamic> store) {
    final iv = Uint8List.fromList(
      List<int>.generate(_ivLength, (_) => _random.nextInt(256)),
    );
    final plaintext = Uint8List.fromList(
      utf8.encode(const JsonEncoder.withIndent('  ').convert(store)),
    );
    final ciphertext = _aesCbc(
      encrypting: true,
      key: _deriveKey(iv),
      iv: iv,
      input: _addPkcs7Padding(plaintext),
    );
    return Uint8List(iv.length + 1 + ciphertext.length)
      ..setAll(0, iv)
      ..[iv.length] = _separator
      ..setAll(iv.length + 1, ciphertext);
  }
}

class RsiLauncherStoreSyncResult {
  const RsiLauncherStoreSyncResult({
    required this.changed,
    required this.backupPath,
  });

  final bool changed;
  final String? backupPath;
}

class RsiLauncherStoreService {
  RsiLauncherStoreService({RsiLauncherStoreCodec? codec})
    : _codec = codec ?? RsiLauncherStoreCodec();

  final RsiLauncherStoreCodec _codec;

  Future<RsiLauncherStoreSyncResult> syncInstalledChannel({
    required File storeFile,
    required String gameDirectory,
    required Map releaseInfo,
    required Map libraryData,
  }) async {
    await _validateInstalledGame(gameDirectory);
    final original = await storeFile.readAsBytes();
    final store = await Isolate.run(() => _codec.decrypt(original));
    final changed = updateRsiLauncherInstalledChannel(
      store,
      gameDirectory: gameDirectory,
      releaseInfo: releaseInfo,
      libraryData: libraryData,
    );
    if (!changed) {
      return const RsiLauncherStoreSyncResult(changed: false, backupPath: null);
    }

    final backupFile = File('${storeFile.path}.sctoolbox.bak');
    final tempFile = File(
      '${storeFile.path}.sctoolbox.$pid.${DateTime.now().microsecondsSinceEpoch}.tmp',
    );
    await storeFile.copy(backupFile.path);
    try {
      final encrypted = await Isolate.run(() => _codec.encrypt(store));
      await tempFile.writeAsBytes(encrypted, flush: true);
      // Dart cannot replace an existing file with rename on Windows. The
      // backup is created first and restored if the final rename fails.
      await storeFile.delete();
      try {
        await tempFile.rename(storeFile.path);
      } catch (_) {
        if (!await storeFile.exists()) {
          await backupFile.copy(storeFile.path);
        }
        rethrow;
      }
    } finally {
      if (await tempFile.exists()) await tempFile.delete();
    }
    return RsiLauncherStoreSyncResult(
      changed: true,
      backupPath: backupFile.path,
    );
  }
}

bool updateRsiLauncherInstalledChannel(
  Map<String, dynamic> store, {
  required String gameDirectory,
  required Map releaseInfo,
  required Map libraryData,
}) {
  final before = json.encode(store);
  final library = _requiredMap(store, 'library');
  final installed = _requiredList(library, 'installed');
  final environment = p.windows.basename(p.windows.normalize(gameDirectory));
  final serverGame = _findGame(_gamesFromLibraryData(libraryData), null);
  final serverChannel = serverGame == null
      ? null
      : _findChannel(_channels(serverGame), environment);
  final game = _findGame(installed, serverGame);

  final targetGame = game ?? _newGame(serverGame);
  final channels = _channels(targetGame);
  final currentChannel = _findChannel(channels, environment);
  if (currentChannel == null && serverChannel == null) {
    throw StateError('No $environment channel metadata was found');
  }

  final channel = <String, dynamic>{
    if (currentChannel != null) ...currentChannel,
    if (serverChannel != null) ...serverChannel,
  };
  _overlayReleaseMetadata(channel, releaseInfo);
  channel['id'] = environment;
  channel['status'] = 'installed';
  final installRoot = p.windows.dirname(p.windows.normalize(gameDirectory));
  channel['installDir'] = p.windows.basename(installRoot);
  channel['libraryFolder'] = _withTrailingSeparator(
    p.windows.dirname(installRoot),
  );
  channel.putIfAbsent('network', () => null);
  _normalizeVersion(channel);
  _validateChannel(channel);

  final channelIndex = channels.indexWhere(
    (value) => _mapId(value)?.toUpperCase() == environment.toUpperCase(),
  );
  if (channelIndex < 0) {
    channels.add(channel);
  } else {
    channels[channelIndex] = channel;
  }
  targetGame['channels'] = channels;
  if (game == null) {
    installed.add(targetGame);
  } else {
    final gameId = _mapId(game)?.toUpperCase();
    final gameIndex = installed.indexWhere(
      (value) => value is Map && _mapId(value)?.toUpperCase() == gameId,
    );
    if (gameIndex < 0) {
      throw StateError('Installed Star Citizen record disappeared');
    }
    installed[gameIndex] = targetGame;
  }
  library['installed'] = installed;
  store['library'] = library;
  return before != json.encode(store);
}

Uint8List _deriveKey(Uint8List iv) {
  // Node's Buffer.toString() decodes the raw IV as UTF-8 with replacement
  // characters. pbkdf2Sync then encodes that JavaScript string as UTF-8 again.
  final saltText = utf8.decode(iv, allowMalformed: true);
  final derivator = PBKDF2KeyDerivator(HMac(SHA512Digest(), 128))
    ..init(
      Pbkdf2Parameters(Uint8List.fromList(utf8.encode(saltText)), 10000, 32),
    );
  return derivator.process(
    Uint8List.fromList(utf8.encode(_launcherStoreSecret)),
  );
}

Uint8List _aesCbc({
  required bool encrypting,
  required Uint8List key,
  required Uint8List iv,
  required Uint8List input,
}) {
  final cipher = CBCBlockCipher(AESEngine())
    ..init(encrypting, ParametersWithIV(KeyParameter(key), iv));
  final output = Uint8List(input.length);
  for (var offset = 0; offset < input.length; offset += _aesBlockSize) {
    cipher.processBlock(input, offset, output, offset);
  }
  return output;
}

Uint8List _addPkcs7Padding(Uint8List input) {
  final count = _aesBlockSize - input.length % _aesBlockSize;
  return Uint8List(input.length + count)
    ..setAll(0, input)
    ..fillRange(input.length, input.length + count, count);
}

Uint8List _removePkcs7Padding(Uint8List input) {
  if (input.isEmpty) throw const FormatException('Invalid PKCS7 padding');
  final count = input.last;
  if (count < 1 || count > _aesBlockSize || count > input.length) {
    throw const FormatException('Invalid PKCS7 padding');
  }
  for (var index = input.length - count; index < input.length; index++) {
    if (input[index] != count) {
      throw const FormatException('Invalid PKCS7 padding');
    }
  }
  return Uint8List.sublistView(input, 0, input.length - count);
}

Future<void> _validateInstalledGame(String gameDirectory) async {
  if (await File(p.windows.join(gameDirectory, 'Data.p4k.part')).exists()) {
    throw StateError('Data.p4k is still incomplete');
  }
  if (!await File(p.windows.join(gameDirectory, 'Data.p4k')).exists()) {
    throw StateError('Data.p4k was not found');
  }
}

Map<String, dynamic> _requiredMap(Map source, String key) {
  final value = source[key];
  if (value is! Map) throw FormatException('$key must be an object');
  return Map<String, dynamic>.from(value);
}

List<dynamic> _requiredList(Map source, String key) {
  final value = source[key];
  if (value is! List) throw FormatException('$key must be an array');
  return List<dynamic>.from(value);
}

List<dynamic> _gamesFromLibraryData(Map libraryData) {
  final games = libraryData['games'];
  return games is List ? games : const [];
}

Map<String, dynamic>? _findGame(List<dynamic> games, Map? template) {
  final templateId = _mapId(template)?.toUpperCase();
  for (final value in games) {
    if (value is! Map) continue;
    final id = _mapId(value)?.toUpperCase();
    final name = value['name']?.toString().toLowerCase();
    if ((templateId != null && id == templateId) ||
        id == 'SC' ||
        name == 'star citizen') {
      return Map<String, dynamic>.from(value);
    }
  }
  return null;
}

Map<String, dynamic>? _findChannel(
  List<Map<String, dynamic>> channels,
  String environment,
) {
  for (final channel in channels) {
    if (_mapId(channel)?.toUpperCase() == environment.toUpperCase()) {
      return Map<String, dynamic>.from(channel);
    }
  }
  return null;
}

List<Map<String, dynamic>> _channels(Map game) {
  final values = game['channels'];
  if (values is! List) return [];
  return values
      .whereType<Map>()
      .map((value) => Map<String, dynamic>.from(value))
      .toList();
}

Map<String, dynamic> _newGame(Map<String, dynamic>? serverGame) {
  if (serverGame == null) {
    throw StateError('Star Citizen library metadata was not found');
  }
  return {
    'id': serverGame['id'],
    'name': serverGame['name'],
    'channels': <Map<String, dynamic>>[],
  };
}

void _overlayReleaseMetadata(Map<String, dynamic> channel, Map releaseInfo) {
  const fields = [
    'name',
    'version',
    'versionLabel',
    'platformId',
    'servicesEndpoint',
    'nid',
    'network',
    'weight',
  ];
  for (final field in fields) {
    if (releaseInfo[field] != null) channel[field] = releaseInfo[field];
  }
  if (releaseInfo['version'] == null && releaseInfo['versionLabel'] != null) {
    channel['version'] = releaseInfo['versionLabel'];
  }
}

void _normalizeVersion(Map<String, dynamic> channel) {
  final version = channel['version'];
  if (version is num) return;
  final direct = int.tryParse(version?.toString() ?? '');
  if (direct != null) {
    channel['version'] = direct;
    return;
  }
  var versionLabel = channel['versionLabel']?.toString() ?? '';
  if (versionLabel.isEmpty && version is String && version.isNotEmpty) {
    versionLabel = version;
    channel['versionLabel'] = versionLabel;
  }
  final label = versionLabel.isNotEmpty
      ? versionLabel
      : version?.toString() ?? '';
  final matches = RegExp(r'(\d+)').allMatches(label).toList();
  if (matches.isNotEmpty) {
    channel['version'] = int.tryParse(matches.last.group(1)!);
  }
}

void _validateChannel(Map<String, dynamic> channel) {
  const stringFields = [
    'id',
    'name',
    'versionLabel',
    'platformId',
    'servicesEndpoint',
    'status',
    'installDir',
    'libraryFolder',
  ];
  for (final field in stringFields) {
    if (channel[field] is! String || (channel[field] as String).isEmpty) {
      throw FormatException('Channel $field must be a non-empty string');
    }
  }
  if (channel['version'] is! num) {
    throw const FormatException('Channel version must be a number');
  }
  if (!channel.containsKey('network')) {
    throw const FormatException('Channel network is required');
  }
}

String? _mapId(Map? value) => value?['id']?.toString();

String _withTrailingSeparator(String value) =>
    value.endsWith('\\') ? value : '$value\\';
