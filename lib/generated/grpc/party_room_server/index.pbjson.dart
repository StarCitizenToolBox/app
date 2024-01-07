//
//  Generated code. Do not modify.
//  source: index.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use roomStatusDescriptor instead')
const RoomStatus$json = {
  '1': 'RoomStatus',
  '2': [
    {'1': 'All', '2': 0},
    {'1': 'Open', '2': 1},
    {'1': 'Private', '2': 2},
    {'1': 'Full', '2': 3},
    {'1': 'Closed', '2': 4},
    {'1': 'WillOffline', '2': 5},
    {'1': 'Offline', '2': 6},
  ],
};

/// Descriptor for `RoomStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomStatusDescriptor = $convert.base64Decode(
    'CgpSb29tU3RhdHVzEgcKA0FsbBAAEggKBE9wZW4QARILCgdQcml2YXRlEAISCAoERnVsbBADEg'
    'oKBkNsb3NlZBAEEg8KC1dpbGxPZmZsaW5lEAUSCwoHT2ZmbGluZRAG');

@$core.Deprecated('Use roomSortTypeDescriptor instead')
const RoomSortType$json = {
  '1': 'RoomSortType',
  '2': [
    {'1': 'Default', '2': 0},
    {'1': 'MostPlayerNumber', '2': 1},
    {'1': 'MinimumPlayerNumber', '2': 2},
    {'1': 'RecentlyCreated', '2': 3},
    {'1': 'OldestCreated', '2': 4},
  ],
};

/// Descriptor for `RoomSortType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomSortTypeDescriptor = $convert.base64Decode(
    'CgxSb29tU29ydFR5cGUSCwoHRGVmYXVsdBAAEhQKEE1vc3RQbGF5ZXJOdW1iZXIQARIXChNNaW'
    '5pbXVtUGxheWVyTnVtYmVyEAISEwoPUmVjZW50bHlDcmVhdGVkEAMSEQoNT2xkZXN0Q3JlYXRl'
    'ZBAE');

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use pingDataDescriptor instead')
const PingData$json = {
  '1': 'PingData',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 9, '10': 'data'},
    {'1': 'clientVersion', '3': 2, '4': 1, '5': 18, '10': 'clientVersion'},
    {'1': 'serverVersion', '3': 3, '4': 1, '5': 18, '10': 'serverVersion'},
  ],
};

/// Descriptor for `PingData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingDataDescriptor = $convert.base64Decode(
    'CghQaW5nRGF0YRISCgRkYXRhGAEgASgJUgRkYXRhEiQKDWNsaWVudFZlcnNpb24YAiABKBJSDW'
    'NsaWVudFZlcnNpb24SJAoNc2VydmVyVmVyc2lvbhgDIAEoElINc2VydmVyVmVyc2lvbg==');

@$core.Deprecated('Use roomTypesDataDescriptor instead')
const RoomTypesData$json = {
  '1': 'RoomTypesData',
  '2': [
    {'1': 'roomTypes', '3': 1, '4': 3, '5': 11, '6': '.RoomType', '10': 'roomTypes'},
  ],
};

/// Descriptor for `RoomTypesData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomTypesDataDescriptor = $convert.base64Decode(
    'Cg1Sb29tVHlwZXNEYXRhEicKCXJvb21UeXBlcxgBIAMoCzIJLlJvb21UeXBlUglyb29tVHlwZX'
    'M=');

@$core.Deprecated('Use roomTypeDescriptor instead')
const RoomType$json = {
  '1': 'RoomType',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'icon', '3': 3, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'desc', '3': 4, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'subTypes', '3': 5, '4': 3, '5': 11, '6': '.RoomSubtype', '10': 'subTypes'},
  ],
};

/// Descriptor for `RoomType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomTypeDescriptor = $convert.base64Decode(
    'CghSb29tVHlwZRIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCgRpY29uGA'
    'MgASgJUgRpY29uEhIKBGRlc2MYBCABKAlSBGRlc2MSKAoIc3ViVHlwZXMYBSADKAsyDC5Sb29t'
    'U3VidHlwZVIIc3ViVHlwZXM=');

@$core.Deprecated('Use roomSubtypeDescriptor instead')
const RoomSubtype$json = {
  '1': 'RoomSubtype',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RoomSubtype`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomSubtypeDescriptor = $convert.base64Decode(
    'CgtSb29tU3VidHlwZRIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZQ==');

