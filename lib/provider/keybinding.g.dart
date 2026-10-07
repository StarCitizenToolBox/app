// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keybinding.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Device input and system hooks; overridden with fakes in tests.

@ProviderFor(keybindingEnvironment)
final keybindingEnvironmentProvider = KeybindingEnvironmentProvider._();

/// Device input and system hooks; overridden with fakes in tests.

final class KeybindingEnvironmentProvider
    extends
        $FunctionalProvider<
          KeybindingEnvironment,
          KeybindingEnvironment,
          KeybindingEnvironment
        >
    with $Provider<KeybindingEnvironment> {
  /// Device input and system hooks; overridden with fakes in tests.
  KeybindingEnvironmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keybindingEnvironmentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keybindingEnvironmentHash();

  @$internal
  @override
  $ProviderElement<KeybindingEnvironment> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeybindingEnvironment create(Ref ref) {
    return keybindingEnvironment(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeybindingEnvironment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeybindingEnvironment>(value),
    );
  }
}

String _$keybindingEnvironmentHash() =>
    r'057f75fa7b37780f40c1721124a616326ee2e3ac';

@ProviderFor(KeybindingModel)
final keybindingModelProvider = KeybindingModelProvider._();

final class KeybindingModelProvider
    extends $NotifierProvider<KeybindingModel, KeybindingState> {
  KeybindingModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keybindingModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keybindingModelHash();

  @$internal
  @override
  KeybindingModel create() => KeybindingModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeybindingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeybindingState>(value),
    );
  }
}

String _$keybindingModelHash() => r'96e395529fa74e62aa1312ac3ba574ba408b8d77';

abstract class _$KeybindingModel extends $Notifier<KeybindingState> {
  KeybindingState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<KeybindingState, KeybindingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KeybindingState, KeybindingState>,
              KeybindingState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
