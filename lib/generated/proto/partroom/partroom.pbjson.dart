// This is a generated file - do not edit.
//
// Generated from proto/partroom/partroom.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use roomEventTypeDescriptor instead')
const RoomEventType$json = {
  '1': 'RoomEventType',
  '2': [
    {'1': 'MEMBER_JOINED', '2': 0},
    {'1': 'MEMBER_LEFT', '2': 1},
    {'1': 'OWNER_CHANGED', '2': 2},
    {'1': 'ROOM_UPDATED', '2': 3},
    {'1': 'MEMBER_STATUS_UPDATED', '2': 4},
    {'1': 'SIGNAL_BROADCAST', '2': 5},
    {'1': 'ROOM_DISMISSED', '2': 6},
    {'1': 'MEMBER_KICKED', '2': 7},
  ],
};

/// Descriptor for `RoomEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomEventTypeDescriptor = $convert.base64Decode(
    'Cg1Sb29tRXZlbnRUeXBlEhEKDU1FTUJFUl9KT0lORUQQABIPCgtNRU1CRVJfTEVGVBABEhEKDU'
    '9XTkVSX0NIQU5HRUQQAhIQCgxST09NX1VQREFURUQQAxIZChVNRU1CRVJfU1RBVFVTX1VQREFU'
    'RUQQBBIUChBTSUdOQUxfQlJPQURDQVNUEAUSEgoOUk9PTV9ESVNNSVNTRUQQBhIRCg1NRU1CRV'
    'JfS0lDS0VEEAc=');

@$core.Deprecated('Use roomListItemDescriptor instead')
const RoomListItem$json = {
  '1': 'RoomListItem',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'owner_game_id', '3': 2, '4': 1, '5': 9, '10': 'ownerGameId'},
    {'1': 'owner_handle_name', '3': 3, '4': 1, '5': 9, '10': 'ownerHandleName'},
    {'1': 'owner_avatar', '3': 4, '4': 1, '5': 9, '10': 'ownerAvatar'},
    {'1': 'main_tag_id', '3': 5, '4': 1, '5': 9, '10': 'mainTagId'},
    {'1': 'sub_tag_id', '3': 6, '4': 1, '5': 9, '10': 'subTagId'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'owner_last_active', '3': 8, '4': 1, '5': 3, '10': 'ownerLastActive'},
    {'1': 'current_members', '3': 9, '4': 1, '5': 5, '10': 'currentMembers'},
    {'1': 'target_members', '3': 10, '4': 1, '5': 5, '10': 'targetMembers'},
    {'1': 'has_password', '3': 11, '4': 1, '5': 8, '10': 'hasPassword'},
    {'1': 'social_links', '3': 12, '4': 3, '5': 9, '10': 'socialLinks'},
  ],
};

/// Descriptor for `RoomListItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomListItemDescriptor = $convert.base64Decode(
    'CgxSb29tTGlzdEl0ZW0SGwoJcm9vbV91dWlkGAEgASgJUghyb29tVXVpZBIiCg1vd25lcl9nYW'
    '1lX2lkGAIgASgJUgtvd25lckdhbWVJZBIqChFvd25lcl9oYW5kbGVfbmFtZRgDIAEoCVIPb3du'
    'ZXJIYW5kbGVOYW1lEiEKDG93bmVyX2F2YXRhchgEIAEoCVILb3duZXJBdmF0YXISHgoLbWFpbl'
    '90YWdfaWQYBSABKAlSCW1haW5UYWdJZBIcCgpzdWJfdGFnX2lkGAYgASgJUghzdWJUYWdJZBId'
    'CgpjcmVhdGVkX2F0GAcgASgDUgljcmVhdGVkQXQSKgoRb3duZXJfbGFzdF9hY3RpdmUYCCABKA'
    'NSD293bmVyTGFzdEFjdGl2ZRInCg9jdXJyZW50X21lbWJlcnMYCSABKAVSDmN1cnJlbnRNZW1i'
    'ZXJzEiUKDnRhcmdldF9tZW1iZXJzGAogASgFUg10YXJnZXRNZW1iZXJzEiEKDGhhc19wYXNzd2'
    '9yZBgLIAEoCFILaGFzUGFzc3dvcmQSIQoMc29jaWFsX2xpbmtzGAwgAygJUgtzb2NpYWxMaW5r'
    'cw==');

