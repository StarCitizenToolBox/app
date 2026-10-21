import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/common/helper/yearly_report_analyzer.dart';

// Times are local wall-clock times (the report reasons in local time) written to the
// log as UTC, the way Game.log stores them. June-August avoids DST transitions.
String _ts(DateTime local) => '<${local.toUtc().toIso8601String()}>';

String _login(DateTime t, String name) =>
    '${_ts(t)} [Notice] <AccountLoginCharacterStatus_Character> Character: createdAt 1 - updatedAt 1 - '
    'geid 2 - accountId 3 - name $name - state STATE_CURRENT [Team_GameServices][Login]';

String _death(DateTime t, String victim) =>
    "${_ts(t)} [Notice] <[ActorState] Dead> [ACTOR STATE][SSCActorStateCPC::UpdateActorStateBasedOnUnconsciousness] "
    "Actor '$victim' [200000000001] ejected from zone 'ANVL_Hornet_F7A_Mk2_3467069517923' [3467069517923] "
    "to zone 'OOC_Stanton_1_Hurston' [1] due to previous zone being in a destroyed state [Team_ActorFeatures][Actor]";

String _legacyKill(DateTime t, String victim, String killer, String damage) =>
    "${_ts(t)} [Notice] <Actor Death> CActor::Kill: '$victim' [200000000002] in zone 'OOC_Stanton_1_Hurston' "
    "killed by '$killer' [200000000001] using 'KLWE_LaserRepeater_S3' [Class unknown] with damage type '$damage' "
    "from direction x: 0, y: 0, z: 0 [Team_ActorFeatures][Actor]";

String _destruction(DateTime t, String vehicle, String causedBy, {int to = 1}) =>
    "${_ts(t)} [Notice] <Vehicle Destruction> CVehicle::OnAdvanceDestroyLevel: Vehicle '$vehicle' [1] "
    "in zone 'OOC_Stanton_1_Hurston' [pos x: 1, y: 2, z: 3] driven by '$causedBy' [1] "
    "advanced from destroy level ${to - 1} to $to caused by '$causedBy' [1] with 'Combat' [Team_VehicleFeatures][Vehicle]";

String _control(DateTime t, String vehicle) =>
    "${_ts(t)} [Notice] <Vehicle Control Flow> CVehicleMovementBase::SetDriver: Local client node [1] "
    "granted control token for '$vehicle' [1] [Team_VehicleFeatures][Vehicle]";

String _location(DateTime t, String location) =>
    '${_ts(t)} [Notice] <RequestLocationInventory> Player[Alpha] requested inventory for Location[$location] '
    '[Team_CoreGameplayFeatures][Inventory]';

String _line(DateTime t, String text) => '${_ts(t)} $text';

const _crash = 'Cloud Imperium Games public crash handler';

DateTime _at(int month, int day, int hour, [int minute = 0, int second = 0]) =>
    DateTime(2025, month, day, hour, minute, second);

// 06-01 09:00-11:00. Kills, a debounced death, destructions, piloting and locations.
final _s1 = [
  'Log started on Sun Jun 01 09:00:00 2025',
  _line(_at(6, 1, 9), '[Notice] <Init> Game started'),
  _login(_at(6, 1, 9, 1), 'Alpha'),
  _control(_at(6, 1, 9, 5), 'ANVL_Hornet_F7A_Mk2_3467069517923'),
  _control(_at(6, 1, 9, 6), 'Default_1234'),
  _location(_at(6, 1, 9, 10), 'Stanton1_Lorville'),
  _location(_at(6, 1, 9, 11), 'Stanton1_Lorville'),
  _location(_at(6, 1, 9, 12), 'Stanton2_Orison_1234567'),
  _destruction(_at(6, 1, 9, 59, 58), 'ANVL_Hornet_F7A_Mk2_3467069517923', 'Alpha'),
  _destruction(_at(6, 1, 9, 59, 59), 'ANVL_Hornet_F7A_Mk2_3467069517923', 'Alpha', to: 2),
  _destruction(_at(6, 1, 9, 59, 59), 'DRAK_Cutlass_Black_42', 'Someone'),
  _death(_at(6, 1, 10), 'Alpha'),
  _death(_at(6, 1, 10, 0, 1), 'Alpha'), // the same death logged twice
  _legacyKill(_at(6, 1, 10, 30), 'Bravo', 'Alpha', 'Bullet'),
  _line(_at(6, 1, 11), '[Notice] <FastShutdown> [CIG] CCIGBroker::FastShutdown'),
];

// 06-02 22:00 - 06-03 02:30 (4h30m), crashes. Same account, differently cased.
final _s2 = [
  _line(_at(6, 2, 22), '[Notice] <Init> Game started'),
  _login(_at(6, 2, 22, 1), 'alpha'),
  _line(_at(6, 3, 2, 30), _crash),
];

