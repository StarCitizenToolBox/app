// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_doctor_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
    r'7035b501860e9d8c3fdfb91370311760120af115';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
