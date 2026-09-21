// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_localization_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdvancedLocalizationUIModel)
final advancedLocalizationUIModelProvider =
    AdvancedLocalizationUIModelProvider._();

final class AdvancedLocalizationUIModelProvider
    extends
        $NotifierProvider<
          AdvancedLocalizationUIModel,
          AdvancedLocalizationUIState
        > {
  AdvancedLocalizationUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'advancedLocalizationUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$advancedLocalizationUIModelHash();

  @$internal
  @override
  AdvancedLocalizationUIModel create() => AdvancedLocalizationUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdvancedLocalizationUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdvancedLocalizationUIState>(value),
    );
  }
}

String _$advancedLocalizationUIModelHash() =>
    r'9b0c8f2714b5dd06ace47e194a93478dfa71dc00';

abstract class _$AdvancedLocalizationUIModel
    extends $Notifier<AdvancedLocalizationUIState> {
  AdvancedLocalizationUIState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AdvancedLocalizationUIState, AdvancedLocalizationUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AdvancedLocalizationUIState,
                AdvancedLocalizationUIState
              >,
              AdvancedLocalizationUIState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
