// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_log_tracker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PartyRoomGameLogTrackerProvider)
final partyRoomGameLogTrackerProviderProvider =
    PartyRoomGameLogTrackerProviderFamily._();

final class PartyRoomGameLogTrackerProviderProvider
    extends
        $NotifierProvider<
          PartyRoomGameLogTrackerProvider,
          PartyRoomGameLogTrackerProviderState
        > {
  PartyRoomGameLogTrackerProviderProvider._({
    required PartyRoomGameLogTrackerProviderFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'partyRoomGameLogTrackerProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$partyRoomGameLogTrackerProviderHash();

  @override
  String toString() {
    return r'partyRoomGameLogTrackerProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PartyRoomGameLogTrackerProvider create() => PartyRoomGameLogTrackerProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartyRoomGameLogTrackerProviderState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<PartyRoomGameLogTrackerProviderState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PartyRoomGameLogTrackerProviderProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$partyRoomGameLogTrackerProviderHash() =>
    r'7c9413736b0a3357075ab5309f0e746f0d6e3fc3';

final class PartyRoomGameLogTrackerProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          PartyRoomGameLogTrackerProvider,
          PartyRoomGameLogTrackerProviderState,
          PartyRoomGameLogTrackerProviderState,
          PartyRoomGameLogTrackerProviderState,
          DateTime
        > {
  PartyRoomGameLogTrackerProviderFamily._()
    : super(
        retry: null,
        name: r'partyRoomGameLogTrackerProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PartyRoomGameLogTrackerProviderProvider call({required DateTime startTime}) =>
      PartyRoomGameLogTrackerProviderProvider._(
        argument: startTime,
        from: this,
      );

  @override
  String toString() => r'partyRoomGameLogTrackerProviderProvider';
}

abstract class _$PartyRoomGameLogTrackerProvider
    extends $Notifier<PartyRoomGameLogTrackerProviderState> {
  late final _$args = ref.$arg as DateTime;
  DateTime get startTime => _$args;

  PartyRoomGameLogTrackerProviderState build({required DateTime startTime});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              PartyRoomGameLogTrackerProviderState,
              PartyRoomGameLogTrackerProviderState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PartyRoomGameLogTrackerProviderState,
                PartyRoomGameLogTrackerProviderState
              >,
              PartyRoomGameLogTrackerProviderState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(startTime: _$args));
  }
}
