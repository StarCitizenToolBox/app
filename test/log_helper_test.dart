import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/utils/app_hive.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

/// A line of the RSI Launcher's log.log, where paths are JSON-escaped.
String _launcherLine(String path) =>
    '{ "t":"2025-06-01 09:00:00.000", "[main][info] ": "[Launcher::launch] Launching Star Citizen '
    'from (${path.replaceAll(r'\', r'\\')})" },';

void main() {
  setUpAll(() async => S.load(const Locale('en')));

  group('getGameInstallPath', () {
    late Directory sandbox;

    setUp(() async {
      // Resolved so that Windows 8.3 short names (C:\Users\RUNNER~1) are expanded.
      sandbox = Directory((await Directory.systemTemp.createTemp('log_helper_test_')).resolveSymbolicLinksSync());
      Hive.init(sandbox.path);
    });

    tearDown(() async {
      await Hive.close();
      if (await sandbox.exists()) await sandbox.delete(recursive: true);
    });

    Future<String> install(String channel) async {
      final dir = Directory('${sandbox.path}${Platform.pathSeparator}StarCitizen${Platform.pathSeparator}$channel');
      await Directory('${dir.path}/Bin64').create(recursive: true);
      await File('${dir.path}/Bin64/StarCitizen.exe').writeAsString('');
      await File('${dir.path}/Data.p4k').writeAsString('');
      return dir.path;
    }

    test(
      'finds every channel in the launcher log, JSON-escaped or not, once',
      () async {
        const live = r'D:\Games\Roberts Space Industries\StarCitizen\LIVE';
        const ptu = r'D:\Games\Roberts Space Industries\StarCitizen\PTU';
        final paths = await SCLoggerHelper.getGameInstallPath(
          [
            'header',
            _launcherLine(live),
            'Launching from $ptu',
            _launcherLine(live.replaceAll(r'\', '/').toLowerCase()),
            _launcherLine(r'D:\Games\Other\LIVE'),
          ],
          checkExists: false,
          withVersion: ['LIVE', 'PTU'],
        );

        expect(paths, [live.toLowerCase(), ptu]);
      },
      skip: Platform.isWindows ? false : 'Windows path format',
    );

    test(
      'finds Wine paths in the launcher log',
      () async {
        const live = '/home/user/Games/star-citizen/drive_c/Program Files/Roberts Space Industries/StarCitizen/LIVE';
        final paths = await SCLoggerHelper.getGameInstallPath(
          ['header', 'Launching from (Z:$live)'],
          checkExists: false,
        );

        expect(paths, [live]);
      },
      skip: Platform.isWindows ? 'Unix path format' : false,
    );

    test('only keeps installs with the game files, and finds sibling channels', () async {
      final live = await install('LIVE');
      final ptu = await install('PTU');
      await Directory('${sandbox.path}/StarCitizen/EPTU').create(recursive: true); // no game files
      await Directory('${sandbox.path}/StarCitizen/TECH-PREVIEW/Bin64').create(recursive: true);
      await File('${sandbox.path}/StarCitizen/TECH-PREVIEW/Bin64/StarCitizen.exe').writeAsString('');

      final paths = await SCLoggerHelper.getGameInstallPath(
        ['header', _launcherLine(live), _launcherLine(live.replaceAll('LIVE', 'EPTU'))],
        withVersion: ['LIVE', 'PTU', 'EPTU', 'TECH-PREVIEW'],
      );

      expect(paths, [live, ptu]);
    });

    test('uses the custom game path when the launcher log has nothing', () async {
      final live = await install('LIVE');
      final ptu = await install('PTU');
      final conf = await AppHive.openBox('app_conf');
      await conf.put('custom_game_path', '${sandbox.path}${Platform.pathSeparator}StarCitizen');

      final paths = await SCLoggerHelper.getGameInstallPath([], withVersion: ['LIVE', 'PTU']);

      expect(paths, [live, ptu]);
    });

    test('nothing installed, nothing logged', () async {
      expect(await SCLoggerHelper.getGameInstallPath(['header', 'unrelated']), isEmpty);
    });

    test(
      'a path on the first log line is found',
      () async {
        final live = await install('LIVE');
        expect(await SCLoggerHelper.getGameInstallPath([_launcherLine(live)]), [live]);
      },
    );

    test(
      'a path with non-ASCII folder names is found',
      () async {
        // Each platform has its own path regex; exercise the one in use.
        final live = Platform.isWindows
            ? r'D:\游戏\Roberts Space Industries\StarCitizen\LIVE'
            : '/home/玩家/游戏/drive_c/Program Files/Roberts Space Industries/StarCitizen/LIVE';
        final line = Platform.isWindows ? _launcherLine(live) : 'Launching from (Z:$live)';
        final paths = await SCLoggerHelper.getGameInstallPath(['header', line], checkExists: false);
        expect(paths, [live]);
      },
    );
  });

  group('getGameChannelID', () {
    tearDown(() => AppConf.setNetworkChannels(null));

    test('matches the last path segment, case-insensitively', () {
      expect(SCLoggerHelper.getGameChannelID('D:/Games/StarCitizen/LIVE'), 'LIVE');
      expect(SCLoggerHelper.getGameChannelID(r'D:\Games\StarCitizen\ptu'), 'PTU');
      expect(SCLoggerHelper.getGameChannelID('D:/Games/StarCitizen/EPTU'), 'EPTU');
      expect(SCLoggerHelper.getGameChannelID('D:/Games/StarCitizen/4.0_PREVIEW'), '4.0_PREVIEW');
      expect(SCLoggerHelper.getGameChannelID('D:/Games/StarCitizen/TECH-PREVIEW'), 'TECH-PREVIEW');
    });

    test('a channel name elsewhere in the path is not a match', () {
      expect(SCLoggerHelper.getGameChannelID('D:/LIVE/StarCitizen/LIVE_backup'), 'UNKNOWN');
      expect(SCLoggerHelper.getGameChannelID('D:/Games/StarCitizen/XPTU'), 'UNKNOWN');
    });

    test('follows the channel list from the server', () {
      AppConf.setNetworkChannels(['LIVE', 'PTU', 'NEW-CHANNEL']);
      expect(SCLoggerHelper.getGameChannelID('D:/Games/StarCitizen/new-channel'), 'NEW-CHANNEL');
      expect(SCLoggerHelper.getGameChannelID('D:/Games/StarCitizen/EPTU'), 'UNKNOWN');
    });
  });

  group('getGameRunningLogInfo', () {
    test('reports the most recent recognised cause', () {
      final info = SCLoggerHelper.getGameRunningLogInfo([
        '<2025-06-01T09:00:00.000Z> Log started',
        '<2025-06-01T09:10:00.000Z> DXGI_ERROR_DEVICE_REMOVED',
        '<2025-06-01T09:20:00.000Z> STATUS_CRYENGINE_OUT_OF_SYSMEM',
        '<2025-06-01T09:20:01.000Z> shutting down',
      ]);

      expect(info?.key, S.current.doctor_game_error_low_memory);
      expect(info?.value, S.current.doctor_game_error_low_memory_info);
    });

    test('recognises a damaged Data.p4k and GPU memory exhaustion', () {
      expect(
        SCLoggerHelper.getGameRunningLogInfo([
          'start',
          'Please use the option to verify the content of the Data.p4k file',
        ])?.key,
        S.current.doctor_game_error_game_damaged_p4k_file,
      );
      expect(
        SCLoggerHelper.getGameRunningLogInfo(['start', 'OUTOFMEMORY Direct3D could not allocate'])?.key,
        S.current.doctor_game_error_low_gpu_memory,
      );
    });

    test('unrecognised but known-bad markers are passed through raw', () {
      expect(SCLoggerHelper.getGameRunningLogInfo(['start', 'Exception Unknown at 0x0'])?.value, 'Exception Unknown');
    });

    test('a clean log has no cause', () {
      expect(SCLoggerHelper.getGameRunningLogInfo(['start', 'everything fine']), isNull);
      expect(SCLoggerHelper.getGameRunningLogInfo([]), isNull);
    });
  });
}
