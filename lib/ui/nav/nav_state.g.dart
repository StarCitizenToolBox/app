// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Nav)
const navProvider = NavProvider._();

final class NavProvider extends $NotifierProvider<Nav, NavState> {
  const NavProvider._()
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

String _$navHash() => r'00c4da8fdd37214cda179a81ece3676add7aab53';

abstract class _$Nav extends $Notifier<NavState> {
  NavState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NavState, NavState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NavState, NavState>,
              NavState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
