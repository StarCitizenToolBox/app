// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_analyze_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ToolsLogAnalyze)
const toolsLogAnalyzeProvider = ToolsLogAnalyzeFamily._();

final class ToolsLogAnalyzeProvider
    extends $AsyncNotifierProvider<ToolsLogAnalyze, List<LogAnalyzeLineData>> {
  const ToolsLogAnalyzeProvider._({
    required ToolsLogAnalyzeFamily super.from,
    required (String, bool) super.argument,
  }) : super(
         retry: null,
         name: r'toolsLogAnalyzeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$toolsLogAnalyzeHash();

  @override
  String toString() {
    return r'toolsLogAnalyzeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ToolsLogAnalyze create() => ToolsLogAnalyze();

  @override
  bool operator ==(Object other) {
    return other is ToolsLogAnalyzeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$toolsLogAnalyzeHash() => r'5666c3f882e22e2192593629164bc53f8ce4aabe';

final class ToolsLogAnalyzeFamily extends $Family
    with
        $ClassFamilyOverride<
          ToolsLogAnalyze,
          AsyncValue<List<LogAnalyzeLineData>>,
          List<LogAnalyzeLineData>,
          FutureOr<List<LogAnalyzeLineData>>,
          (String, bool)
        > {
  const ToolsLogAnalyzeFamily._()
    : super(
        retry: null,
        name: r'toolsLogAnalyzeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ToolsLogAnalyzeProvider call(String gameInstallPath, bool listSortReverse) =>
      ToolsLogAnalyzeProvider._(
        argument: (gameInstallPath, listSortReverse),
        from: this,
      );

  @override
  String toString() => r'toolsLogAnalyzeProvider';
}

abstract class _$ToolsLogAnalyze
    extends $AsyncNotifier<List<LogAnalyzeLineData>> {
  late final _$args = ref.$arg as (String, bool);
  String get gameInstallPath => _$args.$1;
  bool get listSortReverse => _$args.$2;

  FutureOr<List<LogAnalyzeLineData>> build(
    String gameInstallPath,
    bool listSortReverse,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<LogAnalyzeLineData>>,
              List<LogAnalyzeLineData>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LogAnalyzeLineData>>,
                List<LogAnalyzeLineData>
              >,
              AsyncValue<List<LogAnalyzeLineData>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
