// This is a generated file - do not edit.
//
// Generated from proto/partroom/partroom.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'partroom.pb.dart' as $0;

export 'partroom.pb.dart';

/// 房间服务
@$pb.GrpcServiceName('partroom.PartRoomService')
class PartRoomServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PartRoomServiceClient(super.channel, {super.options, super.interceptors});

  /// 获取房间列表（匿名接口）
  $grpc.ResponseFuture<$0.GetRoomListResponse> getRoomList(
    $0.GetRoomListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoomList, request, options: options);
  }

  /// 创建房间（需认证）
  $grpc.ResponseFuture<$0.CreateRoomResponse> createRoom(
    $0.CreateRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createRoom, request, options: options);
  }

  /// 加入房间（需认证）
  $grpc.ResponseFuture<$0.JoinRoomResponse> joinRoom(
    $0.JoinRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$joinRoom, request, options: options);
  }

  /// 离开房间（需认证）
  $grpc.ResponseFuture<$0.LeaveRoomResponse> leaveRoom(
    $0.LeaveRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$leaveRoom, request, options: options);
  }

  /// 解散房间（需认证，仅房主）
  $grpc.ResponseFuture<$0.DismissRoomResponse> dismissRoom(
    $0.DismissRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$dismissRoom, request, options: options);
  }

  /// 获取房间详情（需认证）
  $grpc.ResponseFuture<$0.GetRoomInfoResponse> getRoomInfo(
    $0.GetRoomInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoomInfo, request, options: options);
  }

  /// 获取房间成员列表（需认证）
  $grpc.ResponseFuture<$0.GetRoomMembersResponse> getRoomMembers(
    $0.GetRoomMembersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoomMembers, request, options: options);
  }

  /// 心跳（需认证）
  $grpc.ResponseFuture<$0.HeartbeatResponse> heartbeat(
    $0.HeartbeatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$heartbeat, request, options: options);
  }

  /// 获取当前用户所在房间（需认证）
  $grpc.ResponseFuture<$0.GetMyRoomResponse> getMyRoom(
    $0.GetMyRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMyRoom, request, options: options);
  }

  /// 更新房间信息（需认证，仅房主）
  $grpc.ResponseFuture<$0.UpdateRoomResponse> updateRoom(
    $0.UpdateRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateRoom, request, options: options);
  }

  /// 踢出成员（需认证，仅房主）
  $grpc.ResponseFuture<$0.KickMemberResponse> kickMember(
    $0.KickMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$kickMember, request, options: options);
  }

  /// 设置状态（需认证）
  $grpc.ResponseFuture<$0.SetStatusResponse> setStatus(
    $0.SetStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setStatus, request, options: options);
  }

  /// 发送信号（需认证）
  $grpc.ResponseFuture<$0.SendSignalResponse> sendSignal(
    $0.SendSignalRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendSignal, request, options: options);
  }

  /// 监听房间事件流（需认证）
  $grpc.ResponseStream<$0.RoomEvent> listenRoomEvents(
    $0.ListenRoomEventsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$listenRoomEvents, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// 转移房主（需认证，仅房主）
  $grpc.ResponseFuture<$0.TransferOwnershipResponse> transferOwnership(
    $0.TransferOwnershipRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$transferOwnership, request, options: options);
  }

  /// 获取被踢出成员列表（需认证，仅房主）
  $grpc.ResponseFuture<$0.GetKickedMembersResponse> getKickedMembers(
    $0.GetKickedMembersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getKickedMembers, request, options: options);
  }

  /// 移除被踢出成员（需认证，仅房主）
  $grpc.ResponseFuture<$0.RemoveKickedMemberResponse> removeKickedMember(
    $0.RemoveKickedMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeKickedMember, request, options: options);
  }

  // method descriptors

  static final _$getRoomList =
      $grpc.ClientMethod<$0.GetRoomListRequest, $0.GetRoomListResponse>(
          '/partroom.PartRoomService/GetRoomList',
          ($0.GetRoomListRequest value) => value.writeToBuffer(),
          $0.GetRoomListResponse.fromBuffer);
  static final _$createRoom =
      $grpc.ClientMethod<$0.CreateRoomRequest, $0.CreateRoomResponse>(
          '/partroom.PartRoomService/CreateRoom',
          ($0.CreateRoomRequest value) => value.writeToBuffer(),
          $0.CreateRoomResponse.fromBuffer);
  static final _$joinRoom =
      $grpc.ClientMethod<$0.JoinRoomRequest, $0.JoinRoomResponse>(
          '/partroom.PartRoomService/JoinRoom',
          ($0.JoinRoomRequest value) => value.writeToBuffer(),
          $0.JoinRoomResponse.fromBuffer);
  static final _$leaveRoom =
      $grpc.ClientMethod<$0.LeaveRoomRequest, $0.LeaveRoomResponse>(
          '/partroom.PartRoomService/LeaveRoom',
          ($0.LeaveRoomRequest value) => value.writeToBuffer(),
          $0.LeaveRoomResponse.fromBuffer);
  static final _$dismissRoom =
      $grpc.ClientMethod<$0.DismissRoomRequest, $0.DismissRoomResponse>(
          '/partroom.PartRoomService/DismissRoom',
          ($0.DismissRoomRequest value) => value.writeToBuffer(),
          $0.DismissRoomResponse.fromBuffer);
  static final _$getRoomInfo =
      $grpc.ClientMethod<$0.GetRoomInfoRequest, $0.GetRoomInfoResponse>(
          '/partroom.PartRoomService/GetRoomInfo',
          ($0.GetRoomInfoRequest value) => value.writeToBuffer(),
          $0.GetRoomInfoResponse.fromBuffer);
  static final _$getRoomMembers =
      $grpc.ClientMethod<$0.GetRoomMembersRequest, $0.GetRoomMembersResponse>(
          '/partroom.PartRoomService/GetRoomMembers',
          ($0.GetRoomMembersRequest value) => value.writeToBuffer(),
          $0.GetRoomMembersResponse.fromBuffer);
  static final _$heartbeat =
      $grpc.ClientMethod<$0.HeartbeatRequest, $0.HeartbeatResponse>(
          '/partroom.PartRoomService/Heartbeat',
          ($0.HeartbeatRequest value) => value.writeToBuffer(),
          $0.HeartbeatResponse.fromBuffer);
  static final _$getMyRoom =
      $grpc.ClientMethod<$0.GetMyRoomRequest, $0.GetMyRoomResponse>(
          '/partroom.PartRoomService/GetMyRoom',
          ($0.GetMyRoomRequest value) => value.writeToBuffer(),
          $0.GetMyRoomResponse.fromBuffer);
  static final _$updateRoom =
      $grpc.ClientMethod<$0.UpdateRoomRequest, $0.UpdateRoomResponse>(
          '/partroom.PartRoomService/UpdateRoom',
          ($0.UpdateRoomRequest value) => value.writeToBuffer(),
          $0.UpdateRoomResponse.fromBuffer);
  static final _$kickMember =
      $grpc.ClientMethod<$0.KickMemberRequest, $0.KickMemberResponse>(
          '/partroom.PartRoomService/KickMember',
          ($0.KickMemberRequest value) => value.writeToBuffer(),
          $0.KickMemberResponse.fromBuffer);
  static final _$setStatus =
      $grpc.ClientMethod<$0.SetStatusRequest, $0.SetStatusResponse>(
          '/partroom.PartRoomService/SetStatus',
          ($0.SetStatusRequest value) => value.writeToBuffer(),
          $0.SetStatusResponse.fromBuffer);
  static final _$sendSignal =
      $grpc.ClientMethod<$0.SendSignalRequest, $0.SendSignalResponse>(
          '/partroom.PartRoomService/SendSignal',
          ($0.SendSignalRequest value) => value.writeToBuffer(),
          $0.SendSignalResponse.fromBuffer);
  static final _$listenRoomEvents =
      $grpc.ClientMethod<$0.ListenRoomEventsRequest, $0.RoomEvent>(
          '/partroom.PartRoomService/ListenRoomEvents',
          ($0.ListenRoomEventsRequest value) => value.writeToBuffer(),
          $0.RoomEvent.fromBuffer);
  static final _$transferOwnership = $grpc.ClientMethod<
          $0.TransferOwnershipRequest, $0.TransferOwnershipResponse>(
      '/partroom.PartRoomService/TransferOwnership',
      ($0.TransferOwnershipRequest value) => value.writeToBuffer(),
      $0.TransferOwnershipResponse.fromBuffer);
  static final _$getKickedMembers = $grpc.ClientMethod<
          $0.GetKickedMembersRequest, $0.GetKickedMembersResponse>(
      '/partroom.PartRoomService/GetKickedMembers',
      ($0.GetKickedMembersRequest value) => value.writeToBuffer(),
      $0.GetKickedMembersResponse.fromBuffer);
  static final _$removeKickedMember = $grpc.ClientMethod<
          $0.RemoveKickedMemberRequest, $0.RemoveKickedMemberResponse>(
      '/partroom.PartRoomService/RemoveKickedMember',
      ($0.RemoveKickedMemberRequest value) => value.writeToBuffer(),
      $0.RemoveKickedMemberResponse.fromBuffer);
}

