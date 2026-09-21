import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/utils/app_hive.dart';

void main() {
  late Directory sandbox;

  setUp(() async {
    sandbox = await Directory.systemTemp.createTemp('app_hive_test_');
    Hive.init(sandbox.path);
  });

  tearDown(() async {
    await Hive.close();
    if (await sandbox.exists()) await sandbox.delete(recursive: true);
  });

  test('compacts in the background once over the threshold', () async {
    // Same writes into a box that never compacts, for comparison.
    final control = await Hive.openBox(
      'control',
      compactionStrategy: (_, _) => false,
    );
    final box = await AppHive.openBox('app_conf');
    for (final b in [control, box]) {
      await b.put('keep', 1);
      // 100 overwrites of one key: 99 deleted entries, over the threshold.
      for (var i = 0; i < 100; i++) {
        await b.put('counter', i);
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final compacted = await File('${sandbox.path}/app_conf.hive').length();
    final uncompacted = await File('${sandbox.path}/control.hive').length();
    expect(compacted, lessThan(uncompacted));
    expect(box.get('counter'), 99);
    expect(box.get('keep'), 1);
  });

  test('repair keeps every config key and drops cache boxes', () async {
    final conf = await AppHive.openBox('app_conf');
    await conf.putAll({
      'install_id': 'abc',
      'vehicle_sorting': true,
      'localization_extensions': ['a.ini', 'b.ini'],
    });
    final cache = await AppHive.openBox(AppHive.cacheBoxes.first);
    await cache.put('zh_CN_data', 'x' * 1000);
    await Hive.close();
    await AppHive.openBox('app_conf');

    final repaired = await AppHive.repair();

    expect(repaired.get('install_id'), 'abc');
    expect(repaired.get('vehicle_sorting'), true);
    expect(repaired.get('localization_extensions'), ['a.ini', 'b.ini']);
    for (final name in AppHive.cacheBoxes) {
      expect(await Hive.boxExists(name), isFalse, reason: name);
    }
  });

  test('recognises a lock held by another instance', () {
    expect(
      AppHive.isLockedByAnotherInstance(
        FileSystemException('lock failed', r'C:\db\app_conf.lock'),
      ),
      isTrue,
    );
    expect(
      AppHive.isLockedByAnotherInstance(
        FileSystemException('rename failed', r'C:\db\app_conf.hive'),
      ),
      isFalse,
    );
    expect(AppHive.isLockedByAnotherInstance(StateError('x')), isFalse);
  });
}
