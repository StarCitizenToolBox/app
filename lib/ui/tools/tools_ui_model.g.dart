// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tools_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ToolsUIModel)
final toolsUIModelProvider = ToolsUIModelProvider._();

final class ToolsUIModelProvider
    extends $NotifierProvider<ToolsUIModel, ToolsUIState> {
  ToolsUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toolsUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toolsUIModelHash();

  @$internal
  @override
  ToolsUIModel create() => ToolsUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToolsUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToolsUIState>(value),
    );
  }
}

String _$toolsUIModelHash() => r'4a05043b70e95402aba1ee9be8f47be1e0a7f287';

abstract class _$ToolsUIModel extends $Notifier<ToolsUIState> {
  ToolsUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ToolsUIState, ToolsUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ToolsUIState, ToolsUIState>,
              ToolsUIState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