@$core.Deprecated('Use getRoomListRequestDescriptor instead')
const GetRoomListRequest$json = {
  '1': 'GetRoomListRequest',
  '2': [
    {'1': 'main_tag_id', '3': 1, '4': 1, '5': 9, '10': 'mainTagId'},
    {'1': 'sub_tag_id', '3': 2, '4': 1, '5': 9, '10': 'subTagId'},
    {'1': 'search_owner_name', '3': 3, '4': 1, '5': 9, '10': 'searchOwnerName'},
    {'1': 'page', '3': 4, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetRoomListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomListRequestDescriptor = $convert.base64Decode(
    'ChJHZXRSb29tTGlzdFJlcXVlc3QSHgoLbWFpbl90YWdfaWQYASABKAlSCW1haW5UYWdJZBIcCg'
    'pzdWJfdGFnX2lkGAIgASgJUghzdWJUYWdJZBIqChFzZWFyY2hfb3duZXJfbmFtZRgDIAEoCVIP'
    'c2VhcmNoT3duZXJOYW1lEhIKBHBhZ2UYBCABKAVSBHBhZ2USGwoJcGFnZV9zaXplGAUgASgFUg'
    'hwYWdlU2l6ZQ==');

@$core.Deprecated('Use getRoomListResponseDescriptor instead')
const GetRoomListResponse$json = {
  '1': 'GetRoomListResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.partroom.RoomListItem',
      '10': 'rooms'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
    {'1': 'page', '3': 3, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetRoomListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomListResponseDescriptor = $convert.base64Decode(
    'ChNHZXRSb29tTGlzdFJlc3BvbnNlEiwKBXJvb21zGAEgAygLMhYucGFydHJvb20uUm9vbUxpc3'
    'RJdGVtUgVyb29tcxIUCgV0b3RhbBgCIAEoBVIFdG90YWwSEgoEcGFnZRgDIAEoBVIEcGFnZRIb'
    'CglwYWdlX3NpemUYBCABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use createRoomRequestDescriptor instead')
const CreateRoomRequest$json = {
  '1': 'CreateRoomRequest',
  '2': [
    {'1': 'main_tag_id', '3': 1, '4': 1, '5': 9, '10': 'mainTagId'},
    {'1': 'sub_tag_id', '3': 2, '4': 1, '5': 9, '10': 'subTagId'},
    {'1': 'target_members', '3': 3, '4': 1, '5': 5, '10': 'targetMembers'},
    {'1': 'has_password', '3': 4, '4': 1, '5': 8, '10': 'hasPassword'},
    {'1': 'password', '3': 5, '4': 1, '5': 9, '10': 'password'},
    {'1': 'social_links', '3': 6, '4': 3, '5': 9, '10': 'socialLinks'},
  ],
};

/// Descriptor for `CreateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVSb29tUmVxdWVzdBIeCgttYWluX3RhZ19pZBgBIAEoCVIJbWFpblRhZ0lkEhwKCn'
    'N1Yl90YWdfaWQYAiABKAlSCHN1YlRhZ0lkEiUKDnRhcmdldF9tZW1iZXJzGAMgASgFUg10YXJn'
    'ZXRNZW1iZXJzEiEKDGhhc19wYXNzd29yZBgEIAEoCFILaGFzUGFzc3dvcmQSGgoIcGFzc3dvcm'
    'QYBSABKAlSCHBhc3N3b3JkEiEKDHNvY2lhbF9saW5rcxgGIAMoCVILc29jaWFsTGlua3M=');

@$core.Deprecated('Use createRoomResponseDescriptor instead')
const CreateRoomResponse$json = {
  '1': 'CreateRoomResponse',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
  ],
};

/// Descriptor for `CreateRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomResponseDescriptor =
    $convert.base64Decode(
        'ChJDcmVhdGVSb29tUmVzcG9uc2USGwoJcm9vbV91dWlkGAEgASgJUghyb29tVXVpZA==');

@$core.Deprecated('Use joinRoomRequestDescriptor instead')
const JoinRoomRequest$json = {
  '1': 'JoinRoomRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `JoinRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomRequestDescriptor = $convert.base64Decode(
    'Cg9Kb2luUm9vbVJlcXVlc3QSGwoJcm9vbV91dWlkGAEgASgJUghyb29tVXVpZBIaCghwYXNzd2'
    '9yZBgCIAEoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use joinRoomResponseDescriptor instead')
const JoinRoomResponse$json = {
  '1': 'JoinRoomResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `JoinRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomResponseDescriptor = $convert.base64Decode(
    'ChBKb2luUm9vbVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use leaveRoomRequestDescriptor instead')
const LeaveRoomRequest$json = {
  '1': 'LeaveRoomRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
  ],
};

/// Descriptor for `LeaveRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveRoomRequestDescriptor = $convert.base64Decode(
    'ChBMZWF2ZVJvb21SZXF1ZXN0EhsKCXJvb21fdXVpZBgBIAEoCVIIcm9vbVV1aWQ=');

@$core.Deprecated('Use leaveRoomResponseDescriptor instead')
const LeaveRoomResponse$json = {
  '1': 'LeaveRoomResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LeaveRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveRoomResponseDescriptor = $convert.base64Decode(
    'ChFMZWF2ZVJvb21SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use dismissRoomRequestDescriptor instead')
const DismissRoomRequest$json = {
  '1': 'DismissRoomRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
  ],
};

