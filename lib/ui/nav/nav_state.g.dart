// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Nav)
final navProvider = NavProvider._();

final class NavProvider extends $NotifierProvider<Nav, NavState> {
  NavProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navHash();

  @$internal
  @override
  Nav create() => Nav();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NavState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NavState>(value),
    );
  }
}

String _$navHash() => r'bd3773505d6ae53f577ac6f3bfe711b320faa524';

abstract class _$Nav extends $Notifier<NavState> {
  NavState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NavState, NavState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NavState, NavState>,
              NavState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
