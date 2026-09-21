import 'dart:async';
import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';

import 'log.dart';

/// Opens and maintains the app's Hive boxes.
///
/// Hive compacts a box inside `put`/`delete` once enough overwritten entries
/// pile up, and a failed compaction is rethrown to that write. Compaction ends
/// with a rename over the `.hive` file, which fails on some machines (a file
/// scanner holding the file open, MSIX file virtualisation), and then every
/// later write fails too because the count of deleted entries is never reset.
/// Install flows awaited such writes without handling errors, so the UI simply
/// did nothing until the app data was wiped.
///
/// Boxes opened here never compact inside a write. Once Hive's usual threshold
/// is crossed, compaction is scheduled separately and its failure is only
/// logged, at most once per box per session.
class AppHive {
  AppHive._();

  /// Boxes that only cache downloaded data; [repair] drops them.
  static const cacheBoxes = [
    "community_input_method_data",
    "localization_extension_data",
    "web_localization_cache_data",
  ];

  static const _confBox = "app_conf";

  /// Boxes with a compaction scheduled or failed this session.
  static final _compactionScheduled = <String>{};

  /// The database folder under [applicationSupportDir].
  ///
  /// Store (MSIX) builds use their own folder: under MSIX, files that already
  /// exist in the real %APPDATA% (e.g. from a Dev build) are modified in place,
  /// while files created later (compaction output, new lock files) go to the
  /// package's private copy, so sharing one folder mixes both.
  static String dbDirFor(String applicationSupportDir) =>
      ConstConf.isMSE
          ? "$applicationSupportDir/db_store"
          : "$applicationSupportDir/db";

  static Future<Box<E>> openBox<E>(String name) {
    return Hive.openBox<E>(
      name,
      compactionStrategy: (entries, deletedEntries) {
        // Same threshold as Hive's defaultCompactionStrategy.
        if (deletedEntries > 60 &&
            deletedEntries / entries > 0.15 &&
            _compactionScheduled.add(name)) {
          Timer.run(() => _compact(name));
        }
        return false;
      },
    );
  }

  static Future<void> _compact(String name) async {
    if (!Hive.isBoxOpen(name)) {
      _compactionScheduled.remove(name);
      return;
    }
    try {
      await Hive.box(name).compact();
      _compactionScheduled.remove(name);
    } catch (e, s) {
      // Stays in the set, so it is not retried until the next launch.
      dPrint("[AppHive] compacting $name failed: $e\n$s");
    }
  }

  /// Whether [error] means another running instance holds the database.
  static bool isLockedByAnotherInstance(Object error) =>
      error is FileSystemException &&
      (error.path ?? "").toLowerCase().endsWith(".lock");

  /// Store builds: copy the database from the shared folder used before
  /// [dbDirFor] split it, once, so settings survive the move.
  static Future<void> migrateStoreDb(String applicationSupportDir) async {
    if (!ConstConf.isMSE) return;
    final target = Directory(dbDirFor(applicationSupportDir));
    final legacy = Directory("$applicationSupportDir/db");
    try {
      if (await target.exists() || !await legacy.exists()) return;
      final staging = Directory("${target.path}.migrating");
      if (await staging.exists()) await staging.delete(recursive: true);
      await staging.create(recursive: true);
      await for (final entity in legacy.list()) {
        if (entity is File && entity.path.toLowerCase().endsWith(".hive")) {
          final name = entity.uri.pathSegments.last;
          await entity.copy("${staging.path}/$name");
        }
      }
      await staging.rename(target.path);
      dPrint("[AppHive] migrated store database to ${target.path}");
    } catch (e, s) {
      // Start with a fresh database rather than failing to launch.
      dPrint("[AppHive] migrating store database failed: $e\n$s");
    }
  }

  /// Rebuilds the config box (keeping every key) and deletes [cacheBoxes],
  /// for a database that keeps failing writes. Returns the new config box.
  ///
  /// Throws the first error after attempting every step; the config box is
  /// always left open.
  static Future<Box> repair() async {
    Object? firstError;
    StackTrace? firstStack;
    void record(Object e, StackTrace s, String step) {
      dPrint("[AppHive] repair: $step failed: $e\n$s");
      firstError ??= e;
      firstStack ??= s;
    }

    for (final name in cacheBoxes) {
      try {
        if (Hive.isBoxOpen(name)) {
          await Hive.box(name).deleteFromDisk();
        } else {
          await Hive.deleteBoxFromDisk(name);
        }
        _compactionScheduled.remove(name);
      } catch (e, s) {
        record(e, s, "deleting $name");
      }
    }

    final conf = await openBox(_confBox);
    final data = Map<dynamic, dynamic>.of(conf.toMap());
    try {
      await conf.deleteFromDisk();
      _compactionScheduled.remove(_confBox);
    } catch (e, s) {
      record(e, s, "deleting $_confBox");
    }
    // If the delete failed the old file is still there and reopens intact.
    final fresh = await openBox(_confBox);
    if (fresh.isEmpty && data.isNotEmpty) {
      await fresh.putAll(data);
    }
    dPrint("[AppHive] repair: rebuilt $_confBox with ${fresh.length} keys");

    if (firstError != null) {
      Error.throwWithStackTrace(firstError!, firstStack!);
    }
    return fresh;
  }
}
