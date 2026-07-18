import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

const _eacDirectoryName = 'EasyAntiCheat';
const _eacSettingsFileName = 'Settings.json';
const _eacSetupFileName = 'EasyAntiCheat_EOS_Setup.exe';

String getAntiCheatDirectory(String gameDirectory) =>
    p.windows.join(gameDirectory, _eacDirectoryName);

enum EacRegistrationOutcome { registered, distributionNotFound }

class EACError implements Exception {
  const EACError(this.message);

  final String message;

  @override
  String toString() => 'EACError: $message';
}

abstract interface class EacInstallerRunner {
  Future<void> install({required String setupPath, required String productId});
}

class DirectEacInstallerRunner implements EacInstallerRunner {
  const DirectEacInstallerRunner({
    this.timeout = const Duration(minutes: 2),
  });

  final Duration timeout;

  @override
  Future<void> install({
    required String setupPath,
    required String productId,
  }) async {
    final result = await Process.run(
      setupPath,
      ['install', productId],
      workingDirectory: File(setupPath).parent.path,
    ).timeout(timeout);
    if (result.exitCode != 0) {
      final stderr = result.stderr.toString().trim();
      throw ProcessException(
        setupPath,
        ['install', productId],
        stderr.isEmpty
            ? 'EasyAntiCheat setup exited with code ${result.exitCode}'
            : stderr,
        result.exitCode,
      );
    }
  }
}

class EacRegistrar {
  EacRegistrar({EacInstallerRunner? installerRunner})
    : _installerRunner = installerRunner ?? const DirectEacInstallerRunner();

  final EacInstallerRunner _installerRunner;

  Future<EacRegistrationOutcome> register({
    required String gameDirectory,
    void Function(String message)? log,
  }) async {
    final antiCheatDirectory = getAntiCheatDirectory(gameDirectory);
    if (!await Directory(antiCheatDirectory).exists()) {
      log?.call('No Anti-Cheat distribution was found in this build');
      return EacRegistrationOutcome.distributionNotFound;
    }

    final productId = await _readProductId(antiCheatDirectory);
    final setupPath = p.windows.join(antiCheatDirectory, _eacSetupFileName);
    final identity = _gameIdentity(gameDirectory);
    try {
      await _installerRunner.install(
        setupPath: setupPath,
        productId: productId,
      );
    } catch (_) {
      throw EACError(
        'Unable to register game ${identity.gameName} with environment '
        '${identity.environment} to the EAC service',
      );
    }
    return EacRegistrationOutcome.registered;
  }
}

Future<void> deleteAntiCheatDistribution(
  String gameDirectory, {
  void Function(String message)? log,
}) async {
  final directory = Directory(getAntiCheatDirectory(gameDirectory));
  if (await directory.exists()) {
    await directory.delete(recursive: true);
  }
  log?.call('EAC DIRECTORY SUCCESSFULLY DELETED');
}

Future<String> _readProductId(String antiCheatDirectory) async {
  final settingsFile = File(
    p.windows.join(antiCheatDirectory, _eacSettingsFileName),
  );
  final decoded = json.decode(await settingsFile.readAsString());
  if (decoded is! Map || decoded['productid'] is! String) {
    throw const FormatException(
      'EasyAntiCheat Settings.json does not contain a productid',
    );
  }
  final productId = (decoded['productid'] as String).trim();
  if (productId.isEmpty) {
    throw const FormatException(
      'EasyAntiCheat Settings.json contains an empty productid',
    );
  }
  return productId;
}

({String gameName, String environment}) _gameIdentity(String gameDirectory) {
  final normalized = p.windows.normalize(gameDirectory);
  return (
    gameName: p.windows.basename(p.windows.dirname(normalized)),
    environment: p.windows.basename(normalized),
  );
}
