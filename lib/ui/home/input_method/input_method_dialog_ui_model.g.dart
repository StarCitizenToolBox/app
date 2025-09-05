// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_method_dialog_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(InputMethodDialogUIModel)
const inputMethodDialogUIModelProvider = InputMethodDialogUIModelProvider._();

final class InputMethodDialogUIModelProvider
    extends
        $NotifierProvider<InputMethodDialogUIModel, InputMethodDialogUIState> {
  const InputMethodDialogUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputMethodDialogUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputMethodDialogUIModelHash();

  @$internal
  @override
  InputMethodDialogUIModel create() => InputMethodDialogUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InputMethodDialogUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InputMethodDialogUIState>(value),
    );
  }
}

String _$inputMethodDialogUIModelHash() =>
    r'c07ef2474866bdb3944892460879121e0f90591f';

abstract class _$InputMethodDialogUIModel
    extends $Notifier<InputMethodDialogUIState> {
  InputMethodDialogUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<InputMethodDialogUIState, InputMethodDialogUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InputMethodDialogUIState, InputMethodDialogUIState>,
              InputMethodDialogUIState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
