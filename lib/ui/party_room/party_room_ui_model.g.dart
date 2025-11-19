// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_room_ui_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PartyRoomUIModel)
const partyRoomUIModelProvider = PartyRoomUIModelProvider._();

final class PartyRoomUIModelProvider
    extends $NotifierProvider<PartyRoomUIModel, PartyRoomUIState> {
  const PartyRoomUIModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partyRoomUIModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partyRoomUIModelHash();

  @$internal
  @override
  PartyRoomUIModel create() => PartyRoomUIModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartyRoomUIState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartyRoomUIState>(value),
    );
  }
}

String _$partyRoomUIModelHash() => r'a0b6c3632ff33f2d58882f9bc1ab58c69c2487f4';

abstract class _$PartyRoomUIModel extends $Notifier<PartyRoomUIState> {
  PartyRoomUIState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PartyRoomUIState, PartyRoomUIState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PartyRoomUIState, PartyRoomUIState>,
              PartyRoomUIState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
