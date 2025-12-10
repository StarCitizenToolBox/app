// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(router)
const routerProvider = RouterProvider._();

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  const RouterProvider._()
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

String _$routerHash() => r'e89f3f0277879147cdce5373cbe2554821e9cd31';

@ProviderFor(AppGlobalModel)
const appGlobalModelProvider = AppGlobalModelProvider._();

final class AppGlobalModelProvider
    extends $NotifierProvider<AppGlobalModel, AppGlobalState> {
  const AppGlobalModelProvider._()
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

String _$appGlobalModelHash() => r'0e46d72594d94e2beb4d2ccb8616eb37facba288';

abstract class _$AppGlobalModel extends $Notifier<AppGlobalState> {
  AppGlobalState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppGlobalState, AppGlobalState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppGlobalState, AppGlobalState>,
              AppGlobalState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