// 06-03 06:00-06:03, too short to be the shortest session. Also logs an over-long handle
// and something that is not a handle. As LIVE/Game.log it is read first.
final _s3 = [
  _line(_at(6, 3, 6), '[Notice] <Init> Game started'),
  _login(_at(6, 3, 6, 1), 'Alpha'),
  _login(_at(6, 3, 6, 2), 'ThisHandleIsTooLong'),
  _login(_at(6, 3, 6, 2, 30), 'some.file'),
  _line(_at(6, 3, 6, 3), '[Notice] <FastShutdown> [CIG] CCIGBroker::FastShutdown'),
];

// 2024-12-31 20:00-23:00, crashes; counts toward totals only.
final _s5 = [
  _line(DateTime(2024, 12, 31, 20), '[Notice] <Init> Game started'),
  _login(DateTime(2024, 12, 31, 20, 1), 'Alpha'),
  _location(DateTime(2024, 12, 31, 21), 'Pyro'),
  _death(DateTime(2024, 12, 31, 21, 30), 'Alpha'),
  _line(DateTime(2024, 12, 31, 23), _crash),
];

// 06-10 20:00-20:30. A suicide logged in both formats, then a legacy-only death.
final _s6 = [
  _line(_at(6, 10, 20), '[Notice] <Init> Game started'),
  _login(_at(6, 10, 20, 1), 'Alpha'),
  _location(_at(6, 10, 20, 2), 'Stanton2_Orison'),
  _location(_at(6, 10, 20, 3), 'Stanton2_Orison'),
  _location(_at(6, 10, 20, 4), 'ArcCorp_12345'),
  _destruction(_at(6, 10, 20, 5), 'PU_Pirate_Gladius_99', 'Alpha'),
  _death(_at(6, 10, 20, 10), 'Alpha'),
  _legacyKill(_at(6, 10, 20, 10, 1), 'Alpha', 'Alpha', 'Suicide'),
  _legacyKill(_at(6, 10, 20, 20), 'Alpha', 'Bravo', 'Bullet'),
  _line(_at(6, 10, 20, 30), '[Notice] <FastShutdown> [CIG] CCIGBroker::FastShutdown'),
];

// 08-05 12:00-13:00 on another account.
final _s7 = [
  _line(_at(8, 5, 12), '[Notice] <Init> Game started'),
  _login(_at(8, 5, 12, 1), 'Bravo'),
  _control(_at(8, 5, 12, 5), 'DRAK_Cutlass_Black_123456789'),
  _control(_at(8, 5, 12, 6), 'DRAK_Cutlass_Black_123456789'),
  _destruction(_at(8, 5, 12, 30), 'DRAK_Cutlass_Black_123456789', 'Bravo'),
  _line(_at(8, 5, 13), '[Notice] <FastShutdown> [CIG] CCIGBroker::FastShutdown'),
];

