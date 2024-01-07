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

