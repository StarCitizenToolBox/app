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

String _$toolsUIModelHash() => r'de2a6550f2fad73c112a91528b514e81145dae31';

abstract class _$ToolsUIModel extends $Notifier<ToolsUIState> {
  ToolsUIState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ToolsUIState, ToolsUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ToolsUIState, ToolsUIState>,
              ToolsUIState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
