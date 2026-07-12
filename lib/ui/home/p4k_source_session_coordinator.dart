import 'package:starcitizen_doctor/common/rust/api/p4k_upgrader_api.dart';

typedef P4kSourceSelector = Future<P4kDownloadSource?> Function();
typedef P4kSourceRoute = Future<void> Function();

Future<void> openP4kUpdaterSession({
  required P4kSourceSelector selectSource,
  required P4kSourceRoute openOfficial,
  required P4kSourceRoute openCommunityMirror,
}) {
  return const P4kSourceSessionCoordinator().open(
    selectSource: selectSource,
    openOfficial: openOfficial,
    openCommunityMirror: openCommunityMirror,
  );
}

/// Session-scoped source router used by the real home updater entry point.
///
/// Source selection always completes before either route is invoked. The
/// selected value is intentionally not persisted.
class P4kSourceSessionCoordinator {
  const P4kSourceSessionCoordinator();

  Future<void> open({
    required P4kSourceSelector selectSource,
    required P4kSourceRoute openOfficial,
    required P4kSourceRoute openCommunityMirror,
  }) async {
    final source = await selectSource();
    switch (source) {
      case P4kDownloadSource.official:
        await openOfficial();
      case P4kDownloadSource.communityMirror:
        await openCommunityMirror();
      case null:
        return;
    }
  }

  /// A mirror failure never changes source implicitly. The first prompt may
  /// offer switching; a separate explicit confirmation is always required.
  Future<bool> confirmOfficialFallback({
    required Future<bool?> Function() offerSwitch,
    required Future<bool?> Function() confirmSwitch,
  }) async {
    if (await offerSwitch() != true) return false;
    return await confirmSwitch() == true;
  }
}
