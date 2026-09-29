// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_method_hotkey_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global hotkey popup for the community input method: owns the settings and answers the
/// popup's submit events with encoded text (issue #322).

@ProviderFor(InputMethodHotkeyService)
final inputMethodHotkeyServiceProvider = InputMethodHotkeyServiceProvider._();

/// Global hotkey popup for the community input method: owns the settings and answers the
/// popup's submit events with encoded text (issue #322).
final class InputMethodHotkeyServiceProvider
    extends
        $NotifierProvider<InputMethodHotkeyService, InputMethodHotkeyState> {
  /// Global hotkey popup for the community input method: owns the settings and answers the
  /// popup's submit events with encoded text (issue #322).
  InputMethodHotkeyServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputMethodHotkeyServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputMethodHotkeyServiceHash();

  @$internal
  @override
  InputMethodHotkeyService create() => InputMethodHotkeyService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InputMethodHotkeyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InputMethodHotkeyState>(value),
    );
  }
}

String _$inputMethodHotkeyServiceHash() =>
    r'53d8105b44179e099705f49d61c0b5e46f4b6a07';

/// Global hotkey popup for the community input method: owns the settings and answers the
/// popup's submit events with encoded text (issue #322).

abstract class _$InputMethodHotkeyService
    extends $Notifier<InputMethodHotkeyState> {
  InputMethodHotkeyState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<InputMethodHotkeyState, InputMethodHotkeyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InputMethodHotkeyState, InputMethodHotkeyState>,
              InputMethodHotkeyState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
