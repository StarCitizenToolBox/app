// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(HomePerformanceUIModel)
const homePerformanceUIModelProvider = HomePerformanceUIModelProvider._();

final class HomePerformanceUIModelProvider
    extends $NotifierProvider<HomePerformanceUIModel, HomePerformanceUIState> {
  const HomePerformanceUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homePerformanceUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homePerformanceUIModelHash();

  @$internal
  @override
  HomePerformanceUIModel create() => HomePerformanceUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomePerformanceUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomePerformanceUIState>(value),
    );
  }
}

String _$homePerformanceUIModelHash() =>
    r'c3c55c0470ef8c8be4915a1878deba332653ecde';

abstract class _$HomePerformanceUIModel
    extends $Notifier<HomePerformanceUIState> {
  HomePerformanceUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<HomePerformanceUIState, HomePerformanceUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomePerformanceUIState, HomePerformanceUIState>,
              HomePerformanceUIState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
