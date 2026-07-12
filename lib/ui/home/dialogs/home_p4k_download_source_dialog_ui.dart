import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/rust/api/p4k_upgrader_api.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

const p4kOfficialSourceOptionKey = Key('p4k-source-official');
const p4kCommunityMirrorSourceOptionKey = Key('p4k-source-community-mirror');
const p4kSourceContinueKey = Key('p4k-source-continue');
const p4kSourceCancelKey = Key('p4k-source-cancel');
const p4kCommunityMirrorLimitationKey = Key(
  'p4k-source-community-mirror-limitation',
);

String p4kProviderErrorMessage(P4kMirrorUnavailable? error) {
  if (error == null) return S.current.p4k_source_error_provider_unavailable;
  final summary = switch (error.reason) {
    P4kMirrorUnavailableReason.notEligible =>
      S.current.p4k_source_mirror_not_eligible,
    P4kMirrorUnavailableReason.notMirrored =>
      S.current.p4k_source_mirror_not_mirrored,
    P4kMirrorUnavailableReason.incompleteBase =>
      S.current.p4k_source_mirror_incomplete_base,
    P4kMirrorUnavailableReason.releaseMismatch =>
      S.current.p4k_source_mirror_release_mismatch,
  };
  final details = [
    if (error.objectSha256 case final sha?)
      S.current.p4k_source_object_sha(sha),
    if (error.compressedSize case final size?)
      S.current.p4k_source_compressed_size(size),
  ];
  return [summary, ...details].join('\n');
}

/// Accepts only the typed mirror-unavailable boundary exposed by Rust.
///
/// Other updater failures remain ordinary errors; no string parsing or
/// inference is used to trigger the mirror fallback flow.
P4kMirrorUnavailable? mapP4kMirrorOperationalError(Object error) {
  return error is P4kMirrorUnavailable ? error : null;
}

Future<P4kDownloadSource?> showP4kDownloadSourceDialog(BuildContext context) {
  return showDialog<P4kDownloadSource>(
    context: context,
    barrierDismissible: true,
    dismissWithEsc: true,
    builder: (_) => const HomeP4kDownloadSourceDialogUI(),
  );
}

class HomeP4kDownloadSourceDialogUI extends StatefulWidget {
  const HomeP4kDownloadSourceDialogUI({super.key});

  @override
  State<HomeP4kDownloadSourceDialogUI> createState() =>
      _HomeP4kDownloadSourceDialogUIState();
}

class _HomeP4kDownloadSourceDialogUIState
    extends State<HomeP4kDownloadSourceDialogUI> {
  P4kDownloadSource? _source;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(S.current.p4k_source_dialog_title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.current.p4k_source_dialog_description),
            const SizedBox(height: 16),
            RadioGroup<P4kDownloadSource>(
              groupValue: _source,
              onChanged: (source) => setState(() => _source = source),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioButton<P4kDownloadSource>(
                    key: p4kOfficialSourceOptionKey,
                    value: P4kDownloadSource.official,
                    semanticLabel: S.current.p4k_source_official,
                    content: Text(S.current.p4k_source_official),
                  ),
                  const SizedBox(height: 12),
                  RadioButton<P4kDownloadSource>(
                    key: p4kCommunityMirrorSourceOptionKey,
                    value: P4kDownloadSource.communityMirror,
                    semanticLabel: S.current.p4k_source_community_mirror,
                    content: Text(S.current.p4k_source_community_mirror),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 28,
                      top: 6,
                    ),
                    child: Text(
                      S.current.p4k_source_community_mirror_limitation,
                      key: p4kCommunityMirrorLimitationKey,
                      style: FluentTheme.of(context).typography.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Button(
          key: p4kSourceCancelKey,
          onPressed: () => Navigator.pop(context),
          child: Text(S.current.app_common_tip_cancel),
        ),
        FilledButton(
          key: p4kSourceContinueKey,
          onPressed: _source == null
              ? null
              : () => Navigator.pop(context, _source),
          child: Text(S.current.p4k_source_continue),
        ),
      ],
    );
  }
}
