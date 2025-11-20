// This is a generated file - do not edit.
//
// Generated from proto/common/common.proto.

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

import 'common.pb.dart' as $0;

export 'common.pb.dart';

/// 通用服务
@$pb.GrpcServiceName('common.CommonService')
class CommonServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CommonServiceClient(super.channel, {super.options, super.interceptors});

  /// 获取服务器时间（匿名接口）
  $grpc.ResponseFuture<$0.GetServerTimeResponse> getServerTime(
    $0.GetServerTimeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getServerTime, request, options: options);
  }

  /// 获取版本信息（匿名接口）
  $grpc.ResponseFuture<$0.GetVersionResponse> getVersion(
    $0.GetVersionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getVersion, request, options: options);
  }

  /// 获取信号类型列表（匿名接口）
  $grpc.ResponseFuture<$0.GetSignalTypesResponse> getSignalTypes(
    $0.GetSignalTypesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSignalTypes, request, options: options);
  }

  /// 获取房间标签（匿名接口）
  $grpc.ResponseFuture<$0.GetTagsResponse> getTags(
    $0.GetTagsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTags, request, options: options);
  }

  // method descriptors

  static final _$getServerTime =
      $grpc.ClientMethod<$0.GetServerTimeRequest, $0.GetServerTimeResponse>(
          '/common.CommonService/GetServerTime',
          ($0.GetServerTimeRequest value) => value.writeToBuffer(),
          $0.GetServerTimeResponse.fromBuffer);
  static final _$getVersion =
      $grpc.ClientMethod<$0.GetVersionRequest, $0.GetVersionResponse>(
          '/common.CommonService/GetVersion',
          ($0.GetVersionRequest value) => value.writeToBuffer(),
          $0.GetVersionResponse.fromBuffer);
  static final _$getSignalTypes =
      $grpc.ClientMethod<$0.GetSignalTypesRequest, $0.GetSignalTypesResponse>(
          '/common.CommonService/GetSignalTypes',
          ($0.GetSignalTypesRequest value) => value.writeToBuffer(),
          $0.GetSignalTypesResponse.fromBuffer);
  static final _$getTags =
      $grpc.ClientMethod<$0.GetTagsRequest, $0.GetTagsResponse>(
          '/common.CommonService/GetTags',
          ($0.GetTagsRequest value) => value.writeToBuffer(),
          $0.GetTagsResponse.fromBuffer);
}

@$pb.GrpcServiceName('common.CommonService')
abstract class CommonServiceBase extends $grpc.Service {
  $core.String get $name => 'common.CommonService';

  CommonServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetServerTimeRequest, $0.GetServerTimeResponse>(
            'GetServerTime',
            getServerTime_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetServerTimeRequest.fromBuffer(value),
            ($0.GetServerTimeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetVersionRequest, $0.GetVersionResponse>(
        'GetVersion',
        getVersion_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetVersionRequest.fromBuffer(value),
        ($0.GetVersionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSignalTypesRequest,
            $0.GetSignalTypesResponse>(
        'GetSignalTypes',
        getSignalTypes_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSignalTypesRequest.fromBuffer(value),
        ($0.GetSignalTypesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTagsRequest, $0.GetTagsResponse>(
        'GetTags',
        getTags_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetTagsRequest.fromBuffer(value),
        ($0.GetTagsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetServerTimeResponse> getServerTime_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetServerTimeRequest> $request) async {
    return getServerTime($call, await $request);
  }

  $async.Future<$0.GetServerTimeResponse> getServerTime(
      $grpc.ServiceCall call, $0.GetServerTimeRequest request);

  $async.Future<$0.GetVersionResponse> getVersion_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetVersionRequest> $request) async {
    return getVersion($call, await $request);
  }

  $async.Future<$0.GetVersionResponse> getVersion(
      $grpc.ServiceCall call, $0.GetVersionRequest request);

  $async.Future<$0.GetSignalTypesResponse> getSignalTypes_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSignalTypesRequest> $request) async {
    return getSignalTypes($call, await $request);
  }

  $async.Future<$0.GetSignalTypesResponse> getSignalTypes(
      $grpc.ServiceCall call, $0.GetSignalTypesRequest request);

  $async.Future<$0.GetTagsResponse> getTags_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetTagsRequest> $request) async {
    return getTags($call, await $request);
  }

  $async.Future<$0.GetTagsResponse> getTags(
      $grpc.ServiceCall call, $0.GetTagsRequest request);
}
