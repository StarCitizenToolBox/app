// This is a generated file - do not edit.
//
// Generated from proto/auth/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

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

  /// 验证 JWT token
  $grpc.ResponseFuture<$0.ValidateTokenResponse> validateToken(
    $0.ValidateTokenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$validateToken, request, options: options);
  }

  /// 获取公钥信息
  $grpc.ResponseFuture<$0.GetPublicKeyResponse> getPublicKey(
    $0.GetPublicKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPublicKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetJWTDomainListResponse> getJWTDomainList(
    $0.GetJWTDomainListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getJWTDomainList, request, options: options);
  }

  /// 刷新用户资料（需要认证）
  $grpc.ResponseFuture<$0.RefreshUserProfileResponse> refreshUserProfile(
    $0.RefreshUserProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$refreshUserProfile, request, options: options);
  }

  /// 生成 OIDC 授权码（供客户端 App 使用）
  $grpc.ResponseFuture<$0.GenerateOIDCAuthCodeResponse> generateOIDCAuthCode(
    $0.GenerateOIDCAuthCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateOIDCAuthCode, request, options: options);
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
  static final _$validateToken =
      $grpc.ClientMethod<$0.ValidateTokenRequest, $0.ValidateTokenResponse>(
          '/auth.AuthService/ValidateToken',
          ($0.ValidateTokenRequest value) => value.writeToBuffer(),
          $0.ValidateTokenResponse.fromBuffer);
  static final _$getPublicKey =
      $grpc.ClientMethod<$0.GetPublicKeyRequest, $0.GetPublicKeyResponse>(
          '/auth.AuthService/GetPublicKey',
          ($0.GetPublicKeyRequest value) => value.writeToBuffer(),
          $0.GetPublicKeyResponse.fromBuffer);
  static final _$getJWTDomainList = $grpc.ClientMethod<
          $0.GetJWTDomainListRequest, $0.GetJWTDomainListResponse>(
      '/auth.AuthService/GetJWTDomainList',
      ($0.GetJWTDomainListRequest value) => value.writeToBuffer(),
      $0.GetJWTDomainListResponse.fromBuffer);
  static final _$refreshUserProfile = $grpc.ClientMethod<
          $0.RefreshUserProfileRequest, $0.RefreshUserProfileResponse>(
      '/auth.AuthService/RefreshUserProfile',
      ($0.RefreshUserProfileRequest value) => value.writeToBuffer(),
      $0.RefreshUserProfileResponse.fromBuffer);
  static final _$generateOIDCAuthCode = $grpc.ClientMethod<
          $0.GenerateOIDCAuthCodeRequest, $0.GenerateOIDCAuthCodeResponse>(
      '/auth.AuthService/GenerateOIDCAuthCode',
      ($0.GenerateOIDCAuthCodeRequest value) => value.writeToBuffer(),
      $0.GenerateOIDCAuthCodeResponse.fromBuffer);
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
    $addMethod(
        $grpc.ServiceMethod<$0.ValidateTokenRequest, $0.ValidateTokenResponse>(
            'ValidateToken',
            validateToken_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ValidateTokenRequest.fromBuffer(value),
            ($0.ValidateTokenResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPublicKeyRequest, $0.GetPublicKeyResponse>(
            'GetPublicKey',
            getPublicKey_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPublicKeyRequest.fromBuffer(value),
            ($0.GetPublicKeyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetJWTDomainListRequest,
            $0.GetJWTDomainListResponse>(
        'GetJWTDomainList',
        getJWTDomainList_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetJWTDomainListRequest.fromBuffer(value),
        ($0.GetJWTDomainListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RefreshUserProfileRequest,
            $0.RefreshUserProfileResponse>(
        'RefreshUserProfile',
        refreshUserProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RefreshUserProfileRequest.fromBuffer(value),
        ($0.RefreshUserProfileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GenerateOIDCAuthCodeRequest,
            $0.GenerateOIDCAuthCodeResponse>(
        'GenerateOIDCAuthCode',
        generateOIDCAuthCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GenerateOIDCAuthCodeRequest.fromBuffer(value),
        ($0.GenerateOIDCAuthCodeResponse value) => value.writeToBuffer()));
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

  $async.Future<$0.ValidateTokenResponse> validateToken_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ValidateTokenRequest> $request) async {
    return validateToken($call, await $request);
  }

  $async.Future<$0.ValidateTokenResponse> validateToken(
      $grpc.ServiceCall call, $0.ValidateTokenRequest request);

  $async.Future<$0.GetPublicKeyResponse> getPublicKey_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPublicKeyRequest> $request) async {
    return getPublicKey($call, await $request);
  }

  $async.Future<$0.GetPublicKeyResponse> getPublicKey(
      $grpc.ServiceCall call, $0.GetPublicKeyRequest request);

  $async.Future<$0.GetJWTDomainListResponse> getJWTDomainList_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetJWTDomainListRequest> $request) async {
    return getJWTDomainList($call, await $request);
  }

  $async.Future<$0.GetJWTDomainListResponse> getJWTDomainList(
      $grpc.ServiceCall call, $0.GetJWTDomainListRequest request);

  $async.Future<$0.RefreshUserProfileResponse> refreshUserProfile_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RefreshUserProfileRequest> $request) async {
    return refreshUserProfile($call, await $request);
  }

  $async.Future<$0.RefreshUserProfileResponse> refreshUserProfile(
      $grpc.ServiceCall call, $0.RefreshUserProfileRequest request);

  $async.Future<$0.GenerateOIDCAuthCodeResponse> generateOIDCAuthCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GenerateOIDCAuthCodeRequest> $request) async {
    return generateOIDCAuthCode($call, await $request);
  }

  $async.Future<$0.GenerateOIDCAuthCodeResponse> generateOIDCAuthCode(
      $grpc.ServiceCall call, $0.GenerateOIDCAuthCodeRequest request);
}
