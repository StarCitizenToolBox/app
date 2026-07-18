import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:starcitizen_doctor/common/eac/eac_registrar.dart';

void main() {
  late Directory sandbox;

  setUp(() async {
    sandbox = await Directory.systemTemp.createTemp('eac_registrar_test_');
  });

  tearDown(() async {
    if (await sandbox.exists()) await sandbox.delete(recursive: true);
  });

  test('skips a build without an EAC distribution', () async {
    final runner = _RecordingInstallerRunner();
    final logs = <String>[];

    final outcome = await EacRegistrar(
      installerRunner: runner,
    ).register(gameDirectory: sandbox.path, log: logs.add);

    expect(outcome, EacRegistrationOutcome.distributionNotFound);
    expect(runner.calls, isEmpty);
    expect(logs, ['No Anti-Cheat distribution was found in this build']);
  });

  test('reads productid and unconditionally runs the installer', () async {
    final gameDirectory = p.windows.join(sandbox.path, 'StarCitizen', 'LIVE');
    final eacDirectory = Directory(getAntiCheatDirectory(gameDirectory));
    await eacDirectory.create(recursive: true);
    await File(
      p.windows.join(eacDirectory.path, 'Settings.json'),
    ).writeAsString('{"productid":"build-product-id"}');
    final runner = _RecordingInstallerRunner();
    final registrar = EacRegistrar(installerRunner: runner);

    await registrar.register(gameDirectory: gameDirectory);
    await registrar.register(gameDirectory: gameDirectory);

    expect(runner.calls, hasLength(2));
    expect(runner.calls.first.productId, 'build-product-id');
    expect(
      runner.calls.first.setupPath,
      p.windows.join(eacDirectory.path, 'EasyAntiCheat_EOS_Setup.exe'),
    );
  });

  test('reports a named EACError when setup fails', () async {
    final gameDirectory = p.windows.join(sandbox.path, 'StarCitizen', 'PTU');
    final eacDirectory = Directory(getAntiCheatDirectory(gameDirectory));
    await eacDirectory.create(recursive: true);
    await File(
      p.windows.join(eacDirectory.path, 'Settings.json'),
    ).writeAsString('{"productid":"ptu-product-id"}');
    final registrar = EacRegistrar(
      installerRunner: _RecordingInstallerRunner(error: Exception('failed')),
    );

    expect(
      () => registrar.register(gameDirectory: gameDirectory),
      throwsA(
        isA<EACError>()
            .having(
              (error) => error.message,
              'message',
              'Unable to register game StarCitizen with environment PTU to the EAC service',
            )
            .having((error) => error.cause, 'cause', isA<Exception>()),
      ),
    );
  });

  test('deletes the complete EAC distribution before patching', () async {
    final eacDirectory = Directory(getAntiCheatDirectory(sandbox.path));
    await eacDirectory.create(recursive: true);
    await File(
      p.windows.join(eacDirectory.path, 'old.bin'),
    ).writeAsString('old');
    final logs = <String>[];

    await deleteAntiCheatDistribution(sandbox.path, log: logs.add);

    expect(await eacDirectory.exists(), isFalse);
    expect(logs, ['EAC DIRECTORY SUCCESSFULLY DELETED']);
  });
}

class _RecordingInstallerRunner implements EacInstallerRunner {
  _RecordingInstallerRunner({this.error});

  final Object? error;
  final List<({String setupPath, String productId})> calls = [];

  @override
  Future<void> install({
    required String setupPath,
    required String productId,
  }) async {
    calls.add((setupPath: setupPath, productId: productId));
    if (error case final error?) throw error;
  }
}
