// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadManager)
const downloadManagerProvider = DownloadManagerProvider._();

final class DownloadManagerProvider
    extends $NotifierProvider<DownloadManager, DownloadManagerState> {
  const DownloadManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadManagerHash();

  @$internal
  @override
  DownloadManager create() => DownloadManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DownloadManagerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DownloadManagerState>(value),
    );
  }
}

String _$downloadManagerHash() => r'f0fd818851be0d1c9e6774803aae465c33843cde';

abstract class _$DownloadManager extends $Notifier<DownloadManagerState> {
  DownloadManagerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DownloadManagerState, DownloadManagerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DownloadManagerState, DownloadManagerState>,
              DownloadManagerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
