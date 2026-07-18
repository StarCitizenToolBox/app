import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:starcitizen_doctor/ui/home/dialogs/home_p4k_update_dialog_ui.dart';

void main() {
  late Directory sandbox;

  setUp(() async {
    sandbox = await Directory.systemTemp.createTemp('p4k_post_install_test_');
  });

  tearDown(() async {
    if (await sandbox.exists()) await sandbox.delete(recursive: true);
  });

  test('removes the loose files ledger after installation', () async {
    final ledger = File(p.join(sandbox.path, '.LooseFiles.txt'));
    await ledger.writeAsString('loose files');
    final logs = <String>[];

    final removed = await removeLooseFilesLedger(sandbox.path, log: logs.add);

    expect(removed, isTrue);
    expect(await ledger.exists(), isFalse);
    expect(logs.single, contains(ledger.path));
  });

  test('skips a missing loose files ledger', () async {
    final logs = <String>[];

    final removed = await removeLooseFilesLedger(sandbox.path, log: logs.add);

    expect(removed, isFalse);
    expect(logs, isEmpty);
  });
}
