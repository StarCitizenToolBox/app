// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_qr_dialog_ui.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServerQrState)
final serverQrStateProvider = ServerQrStateProvider._();

final class ServerQrStateProvider
    extends $NotifierProvider<ServerQrState, bool> {
  ServerQrStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverQrStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverQrStateHash();

  @$internal
  @override
  ServerQrState create() => ServerQrState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$serverQrStateHash() => r'41b627b3d012b29a9b68d19a45dbf5257d67a008';

abstract class _$ServerQrState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
