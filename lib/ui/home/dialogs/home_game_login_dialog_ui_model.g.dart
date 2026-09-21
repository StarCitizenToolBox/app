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
    r'3f04cc8e336d320257b9cf099d8bf826d57e9941';

abstract class _$HomeGameLoginUIModel extends $Notifier<HomeGameLoginState> {
  HomeGameLoginState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HomeGameLoginState, HomeGameLoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeGameLoginState, HomeGameLoginState>,
              HomeGameLoginState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
