import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/common/rust/api/p4k_upgrader_api.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/home_p4k_update_dialog_ui.dart';
import 'package:starcitizen_doctor/ui/home/p4k_source_session_coordinator.dart';

void main() {
  const coordinator = P4kSourceSessionCoordinator();

  test('cancel ends before path/provider/login/task side effects', () async {
    var pathCalls = 0;
    var providerCalls = 0;
    var loginCalls = 0;
    var taskCalls = 0;
    await coordinator.open(
      selectSource: () async => null,
      openOfficial: () async {
        pathCalls++;
        loginCalls++;
        taskCalls++;
      },
      openCommunityMirror: () async {
        pathCalls++;
        providerCalls++;
        taskCalls++;
      },
    );
    expect([pathCalls, providerCalls, loginCalls, taskCalls], [0, 0, 0, 0]);
  });

  test('official and mirror route exclusively', () async {
    var official = 0;
    var mirror = 0;
    await coordinator.open(
      selectSource: () async => P4kDownloadSource.official,
      openOfficial: () async => official++,
      openCommunityMirror: () async => mirror++,
    );
    expect([official, mirror], [1, 0]);

    await coordinator.open(
      selectSource: () async => P4kDownloadSource.communityMirror,
      openOfficial: () async => official++,
      openCommunityMirror: () async => mirror++,
    );
    expect([official, mirror], [1, 1]);
  });

  test('mirror fallback requires both explicit confirmations', () async {
    var official = 0;
    var secondPrompt = 0;
    final first = await coordinator.confirmOfficialFallback(
      offerSwitch: () async => false,
      confirmSwitch: () async {
        secondPrompt++;
        return true;
      },
    );
    if (first) official++;
    expect([secondPrompt, official], [0, 0]);

    final second = await coordinator.confirmOfficialFallback(
      offerSwitch: () async => true,
      confirmSwitch: () async {
        secondPrompt++;
        return false;
      },
    );
    if (second) official++;
    expect([secondPrompt, official], [1, 0]);

    final third = await coordinator.confirmOfficialFallback(
      offerSwitch: () async => true,
      confirmSwitch: () async {
        secondPrompt++;
        return true;
      },
    );
    if (third) official++;
    expect([secondPrompt, official], [2, 1]);
  });

  test('real open session boundary selects before any route', () async {
    final calls = <String>[];
    await openP4kUpdaterSession(
      selectSource: () async {
        calls.add('select');
        return P4kDownloadSource.communityMirror;
      },
      openOfficial: () async => calls.add('official'),
      openCommunityMirror: () async => calls.add('mirror'),
    );
    expect(calls, ['select', 'mirror']);

    calls.clear();
    await openP4kUpdaterSession(
      selectSource: () async {
        calls.add('select');
        return null;
      },
      openOfficial: () async => calls.add('official'),
      openCommunityMirror: () async => calls.add('mirror'),
    );
    expect(calls, ['select']);
  });

  test('mirror switch result precedes outer official transition', () async {
    final calls = <String>[];
    const coordinator = P4kSourceSessionCoordinator();
    final result = await resolveP4kMirrorProviderFailure(
      error: const P4kMirrorUnavailable(
        reason: P4kMirrorUnavailableReason.notMirrored,
        objectSha256: 'abc',
        message: 'not mirrored',
      ),
      decideFallback: (error) async {
        calls.add('failure:${error.objectSha256}');
        return coordinator.confirmOfficialFallback(
          offerSwitch: () async {
            calls.add('offer-switch');
            return true;
          },
          confirmSwitch: () async {
            calls.add('confirm-switch');
            return true;
          },
        );
      },
    );
    calls.add('mirror-dialog-closed');
    if (result == P4kUpdateDialogResult.switchToOfficial) {
      calls.add('official');
    }
    expect(calls, [
      'failure:abc',
      'offer-switch',
      'confirm-switch',
      'mirror-dialog-closed',
      'official',
    ]);
  });

  test('session config preserves source for every operation and retry', () {
    for (final operation in ['fresh', 'update', 'deep-repair', 'retry']) {
      final deepRepair = operation == 'deep-repair';
      final mirror = buildP4kSessionConfig(
        source: P4kDownloadSource.communityMirror,
        manifestSource: '',
        objectBases: const [],
        p4kBaseUrl: '',
        p4kBaseVerificationUrl: '',
        objectPathTemplates: const ['{sha256}'],
        requestCookie: 'must-not-survive',
        rsiToken: 'must-not-survive',
        cacheDir: 'cache',
        gameDir: 'game',
        deepVerify: deepRepair,
      );
      expect(mirror.source, P4kDownloadSource.communityMirror);
      expect(mirror.updateP4K, isTrue, reason: operation);
      expect(mirror.updateLooseFiles, isTrue, reason: operation);
      expect(mirror.mirrorBases, isEmpty);
      expect(mirror.officialBases, isEmpty);
      expect(mirror.requestCookie, isEmpty);
      expect(mirror.rsiToken, isEmpty);
      expect(mirror.p4KBaseUrl, isEmpty);
      expect(mirror.verifyCigStructure, deepRepair);
    }

    final official = buildP4kSessionConfig(
      source: P4kDownloadSource.official,
      manifestSource: 'https://official/manifest',
      objectBases: const ['https://official/objects'],
      p4kBaseUrl: 'https://official/Data.p4k',
      p4kBaseVerificationUrl: 'https://official/Data.p4k.vf',
      objectPathTemplates: const [],
      requestCookie: 'cookie',
      rsiToken: 'token',
      cacheDir: 'cache',
      gameDir: 'game',
      deepVerify: false,
    );
    expect(official.source, P4kDownloadSource.official);
    expect(official.updateP4K, isTrue);
    expect(official.updateLooseFiles, isTrue);
    expect(official.officialBases, isNotEmpty);
    expect(official.mirrorBases, isEmpty);
    expect(official.requestCookie, 'cookie');
    expect(official.rsiToken, 'token');
  });
}
