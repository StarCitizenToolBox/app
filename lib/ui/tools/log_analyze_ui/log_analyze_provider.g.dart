// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_analyze_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$toolsLogAnalyzeHash() => r'cc8aed5b4eeb6c8feb35c59ef484dc61c92a5549';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ToolsLogAnalyze
    extends BuildlessAutoDisposeAsyncNotifier<List<LogAnalyzeLineData>> {
  late final String gameInstallPath;

  FutureOr<List<LogAnalyzeLineData>> build(
    String gameInstallPath,
  );
}

/// See also [ToolsLogAnalyze].
@ProviderFor(ToolsLogAnalyze)
const toolsLogAnalyzeProvider = ToolsLogAnalyzeFamily();

/// See also [ToolsLogAnalyze].
class ToolsLogAnalyzeFamily
    extends Family<AsyncValue<List<LogAnalyzeLineData>>> {
  /// See also [ToolsLogAnalyze].
  const ToolsLogAnalyzeFamily();

  /// See also [ToolsLogAnalyze].
  ToolsLogAnalyzeProvider call(
    String gameInstallPath,
  ) {
    return ToolsLogAnalyzeProvider(
      gameInstallPath,
    );
  }

  @override
  ToolsLogAnalyzeProvider getProviderOverride(
    covariant ToolsLogAnalyzeProvider provider,
  ) {
    return call(
      provider.gameInstallPath,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'toolsLogAnalyzeProvider';
}

/// See also [ToolsLogAnalyze].
class ToolsLogAnalyzeProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ToolsLogAnalyze, List<LogAnalyzeLineData>> {
  /// See also [ToolsLogAnalyze].
  ToolsLogAnalyzeProvider(
    String gameInstallPath,
  ) : this._internal(
          () => ToolsLogAnalyze()..gameInstallPath = gameInstallPath,
          from: toolsLogAnalyzeProvider,
          name: r'toolsLogAnalyzeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$toolsLogAnalyzeHash,
          dependencies: ToolsLogAnalyzeFamily._dependencies,
          allTransitiveDependencies:
              ToolsLogAnalyzeFamily._allTransitiveDependencies,
          gameInstallPath: gameInstallPath,
        );

  ToolsLogAnalyzeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.gameInstallPath,
  }) : super.internal();

  final String gameInstallPath;

  @override
  FutureOr<List<LogAnalyzeLineData>> runNotifierBuild(
    covariant ToolsLogAnalyze notifier,
  ) {
    return notifier.build(
      gameInstallPath,
    );
  }

  @override
  Override overrideWith(ToolsLogAnalyze Function() create) {
    return ProviderOverride(
      origin: this,
      override: ToolsLogAnalyzeProvider._internal(
        () => create()..gameInstallPath = gameInstallPath,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        gameInstallPath: gameInstallPath,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ToolsLogAnalyze,
      List<LogAnalyzeLineData>> createElement() {
    return _ToolsLogAnalyzeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ToolsLogAnalyzeProvider &&
        other.gameInstallPath == gameInstallPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, gameInstallPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ToolsLogAnalyzeRef
    on AutoDisposeAsyncNotifierProviderRef<List<LogAnalyzeLineData>> {
  /// The parameter `gameInstallPath` of this provider.
  String get gameInstallPath;
}

class _ToolsLogAnalyzeProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ToolsLogAnalyze,
        List<LogAnalyzeLineData>> with ToolsLogAnalyzeRef {
  _ToolsLogAnalyzeProviderElement(super.provider);

  @override
  String get gameInstallPath =>
      (origin as ToolsLogAnalyzeProvider).gameInstallPath;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
