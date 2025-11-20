// This is a generated file - do not edit.
//
// Generated from proto/auth/auth.proto.

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

import 'auth.pb.dart' as $0;

export 'auth.pb.dart';

/// 认证服务
@$pb.GrpcServiceName('auth.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  /// 获取服务状态（匿名接口）
  $grpc.ResponseFuture<$0.StatusResponse> status(
    $0.StatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$status, request, options: options);
  }

  /// 获取当前账号状态（需认证）
  $grpc.ResponseFuture<$0.LoginResponse> login(
    $0.LoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$login, request, options: options);
  }

  /// 请求注册（匿名接口）
  $grpc.ResponseFuture<$0.PreRegisterResponse> preRegister(
    $0.PreRegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$preRegister, request, options: options);
  }

  /// 注册账号（匿名接口）
  $grpc.ResponseFuture<$0.RegisterResponse> register(
    $0.RegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$register, request, options: options);
  }

  /// 注销账号（需认证）
  $grpc.ResponseFuture<$0.UnregisterResponse> unregister(
    $0.UnregisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unregister, request, options: options);
  }

  // method descriptors

  static final _$status =
      $grpc.ClientMethod<$0.StatusRequest, $0.StatusResponse>(
          '/auth.AuthService/Status',
          ($0.StatusRequest value) => value.writeToBuffer(),
          $0.StatusResponse.fromBuffer);
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
      '/auth.AuthService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      $0.LoginResponse.fromBuffer);
  static final _$preRegister =
      $grpc.ClientMethod<$0.PreRegisterRequest, $0.PreRegisterResponse>(
          '/auth.AuthService/PreRegister',
          ($0.PreRegisterRequest value) => value.writeToBuffer(),
          $0.PreRegisterResponse.fromBuffer);
  static final _$register =
      $grpc.ClientMethod<$0.RegisterRequest, $0.RegisterResponse>(
          '/auth.AuthService/Register',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          $0.RegisterResponse.fromBuffer);
  static final _$unregister =
      $grpc.ClientMethod<$0.UnregisterRequest, $0.UnregisterResponse>(
          '/auth.AuthService/Unregister',
          ($0.UnregisterRequest value) => value.writeToBuffer(),
          $0.UnregisterResponse.fromBuffer);
}

@$pb.GrpcServiceName('auth.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'auth.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.StatusRequest, $0.StatusResponse>(
        'Status',
        status_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StatusRequest.fromBuffer(value),
        ($0.StatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PreRegisterRequest, $0.PreRegisterResponse>(
            'PreRegister',
            preRegister_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PreRegisterRequest.fromBuffer(value),
            ($0.PreRegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.RegisterResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.RegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnregisterRequest, $0.UnregisterResponse>(
        'Unregister',
        unregister_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UnregisterRequest.fromBuffer(value),
        ($0.UnregisterResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.StatusResponse> status_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.StatusRequest> $request) async {
    return status($call, await $request);
  }

  $async.Future<$0.StatusResponse> status(
      $grpc.ServiceCall call, $0.StatusRequest request);

  $async.Future<$0.LoginResponse> login_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LoginRequest> $request) async {
    return login($call, await $request);
  }

  $async.Future<$0.LoginResponse> login(
      $grpc.ServiceCall call, $0.LoginRequest request);

  $async.Future<$0.PreRegisterResponse> preRegister_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PreRegisterRequest> $request) async {
    return preRegister($call, await $request);
  }

  $async.Future<$0.PreRegisterResponse> preRegister(
      $grpc.ServiceCall call, $0.PreRegisterRequest request);

  $async.Future<$0.RegisterResponse> register_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterRequest> $request) async {
    return register($call, await $request);
  }

  $async.Future<$0.RegisterResponse> register(
      $grpc.ServiceCall call, $0.RegisterRequest request);

  $async.Future<$0.UnregisterResponse> unregister_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UnregisterRequest> $request) async {
    return unregister($call, await $request);
  }

  $async.Future<$0.UnregisterResponse> unregister(
      $grpc.ServiceCall call, $0.UnregisterRequest request);
}
