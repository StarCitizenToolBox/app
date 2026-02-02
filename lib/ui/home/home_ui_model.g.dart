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

String _$homeUIModelHash() => r'9e16e9021ef2b68403f5d5ce21829d1fee0f4c8a';

abstract class _$HomeUIModel extends $Notifier<HomeUIModelState> {
  HomeUIModelState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeUIModelState, HomeUIModelState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeUIModelState, HomeUIModelState>,
              HomeUIModelState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
