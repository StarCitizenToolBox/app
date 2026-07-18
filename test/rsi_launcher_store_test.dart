import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:starcitizen_doctor/common/rsi_launcher/launcher_store.dart';

void main() {
  const nodePayload =
      '//79gMDB4iihADphYmNkZTrg0ihWJ+U9fDUdiFMRr48y9fP5F1MjcOcpOV8xgiN0WPttIbz/QUGml5Dcd5mkciQ=';
  final nodeStore = <String, dynamic>{
    'library': <String, dynamic>{'installed': <dynamic>[]},
  };

  test('decrypts and reproduces a Node crypto compatibility vector', () {
    final iv = [
      255,
      254,
      253,
      128,
      192,
      193,
      226,
      40,
      161,
      0,
      58,
      97,
      98,
      99,
      100,
      101,
    ];
    final codec = RsiLauncherStoreCodec(random: _SequenceRandom(iv));

    expect(codec.decrypt(base64Decode(nodePayload)), nodeStore);
    expect(base64Encode(codec.encrypt(nodeStore)), nodePayload);
  });

  test('updates an existing channel with schema-safe values and paths', () {
    final store = _storeWithInstalled([]);
    (store['library'] as Map)['installed'] = [
      {
        'id': 'SC',
        'name': 'Star Citizen',
        'channels': [
          {
            'id': 'LIVE',
            'name': 'Live Release',
            'version': 1,
            'versionLabel': 'old',
            'platformId': 'prod',
            'servicesEndpoint': 'https://old.example',
            'network': null,
            'installDir': 'Old',
            'status': 'installed',
            'libraryFolder': r'E:\Old\',
          },
        ],
      },
    ];

    final changed = updateRsiLauncherInstalledChannel(
      store,
      gameDirectory: r'P:\Games\RSI\StarCitizen\LIVE',
      releaseInfo: {
        'versionLabel': '4.9.0-live.12248363',
        'servicesEndpoint': 'https://live.example',
      },
      libraryData: const {},
    );

    final channel = _firstChannel(store);
    expect(changed, isTrue);
    expect(channel['version'], 12248363);
    expect(channel['versionLabel'], '4.9.0-live.12248363');
    expect(channel['servicesEndpoint'], 'https://live.example');
    expect(channel['status'], 'installed');
    expect(channel['installDir'], 'StarCitizen');
    expect(channel['libraryFolder'], r'P:\Games\RSI\');
  });

  test('adds a missing installed game from RSI library metadata', () {
    final store = _storeWithInstalled([]);
    final changed = updateRsiLauncherInstalledChannel(
      store,
      gameDirectory: r'P:\Games\RSI\StarCitizen\PTU',
      releaseInfo: const {'versionLabel': '4.9.0-ptu.12345678'},
      libraryData: {
        'games': [
          {
            'id': 'SC',
            'name': 'Star Citizen',
            'channels': [
              {
                'id': 'PTU',
                'name': 'Public Test Universe',
                'version': 12345678,
                'versionLabel': '4.9.0-ptu.12345678',
                'platformId': 'ptu',
                'servicesEndpoint': 'https://ptu.example',
                'network': null,
              },
            ],
          },
        ],
      },
    );

    final installed = (store['library'] as Map)['installed'] as List;
    final channel = _firstChannel(store);
    expect(changed, isTrue);
    expect(installed, hasLength(1));
    expect((installed.first as Map)['id'], 'SC');
    expect(channel['id'], 'PTU');
    expect(channel['version'], isA<num>());
    expect(channel['installDir'], 'StarCitizen');
    expect(channel['libraryFolder'], r'P:\Games\RSI\');
  });

  test('normalizes a semantic version when versionLabel is empty', () {
    final store = _storeWithInstalled([
      {
        'id': 'SC',
        'name': 'Star Citizen',
        'channels': [
          {
            'id': 'LIVE',
            'name': 'Live Release',
            'version': '4.9.0-live.12248363',
            'versionLabel': '',
            'platformId': 'prod',
            'servicesEndpoint': 'https://live.example',
            'network': null,
            'installDir': 'StarCitizen',
            'status': 'installed',
            'libraryFolder': r'P:\Games\RSI\',
          },
        ],
      },
    ]);

    updateRsiLauncherInstalledChannel(
      store,
      gameDirectory: r'P:\Games\RSI\StarCitizen\LIVE',
      releaseInfo: const {},
      libraryData: const {},
    );

    final channel = _firstChannel(store);
    expect(channel['version'], 12248363);
    expect(channel['versionLabel'], '4.9.0-live.12248363');
  });

  test(
    'backs up and rewrites the encrypted store after validating Data.p4k',
    () async {
      final sandbox = await Directory.systemTemp.createTemp('rsi_store_test_');
      try {
        final gameDirectory = p.windows.join(
          sandbox.path,
          'StarCitizen',
          'LIVE',
        );
        await Directory(gameDirectory).create(recursive: true);
        await File(p.windows.join(gameDirectory, 'Data.p4k')).writeAsBytes([1]);
        final storeFile = File(
          p.windows.join(sandbox.path, 'launcher store.json'),
        );
        final codec = RsiLauncherStoreCodec(random: Random(7));
        await storeFile.writeAsBytes(
          codec.encrypt(
            _storeWithInstalled([
              {
                'id': 'SC',
                'name': 'Star Citizen',
                'channels': [
                  {
                    'id': 'LIVE',
                    'name': 'Live Release',
                    'version': 1,
                    'versionLabel': 'old',
                    'platformId': 'prod',
                    'servicesEndpoint': 'https://old.example',
                    'network': null,
                    'installDir': 'StarCitizen',
                    'status': 'installed',
                    'libraryFolder': '${sandbox.path}\\',
                  },
                ],
              },
            ]),
          ),
        );

        final result = await RsiLauncherStoreService(codec: codec)
            .syncInstalledChannel(
              storeFile: storeFile,
              gameDirectory: gameDirectory,
              releaseInfo: const {
                'versionLabel': '4.9.0-live.12248363',
                'servicesEndpoint': 'https://live.example',
              },
              libraryData: const {},
            );

        expect(result.changed, isTrue);
        expect(await File(result.backupPath!).exists(), isTrue);
        expect(
          _firstChannel(
            codec.decrypt(await storeFile.readAsBytes()),
          )['version'],
          12248363,
        );
      } finally {
        await sandbox.delete(recursive: true);
      }
    },
  );
}

Map<String, dynamic> _storeWithInstalled(List<dynamic> installed) => {
  'library': {'installed': installed},
};

Map _firstChannel(Map store) {
  final installed = (store['library'] as Map)['installed'] as List;
  return ((installed.first as Map)['channels'] as List).first as Map;
}

class _SequenceRandom implements Random {
  _SequenceRandom(this.values);

  final List<int> values;
  var _index = 0;

  @override
  bool nextBool() => nextInt(2) == 1;

  @override
  double nextDouble() => nextInt(1 << 26) / (1 << 26);

  @override
  int nextInt(int max) => values[_index++] % max;
}
