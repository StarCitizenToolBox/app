import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/common/helper/launcher_permission_helper.dart';

void main() {
  late Directory sandbox;

  setUp(() async {
    sandbox = await Directory.systemTemp.createTemp(
      'launcher_permission_helper_test_',
    );
  });

  tearDown(() async {
    if (await sandbox.exists()) await sandbox.delete(recursive: true);
  });

  test(
    'grants the same non-recursive inheritable permissions as launcher',
    () async {
      final runner = _RecordingPermissionCommandRunner();
      final logs = <String>[];

      final repaired = await LauncherPermissionHelper(
        commandRunner: runner,
      ).fixDirectory(sandbox.path, log: logs.add);

      expect(repaired, isTrue);
      expect(runner.calls, hasLength(1));
      expect(runner.calls.single.program, endsWith(r'\System32\icacls.exe'));
      expect(runner.calls.single.args, [
        sandbox.path,
        '/grant',
        ...launcherPermissionGrants,
      ]);
      expect(runner.calls.single.args, isNot(contains('/T')));
      expect(runner.calls.single.args, isNot(contains('/reset')));
      expect(runner.calls.single.timeoutMs, 60000);
      expect(logs.single, contains(sandbox.path));
    },
  );

  test('skips a directory that does not exist', () async {
    final runner = _RecordingPermissionCommandRunner();
    final missing = '${sandbox.path}${Platform.pathSeparator}missing';

    final repaired = await LauncherPermissionHelper(
      commandRunner: runner,
    ).fixDirectory(missing);

    expect(repaired, isFalse);
    expect(runner.calls, isEmpty);
  });

  test('reports a non-zero icacls exit code', () async {
    final runner = _RecordingPermissionCommandRunner(exitCode: 5);

    expect(
      () => LauncherPermissionHelper(
        commandRunner: runner,
      ).fixDirectory(sandbox.path),
      throwsA(
        isA<LauncherPermissionError>()
            .having((error) => error.directory, 'directory', sandbox.path)
            .having((error) => error.exitCode, 'exitCode', 5),
      ),
    );
  });
}

class _RecordingPermissionCommandRunner
    implements ElevatedPermissionCommandRunner {
  _RecordingPermissionCommandRunner({this.exitCode = 0});

  final int exitCode;
  final List<({String program, List<String> args, int timeoutMs})> calls = [];

  @override
  Future<int> run({
    required String program,
    required List<String> args,
    required int timeoutMs,
  }) async {
    calls.add((program: program, args: args, timeoutMs: timeoutMs));
    return exitCode;
  }
}
