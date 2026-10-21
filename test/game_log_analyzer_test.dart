import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:starcitizen_doctor/common/helper/game_log_analyzer.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

// Lines in the shape Star Citizen writes them to Game.log.
const _login =
    '<2025-01-12T10:01:00.000Z> [Notice] <AccountLoginCharacterStatus_Character> Character: '
    'createdAt 1736676000000 - updatedAt 1736676000000 - geid 200000000001 - accountId 1000001 - '
    'name TestPilot - state STATE_CURRENT [Team_GameServices][Login]';
const _loading = '<2025-01-12T10:02:00.000Z> Loading screen for PU : SC_Frontend closed after 42.50 seconds';
const _location1 =
    '<2025-01-12T10:05:00.000Z> [Notice] <RequestLocationInventory> Player[TestPilot] requested inventory '
    'for Location[Stanton1_Lorville] [Team_CoreGameplayFeatures][Inventory]';
const _softDestruction =
    "<2025-01-12T10:20:00.000Z> [Notice] <Vehicle Destruction> CVehicle::OnAdvanceDestroyLevel: "
    "Vehicle 'ANVL_Hornet_F7A_Mk2_3467069517923' [3467069517923] in zone 'OOC_Stanton_1_Hurston' "
    "[pos x: 1, y: 2, z: 3 vel x: 0, y: 0, z: 0] driven by 'TestPilot' [200000000001] "
    "advanced from destroy level 0 to 1 caused by 'TestPilot' [200000000001] with 'Collision' "
    "[Team_VehicleFeatures][Vehicle]";
const _hardDestruction =
    "<2025-01-12T10:20:01.000Z> [Notice] <Vehicle Destruction> CVehicle::OnAdvanceDestroyLevel: "
    "Vehicle 'ANVL_Hornet_F7A_Mk2_3467069517923' [3467069517923] in zone 'OOC_Stanton_1_Hurston' "
    "[pos x: 1, y: 2, z: 3 vel x: 0, y: 0, z: 0] driven by 'TestPilot' [200000000001] "
    "advanced from destroy level 1 to 2 caused by 'TestPilot' [200000000001] with 'Collision' "
    "[Team_VehicleFeatures][Vehicle]";
const _otherDestruction =
    "<2025-01-12T10:25:00.000Z> [Notice] <Vehicle Destruction> CVehicle::OnAdvanceDestroyLevel: "
    "Vehicle 'DRAK_Cutlass_Black_123456789' [123456789] in zone 'OOC_Stanton_1_Hurston' "
    "[pos x: 1, y: 2, z: 3 vel x: 0, y: 0, z: 0] driven by 'Someone' [200000000002] "
    "advanced from destroy level 0 to 1 caused by 'Someone' [200000000002] with 'Combat' "
    "[Team_VehicleFeatures][Vehicle]";
const _collision =
    '<2025-01-12T10:19:59.000Z> [Notice] <FatalCollision> Fatal Collision occured for vehicle '
    'ANVL_Hornet_F7A_Mk2_3467069517923 [Part: body, Pos: x: 1, y: 2, z: 3, Zone: OOC_Stanton_1_Hurston, '
    'PlayerPilot: 1] after hitting entity: Asteroid [Id: 1] [Part: rock]. Distance: 12.345678 '
    '[Team_VehicleFeatures][Collision]';
const _ownDeath =
    "<2025-01-12T10:20:02.000Z> [Notice] <[ActorState] Dead> [ACTOR STATE][SSCActorStateCPC::"
    "UpdateActorStateBasedOnUnconsciousness] Actor 'TestPilot' [200000000001] ejected from zone "
    "'ANVL_Hornet_F7A_Mk2_3467069517923' [3467069517923] to zone 'OOC_Stanton_1_Hurston' [1] due to "
    "previous zone being in a destroyed state [Team_ActorFeatures][Actor]";
const _otherDeath =
    "<2025-01-12T10:40:00.000Z> [Notice] <[ActorState] Dead> [ACTOR STATE][SSCActorStateCPC::"
    "UpdateActorStateBasedOnUnconsciousness] Actor 'Someone' [200000000002] ejected from zone "
    "'DRAK_Cutlass_Black_123456789' [123456789] to zone 'OOC_Stanton_1_Hurston' [1] due to "
    "previous zone being in a destroyed state [Team_ActorFeatures][Actor]";
const _location2 =
    '<2025-01-12T11:00:00.000Z> [Notice] <RequestLocationInventory> Player[TestPilot] requested inventory '
    'for Location[Stanton2_Orison] [Team_CoreGameplayFeatures][Inventory]';
const _shutdown =
    '<2025-01-12T11:30:00.000Z> [Notice] <FastShutdown> [CIG] CCIGBroker::FastShutdown [Team_Engine][Shutdown]';

