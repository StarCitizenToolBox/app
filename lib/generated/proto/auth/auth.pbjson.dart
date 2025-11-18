// This is a generated file - do not edit.
//
// Generated from proto/auth/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use statusRequestDescriptor instead')
const StatusRequest$json = {
  '1': 'StatusRequest',
};

/// Descriptor for `StatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusRequestDescriptor =
    $convert.base64Decode('Cg1TdGF0dXNSZXF1ZXN0');

@$core.Deprecated('Use statusResponseDescriptor instead')
const StatusResponse$json = {
  '1': 'StatusResponse',
  '2': [
    {'1': 'online', '3': 1, '4': 1, '5': 8, '10': 'online'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'server_time', '3': 3, '4': 1, '5': 3, '10': 'serverTime'},
  ],
};

/// Descriptor for `StatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusResponseDescriptor = $convert.base64Decode(
    'Cg5TdGF0dXNSZXNwb25zZRIWCgZvbmxpbmUYASABKAhSBm9ubGluZRIYCgdtZXNzYWdlGAIgAS'
    'gJUgdtZXNzYWdlEh8KC3NlcnZlcl90aW1lGAMgASgDUgpzZXJ2ZXJUaW1l');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor =
    $convert.base64Decode('CgxMb2dpblJlcXVlc3Q=');

@$core.Deprecated('Use gameUserInfoDescriptor instead')
const GameUserInfo$json = {
  '1': 'GameUserInfo',
  '2': [
    {'1': 'game_user_id', '3': 1, '4': 1, '5': 9, '10': 'gameUserId'},
    {'1': 'handle_name', '3': 2, '4': 1, '5': 9, '10': 'handleName'},
    {'1': 'avatar_url', '3': 3, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'citizen_record', '3': 4, '4': 1, '5': 9, '10': 'citizenRecord'},
    {'1': 'enlisted_date', '3': 5, '4': 1, '5': 3, '10': 'enlistedDate'},
  ],
};

/// Descriptor for `GameUserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameUserInfoDescriptor = $convert.base64Decode(
    'CgxHYW1lVXNlckluZm8SIAoMZ2FtZV91c2VyX2lkGAEgASgJUgpnYW1lVXNlcklkEh8KC2hhbm'
    'RsZV9uYW1lGAIgASgJUgpoYW5kbGVOYW1lEh0KCmF2YXRhcl91cmwYAyABKAlSCWF2YXRhclVy'
    'bBIlCg5jaXRpemVuX3JlY29yZBgEIAEoCVINY2l0aXplblJlY29yZBIjCg1lbmxpc3RlZF9kYX'
    'RlGAUgASgDUgxlbmxpc3RlZERhdGU=');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    {
      '1': 'user_info',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.auth.GameUserInfo',
      '10': 'userInfo'
    },
    {'1': 'last_login_time', '3': 3, '4': 1, '5': 3, '10': 'lastLoginTime'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhIKBHV1aWQYASABKAlSBHV1aWQSLwoJdXNlcl9pbmZvGAIgASgLMh'
    'IuYXV0aC5HYW1lVXNlckluZm9SCHVzZXJJbmZvEiYKD2xhc3RfbG9naW5fdGltZRgDIAEoA1IN'
    'bGFzdExvZ2luVGltZQ==');

@$core.Deprecated('Use preRegisterRequestDescriptor instead')
const PreRegisterRequest$json = {
  '1': 'PreRegisterRequest',
  '2': [
    {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'game_user_id', '3': 2, '4': 1, '5': 9, '10': 'gameUserId'},
  ],
};

/// Descriptor for `PreRegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preRegisterRequestDescriptor = $convert.base64Decode(
    'ChJQcmVSZWdpc3RlclJlcXVlc3QSEgoEdXVpZBgBIAEoCVIEdXVpZBIgCgxnYW1lX3VzZXJfaW'
    'QYAiABKAlSCmdhbWVVc2VySWQ=');

@$core.Deprecated('Use preRegisterResponseDescriptor instead')
const PreRegisterResponse$json = {
  '1': 'PreRegisterResponse',
  '2': [
    {
      '1': 'verification_code',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'verificationCode'
    },
    {'1': 'expire_time', '3': 2, '4': 1, '5': 3, '10': 'expireTime'},
  ],
};

/// Descriptor for `PreRegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preRegisterResponseDescriptor = $convert.base64Decode(
    'ChNQcmVSZWdpc3RlclJlc3BvbnNlEisKEXZlcmlmaWNhdGlvbl9jb2RlGAEgASgJUhB2ZXJpZm'
    'ljYXRpb25Db2RlEh8KC2V4cGlyZV90aW1lGAIgASgDUgpleHBpcmVUaW1l');

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'game_user_id', '3': 2, '4': 1, '5': 9, '10': 'gameUserId'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSEgoEdXVpZBgBIAEoCVIEdXVpZBIgCgxnYW1lX3VzZXJfaWQYAi'
    'ABKAlSCmdhbWVVc2VySWQ=');

@$core.Deprecated('Use registerResponseDescriptor instead')
const RegisterResponse$json = {
  '1': 'RegisterResponse',
  '2': [
    {
      '1': 'party_room_secret_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'partyRoomSecretKey'
    },
    {
      '1': 'user_info',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.auth.GameUserInfo',
      '10': 'userInfo'
    },
  ],
};

/// Descriptor for `RegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerResponseDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclJlc3BvbnNlEjEKFXBhcnR5X3Jvb21fc2VjcmV0X2tleRgBIAEoCVIScGFydH'
    'lSb29tU2VjcmV0S2V5Ei8KCXVzZXJfaW5mbxgCIAEoCzISLmF1dGguR2FtZVVzZXJJbmZvUgh1'
    'c2VySW5mbw==');

@$core.Deprecated('Use unregisterRequestDescriptor instead')
const UnregisterRequest$json = {
  '1': 'UnregisterRequest',
};

/// Descriptor for `UnregisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unregisterRequestDescriptor =
    $convert.base64Decode('ChFVbnJlZ2lzdGVyUmVxdWVzdA==');

@$core.Deprecated('Use unregisterResponseDescriptor instead')
const UnregisterResponse$json = {
  '1': 'UnregisterResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UnregisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unregisterResponseDescriptor =
    $convert.base64Decode(
        'ChJVbnJlZ2lzdGVyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');
