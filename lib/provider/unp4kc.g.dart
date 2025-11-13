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

String _$unp4kCModelHash() => r'5ea79d8084a79353742a3344102fb5725b50211b';

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
