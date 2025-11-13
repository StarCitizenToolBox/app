// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsUIModel)
const settingsUIModelProvider = SettingsUIModelProvider._();

final class SettingsUIModelProvider
    extends $NotifierProvider<SettingsUIModel, SettingsUIState> {
  const SettingsUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsUIModelHash();

  @$internal
  @override
  SettingsUIModel create() => SettingsUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsUIState>(value),
    );
  }
}

String _$settingsUIModelHash() => r'd19104d924f018a9230548d0372692fc344adacd';

abstract class _$SettingsUIModel extends $Notifier<SettingsUIState> {
  SettingsUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SettingsUIState, SettingsUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsUIState, SettingsUIState>,
              SettingsUIState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
