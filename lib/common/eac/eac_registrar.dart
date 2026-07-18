import 'dart:async';
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
  const EACError(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => cause == null
      ? 'EACError: $message'
      : 'EACError: $message; cause: $cause';
}

abstract interface class EacInstallerRunner {
  Future<void> install({required String setupPath, required String productId});
}

class DirectEacInstallerRunner implements EacInstallerRunner {
  const DirectEacInstallerRunner({this.timeout = const Duration(minutes: 2)});

  final Duration timeout;

  @override
  Future<void> install({
    required String setupPath,
    required String productId,
  }) async {
    final arguments = ['install', productId];
    final process = await Process.start(
      setupPath,
      arguments,
      workingDirectory: File(setupPath).parent.path,
    );
    final stdoutFuture = process.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .join();
    final stderrFuture = process.stderr
        .transform(const Utf8Decoder(allowMalformed: true))
        .join();
    late final int exitCode;
    try {
      exitCode = await process.exitCode.timeout(timeout);
    } on TimeoutException {
      final killed = process.kill();
      if (killed) {
        try {
          await process.exitCode.timeout(const Duration(seconds: 5));
        } on TimeoutException {
          // The timeout error below remains the actionable failure even when
          // Windows does not report process termination promptly.
        }
      }
      throw ProcessException(
        setupPath,
        arguments,
        'EasyAntiCheat setup timed out after ${timeout.inSeconds} seconds',
        -1,
      );
    }
    final output = (await Future.wait([stderrFuture, stdoutFuture]))
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join('\n');
    if (exitCode != 0) {
      throw ProcessException(
        setupPath,
        arguments,
        output.isEmpty
            ? 'EasyAntiCheat setup exited with code $exitCode'
            : output,
        exitCode,
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
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        EACError(
          'Unable to register game ${identity.gameName} with environment '
          '${identity.environment} to the EAC service',
          cause: error,
        ),
        stackTrace,
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