/// Descriptor for `DismissRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissRoomRequestDescriptor =
    $convert.base64Decode(
        'ChJEaXNtaXNzUm9vbVJlcXVlc3QSGwoJcm9vbV91dWlkGAEgASgJUghyb29tVXVpZA==');

@$core.Deprecated('Use dismissRoomResponseDescriptor instead')
const DismissRoomResponse$json = {
  '1': 'DismissRoomResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DismissRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissRoomResponseDescriptor =
    $convert.base64Decode(
        'ChNEaXNtaXNzUm9vbVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use memberStatusDescriptor instead')
const MemberStatus$json = {
  '1': 'MemberStatus',
  '2': [
    {'1': 'current_location', '3': 1, '4': 1, '5': 9, '10': 'currentLocation'},
    {'1': 'kills', '3': 2, '4': 1, '5': 5, '10': 'kills'},
    {'1': 'deaths', '3': 3, '4': 1, '5': 5, '10': 'deaths'},
    {'1': 'play_time', '3': 4, '4': 1, '5': 3, '10': 'playTime'},
  ],
};

/// Descriptor for `MemberStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberStatusDescriptor = $convert.base64Decode(
    'CgxNZW1iZXJTdGF0dXMSKQoQY3VycmVudF9sb2NhdGlvbhgBIAEoCVIPY3VycmVudExvY2F0aW'
    '9uEhQKBWtpbGxzGAIgASgFUgVraWxscxIWCgZkZWF0aHMYAyABKAVSBmRlYXRocxIbCglwbGF5'
    'X3RpbWUYBCABKANSCHBsYXlUaW1l');

