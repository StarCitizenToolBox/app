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

String _$partyRoomHash() => r'd57cf03dbf7b343cde3ba947f12de3ca34d31cd6';

/// PartyRoom Provider

abstract class _$PartyRoom extends $Notifier<PartyRoomFullState> {
  PartyRoomFullState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PartyRoomFullState, PartyRoomFullState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PartyRoomFullState, PartyRoomFullState>,
              PartyRoomFullState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
