// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_doctor_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeGameDoctorUIModel)
const homeGameDoctorUIModelProvider = HomeGameDoctorUIModelProvider._();

final class HomeGameDoctorUIModelProvider
    extends $NotifierProvider<HomeGameDoctorUIModel, HomeGameDoctorState> {
  const HomeGameDoctorUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeGameDoctorUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeGameDoctorUIModelHash();

  @$internal
  @override
  HomeGameDoctorUIModel create() => HomeGameDoctorUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeGameDoctorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeGameDoctorState>(value),
    );
  }
}

String _$homeGameDoctorUIModelHash() =>
    r'8b969c4638fb07b8224dd60b3f04fa29742c4ae8';

abstract class _$HomeGameDoctorUIModel extends $Notifier<HomeGameDoctorState> {
  HomeGameDoctorState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HomeGameDoctorState, HomeGameDoctorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeGameDoctorState, HomeGameDoctorState>,
              HomeGameDoctorState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
