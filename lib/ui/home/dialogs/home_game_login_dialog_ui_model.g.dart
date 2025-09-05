// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_game_login_dialog_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(HomeGameLoginUIModel)
const homeGameLoginUIModelProvider = HomeGameLoginUIModelProvider._();

final class HomeGameLoginUIModelProvider
    extends $NotifierProvider<HomeGameLoginUIModel, HomeGameLoginState> {
  const HomeGameLoginUIModelProvider._()
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
    r'c9e9ec2e85f2459b6bfc1518406b091ff4675a85';

abstract class _$HomeGameLoginUIModel extends $Notifier<HomeGameLoginState> {
  HomeGameLoginState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HomeGameLoginState, HomeGameLoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeGameLoginState, HomeGameLoginState>,
              HomeGameLoginState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
