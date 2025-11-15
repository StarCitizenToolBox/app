// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aria2c.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Aria2cModel)
const aria2cModelProvider = Aria2cModelProvider._();

final class Aria2cModelProvider
    extends $NotifierProvider<Aria2cModel, Aria2cModelState> {
  const Aria2cModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aria2cModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aria2cModelHash();

  @$internal
  @override
  Aria2cModel create() => Aria2cModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Aria2cModelState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Aria2cModelState>(value),
    );
  }
}

String _$aria2cModelHash() => r'eb45d6aa9fc641abceb34ad5685aab57aa7a870b';

abstract class _$Aria2cModel extends $Notifier<Aria2cModelState> {
  Aria2cModelState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Aria2cModelState, Aria2cModelState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Aria2cModelState, Aria2cModelState>,
              Aria2cModelState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
