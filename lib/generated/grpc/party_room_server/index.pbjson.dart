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

@$core.Deprecated('Use baseRespDataDescriptor instead')
const BaseRespData$json = {
  '1': 'BaseRespData',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `BaseRespData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List baseRespDataDescriptor = $convert.base64Decode(
    'CgxCYXNlUmVzcERhdGESEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZX'
    'NzYWdl');

@$core.Deprecated('Use basePageRespDataDescriptor instead')
const BasePageRespData$json = {
  '1': 'BasePageRespData',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'hasNext', '3': 3, '4': 1, '5': 8, '10': 'hasNext'},
    {'1': 'curPageNum', '3': 4, '4': 1, '5': 4, '10': 'curPageNum'},
    {'1': 'pageSize', '3': 5, '4': 1, '5': 3, '10': 'pageSize'},
  ],
};

/// Descriptor for `BasePageRespData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List basePageRespDataDescriptor = $convert.base64Decode(
    'ChBCYXNlUGFnZVJlc3BEYXRhEhIKBGNvZGUYASABKAVSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCV'
    'IHbWVzc2FnZRIYCgdoYXNOZXh0GAMgASgIUgdoYXNOZXh0Eh4KCmN1clBhZ2VOdW0YBCABKARS'
    'CmN1clBhZ2VOdW0SGgoIcGFnZVNpemUYBSABKANSCHBhZ2VTaXpl');

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

@$core.Deprecated('Use roomDataDescriptor instead')
const RoomData$json = {
  '1': 'RoomData',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'roomTypeID', '3': 2, '4': 1, '5': 9, '10': 'roomTypeID'},
    {'1': 'roomSubTypeIds', '3': 3, '4': 3, '5': 9, '10': 'roomSubTypeIds'},
    {'1': 'owner', '3': 4, '4': 1, '5': 9, '10': 'owner'},
    {'1': 'maxPlayer', '3': 5, '4': 1, '5': 5, '10': 'maxPlayer'},
    {'1': 'createTime', '3': 6, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'curPlayer', '3': 7, '4': 1, '5': 5, '10': 'curPlayer'},
    {'1': 'status', '3': 8, '4': 1, '5': 14, '6': '.RoomStatus', '10': 'status'},
    {'1': 'deviceUUID', '3': 9, '4': 1, '5': 9, '10': 'deviceUUID'},
    {'1': 'announcement', '3': 10, '4': 1, '5': 9, '10': 'announcement'},
    {'1': 'avatar', '3': 11, '4': 1, '5': 9, '10': 'avatar'},
  ],
};

/// Descriptor for `RoomData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDataDescriptor = $convert.base64Decode(
    'CghSb29tRGF0YRIOCgJpZBgBIAEoCVICaWQSHgoKcm9vbVR5cGVJRBgCIAEoCVIKcm9vbVR5cG'
    'VJRBImCg5yb29tU3ViVHlwZUlkcxgDIAMoCVIOcm9vbVN1YlR5cGVJZHMSFAoFb3duZXIYBCAB'
    'KAlSBW93bmVyEhwKCW1heFBsYXllchgFIAEoBVIJbWF4UGxheWVyEh4KCmNyZWF0ZVRpbWUYBi'
    'ABKANSCmNyZWF0ZVRpbWUSHAoJY3VyUGxheWVyGAcgASgFUgljdXJQbGF5ZXISIwoGc3RhdHVz'
    'GAggASgOMgsuUm9vbVN0YXR1c1IGc3RhdHVzEh4KCmRldmljZVVVSUQYCSABKAlSCmRldmljZV'
    'VVSUQSIgoMYW5ub3VuY2VtZW50GAogASgJUgxhbm5vdW5jZW1lbnQSFgoGYXZhdGFyGAsgASgJ'
    'UgZhdmF0YXI=');

@$core.Deprecated('Use roomListPageReqDataDescriptor instead')
const RoomListPageReqData$json = {
  '1': 'RoomListPageReqData',
  '2': [
    {'1': 'typeID', '3': 1, '4': 1, '5': 9, '10': 'typeID'},
    {'1': 'subTypeID', '3': 2, '4': 1, '5': 9, '10': 'subTypeID'},
    {'1': 'status', '3': 3, '4': 1, '5': 14, '6': '.RoomStatus', '10': 'status'},
    {'1': 'sort', '3': 4, '4': 1, '5': 14, '6': '.RoomSortType', '10': 'sort'},
    {'1': 'pageNum', '3': 5, '4': 1, '5': 4, '10': 'pageNum'},
  ],
};

/// Descriptor for `RoomListPageReqData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomListPageReqDataDescriptor = $convert.base64Decode(
    'ChNSb29tTGlzdFBhZ2VSZXFEYXRhEhYKBnR5cGVJRBgBIAEoCVIGdHlwZUlEEhwKCXN1YlR5cG'
    'VJRBgCIAEoCVIJc3ViVHlwZUlEEiMKBnN0YXR1cxgDIAEoDjILLlJvb21TdGF0dXNSBnN0YXR1'
    'cxIhCgRzb3J0GAQgASgOMg0uUm9vbVNvcnRUeXBlUgRzb3J0EhgKB3BhZ2VOdW0YBSABKARSB3'
    'BhZ2VOdW0=');

@$core.Deprecated('Use roomListDataDescriptor instead')
const RoomListData$json = {
  '1': 'RoomListData',
  '2': [
    {'1': 'pageData', '3': 1, '4': 1, '5': 11, '6': '.BasePageRespData', '10': 'pageData'},
    {'1': 'rooms', '3': 2, '4': 3, '5': 11, '6': '.RoomData', '10': 'rooms'},
  ],
};

/// Descriptor for `RoomListData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomListDataDescriptor = $convert.base64Decode(
    'CgxSb29tTGlzdERhdGESLQoIcGFnZURhdGEYASABKAsyES5CYXNlUGFnZVJlc3BEYXRhUghwYW'
    'dlRGF0YRIfCgVyb29tcxgCIAMoCzIJLlJvb21EYXRhUgVyb29tcw==');