@$core.Deprecated('Use roomMemberDescriptor instead')
const RoomMember$json = {
  '1': 'RoomMember',
  '2': [
    {'1': 'game_user_id', '3': 1, '4': 1, '5': 9, '10': 'gameUserId'},
    {'1': 'handle_name', '3': 2, '4': 1, '5': 9, '10': 'handleName'},
    {'1': 'avatar_url', '3': 3, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'joined_at', '3': 4, '4': 1, '5': 3, '10': 'joinedAt'},
    {'1': 'last_active', '3': 5, '4': 1, '5': 3, '10': 'lastActive'},
    {'1': 'is_owner', '3': 6, '4': 1, '5': 8, '10': 'isOwner'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.partroom.MemberStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `RoomMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomMemberDescriptor = $convert.base64Decode(
    'CgpSb29tTWVtYmVyEiAKDGdhbWVfdXNlcl9pZBgBIAEoCVIKZ2FtZVVzZXJJZBIfCgtoYW5kbG'
    'VfbmFtZRgCIAEoCVIKaGFuZGxlTmFtZRIdCgphdmF0YXJfdXJsGAMgASgJUglhdmF0YXJVcmwS'
    'GwoJam9pbmVkX2F0GAQgASgDUghqb2luZWRBdBIfCgtsYXN0X2FjdGl2ZRgFIAEoA1IKbGFzdE'
    'FjdGl2ZRIZCghpc19vd25lchgGIAEoCFIHaXNPd25lchIuCgZzdGF0dXMYByABKAsyFi5wYXJ0'
    'cm9vbS5NZW1iZXJTdGF0dXNSBnN0YXR1cw==');

@$core.Deprecated('Use roomInfoDescriptor instead')
const RoomInfo$json = {
  '1': 'RoomInfo',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'owner_game_id', '3': 2, '4': 1, '5': 9, '10': 'ownerGameId'},
    {'1': 'main_tag_id', '3': 3, '4': 1, '5': 9, '10': 'mainTagId'},
    {'1': 'sub_tag_id', '3': 4, '4': 1, '5': 9, '10': 'subTagId'},
    {'1': 'target_members', '3': 5, '4': 1, '5': 5, '10': 'targetMembers'},
    {'1': 'has_password', '3': 6, '4': 1, '5': 8, '10': 'hasPassword'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'current_members', '3': 8, '4': 1, '5': 5, '10': 'currentMembers'},
    {'1': 'social_links', '3': 9, '4': 3, '5': 9, '10': 'socialLinks'},
  ],
};

/// Descriptor for `RoomInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomInfoDescriptor = $convert.base64Decode(
    'CghSb29tSW5mbxIbCglyb29tX3V1aWQYASABKAlSCHJvb21VdWlkEiIKDW93bmVyX2dhbWVfaW'
    'QYAiABKAlSC293bmVyR2FtZUlkEh4KC21haW5fdGFnX2lkGAMgASgJUgltYWluVGFnSWQSHAoK'
    'c3ViX3RhZ19pZBgEIAEoCVIIc3ViVGFnSWQSJQoOdGFyZ2V0X21lbWJlcnMYBSABKAVSDXRhcm'
    'dldE1lbWJlcnMSIQoMaGFzX3Bhc3N3b3JkGAYgASgIUgtoYXNQYXNzd29yZBIdCgpjcmVhdGVk'
    'X2F0GAcgASgDUgljcmVhdGVkQXQSJwoPY3VycmVudF9tZW1iZXJzGAggASgFUg5jdXJyZW50TW'
    'VtYmVycxIhCgxzb2NpYWxfbGlua3MYCSADKAlSC3NvY2lhbExpbmtz');

@$core.Deprecated('Use getRoomInfoRequestDescriptor instead')
const GetRoomInfoRequest$json = {
  '1': 'GetRoomInfoRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
  ],
};

/// Descriptor for `GetRoomInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomInfoRequestDescriptor =
    $convert.base64Decode(
        'ChJHZXRSb29tSW5mb1JlcXVlc3QSGwoJcm9vbV91dWlkGAEgASgJUghyb29tVXVpZA==');

@$core.Deprecated('Use getRoomInfoResponseDescriptor instead')
const GetRoomInfoResponse$json = {
  '1': 'GetRoomInfoResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.partroom.RoomInfo',
      '10': 'room'
    },
  ],
};

/// Descriptor for `GetRoomInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomInfoResponseDescriptor = $convert.base64Decode(
    'ChNHZXRSb29tSW5mb1Jlc3BvbnNlEiYKBHJvb20YASABKAsyEi5wYXJ0cm9vbS5Sb29tSW5mb1'
    'IEcm9vbQ==');

@$core.Deprecated('Use getRoomMembersRequestDescriptor instead')
const GetRoomMembersRequest$json = {
  '1': 'GetRoomMembersRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetRoomMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomMembersRequestDescriptor = $convert.base64Decode(
    'ChVHZXRSb29tTWVtYmVyc1JlcXVlc3QSGwoJcm9vbV91dWlkGAEgASgJUghyb29tVXVpZBISCg'
    'RwYWdlGAIgASgFUgRwYWdlEhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use getRoomMembersResponseDescriptor instead')
