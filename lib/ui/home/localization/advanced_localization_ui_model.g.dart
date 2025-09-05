// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_localization_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AdvancedLocalizationUIModel)
const advancedLocalizationUIModelProvider =
    AdvancedLocalizationUIModelProvider._();

final class AdvancedLocalizationUIModelProvider
    extends
        $NotifierProvider<
          AdvancedLocalizationUIModel,
          AdvancedLocalizationUIState
        > {
  const AdvancedLocalizationUIModelProvider._()
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
    r'2f890c854bc56e506c441acabc2014438a163617';

abstract class _$AdvancedLocalizationUIModel
    extends $Notifier<AdvancedLocalizationUIState> {
  AdvancedLocalizationUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