@$pb.GrpcServiceName('partroom.PartRoomService')
abstract class PartRoomServiceBase extends $grpc.Service {
  $core.String get $name => 'partroom.PartRoomService';

  PartRoomServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetRoomListRequest, $0.GetRoomListResponse>(
            'GetRoomList',
            getRoomList_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetRoomListRequest.fromBuffer(value),
            ($0.GetRoomListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateRoomRequest, $0.CreateRoomResponse>(
        'CreateRoom',
        createRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateRoomRequest.fromBuffer(value),
        ($0.CreateRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.JoinRoomRequest, $0.JoinRoomResponse>(
        'JoinRoom',
        joinRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinRoomRequest.fromBuffer(value),
        ($0.JoinRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LeaveRoomRequest, $0.LeaveRoomResponse>(
        'LeaveRoom',
        leaveRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LeaveRoomRequest.fromBuffer(value),
        ($0.LeaveRoomResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DismissRoomRequest, $0.DismissRoomResponse>(
            'DismissRoom',
            dismissRoom_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DismissRoomRequest.fromBuffer(value),
            ($0.DismissRoomResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetRoomInfoRequest, $0.GetRoomInfoResponse>(
            'GetRoomInfo',
            getRoomInfo_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetRoomInfoRequest.fromBuffer(value),
            ($0.GetRoomInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRoomMembersRequest,
            $0.GetRoomMembersResponse>(
        'GetRoomMembers',
        getRoomMembers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRoomMembersRequest.fromBuffer(value),
        ($0.GetRoomMembersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HeartbeatRequest, $0.HeartbeatResponse>(
        'Heartbeat',
        heartbeat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HeartbeatRequest.fromBuffer(value),
        ($0.HeartbeatResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMyRoomRequest, $0.GetMyRoomResponse>(
        'GetMyRoom',
        getMyRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetMyRoomRequest.fromBuffer(value),
        ($0.GetMyRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateRoomRequest, $0.UpdateRoomResponse>(
        'UpdateRoom',
        updateRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateRoomRequest.fromBuffer(value),
        ($0.UpdateRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KickMemberRequest, $0.KickMemberResponse>(
        'KickMember',
        kickMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.KickMemberRequest.fromBuffer(value),
        ($0.KickMemberResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetStatusRequest, $0.SetStatusResponse>(
        'SetStatus',
        setStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SetStatusRequest.fromBuffer(value),
        ($0.SetStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SendSignalRequest, $0.SendSignalResponse>(
        'SendSignal',
        sendSignal_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SendSignalRequest.fromBuffer(value),
        ($0.SendSignalResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListenRoomEventsRequest, $0.RoomEvent>(
        'ListenRoomEvents',
        listenRoomEvents_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.ListenRoomEventsRequest.fromBuffer(value),
        ($0.RoomEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TransferOwnershipRequest,
            $0.TransferOwnershipResponse>(
        'TransferOwnership',
        transferOwnership_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TransferOwnershipRequest.fromBuffer(value),
        ($0.TransferOwnershipResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetKickedMembersRequest,
            $0.GetKickedMembersResponse>(
        'GetKickedMembers',
        getKickedMembers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetKickedMembersRequest.fromBuffer(value),
        ($0.GetKickedMembersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveKickedMemberRequest,
            $0.RemoveKickedMemberResponse>(
        'RemoveKickedMember',
        removeKickedMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemoveKickedMemberRequest.fromBuffer(value),
        ($0.RemoveKickedMemberResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetRoomListResponse> getRoomList_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRoomListRequest> $request) async {
    return getRoomList($call, await $request);
  }

  $async.Future<$0.GetRoomListResponse> getRoomList(
      $grpc.ServiceCall call, $0.GetRoomListRequest request);

  $async.Future<$0.CreateRoomResponse> createRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateRoomRequest> $request) async {
    return createRoom($call, await $request);
  }

  $async.Future<$0.CreateRoomResponse> createRoom(
      $grpc.ServiceCall call, $0.CreateRoomRequest request);

  $async.Future<$0.JoinRoomResponse> joinRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.JoinRoomRequest> $request) async {
    return joinRoom($call, await $request);
  }

  $async.Future<$0.JoinRoomResponse> joinRoom(
      $grpc.ServiceCall call, $0.JoinRoomRequest request);

  $async.Future<$0.LeaveRoomResponse> leaveRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.LeaveRoomRequest> $request) async {
    return leaveRoom($call, await $request);
  }

  $async.Future<$0.LeaveRoomResponse> leaveRoom(
      $grpc.ServiceCall call, $0.LeaveRoomRequest request);

  $async.Future<$0.DismissRoomResponse> dismissRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DismissRoomRequest> $request) async {
    return dismissRoom($call, await $request);
  }

  $async.Future<$0.DismissRoomResponse> dismissRoom(
      $grpc.ServiceCall call, $0.DismissRoomRequest request);

  $async.Future<$0.GetRoomInfoResponse> getRoomInfo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRoomInfoRequest> $request) async {
    return getRoomInfo($call, await $request);
  }

  $async.Future<$0.GetRoomInfoResponse> getRoomInfo(
      $grpc.ServiceCall call, $0.GetRoomInfoRequest request);

  $async.Future<$0.GetRoomMembersResponse> getRoomMembers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRoomMembersRequest> $request) async {
    return getRoomMembers($call, await $request);
  }

  $async.Future<$0.GetRoomMembersResponse> getRoomMembers(
      $grpc.ServiceCall call, $0.GetRoomMembersRequest request);

  $async.Future<$0.HeartbeatResponse> heartbeat_Pre($grpc.ServiceCall $call,
      $async.Future<$0.HeartbeatRequest> $request) async {
    return heartbeat($call, await $request);
  }

  $async.Future<$0.HeartbeatResponse> heartbeat(
      $grpc.ServiceCall call, $0.HeartbeatRequest request);

  $async.Future<$0.GetMyRoomResponse> getMyRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMyRoomRequest> $request) async {
    return getMyRoom($call, await $request);
  }

  $async.Future<$0.GetMyRoomResponse> getMyRoom(
      $grpc.ServiceCall call, $0.GetMyRoomRequest request);

  $async.Future<$0.UpdateRoomResponse> updateRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateRoomRequest> $request) async {
    return updateRoom($call, await $request);
  }

  $async.Future<$0.UpdateRoomResponse> updateRoom(
      $grpc.ServiceCall call, $0.UpdateRoomRequest request);

  $async.Future<$0.KickMemberResponse> kickMember_Pre($grpc.ServiceCall $call,
      $async.Future<$0.KickMemberRequest> $request) async {
    return kickMember($call, await $request);
  }

  $async.Future<$0.KickMemberResponse> kickMember(
      $grpc.ServiceCall call, $0.KickMemberRequest request);

  $async.Future<$0.SetStatusResponse> setStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetStatusRequest> $request) async {
    return setStatus($call, await $request);
  }

  $async.Future<$0.SetStatusResponse> setStatus(
      $grpc.ServiceCall call, $0.SetStatusRequest request);

  $async.Future<$0.SendSignalResponse> sendSignal_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SendSignalRequest> $request) async {
    return sendSignal($call, await $request);
  }

  $async.Future<$0.SendSignalResponse> sendSignal(
      $grpc.ServiceCall call, $0.SendSignalRequest request);

  $async.Stream<$0.RoomEvent> listenRoomEvents_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListenRoomEventsRequest> $request) async* {
    yield* listenRoomEvents($call, await $request);
  }

  $async.Stream<$0.RoomEvent> listenRoomEvents(
      $grpc.ServiceCall call, $0.ListenRoomEventsRequest request);

  $async.Future<$0.TransferOwnershipResponse> transferOwnership_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TransferOwnershipRequest> $request) async {
    return transferOwnership($call, await $request);
  }

  $async.Future<$0.TransferOwnershipResponse> transferOwnership(
      $grpc.ServiceCall call, $0.TransferOwnershipRequest request);

  $async.Future<$0.GetKickedMembersResponse> getKickedMembers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetKickedMembersRequest> $request) async {
    return getKickedMembers($call, await $request);
  }

  $async.Future<$0.GetKickedMembersResponse> getKickedMembers(
      $grpc.ServiceCall call, $0.GetKickedMembersRequest request);

  $async.Future<$0.RemoveKickedMemberResponse> removeKickedMember_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemoveKickedMemberRequest> $request) async {
    return removeKickedMember($call, await $request);
  }

  $async.Future<$0.RemoveKickedMemberResponse> removeKickedMember(
      $grpc.ServiceCall call, $0.RemoveKickedMemberRequest request);
}
