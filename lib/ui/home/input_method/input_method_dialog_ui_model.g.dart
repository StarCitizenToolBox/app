// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_method_dialog_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'f216c1a5b6d68b3924af7b351314c618dcac80b5';

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

@ProviderFor(OnnxTranslation)
const onnxTranslationProvider = OnnxTranslationFamily._();

final class OnnxTranslationProvider
    extends $NotifierProvider<OnnxTranslation, bool> {
  const OnnxTranslationProvider._({
    required OnnxTranslationFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'onnxTranslationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$onnxTranslationHash();

  @override
  String toString() {
    return r'onnxTranslationProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  OnnxTranslation create() => OnnxTranslation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OnnxTranslationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$onnxTranslationHash() => r'4f3dc0e361dca2d6b00f557496bdf006cc6c235c';

final class OnnxTranslationFamily extends $Family
    with
        $ClassFamilyOverride<
          OnnxTranslation,
          bool,
          bool,
          bool,
          (String, String)
        > {
  const OnnxTranslationFamily._()
    : super(
        retry: null,
        name: r'onnxTranslationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OnnxTranslationProvider call(String modelDir, String modelName) =>
      OnnxTranslationProvider._(argument: (modelDir, modelName), from: this);

  @override
  String toString() => r'onnxTranslationProvider';
}

abstract class _$OnnxTranslation extends $Notifier<bool> {
  late final _$args = ref.$arg as (String, String);
  String get modelDir => _$args.$1;
  String get modelName => _$args.$2;

  bool build(String modelDir, String modelName);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
