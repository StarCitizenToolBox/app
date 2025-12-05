// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_downloader_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeDownloaderUIModel)
const homeDownloaderUIModelProvider = HomeDownloaderUIModelProvider._();

final class HomeDownloaderUIModelProvider
    extends $NotifierProvider<HomeDownloaderUIModel, HomeDownloaderUIState> {
  const HomeDownloaderUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDownloaderUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDownloaderUIModelHash();

  @$internal
  @override
  HomeDownloaderUIModel create() => HomeDownloaderUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeDownloaderUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeDownloaderUIState>(value),
    );
  }
}

String _$homeDownloaderUIModelHash() =>
    r'bf7d095d761fff078de707562cf311c20db664d9';

abstract class _$HomeDownloaderUIModel
    extends $Notifier<HomeDownloaderUIState> {
  HomeDownloaderUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HomeDownloaderUIState, HomeDownloaderUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeDownloaderUIState, HomeDownloaderUIState>,
              HomeDownloaderUIState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
