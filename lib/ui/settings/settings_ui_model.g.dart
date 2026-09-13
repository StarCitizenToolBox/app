// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsUIModel)
final settingsUIModelProvider = SettingsUIModelProvider._();

final class SettingsUIModelProvider
    extends $NotifierProvider<SettingsUIModel, SettingsUIState> {
  SettingsUIModelProvider._()
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

String _$settingsUIModelHash() => r'4745404b021c40ec618a601e31d49ec92ac15999';

abstract class _$SettingsUIModel extends $Notifier<SettingsUIState> {
  SettingsUIState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SettingsUIState, SettingsUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsUIState, SettingsUIState>,
              SettingsUIState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