const GetRoomMembersResponse$json = {
  '1': 'GetRoomMembersResponse',
  '2': [
    {
      '1': 'members',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.partroom.RoomMember',
      '10': 'members'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `GetRoomMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomMembersResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRSb29tTWVtYmVyc1Jlc3BvbnNlEi4KB21lbWJlcnMYASADKAsyFC5wYXJ0cm9vbS5Sb2'
        '9tTWVtYmVyUgdtZW1iZXJzEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');

@$core.Deprecated('Use heartbeatRequestDescriptor instead')
const HeartbeatRequest$json = {
  '1': 'HeartbeatRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
  ],
};

/// Descriptor for `HeartbeatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatRequestDescriptor = $convert.base64Decode(
    'ChBIZWFydGJlYXRSZXF1ZXN0EhsKCXJvb21fdXVpZBgBIAEoCVIIcm9vbVV1aWQ=');

@$core.Deprecated('Use heartbeatResponseDescriptor instead')
const HeartbeatResponse$json = {
  '1': 'HeartbeatResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `HeartbeatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatResponseDescriptor = $convert.base64Decode(
    'ChFIZWFydGJlYXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use getMyRoomRequestDescriptor instead')
const GetMyRoomRequest$json = {
  '1': 'GetMyRoomRequest',
};

/// Descriptor for `GetMyRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyRoomRequestDescriptor =
    $convert.base64Decode('ChBHZXRNeVJvb21SZXF1ZXN0');

@$core.Deprecated('Use getMyRoomResponseDescriptor instead')
const GetMyRoomResponse$json = {
  '1': 'GetMyRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.partroom.RoomInfo',
      '10': 'room'
    },
    {'1': 'has_room', '3': 2, '4': 1, '5': 8, '10': 'hasRoom'},
  ],
};

/// Descriptor for `GetMyRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyRoomResponseDescriptor = $convert.base64Decode(
    'ChFHZXRNeVJvb21SZXNwb25zZRImCgRyb29tGAEgASgLMhIucGFydHJvb20uUm9vbUluZm9SBH'
    'Jvb20SGQoIaGFzX3Jvb20YAiABKAhSB2hhc1Jvb20=');

@$core.Deprecated('Use updateRoomRequestDescriptor instead')
const UpdateRoomRequest$json = {
  '1': 'UpdateRoomRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'target_members', '3': 2, '4': 1, '5': 5, '10': 'targetMembers'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
    {'1': 'main_tag_id', '3': 4, '4': 1, '5': 9, '10': 'mainTagId'},
    {'1': 'sub_tag_id', '3': 5, '4': 1, '5': 9, '10': 'subTagId'},
    {'1': 'social_links', '3': 6, '4': 3, '5': 9, '10': 'socialLinks'},
  ],
};

/// Descriptor for `UpdateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVSb29tUmVxdWVzdBIbCglyb29tX3V1aWQYASABKAlSCHJvb21VdWlkEiUKDnRhcm'
    'dldF9tZW1iZXJzGAIgASgFUg10YXJnZXRNZW1iZXJzEhoKCHBhc3N3b3JkGAMgASgJUghwYXNz'
    'd29yZBIeCgttYWluX3RhZ19pZBgEIAEoCVIJbWFpblRhZ0lkEhwKCnN1Yl90YWdfaWQYBSABKA'
    'lSCHN1YlRhZ0lkEiEKDHNvY2lhbF9saW5rcxgGIAMoCVILc29jaWFsTGlua3M=');

@$core.Deprecated('Use updateRoomResponseDescriptor instead')
const UpdateRoomResponse$json = {
  '1': 'UpdateRoomResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UpdateRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomResponseDescriptor =
    $convert.base64Decode(
        'ChJVcGRhdGVSb29tUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use kickMemberRequestDescriptor instead')
const KickMemberRequest$json = {
  '1': 'KickMemberRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {
      '1': 'target_game_user_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'targetGameUserId'
    },
  ],
};

/// Descriptor for `KickMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickMemberRequestDescriptor = $convert.base64Decode(
    'ChFLaWNrTWVtYmVyUmVxdWVzdBIbCglyb29tX3V1aWQYASABKAlSCHJvb21VdWlkEi0KE3Rhcm'
    'dldF9nYW1lX3VzZXJfaWQYAiABKAlSEHRhcmdldEdhbWVVc2VySWQ=');

@$core.Deprecated('Use kickMemberResponseDescriptor instead')
const KickMemberResponse$json = {
  '1': 'KickMemberResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `KickMemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickMemberResponseDescriptor =
    $convert.base64Decode(
        'ChJLaWNrTWVtYmVyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use setStatusRequestDescriptor instead')
const SetStatusRequest$json = {
  '1': 'SetStatusRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.partroom.MemberStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `SetStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setStatusRequestDescriptor = $convert.base64Decode(
    'ChBTZXRTdGF0dXNSZXF1ZXN0EhsKCXJvb21fdXVpZBgBIAEoCVIIcm9vbVV1aWQSLgoGc3RhdH'
    'VzGAIgASgLMhYucGFydHJvb20uTWVtYmVyU3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use setStatusResponseDescriptor instead')
const SetStatusResponse$json = {
  '1': 'SetStatusResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SetStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setStatusResponseDescriptor = $convert.base64Decode(
    'ChFTZXRTdGF0dXNSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use sendSignalRequestDescriptor instead')
const SendSignalRequest$json = {
  '1': 'SendSignalRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'signal_id', '3': 2, '4': 1, '5': 9, '10': 'signalId'},
    {
      '1': 'params',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.partroom.SendSignalRequest.ParamsEntry',
      '10': 'params'
    },
  ],
  '3': [SendSignalRequest_ParamsEntry$json],
};