final _session = [
  'Log started on Sun Jan 12 10:00:00 2025',
  '<2025-01-12T10:00:00.000Z> [Notice] <Legacy login response> [CIG-net] User Login Success [Team_GameServices]',
  _login,
  _loading,
  _location1,
  _collision,
  _softDestruction,
  _hardDestruction,
  _ownDeath,
  _otherDestruction,
  _otherDeath,
  _location2,
  _shutdown,
];

String _fmt(String iso) => DateFormat('yyyy-MM-dd HH:mm:ss:SSS').format(DateTime.parse(iso).toLocal());

void main() {
  late Directory sandbox;

  // The app gets date symbols from its localization delegates; load them here.
  setUpAll(() async {
    await S.load(const Locale('en'));
    await initializeDateFormatting('en');
  });

  setUp(() async => sandbox = await Directory.systemTemp.createTemp('game_log_analyzer_test_'));

  tearDown(() async {
    if (await sandbox.exists()) await sandbox.delete(recursive: true);
  });

  Future<(List<LogAnalyzeLineData>, LogAnalyzeStatistics)> analyze(
    List<String> lines, {
    String eol = '\n',
    DateTime? startTime,
  }) async {
    final file = File('${sandbox.path}/Game.log');
    await file.writeAsString(lines.join(eol));
    return GameLogAnalyzer.analyzeLogFile(file, startTime: startTime);
  }

  test('a missing log file yields a single error entry', () async {
    final (results, stats) = await GameLogAnalyzer.analyzeLogFile(File('${sandbox.path}/Game.log'));

    expect(results.map((e) => e.type), ['error']);
    expect(stats.gameStartTime, isNull);
    expect(stats.gameCrashLineNumber, -1);
  });

  test('an empty log yields no events and no session', () async {
    final (results, stats) = await analyze([]);

    expect(results, isEmpty);
    expect(stats.playerName, '');
    expect(stats.gameStartTime, isNull);
    expect(stats.latestLocation, isNull);
  });

  test('parses each event of a session in order', () async {
    final (results, _) = await analyze(_session);

    expect(results.map((e) => e.type), [
      'info', // game start
      'player_login',
      'info', // loading screen
      'request_location_inventory',
      'fatal_collision',
      'vehicle_destruction',
      'vehicle_destruction',
      'actor_death',
      'vehicle_destruction',
      'actor_death',
      'request_location_inventory',
      'info', // shutdown
      'statistics', // kill summary
      'statistics', // play time
    ]);
    expect(results.first.tag, 'game_start');
  });

  test('extracts the fields of each event', () async {
    final (results, _) = await analyze(_session);
    LogAnalyzeLineData first(String type) => results.firstWhere((e) => e.type == type);

    final login = first('player_login');
    expect(login.playerName, 'TestPilot');
    expect(login.dateTime, _fmt('2025-01-12T10:01:00.000Z'));

    expect(results[2].data, S.current.log_analyzer_mode_loading_time('PU', '42.50'));

    expect(
      first('fatal_collision').data,
      S.current.log_analyzer_collision_details(
        'OOC_Stanton_1_Hurston',
        '✅',
        'Asteroid',
        'ANVL_Hornet_F7A_Mk2_3467069517923',
        '12.35',
      ),
    );

    final destructions = results.where((e) => e.type == 'vehicle_destruction').toList();
    expect(
      destructions[0].data,
      S.current.log_analyzer_vehicle_damage_details(
        'ANVL_Hornet_F7A_Mk2_3467069517923',
        'OOC_Stanton_1_Hurston',
        '1',
        S.current.log_analyzer_soft_death,
        'TestPilot',
      ),
    );
    expect(destructions[1].data, contains(S.current.log_analyzer_disintegration));

    final death = first('actor_death');
    expect(death.victimId, 'TestPilot');
    expect(death.location, 'ANVL_Hornet_F7A_Mk2_3467069517923');
    expect(death.area, 'OOC_Stanton_1_Hurston');
    expect(death.dateTime, _fmt('2025-01-12T10:20:02.000Z'));

    expect(first('request_location_inventory').location, 'Stanton1_Lorville');
  });

  test('counts only the logged-in player\'s deaths and destructions', () async {
    final (results, stats) = await analyze(_session);

    expect(stats.playerName, 'TestPilot');
    expect(stats.deathCount, 1);
    expect(stats.vehicleDestructionCount, 1);
    expect(stats.vehicleDestructionCountHard, 1);
    expect(stats.latestLocation, 'Stanton2_Orison');
    expect(stats.gameStartTime, DateTime.parse('2025-01-12T10:00:00.000Z').toLocal());
    expect(
      results.firstWhere((e) => e.title == S.current.log_analyzer_kill_summary).data,
      S.current.log_analyzer_kill_death_suicide_count(0, 1, 0, 1, 1),
    );
  });

  test('play time spans the first to the last timestamped line', () async {
    final (results, _) = await analyze([..._session, 'Trailing line without a timestamp']);

    expect(
      results.firstWhere((e) => e.title == S.current.log_analyzer_play_time).data,
      S.current.log_analyzer_play_time_format(1, 30, 0),
    );
  });

  test('CRLF line endings parse the same', () async {
    final (results, stats) = await analyze(_session, eol: '\r\n');

    expect(stats.playerName, 'TestPilot');
    expect(stats.deathCount, 1);
    expect(stats.latestLocation, 'Stanton2_Orison');
    expect(results.where((e) => e.type == 'vehicle_destruction'), hasLength(3));
  });

  test('startTime limits counting but not player, start time or location lookup', () async {
    final (_, stats) = await analyze(_session, startTime: DateTime.parse('2025-01-12T10:30:00.000Z'));

    expect(stats.deathCount, 0);
    expect(stats.vehicleDestructionCount, 0);
    expect(stats.vehicleDestructionCountHard, 0);
    expect(stats.playerName, 'TestPilot');
    expect(stats.gameStartTime, DateTime.parse('2025-01-12T10:00:00.000Z').toLocal());
    expect(stats.latestLocation, 'Stanton2_Orison');
  });

  test('events before the player logs in are not attributed to them', () async {
    final (_, stats) = await analyze([_ownDeath, _softDestruction, _login]);

    expect(stats.playerName, 'TestPilot');
    expect(stats.deathCount, 0);
    expect(stats.vehicleDestructionCount, 0);
  });

  test('a crash collects the trailing lines and diagnoses them', () async {
    final lines = [
      ..._session.take(5),
      '<2025-01-12T10:06:00.000Z> Cloud Imperium Games public crash handler',
      'Exception: EXCEPTION_ACCESS_VIOLATION',
      '<2025-01-12T10:06:01.000Z> [Notice] <CrashHandler> writing crash dump',
    ];
    final (results, stats) = await analyze(lines);

    expect(stats.gameCrashLineNumber, 5);
    final crash = results.singleWhere((e) => e.type == 'game_crash');
    expect(crash.dateTime, _fmt('2025-01-12T10:06:01.000Z'));
    expect(crash.data, startsWith('<2025-01-12T10:06:00.000Z> Cloud Imperium Games public crash handler'));
    expect(crash.data, contains(S.current.log_analyzer_one_click_diagnosis_header));
    expect(crash.data, contains(S.current.doctor_game_error_generic_info));
  });

  test('a crash with no known cause says so', () async {
    final (results, _) = await analyze([
      ..._session.take(3),
      '<2025-01-12T10:06:00.000Z> Cloud Imperium Games public crash handler',
      'nothing recognisable here',
    ]);

    expect(results.singleWhere((e) => e.type == 'game_crash').data, contains(S.current.log_analyzer_no_crash_detected));
  });

  test('tolerates invalid UTF-8 and truncated lines', () async {
    final file = File('${sandbox.path}/Game.log');
    await file.writeAsBytes([
      ..._session.take(3).join('\n').codeUnits,
      ...'\n<2025-01-12T10:03:00.000Z> [Notice] <RequestLocationInventory> Player['.codeUnits,
      0xff, 0xfe, // invalid UTF-8
      ...'\n<2025-01-12T10:04:00.0'.codeUnits, // cut off mid-timestamp
    ]);
    final (results, stats) = await GameLogAnalyzer.analyzeLogFile(file);

    expect(stats.playerName, 'TestPilot');
    expect(stats.latestLocation, isNull);
    expect(results.where((e) => e.type == 'request_location_inventory'), isEmpty);
  });

  test('a re-login switches whose deaths are counted', () async {
    final (_, stats) = await analyze([
      _login,
      _ownDeath,
      _login.replaceAll('name TestPilot', 'name Someone'),
      _otherDeath,
      _ownDeath.replaceAll('10:20:02', '10:50:00'),
    ]);

    expect(stats.playerName, 'Someone');
    expect(stats.deathCount, 2);
  });

  test('handles with a hyphen are matched in full', () async {
    final (_, stats) = await analyze([
      _login.replaceAll('TestPilot', 'Test-Pilot'),
      _ownDeath.replaceAll('TestPilot', 'Test-Pilot'),
    ]);

    expect(stats.playerName, 'Test-Pilot');
    expect(stats.deathCount, 1);
  });

  test('removeVehicleId strips only the trailing entity id', () {
    expect(GameLogAnalyzer.removeVehicleId('ANVL_Hornet_F7A_Mk2_3467069517923'), 'ANVL_Hornet_F7A_Mk2');
    expect(GameLogAnalyzer.removeVehicleId('AEGS_Avenger_Titan'), 'AEGS_Avenger_Titan');
    expect(GameLogAnalyzer.removeVehicleId('RSI_Zeus_CL_2_99'), 'RSI_Zeus_CL_2');
  });
}
