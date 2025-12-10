// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dcb_viewer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DcbViewerModel)
const dcbViewerModelProvider = DcbViewerModelProvider._();

final class DcbViewerModelProvider
    extends $NotifierProvider<DcbViewerModel, DcbViewerState> {
  const DcbViewerModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dcbViewerModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dcbViewerModelHash();

  @$internal
  @override
  DcbViewerModel create() => DcbViewerModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DcbViewerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DcbViewerState>(value),
    );
  }
}

String _$dcbViewerModelHash() => r'94c3542282f64917efadbe14a0ee4967220bec77';

abstract class _$DcbViewerModel extends $Notifier<DcbViewerState> {
  DcbViewerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DcbViewerState, DcbViewerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DcbViewerState, DcbViewerState>,
              DcbViewerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