@$core.Deprecated('Use sendSignalRequestDescriptor instead')
const SendSignalRequest_ParamsEntry$json = {
  '1': 'ParamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SendSignalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendSignalRequestDescriptor = $convert.base64Decode(
    'ChFTZW5kU2lnbmFsUmVxdWVzdBIbCglyb29tX3V1aWQYASABKAlSCHJvb21VdWlkEhsKCXNpZ2'
    '5hbF9pZBgCIAEoCVIIc2lnbmFsSWQSPwoGcGFyYW1zGAMgAygLMicucGFydHJvb20uU2VuZFNp'
    'Z25hbFJlcXVlc3QuUGFyYW1zRW50cnlSBnBhcmFtcxo5CgtQYXJhbXNFbnRyeRIQCgNrZXkYAS'
    'ABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use sendSignalResponseDescriptor instead')
const SendSignalResponse$json = {
  '1': 'SendSignalResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SendSignalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendSignalResponseDescriptor =
    $convert.base64Decode(
        'ChJTZW5kU2lnbmFsUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use roomEventDescriptor instead')
const RoomEvent$json = {
  '1': 'RoomEvent',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.partroom.RoomEventType',
      '10': 'type'
    },
    {'1': 'room_uuid', '3': 2, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 3, '10': 'timestamp'},
    {
      '1': 'member',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.partroom.RoomMember',
      '10': 'member'
    },
    {'1': 'signal_id', '3': 5, '4': 1, '5': 9, '10': 'signalId'},
    {'1': 'signal_sender', '3': 6, '4': 1, '5': 9, '10': 'signalSender'},
    {
      '1': 'signal_params',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.partroom.RoomEvent.SignalParamsEntry',
      '10': 'signalParams'
    },
    {
      '1': 'room_info',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.partroom.RoomInfo',
      '10': 'roomInfo'
    },
  ],
  '3': [RoomEvent_SignalParamsEntry$json],
};

@$core.Deprecated('Use roomEventDescriptor instead')
const RoomEvent_SignalParamsEntry$json = {
  '1': 'SignalParamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `RoomEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomEventDescriptor = $convert.base64Decode(
    'CglSb29tRXZlbnQSKwoEdHlwZRgBIAEoDjIXLnBhcnRyb29tLlJvb21FdmVudFR5cGVSBHR5cG'
    'USGwoJcm9vbV91dWlkGAIgASgJUghyb29tVXVpZBIcCgl0aW1lc3RhbXAYAyABKANSCXRpbWVz'
    'dGFtcBIsCgZtZW1iZXIYBCABKAsyFC5wYXJ0cm9vbS5Sb29tTWVtYmVyUgZtZW1iZXISGwoJc2'
    'lnbmFsX2lkGAUgASgJUghzaWduYWxJZBIjCg1zaWduYWxfc2VuZGVyGAYgASgJUgxzaWduYWxT'
    'ZW5kZXISSgoNc2lnbmFsX3BhcmFtcxgHIAMoCzIlLnBhcnRyb29tLlJvb21FdmVudC5TaWduYW'
    'xQYXJhbXNFbnRyeVIMc2lnbmFsUGFyYW1zEi8KCXJvb21faW5mbxgIIAEoCzISLnBhcnRyb29t'
    'LlJvb21JbmZvUghyb29tSW5mbxo/ChFTaWduYWxQYXJhbXNFbnRyeRIQCgNrZXkYASABKAlSA2'
    'tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use listenRoomEventsRequestDescriptor instead')
const ListenRoomEventsRequest$json = {
  '1': 'ListenRoomEventsRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
  ],
};

/// Descriptor for `ListenRoomEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listenRoomEventsRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0ZW5Sb29tRXZlbnRzUmVxdWVzdBIbCglyb29tX3V1aWQYASABKAlSCHJvb21VdWlk');

