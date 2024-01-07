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


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
