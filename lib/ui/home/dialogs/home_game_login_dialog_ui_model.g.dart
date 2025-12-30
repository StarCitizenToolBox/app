// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_game_login_dialog_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeGameLoginUIModel)
final homeGameLoginUIModelProvider = HomeGameLoginUIModelProvider._();

final class HomeGameLoginUIModelProvider
    extends $NotifierProvider<HomeGameLoginUIModel, HomeGameLoginState> {
  HomeGameLoginUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeGameLoginUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeGameLoginUIModelHash();

  @$internal
  @override
  HomeGameLoginUIModel create() => HomeGameLoginUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeGameLoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeGameLoginState>(value),
    );
  }
}

String _$homeGameLoginUIModelHash() =>
    r'ca905904d20a6b1956fee04dcb501f0d1c19f86b';

abstract class _$HomeGameLoginUIModel extends $Notifier<HomeGameLoginState> {
  HomeGameLoginState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HomeGameLoginState, HomeGameLoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeGameLoginState, HomeGameLoginState>,
              HomeGameLoginState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