@$core.Deprecated('Use transferOwnershipRequestDescriptor instead')
const TransferOwnershipRequest$json = {
  '1': 'TransferOwnershipRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {
      '1': 'target_game_user_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'targetGameUserId'
    },
  ],
};

/// Descriptor for `TransferOwnershipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferOwnershipRequestDescriptor =
    $convert.base64Decode(
        'ChhUcmFuc2Zlck93bmVyc2hpcFJlcXVlc3QSGwoJcm9vbV91dWlkGAEgASgJUghyb29tVXVpZB'
        'ItChN0YXJnZXRfZ2FtZV91c2VyX2lkGAIgASgJUhB0YXJnZXRHYW1lVXNlcklk');

@$core.Deprecated('Use transferOwnershipResponseDescriptor instead')
const TransferOwnershipResponse$json = {
  '1': 'TransferOwnershipResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `TransferOwnershipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferOwnershipResponseDescriptor =
    $convert.base64Decode(
        'ChlUcmFuc2Zlck93bmVyc2hpcFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use kickedMemberDescriptor instead')
const KickedMember$json = {
  '1': 'KickedMember',
  '2': [
    {'1': 'game_user_id', '3': 1, '4': 1, '5': 9, '10': 'gameUserId'},
    {'1': 'handle_name', '3': 2, '4': 1, '5': 9, '10': 'handleName'},
    {'1': 'avatar_url', '3': 3, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'joined_at', '3': 4, '4': 1, '5': 3, '10': 'joinedAt'},
    {'1': 'kicked_at', '3': 5, '4': 1, '5': 3, '10': 'kickedAt'},
  ],
};

/// Descriptor for `KickedMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickedMemberDescriptor = $convert.base64Decode(
    'CgxLaWNrZWRNZW1iZXISIAoMZ2FtZV91c2VyX2lkGAEgASgJUgpnYW1lVXNlcklkEh8KC2hhbm'
    'RsZV9uYW1lGAIgASgJUgpoYW5kbGVOYW1lEh0KCmF2YXRhcl91cmwYAyABKAlSCWF2YXRhclVy'
    'bBIbCglqb2luZWRfYXQYBCABKANSCGpvaW5lZEF0EhsKCWtpY2tlZF9hdBgFIAEoA1IIa2lja2'
    'VkQXQ=');

@$core.Deprecated('Use getKickedMembersRequestDescriptor instead')
const GetKickedMembersRequest$json = {
  '1': 'GetKickedMembersRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetKickedMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getKickedMembersRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRLaWNrZWRNZW1iZXJzUmVxdWVzdBIbCglyb29tX3V1aWQYASABKAlSCHJvb21VdWlkEh'
        'IKBHBhZ2UYAiABKAVSBHBhZ2USGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use getKickedMembersResponseDescriptor instead')
const GetKickedMembersResponse$json = {
  '1': 'GetKickedMembersResponse',
  '2': [
    {
      '1': 'members',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.partroom.KickedMember',
      '10': 'members'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `GetKickedMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getKickedMembersResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRLaWNrZWRNZW1iZXJzUmVzcG9uc2USMAoHbWVtYmVycxgBIAMoCzIWLnBhcnRyb29tLk'
        'tpY2tlZE1lbWJlclIHbWVtYmVycxIUCgV0b3RhbBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use removeKickedMemberRequestDescriptor instead')
const RemoveKickedMemberRequest$json = {
  '1': 'RemoveKickedMemberRequest',
  '2': [
    {'1': 'room_uuid', '3': 1, '4': 1, '5': 9, '10': 'roomUuid'},
    {'1': 'game_user_id', '3': 2, '4': 1, '5': 9, '10': 'gameUserId'},
  ],
};

/// Descriptor for `RemoveKickedMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeKickedMemberRequestDescriptor =
    $convert.base64Decode(
        'ChlSZW1vdmVLaWNrZWRNZW1iZXJSZXF1ZXN0EhsKCXJvb21fdXVpZBgBIAEoCVIIcm9vbVV1aW'
        'QSIAoMZ2FtZV91c2VyX2lkGAIgASgJUgpnYW1lVXNlcklk');

@$core.Deprecated('Use removeKickedMemberResponseDescriptor instead')
const RemoveKickedMemberResponse$json = {
  '1': 'RemoveKickedMemberResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `RemoveKickedMemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeKickedMemberResponseDescriptor =
    $convert.base64Decode(
        'ChpSZW1vdmVLaWNrZWRNZW1iZXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');
