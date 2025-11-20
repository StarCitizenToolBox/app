// This is a generated file - do not edit.
//
// Generated from proto/common/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getServerTimeRequestDescriptor instead')
const GetServerTimeRequest$json = {
  '1': 'GetServerTimeRequest',
};

/// Descriptor for `GetServerTimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerTimeRequestDescriptor =
    $convert.base64Decode('ChRHZXRTZXJ2ZXJUaW1lUmVxdWVzdA==');

@$core.Deprecated('Use getServerTimeResponseDescriptor instead')
const GetServerTimeResponse$json = {
  '1': 'GetServerTimeResponse',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'timezone', '3': 2, '4': 1, '5': 9, '10': 'timezone'},
  ],
};

/// Descriptor for `GetServerTimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerTimeResponseDescriptor = $convert.base64Decode(
    'ChVHZXRTZXJ2ZXJUaW1lUmVzcG9uc2USHAoJdGltZXN0YW1wGAEgASgDUgl0aW1lc3RhbXASGg'
    'oIdGltZXpvbmUYAiABKAlSCHRpbWV6b25l');

@$core.Deprecated('Use getVersionRequestDescriptor instead')
const GetVersionRequest$json = {
  '1': 'GetVersionRequest',
};

/// Descriptor for `GetVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVersionRequestDescriptor =
    $convert.base64Decode('ChFHZXRWZXJzaW9uUmVxdWVzdA==');

@$core.Deprecated('Use getVersionResponseDescriptor instead')
const GetVersionResponse$json = {
  '1': 'GetVersionResponse',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    {'1': 'latest_version', '3': 2, '4': 1, '5': 5, '10': 'latestVersion'},
    {
      '1': 'min_client_version',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'minClientVersion'
    },
  ],
};

/// Descriptor for `GetVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVersionResponseDescriptor = $convert.base64Decode(
    'ChJHZXRWZXJzaW9uUmVzcG9uc2USGAoHdmVyc2lvbhgBIAEoBVIHdmVyc2lvbhIlCg5sYXRlc3'
    'RfdmVyc2lvbhgCIAEoBVINbGF0ZXN0VmVyc2lvbhIsChJtaW5fY2xpZW50X3ZlcnNpb24YAyAB'
    'KAVSEG1pbkNsaWVudFZlcnNpb24=');

@$core.Deprecated('Use signalTypeDescriptor instead')
const SignalType$json = {
  '1': 'SignalType',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'is_special', '3': 3, '4': 1, '5': 8, '10': 'isSpecial'},
  ],
};

/// Descriptor for `SignalType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalTypeDescriptor = $convert.base64Decode(
    'CgpTaWduYWxUeXBlEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEh0KCmlzX3'
    'NwZWNpYWwYAyABKAhSCWlzU3BlY2lhbA==');

@$core.Deprecated('Use getSignalTypesRequestDescriptor instead')
const GetSignalTypesRequest$json = {
  '1': 'GetSignalTypesRequest',
};

/// Descriptor for `GetSignalTypesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSignalTypesRequestDescriptor =
    $convert.base64Decode('ChVHZXRTaWduYWxUeXBlc1JlcXVlc3Q=');

@$core.Deprecated('Use getSignalTypesResponseDescriptor instead')
const GetSignalTypesResponse$json = {
  '1': 'GetSignalTypesResponse',
  '2': [
    {
      '1': 'signals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.common.SignalType',
      '10': 'signals'
    },
  ],
};

/// Descriptor for `GetSignalTypesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSignalTypesResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRTaWduYWxUeXBlc1Jlc3BvbnNlEiwKB3NpZ25hbHMYASADKAsyEi5jb21tb24uU2lnbm'
        'FsVHlwZVIHc2lnbmFscw==');

@$core.Deprecated('Use tagDescriptor instead')
const Tag$json = {
  '1': 'Tag',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'info', '3': 3, '4': 1, '5': 9, '10': 'info'},
    {'1': 'color', '3': 4, '4': 1, '5': 9, '10': 'color'},
    {
      '1': 'sub_tags',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.common.Tag',
      '10': 'subTags'
    },
  ],
};

/// Descriptor for `Tag`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tagDescriptor = $convert.base64Decode(
    'CgNUYWcSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEaW5mbxgDIAEoCV'
    'IEaW5mbxIUCgVjb2xvchgEIAEoCVIFY29sb3ISJgoIc3ViX3RhZ3MYBSADKAsyCy5jb21tb24u'
    'VGFnUgdzdWJUYWdz');

@$core.Deprecated('Use getTagsRequestDescriptor instead')
const GetTagsRequest$json = {
  '1': 'GetTagsRequest',
};

/// Descriptor for `GetTagsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTagsRequestDescriptor =
    $convert.base64Decode('Cg5HZXRUYWdzUmVxdWVzdA==');

@$core.Deprecated('Use getTagsResponseDescriptor instead')
const GetTagsResponse$json = {
  '1': 'GetTagsResponse',
  '2': [
    {'1': 'tags', '3': 1, '4': 3, '5': 11, '6': '.common.Tag', '10': 'tags'},
  ],
};

/// Descriptor for `GetTagsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTagsResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRUYWdzUmVzcG9uc2USHwoEdGFncxgBIAMoCzILLmNvbW1vbi5UYWdSBHRhZ3M=');
