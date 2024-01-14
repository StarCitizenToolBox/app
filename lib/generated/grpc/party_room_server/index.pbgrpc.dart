//
//  Generated code. Do not modify.
//  source: index.proto
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

import 'index.pb.dart' as $0;

export 'index.pb.dart';

@$pb.GrpcServiceName('IndexService')
class IndexServiceClient extends $grpc.Client {
  static final _$pingServer = $grpc.ClientMethod<$0.PingData, $0.PingData>(
      '/IndexService/PingServer',
      ($0.PingData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PingData.fromBuffer(value));
  static final _$getRoomTypes = $grpc.ClientMethod<$0.Empty, $0.RoomTypesData>(
      '/IndexService/GetRoomTypes',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RoomTypesData.fromBuffer(value));
  static final _$createRoom = $grpc.ClientMethod<$0.RoomData, $0.RoomData>(
      '/IndexService/CreateRoom',
      ($0.RoomData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RoomData.fromBuffer(value));
  static final _$getRoomList = $grpc.ClientMethod<$0.RoomListPageReqData, $0.RoomListData>(
      '/IndexService/GetRoomList',
      ($0.RoomListPageReqData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RoomListData.fromBuffer(value));
  static final _$touchUser = $grpc.ClientMethod<$0.PreUser, $0.RoomData>(
      '/IndexService/TouchUser',
      ($0.PreUser value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RoomData.fromBuffer(value));
  static final _$joinRoom = $grpc.ClientMethod<$0.PreUser, $0.RoomUpdateMessage>(
      '/IndexService/JoinRoom',
      ($0.PreUser value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RoomUpdateMessage.fromBuffer(value));
  static final _$leaveRoom = $grpc.ClientMethod<$0.PreUser, $0.BaseRespData>(
      '/IndexService/LeaveRoom',
      ($0.PreUser value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.BaseRespData.fromBuffer(value));

  IndexServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.PingData> pingServer($0.PingData request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$pingServer, request, options: options);
  }

  $grpc.ResponseFuture<$0.RoomTypesData> getRoomTypes($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getRoomTypes, request, options: options);
  }

  $grpc.ResponseFuture<$0.RoomData> createRoom($0.RoomData request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.RoomListData> getRoomList($0.RoomListPageReqData request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getRoomList, request, options: options);
  }

  $grpc.ResponseFuture<$0.RoomData> touchUser($0.PreUser request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$touchUser, request, options: options);
  }

  $grpc.ResponseStream<$0.RoomUpdateMessage> joinRoom($0.PreUser request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$joinRoom, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$0.BaseRespData> leaveRoom($0.PreUser request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$leaveRoom, request, options: options);
  }
}

@$pb.GrpcServiceName('IndexService')
abstract class IndexServiceBase extends $grpc.Service {
  $core.String get $name => 'IndexService';

  IndexServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PingData, $0.PingData>(
        'PingServer',
        pingServer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PingData.fromBuffer(value),
        ($0.PingData value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.RoomTypesData>(
        'GetRoomTypes',
        getRoomTypes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.RoomTypesData value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RoomData, $0.RoomData>(
        'CreateRoom',
        createRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RoomData.fromBuffer(value),
        ($0.RoomData value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RoomListPageReqData, $0.RoomListData>(
        'GetRoomList',
        getRoomList_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RoomListPageReqData.fromBuffer(value),
        ($0.RoomListData value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PreUser, $0.RoomData>(
        'TouchUser',
        touchUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PreUser.fromBuffer(value),
        ($0.RoomData value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PreUser, $0.RoomUpdateMessage>(
        'JoinRoom',
        joinRoom_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PreUser.fromBuffer(value),
        ($0.RoomUpdateMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PreUser, $0.BaseRespData>(
        'LeaveRoom',
        leaveRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PreUser.fromBuffer(value),
        ($0.BaseRespData value) => value.writeToBuffer()));
  }

  $async.Future<$0.PingData> pingServer_Pre($grpc.ServiceCall call, $async.Future<$0.PingData> request) async {
    return pingServer(call, await request);
  }

  $async.Future<$0.RoomTypesData> getRoomTypes_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getRoomTypes(call, await request);
  }

  $async.Future<$0.RoomData> createRoom_Pre($grpc.ServiceCall call, $async.Future<$0.RoomData> request) async {
    return createRoom(call, await request);
  }

  $async.Future<$0.RoomListData> getRoomList_Pre($grpc.ServiceCall call, $async.Future<$0.RoomListPageReqData> request) async {
    return getRoomList(call, await request);
  }

  $async.Future<$0.RoomData> touchUser_Pre($grpc.ServiceCall call, $async.Future<$0.PreUser> request) async {
    return touchUser(call, await request);
  }

  $async.Stream<$0.RoomUpdateMessage> joinRoom_Pre($grpc.ServiceCall call, $async.Future<$0.PreUser> request) async* {
    yield* joinRoom(call, await request);
  }

  $async.Future<$0.BaseRespData> leaveRoom_Pre($grpc.ServiceCall call, $async.Future<$0.PreUser> request) async {
    return leaveRoom(call, await request);
  }

  $async.Future<$0.PingData> pingServer($grpc.ServiceCall call, $0.PingData request);
  $async.Future<$0.RoomTypesData> getRoomTypes($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.RoomData> createRoom($grpc.ServiceCall call, $0.RoomData request);
  $async.Future<$0.RoomListData> getRoomList($grpc.ServiceCall call, $0.RoomListPageReqData request);
  $async.Future<$0.RoomData> touchUser($grpc.ServiceCall call, $0.PreUser request);
  $async.Stream<$0.RoomUpdateMessage> joinRoom($grpc.ServiceCall call, $0.PreUser request);
  $async.Future<$0.BaseRespData> leaveRoom($grpc.ServiceCall call, $0.PreUser request);
}
