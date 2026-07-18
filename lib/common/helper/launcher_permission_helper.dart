import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;

const launcherPermissionGrants = <String>[
  '*S-1-5-32-544:(OI)(CI)F',
  '*S-1-5-18:(OI)(CI)F',
  '*S-1-5-32-545:(OI)(CI)F',
  '*S-1-5-11:(OI)(CI)M',
];

abstract interface class ElevatedPermissionCommandRunner {
  Future<int> run({
    required String program,
    required List<String> args,
    required int timeoutMs,
  });
}

class Win32ElevatedPermissionCommandRunner
    implements ElevatedPermissionCommandRunner {
  const Win32ElevatedPermissionCommandRunner();

  @override
  Future<int> run({
    required String program,
    required List<String> args,
    required int timeoutMs,
  }) => win32.runAsAdminAndWait(
    program: program,
    args: args,
    timeoutMs: timeoutMs,
  );
}

class LauncherPermissionError implements Exception {
  const LauncherPermissionError(this.directory, this.exitCode);

  final String directory;
  final int exitCode;

  @override
  String toString() =>
      'Unable to grant RSI Launcher-compatible permissions to $directory '
      '(icacls exit code: $exitCode)';
}

class LauncherPermissionHelper {
  const LauncherPermissionHelper({
    this.commandRunner = const Win32ElevatedPermissionCommandRunner(),
    this.timeoutMs = 60000,
  });

  final ElevatedPermissionCommandRunner commandRunner;
  final int timeoutMs;

  Future<bool> fixDirectory(
    String directory, {
    void Function(String message)? log,
  }) async {
    final target = Directory(directory);
    if (!await target.exists()) {
      log?.call('Permission repair skipped because $directory does not exist');
      return false;
    }

    final systemRoot = Platform.environment['SystemRoot'] ?? r'C:\Windows';
    final icacls = p.windows.join(systemRoot, 'System32', 'icacls.exe');
    final exitCode = await commandRunner.run(
      program: icacls,
      args: [directory, '/grant', ...launcherPermissionGrants],
      timeoutMs: timeoutMs,
    );
    if (exitCode != 0) {
      throw LauncherPermissionError(directory, exitCode);
    }
    log?.call('RSI Launcher-compatible permissions granted to $directory');
    return true;
  }
}
