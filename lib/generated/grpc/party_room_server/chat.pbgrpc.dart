//
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chat.pb.dart' as $1;
import 'index.pb.dart' as $0;

export 'chat.pb.dart';

@$pb.GrpcServiceName('ChatService')
class ChatServiceClient extends $grpc.Client {
  static final _$listenMessage = $grpc.ClientMethod<$0.PreUser, $1.ChatMessage>(
      '/ChatService/ListenMessage',
      ($0.PreUser value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ChatMessage.fromBuffer(value));
  static final _$sendMessage =
      $grpc.ClientMethod<$1.ChatMessage, $0.BaseRespData>(
          '/ChatService/SendMessage',
          ($1.ChatMessage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.BaseRespData.fromBuffer(value));

  ChatServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$1.ChatMessage> listenMessage($0.PreUser request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$listenMessage, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.BaseRespData> sendMessage($1.ChatMessage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }
}

@$pb.GrpcServiceName('ChatService')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'ChatService';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PreUser, $1.ChatMessage>(
        'ListenMessage',
        listenMessage_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PreUser.fromBuffer(value),
        ($1.ChatMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ChatMessage, $0.BaseRespData>(
        'SendMessage',
        sendMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ChatMessage.fromBuffer(value),
        ($0.BaseRespData value) => value.writeToBuffer()));
  }

  $async.Stream<$1.ChatMessage> listenMessage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PreUser> request) async* {
    yield* listenMessage(call, await request);
  }

  $async.Future<$0.BaseRespData> sendMessage_Pre(
      $grpc.ServiceCall call, $async.Future<$1.ChatMessage> request) async {
    return sendMessage(call, await request);
  }

  $async.Stream<$1.ChatMessage> listenMessage(
      $grpc.ServiceCall call, $0.PreUser request);
  $async.Future<$0.BaseRespData> sendMessage(
      $grpc.ServiceCall call, $1.ChatMessage request);
}
