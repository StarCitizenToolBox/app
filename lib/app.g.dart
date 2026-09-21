// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(router)
final routerProvider = RouterProvider._();

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'3b354627fd03989dc9d86e29f90f1226540eef31';

@ProviderFor(AppGlobalModel)
final appGlobalModelProvider = AppGlobalModelProvider._();

final class AppGlobalModelProvider
    extends $NotifierProvider<AppGlobalModel, AppGlobalState> {
  AppGlobalModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appGlobalModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appGlobalModelHash();

  @$internal
  @override
  AppGlobalModel create() => AppGlobalModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppGlobalState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppGlobalState>(value),
    );
  }
}

String _$appGlobalModelHash() => r'c66a23fb3a8bf0acbf90e2de24da6a3ec354b495';

abstract class _$AppGlobalModel extends $Notifier<AppGlobalState> {
  AppGlobalState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppGlobalState, AppGlobalState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppGlobalState, AppGlobalState>,
              AppGlobalState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
