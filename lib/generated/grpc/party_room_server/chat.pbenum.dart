//
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ReceiverType extends $pb.ProtobufEnum {
  static const ReceiverType RoomMsg = ReceiverType._(0, _omitEnumNames ? '' : 'RoomMsg');
  static const ReceiverType PrivateMsg = ReceiverType._(1, _omitEnumNames ? '' : 'PrivateMsg');

  static const $core.List<ReceiverType> values = <ReceiverType> [
    RoomMsg,
    PrivateMsg,
  ];

  static final $core.Map<$core.int, ReceiverType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReceiverType? valueOf($core.int value) => _byValue[value];

  const ReceiverType._($core.int v, $core.String n) : super(v, n);
}

class MessageType extends $pb.ProtobufEnum {
  static const MessageType System = MessageType._(0, _omitEnumNames ? '' : 'System');
  static const MessageType Text = MessageType._(1, _omitEnumNames ? '' : 'Text');
  static const MessageType Image = MessageType._(2, _omitEnumNames ? '' : 'Image');
  static const MessageType Markdown = MessageType._(3, _omitEnumNames ? '' : 'Markdown');

  static const $core.List<MessageType> values = <MessageType> [
    System,
    Text,
    Image,
    Markdown,
  ];

  static final $core.Map<$core.int, MessageType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessageType? valueOf($core.int value) => _byValue[value];

  const MessageType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
