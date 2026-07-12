// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeUIModel)
final homeUIModelProvider = HomeUIModelProvider._();

final class HomeUIModelProvider
    extends $NotifierProvider<HomeUIModel, HomeUIModelState> {
  HomeUIModelProvider._()
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

String _$homeUIModelHash() => r'5ac99548d42e43c2ffc8eff9f9da752b9f0b4d7f';

abstract class _$HomeUIModel extends $Notifier<HomeUIModelState> {
  HomeUIModelState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HomeUIModelState, HomeUIModelState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeUIModelState, HomeUIModelState>,
              HomeUIModelState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
