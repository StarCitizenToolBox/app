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

import 'chat.pbenum.dart';

export 'chat.pbenum.dart';

class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.String? senderID,
    $core.String? receiverID,
    ReceiverType? receiverType,
    MessageType? messageType,
    $core.String? data,
  }) {
    final $result = create();
    if (senderID != null) {
      $result.senderID = senderID;
    }
    if (receiverID != null) {
      $result.receiverID = receiverID;
    }
    if (receiverType != null) {
      $result.receiverType = receiverType;
    }
    if (messageType != null) {
      $result.messageType = messageType;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  ChatMessage._() : super();
  factory ChatMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMessage', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'senderID', protoName: 'senderID')
    ..aOS(2, _omitFieldNames ? '' : 'receiverID', protoName: 'receiverID')
    ..e<ReceiverType>(3, _omitFieldNames ? '' : 'receiverType', $pb.PbFieldType.OE, protoName: 'receiverType', defaultOrMaker: ReceiverType.RoomMsg, valueOf: ReceiverType.valueOf, enumValues: ReceiverType.values)
    ..e<MessageType>(4, _omitFieldNames ? '' : 'messageType', $pb.PbFieldType.OE, protoName: 'messageType', defaultOrMaker: MessageType.System, valueOf: MessageType.valueOf, enumValues: MessageType.values)
    ..aOS(5, _omitFieldNames ? '' : 'data')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatMessage clone() => ChatMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage)) as ChatMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  ChatMessage createEmptyInstance() => create();
  static $pb.PbList<ChatMessage> createRepeated() => $pb.PbList<ChatMessage>();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get senderID => $_getSZ(0);
  @$pb.TagNumber(1)
  set senderID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSenderID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSenderID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get receiverID => $_getSZ(1);
  @$pb.TagNumber(2)
  set receiverID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReceiverID() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiverID() => clearField(2);

  @$pb.TagNumber(3)
  ReceiverType get receiverType => $_getN(2);
  @$pb.TagNumber(3)
  set receiverType(ReceiverType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReceiverType() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiverType() => clearField(3);

  @$pb.TagNumber(4)
  MessageType get messageType => $_getN(3);
  @$pb.TagNumber(4)
  set messageType(MessageType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessageType() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessageType() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get data => $_getSZ(4);
  @$pb.TagNumber(5)
  set data($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasData() => $_has(4);
  @$pb.TagNumber(5)
  void clearData() => clearField(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
