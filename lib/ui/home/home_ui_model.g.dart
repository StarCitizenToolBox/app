// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(HomeUIModel)
const homeUIModelProvider = HomeUIModelProvider._();

final class HomeUIModelProvider
    extends $NotifierProvider<HomeUIModel, HomeUIModelState> {
  const HomeUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeUIModelHash();

  @$internal
  @override
  HomeUIModel create() => HomeUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeUIModelState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeUIModelState>(value),
    );
  }
}

String _$homeUIModelHash() => r'84eb149f999237410a7e0a95b74bd5729c2726d4';

abstract class _$HomeUIModel extends $Notifier<HomeUIModelState> {
  HomeUIModelState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HomeUIModelState, HomeUIModelState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeUIModelState, HomeUIModelState>,
              HomeUIModelState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
