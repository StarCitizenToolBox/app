// This is a generated file - do not edit.
//
// Generated from proto/partroom/partroom.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// 房间事件类型
class RoomEventType extends $pb.ProtobufEnum {
  static const RoomEventType MEMBER_JOINED =
      RoomEventType._(0, _omitEnumNames ? '' : 'MEMBER_JOINED');
  static const RoomEventType MEMBER_LEFT =
      RoomEventType._(1, _omitEnumNames ? '' : 'MEMBER_LEFT');
  static const RoomEventType OWNER_CHANGED =
      RoomEventType._(2, _omitEnumNames ? '' : 'OWNER_CHANGED');
  static const RoomEventType ROOM_UPDATED =
      RoomEventType._(3, _omitEnumNames ? '' : 'ROOM_UPDATED');
  static const RoomEventType MEMBER_STATUS_UPDATED =
      RoomEventType._(4, _omitEnumNames ? '' : 'MEMBER_STATUS_UPDATED');
  static const RoomEventType SIGNAL_BROADCAST =
      RoomEventType._(5, _omitEnumNames ? '' : 'SIGNAL_BROADCAST');
  static const RoomEventType ROOM_DISMISSED =
      RoomEventType._(6, _omitEnumNames ? '' : 'ROOM_DISMISSED');
  static const RoomEventType MEMBER_KICKED =
      RoomEventType._(7, _omitEnumNames ? '' : 'MEMBER_KICKED');

  static const $core.List<RoomEventType> values = <RoomEventType>[
    MEMBER_JOINED,
    MEMBER_LEFT,
    OWNER_CHANGED,
    ROOM_UPDATED,
    MEMBER_STATUS_UPDATED,
    SIGNAL_BROADCAST,
    ROOM_DISMISSED,
    MEMBER_KICKED,
  ];

  static final $core.List<RoomEventType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static RoomEventType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomEventType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