void main() {
  late Directory sandbox;

  setUp(() async => sandbox = await Directory.systemTemp.createTemp('yearly_report_analyzer_test_'));

  tearDown(() async {
    if (await sandbox.exists()) await sandbox.delete(recursive: true);
  });

  Future<void> write(String relativePath, List<String> lines) async {
    final file = File('${sandbox.path}/$relativePath');
    await file.parent.create(recursive: true);
    await file.writeAsString(lines.join('\r\n'));
  }

  group('a year across LIVE and PTU with backups', () {
    late YearlyReportData report;

    setUp(() async {
      await write('LIVE/logbackups/Game Build(1) 01 Jun 25.log', _s1);
      await write('LIVE/logbackups/Game Build(2) 02 Jun 25.log', _s2);
      await write('LIVE/logbackups/Game Build(0) 31 Dec 24.log', _s5);
      await write('LIVE/logbackups/notes.txt', _s6); // not a .log file
      await write('LIVE/Game.log', _s3);
      await write('PTU/logbackups/Game Build(1) 10 Jun 25.log', _s6);
      await write('PTU/logbackups/copy of 01 Jun 25.log', _s1); // same session copied over
      await write('PTU/Game.log', _s7);

      report = await YearlyReportAnalyzer.generateReport([
        '${sandbox.path}/LIVE',
        '${sandbox.path}/PTU',
        '${sandbox.path}/EPTU', // not installed
      ], 2025);
    });

    test('counts launches and play time, dropping the duplicated session', () {
      expect(report.totalLaunchCount, 6);
      expect(report.totalPlayTime, const Duration(hours: 11, minutes: 3));
      expect(report.yearlyLaunchCount, 5);
      expect(report.yearlyPlayTime, const Duration(hours: 8, minutes: 3));
      expect(report.yearlyFirstLaunchTime, _at(6, 1, 9));
    });

    test('splits crashes by the year they happened in', () {
      expect(report.totalCrashCount, 2);
      expect(report.yearlyCrashCount, 1);
    });

    test('session extremes ignore sessions under five minutes', () {
      expect(report.longestSession, const Duration(hours: 4, minutes: 30));
      expect(report.longestSessionDate, _at(6, 2, 22));
      expect(report.shortestSession, const Duration(minutes: 30));
      expect(report.shortestSessionDate, _at(6, 10, 20));
      // (2h + 4h30m + 3m + 30m + 1h) / 5
      expect(report.averageSessionTime, const Duration(minutes: 96, seconds: 36));
    });

    test('earliest start is from 05:00 on, latest end is up to 04:59', () {
      expect(report.earliestPlayDate, _at(6, 3, 6));
      expect(report.latestPlayDate, _at(6, 3, 2, 30));
    });

    test('vehicles: own destructions without ids, PU ships and other players excluded', () {
      expect(report.yearlyVehicleDestructionCount, 3);
      expect(report.mostDestroyedVehicle, 'ANVL_Hornet_F7A_Mk2');
      expect(report.mostDestroyedVehicleCount, 2);
      expect(report.vehiclePilotedDetails, {'ANVL_Hornet_F7A_Mk2': 1, 'DRAK_Cutlass_Black': 2});
      expect(report.mostPilotedVehicle, 'DRAK_Cutlass_Black');
      expect(report.mostPilotedVehicleCount, 2);
    });

    test('kills and deaths merge the two log formats without double counting', () {
      expect(report.yearlyKillCount, 1);
      expect(report.yearlyDeathCount, 3);
      expect(report.yearlySelfKillCount, 1);
    });

    test('accounts merge case-insensitively and skip invalid handles', () {
      expect(report.accountSessionDetails, {'Alpha': 5, 'Bravo': 1});
      expect(report.accountCount, 2);
      expect(report.mostPlayedAccount, 'Alpha');
      expect(report.mostPlayedAccountSessionCount, 5);
    });

    test('locations drop long numeric id suffixes and rank by visits', () {
      expect(report.locationDetails, {'Stanton1_Lorville': 2, 'Stanton2_Orison': 3, 'ArcCorp_12345': 1});
      expect(report.topLocations.map((e) => e.key), ['Stanton2_Orison', 'Stanton1_Lorville', 'ArcCorp_12345']);
    });

    test('months and streaks', () {
      expect(report.mostPlayedMonth, 6);
      expect(report.mostPlayedMonthCount, 4);
      expect(report.leastPlayedMonth, 8);
      expect(report.leastPlayedMonthCount, 1);

      expect(report.longestPlayStreak, 3);
      expect(report.playStreakStartDate, DateTime(2025, 6, 1));
      expect(report.playStreakEndDate, DateTime(2025, 6, 3));

      expect(report.longestOfflineStreak, 55);
      expect(report.offlineStreakStartDate, DateTime(2025, 6, 11));
      expect(report.offlineStreakEndDate, DateTime(2025, 8, 4));
    });

    test('toJson carries UTC timestamps that round-trip', () {
      final json = report.toJson();

      expect(json['yearlyFirstLaunchTimeUtc'], _at(6, 1, 9).millisecondsSinceEpoch);
      expect(json['longestSessionMs'], const Duration(hours: 4, minutes: 30).inMilliseconds);
      expect(json['topLocations'], [
        {'location': 'Stanton2_Orison', 'count': 3},
        {'location': 'Stanton1_Lorville', 'count': 2},
        {'location': 'ArcCorp_12345', 'count': 1},
      ]);
      expect(json['timezoneOffsetMinutes'], DateTime.now().timeZoneOffset.inMinutes);
    });
  });

  test('no installs yields an empty report', () async {
    final report = await YearlyReportAnalyzer.generateReport(['${sandbox.path}/missing'], 2025);

    expect(report.totalLaunchCount, 0);
    expect(report.yearlyPlayTime, Duration.zero);
    expect(report.averageSessionTime, isNull);
    expect(report.mostPlayedMonth, isNull);
    expect(report.longestPlayStreak, 0);
    expect(report.topLocations, isEmpty);
  });

  test('a log without timestamps counts as a launch but not a session', () async {
    await write('LIVE/Game.log', ['Log started on Sun Jun 01 09:00:00 2025', 'garbage']);

    final report = await YearlyReportAnalyzer.generateReport(['${sandbox.path}/LIVE'], 2025);

    expect(report.totalLaunchCount, 1);
    expect(report.yearlyLaunchCount, 0);
    expect(report.totalPlayTime, Duration.zero);
  });

  test('a session started on New Year\'s Eve belongs to the year it started in', () async {
    await write('LIVE/Game.log', [
      _line(DateTime(2024, 12, 31, 23), '[Notice] <Init> Game started'),
      _login(DateTime(2024, 12, 31, 23, 1), 'Alpha'),
      _death(DateTime(2025, 1, 1, 0, 30), 'Alpha'),
      _line(DateTime(2025, 1, 1, 1), _crash),
    ]);

    final report2024 = await YearlyReportAnalyzer.generateReport(['${sandbox.path}/LIVE'], 2024);
    final report2025 = await YearlyReportAnalyzer.generateReport(['${sandbox.path}/LIVE'], 2025);

    expect(report2024.yearlyLaunchCount, 1);
    expect(report2024.yearlyPlayTime, const Duration(hours: 2));
    expect(report2025.yearlyLaunchCount, 0);
    // Events and crashes are dated by their own line, not by the session start.
    expect(report2025.yearlyDeathCount, 1);
    expect(report2025.yearlyCrashCount, 1);
    expect(report2024.yearlyCrashCount, 0);
  });
}
