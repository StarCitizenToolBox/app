// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unp4kc.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Unp4kCModel)
const unp4kCModelProvider = Unp4kCModelProvider._();

final class Unp4kCModelProvider
    extends $NotifierProvider<Unp4kCModel, Unp4kcState> {
  const Unp4kCModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unp4kCModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unp4kCModelHash();

  @$internal
  @override
  Unp4kCModel create() => Unp4kCModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Unp4kcState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Unp4kcState>(value),
    );
  }
}

String _$unp4kCModelHash() => r'410461980f6173fdbb5d92cbaa3f4c2f57c1ad8d';

abstract class _$Unp4kCModel extends $Notifier<Unp4kcState> {
  Unp4kcState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Unp4kcState, Unp4kcState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Unp4kcState, Unp4kcState>,
              Unp4kcState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
