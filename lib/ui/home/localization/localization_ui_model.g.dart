// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalizationUIModel)
final localizationUIModelProvider = LocalizationUIModelProvider._();

final class LocalizationUIModelProvider
    extends $NotifierProvider<LocalizationUIModel, LocalizationUIState> {
  LocalizationUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localizationUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localizationUIModelHash();

  @$internal
  @override
  LocalizationUIModel create() => LocalizationUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalizationUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalizationUIState>(value),
    );
  }
}

String _$localizationUIModelHash() =>
    r'0bb9d762a589be4ac6b1f9a43e90bd776a897d13';

abstract class _$LocalizationUIModel extends $Notifier<LocalizationUIState> {
  LocalizationUIState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LocalizationUIState, LocalizationUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocalizationUIState, LocalizationUIState>,
              LocalizationUIState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
