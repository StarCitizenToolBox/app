// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(LocalizationUIModel)
const localizationUIModelProvider = LocalizationUIModelProvider._();

final class LocalizationUIModelProvider
    extends $NotifierProvider<LocalizationUIModel, LocalizationUIState> {
  const LocalizationUIModelProvider._()
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
    r'd3797a7ff3d31dd1d4b05aed4a9969f4be6853c5';

abstract class _$LocalizationUIModel extends $Notifier<LocalizationUIState> {
  LocalizationUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LocalizationUIState, LocalizationUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocalizationUIState, LocalizationUIState>,
              LocalizationUIState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
