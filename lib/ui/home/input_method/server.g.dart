// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(InputMethodServer)
const inputMethodServerProvider = InputMethodServerProvider._();

final class InputMethodServerProvider
    extends $NotifierProvider<InputMethodServer, InputMethodServerState> {
  const InputMethodServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputMethodServerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputMethodServerHash();

  @$internal
  @override
  InputMethodServer create() => InputMethodServer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InputMethodServerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InputMethodServerState>(value),
    );
  }
}

String _$inputMethodServerHash() => r'58ff318c051f16c76f620258520aadedbdd5057c';

abstract class _$InputMethodServer extends $Notifier<InputMethodServerState> {
  InputMethodServerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<InputMethodServerState, InputMethodServerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InputMethodServerState, InputMethodServerState>,
              InputMethodServerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
