// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_room.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PartyRoom Provider

@ProviderFor(PartyRoom)
final partyRoomProvider = PartyRoomProvider._();

/// PartyRoom Provider
final class PartyRoomProvider
    extends $NotifierProvider<PartyRoom, PartyRoomFullState> {
  /// PartyRoom Provider
  PartyRoomProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partyRoomProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partyRoomHash();

  @$internal
  @override
  PartyRoom create() => PartyRoom();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartyRoomFullState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartyRoomFullState>(value),
    );
  }
}

String _$partyRoomHash() => r'446e4cc88be96c890f8e676c6faf0e4d3b33a529';

/// PartyRoom Provider

abstract class _$PartyRoom extends $Notifier<PartyRoomFullState> {
  PartyRoomFullState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PartyRoomFullState, PartyRoomFullState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PartyRoomFullState, PartyRoomFullState>,
              PartyRoomFullState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
