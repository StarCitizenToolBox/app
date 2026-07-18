import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;

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
    final exitCode = await win32.runAsAdminAndWait(
      program: setupPath,
      args: arguments,
      timeoutMs: timeout.inMilliseconds,
    );
    if (exitCode != 0) {
      throw ProcessException(
        setupPath,
        arguments,
        'Elevated EasyAntiCheat setup exited with code $exitCode',
        exitCode,
      );
    }
  }
}

abstract interface class EacRegistrationMarkerWriter {
  Future<void> markInstalled({
    required String gameName,
    required String environment,
  });
}

class WindowsEacRegistrationMarkerWriter
    implements EacRegistrationMarkerWriter {
  const WindowsEacRegistrationMarkerWriter();

  @override
  Future<void> markInstalled({
    required String gameName,
    required String environment,
  }) => win32.setCurrentUserRegistryDword(
    keyPath: 'SOFTWARE\\Roberts Space Industries\\$gameName\\$environment',
    valueName: 'EACServiceInstalled',
    value: 1,
  );
}

class EacRegistrar {
  EacRegistrar({
    EacInstallerRunner? installerRunner,
    EacRegistrationMarkerWriter? markerWriter,
  }) : _installerRunner = installerRunner ?? const DirectEacInstallerRunner(),
       _markerWriter =
           markerWriter ?? const WindowsEacRegistrationMarkerWriter();

  final EacInstallerRunner _installerRunner;
  final EacRegistrationMarkerWriter _markerWriter;

  Future<EacRegistrationOutcome> register({
    required String gameDirectory,
    void Function(String message)? log,
  }) async {
    final antiCheatDirectory = getAntiCheatDirectory(gameDirectory);
    if (!await Directory(antiCheatDirectory).exists()) {
      log?.call('No Anti-Cheat distribution was found in this build');
      return EacRegistrationOutcome.distributionNotFound;
    }

    final identity = _gameIdentity(gameDirectory);
    try {
      final productId = await _readProductId(antiCheatDirectory);
      final setupPath = p.windows.join(antiCheatDirectory, _eacSetupFileName);
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
    try {
      await _markerWriter.markInstalled(
        gameName: identity.gameName,
        environment: identity.environment,
      );
    } catch (error) {
      log?.call(
        'Unable to write the EACServiceInstalled launcher marker: $error',
      );
    }
    return EacRegistrationOutcome.registered;
  }
}

class EacDistributionPatchGuard {
  EacDistributionPatchGuard._({
    required this.distributionDirectory,
    required this.backupDirectory,
    this.log,
  });

  final Directory distributionDirectory;
  final Directory? backupDirectory;
  final void Function(String message)? log;
  bool _finished = false;

  static Future<EacDistributionPatchGuard> prepare(
    String gameDirectory, {
    void Function(String message)? log,
  }) async {
    final distribution = Directory(getAntiCheatDirectory(gameDirectory));
    Directory? backup;
    if (await distribution.exists()) {
      backup = Directory(
        '${distribution.path}.sctoolbox-backup-'
        '${DateTime.now().microsecondsSinceEpoch}-$pid',
      );
      await distribution.rename(backup.path);
      log?.call('EAC DIRECTORY MOVED TO ROLLBACK BACKUP');
    }
    return EacDistributionPatchGuard._(
      distributionDirectory: distribution,
      backupDirectory: backup,
      log: log,
    );
  }

  Future<void> commit() async {
    if (_finished) return;
    _finished = true;
    final backup = backupDirectory;
    if (backup != null && await backup.exists()) {
      try {
        await backup.delete(recursive: true);
      } catch (error) {
        log?.call('UNABLE TO DELETE EAC ROLLBACK BACKUP: $error');
        return;
      }
    }
    log?.call('EAC DIRECTORY SUCCESSFULLY DELETED');
  }

  Future<void> rollback() async {
    if (_finished) return;
    _finished = true;
    try {
      if (await distributionDirectory.exists()) {
        await distributionDirectory.delete(recursive: true);
      }
      final backup = backupDirectory;
      if (backup != null && await backup.exists()) {
        await backup.rename(distributionDirectory.path);
        log?.call('EAC DIRECTORY SUCCESSFULLY RESTORED');
      }
    } catch (error) {
      log?.call('UNABLE TO RESTORE EAC ROLLBACK BACKUP: $error');
    }
  }
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
