//
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use receiverTypeDescriptor instead')
const ReceiverType$json = {
  '1': 'ReceiverType',
  '2': [
    {'1': 'RoomMsg', '2': 0},
    {'1': 'PrivateMsg', '2': 1},
  ],
};

/// Descriptor for `ReceiverType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List receiverTypeDescriptor = $convert.base64Decode(
    'CgxSZWNlaXZlclR5cGUSCwoHUm9vbU1zZxAAEg4KClByaXZhdGVNc2cQAQ==');

@$core.Deprecated('Use messageTypeDescriptor instead')
const MessageType$json = {
  '1': 'MessageType',
  '2': [
    {'1': 'System', '2': 0},
    {'1': 'Text', '2': 1},
    {'1': 'Image', '2': 2},
    {'1': 'Markdown', '2': 3},
  ],
};

/// Descriptor for `MessageType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageTypeDescriptor = $convert.base64Decode(
    'CgtNZXNzYWdlVHlwZRIKCgZTeXN0ZW0QABIICgRUZXh0EAESCQoFSW1hZ2UQAhIMCghNYXJrZG'
    '93bhAD');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'senderID', '3': 1, '4': 1, '5': 9, '10': 'senderID'},
    {'1': 'receiverID', '3': 2, '4': 1, '5': 9, '10': 'receiverID'},
    {
      '1': 'receiverType',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.ReceiverType',
      '10': 'receiverType'
    },
    {
      '1': 'messageType',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.MessageType',
      '10': 'messageType'
    },
    {'1': 'data', '3': 5, '4': 1, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIaCghzZW5kZXJJRBgBIAEoCVIIc2VuZGVySUQSHgoKcmVjZWl2ZXJJRB'
    'gCIAEoCVIKcmVjZWl2ZXJJRBIxCgxyZWNlaXZlclR5cGUYAyABKA4yDS5SZWNlaXZlclR5cGVS'
    'DHJlY2VpdmVyVHlwZRIuCgttZXNzYWdlVHlwZRgEIAEoDjIMLk1lc3NhZ2VUeXBlUgttZXNzYW'
    'dlVHlwZRISCgRkYXRhGAUgASgJUgRkYXRh');
