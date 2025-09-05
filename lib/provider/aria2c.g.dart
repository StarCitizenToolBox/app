// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aria2c.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

String _$aria2cModelHash() => r'3d51aeefd92e5291dca1f01db961f9c5496ec24f';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
