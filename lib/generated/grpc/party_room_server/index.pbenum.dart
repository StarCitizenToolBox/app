//
//  Generated code. Do not modify.
//  source: index.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RoomStatus extends $pb.ProtobufEnum {
  static const RoomStatus All = RoomStatus._(0, _omitEnumNames ? '' : 'All');
  static const RoomStatus Open = RoomStatus._(1, _omitEnumNames ? '' : 'Open');
  static const RoomStatus Private = RoomStatus._(2, _omitEnumNames ? '' : 'Private');
  static const RoomStatus Full = RoomStatus._(3, _omitEnumNames ? '' : 'Full');
  static const RoomStatus Closed = RoomStatus._(4, _omitEnumNames ? '' : 'Closed');
  static const RoomStatus WillOffline = RoomStatus._(5, _omitEnumNames ? '' : 'WillOffline');
  static const RoomStatus Offline = RoomStatus._(6, _omitEnumNames ? '' : 'Offline');

  static const $core.List<RoomStatus> values = <RoomStatus> [
    All,
    Open,
    Private,
    Full,
    Closed,
    WillOffline,
    Offline,
  ];

  static final $core.Map<$core.int, RoomStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RoomStatus? valueOf($core.int value) => _byValue[value];

  const RoomStatus._($core.int v, $core.String n) : super(v, n);
}

class RoomSortType extends $pb.ProtobufEnum {
  static const RoomSortType Default = RoomSortType._(0, _omitEnumNames ? '' : 'Default');
  static const RoomSortType MostPlayerNumber = RoomSortType._(1, _omitEnumNames ? '' : 'MostPlayerNumber');
  static const RoomSortType MinimumPlayerNumber = RoomSortType._(2, _omitEnumNames ? '' : 'MinimumPlayerNumber');
  static const RoomSortType RecentlyCreated = RoomSortType._(3, _omitEnumNames ? '' : 'RecentlyCreated');
  static const RoomSortType OldestCreated = RoomSortType._(4, _omitEnumNames ? '' : 'OldestCreated');

  static const $core.List<RoomSortType> values = <RoomSortType> [
    Default,
    MostPlayerNumber,
    MinimumPlayerNumber,
    RecentlyCreated,
    OldestCreated,
  ];

  static final $core.Map<$core.int, RoomSortType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RoomSortType? valueOf($core.int value) => _byValue[value];

  const RoomSortType._($core.int v, $core.String n) : super(v, n);
}

class RoomUserStatus extends $pb.ProtobufEnum {
  static const RoomUserStatus RoomUserStatusJoin = RoomUserStatus._(0, _omitEnumNames ? '' : 'RoomUserStatusJoin');
  static const RoomUserStatus RoomUserStatusLostOffline = RoomUserStatus._(1, _omitEnumNames ? '' : 'RoomUserStatusLostOffline');
  static const RoomUserStatus RoomUserStatusLeave = RoomUserStatus._(2, _omitEnumNames ? '' : 'RoomUserStatusLeave');
  static const RoomUserStatus RoomUserStatusWaitingConnect = RoomUserStatus._(3, _omitEnumNames ? '' : 'RoomUserStatusWaitingConnect');

  static const $core.List<RoomUserStatus> values = <RoomUserStatus> [
    RoomUserStatusJoin,
    RoomUserStatusLostOffline,
    RoomUserStatusLeave,
    RoomUserStatusWaitingConnect,
  ];

  static final $core.Map<$core.int, RoomUserStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RoomUserStatus? valueOf($core.int value) => _byValue[value];

  const RoomUserStatus._($core.int v, $core.String n) : super(v, n);
}

class RoomUpdateType extends $pb.ProtobufEnum {
  static const RoomUpdateType RoomUpdateData = RoomUpdateType._(0, _omitEnumNames ? '' : 'RoomUpdateData');
  static const RoomUpdateType RoomClose = RoomUpdateType._(1, _omitEnumNames ? '' : 'RoomClose');

  static const $core.List<RoomUpdateType> values = <RoomUpdateType> [
    RoomUpdateData,
    RoomClose,
  ];

  static final $core.Map<$core.int, RoomUpdateType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RoomUpdateType? valueOf($core.int value) => _byValue[value];

  const RoomUpdateType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
