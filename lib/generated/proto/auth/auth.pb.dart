// This is a generated file - do not edit.
//
// Generated from proto/auth/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// 生成 OIDC 授权码请求
class GenerateOIDCAuthCodeRequest extends $pb.GeneratedMessage {
  factory GenerateOIDCAuthCodeRequest({
    $core.String? nonce,
    $core.String? redirectUri,
  }) {
    final result = create();
    if (nonce != null) result.nonce = nonce;
    if (redirectUri != null) result.redirectUri = redirectUri;
    return result;
  }

  GenerateOIDCAuthCodeRequest._();

  factory GenerateOIDCAuthCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GenerateOIDCAuthCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerateOIDCAuthCodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nonce')
    ..aOS(2, _omitFieldNames ? '' : 'redirectUri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateOIDCAuthCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateOIDCAuthCodeRequest copyWith(
          void Function(GenerateOIDCAuthCodeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GenerateOIDCAuthCodeRequest))
          as GenerateOIDCAuthCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateOIDCAuthCodeRequest create() =>
      GenerateOIDCAuthCodeRequest._();
  @$core.override
  GenerateOIDCAuthCodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GenerateOIDCAuthCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenerateOIDCAuthCodeRequest>(create);
  static GenerateOIDCAuthCodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nonce => $_getSZ(0);
  @$pb.TagNumber(1)
  set nonce($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNonce() => $_has(0);
  @$pb.TagNumber(1)
  void clearNonce() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get redirectUri => $_getSZ(1);
  @$pb.TagNumber(2)
  set redirectUri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRedirectUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearRedirectUri() => $_clearField(2);
}

/// 生成 OIDC 授权码响应
class GenerateOIDCAuthCodeResponse extends $pb.GeneratedMessage {
  factory GenerateOIDCAuthCodeResponse({
    $core.String? code,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  GenerateOIDCAuthCodeResponse._();

  factory GenerateOIDCAuthCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GenerateOIDCAuthCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerateOIDCAuthCodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aInt64(2, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateOIDCAuthCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateOIDCAuthCodeResponse copyWith(
          void Function(GenerateOIDCAuthCodeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GenerateOIDCAuthCodeResponse))
          as GenerateOIDCAuthCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateOIDCAuthCodeResponse create() =>
      GenerateOIDCAuthCodeResponse._();
  @$core.override
  GenerateOIDCAuthCodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GenerateOIDCAuthCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenerateOIDCAuthCodeResponse>(create);
  static GenerateOIDCAuthCodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expiresAt => $_getI64(1);
  @$pb.TagNumber(2)
  set expiresAt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpiresAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiresAt() => $_clearField(2);
}

/// 刷新用户资料请求
class RefreshUserProfileRequest extends $pb.GeneratedMessage {
  factory RefreshUserProfileRequest() => create();

  RefreshUserProfileRequest._();

  factory RefreshUserProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefreshUserProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefreshUserProfileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshUserProfileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshUserProfileRequest copyWith(
          void Function(RefreshUserProfileRequest) updates) =>
      super.copyWith((message) => updates(message as RefreshUserProfileRequest))
          as RefreshUserProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefreshUserProfileRequest create() => RefreshUserProfileRequest._();
  @$core.override
  RefreshUserProfileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefreshUserProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshUserProfileRequest>(create);
  static RefreshUserProfileRequest? _defaultInstance;
}

/// 刷新用户资料响应
class RefreshUserProfileResponse extends $pb.GeneratedMessage {
  factory RefreshUserProfileResponse({
    $core.bool? success,
    GameUserInfo? userInfo,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (userInfo != null) result.userInfo = userInfo;
    return result;
  }

  RefreshUserProfileResponse._();

  factory RefreshUserProfileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefreshUserProfileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefreshUserProfileResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<GameUserInfo>(2, _omitFieldNames ? '' : 'userInfo',
        subBuilder: GameUserInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshUserProfileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshUserProfileResponse copyWith(
          void Function(RefreshUserProfileResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RefreshUserProfileResponse))
          as RefreshUserProfileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefreshUserProfileResponse create() => RefreshUserProfileResponse._();
  @$core.override
  RefreshUserProfileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefreshUserProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshUserProfileResponse>(create);
  static RefreshUserProfileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  GameUserInfo get userInfo => $_getN(1);
  @$pb.TagNumber(2)
  set userInfo(GameUserInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  GameUserInfo ensureUserInfo() => $_ensure(1);
}

/// 服务状态请求
class StatusRequest extends $pb.GeneratedMessage {
  factory StatusRequest() => create();

  StatusRequest._();

  factory StatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusRequest copyWith(void Function(StatusRequest) updates) =>
      super.copyWith((message) => updates(message as StatusRequest))
          as StatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatusRequest create() => StatusRequest._();
  @$core.override
  StatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatusRequest>(create);
  static StatusRequest? _defaultInstance;
}

/// 服务状态响应
class StatusResponse extends $pb.GeneratedMessage {
  factory StatusResponse({
    $core.bool? online,
    $core.String? message,
    $fixnum.Int64? serverTime,
  }) {
    final result = create();
    if (online != null) result.online = online;
    if (message != null) result.message = message;
    if (serverTime != null) result.serverTime = serverTime;
    return result;
  }

  StatusResponse._();

  factory StatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'online')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aInt64(3, _omitFieldNames ? '' : 'serverTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusResponse copyWith(void Function(StatusResponse) updates) =>
      super.copyWith((message) => updates(message as StatusResponse))
          as StatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatusResponse create() => StatusResponse._();
  @$core.override
  StatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatusResponse>(create);
  static StatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get online => $_getBF(0);
  @$pb.TagNumber(1)
  set online($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOnline() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnline() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get serverTime => $_getI64(2);
  @$pb.TagNumber(3)
  set serverTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServerTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerTime() => $_clearField(3);
}

/// 登录请求
class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest() => create();

  LoginRequest._();

  factory LoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest copyWith(void Function(LoginRequest) updates) =>
      super.copyWith((message) => updates(message as LoginRequest))
          as LoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  @$core.override
  LoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;
}

/// 游戏用户信息
class GameUserInfo extends $pb.GeneratedMessage {
  factory GameUserInfo({
    $core.String? gameUserId,
    $core.String? handleName,
    $core.String? avatarUrl,
    $core.String? citizenRecord,
    $fixnum.Int64? enlistedDate,
  }) {
    final result = create();
    if (gameUserId != null) result.gameUserId = gameUserId;
    if (handleName != null) result.handleName = handleName;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (citizenRecord != null) result.citizenRecord = citizenRecord;
    if (enlistedDate != null) result.enlistedDate = enlistedDate;
    return result;
  }

  GameUserInfo._();

  factory GameUserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GameUserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GameUserInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameUserId')
    ..aOS(2, _omitFieldNames ? '' : 'handleName')
    ..aOS(3, _omitFieldNames ? '' : 'avatarUrl')
    ..aOS(4, _omitFieldNames ? '' : 'citizenRecord')
    ..aInt64(5, _omitFieldNames ? '' : 'enlistedDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameUserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GameUserInfo copyWith(void Function(GameUserInfo) updates) =>
      super.copyWith((message) => updates(message as GameUserInfo))
          as GameUserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameUserInfo create() => GameUserInfo._();
  @$core.override
  GameUserInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GameUserInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GameUserInfo>(create);
  static GameUserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameUserId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get handleName => $_getSZ(1);
  @$pb.TagNumber(2)
  set handleName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHandleName() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandleName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get avatarUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatarUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatarUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatarUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get citizenRecord => $_getSZ(3);
  @$pb.TagNumber(4)
  set citizenRecord($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCitizenRecord() => $_has(3);
  @$pb.TagNumber(4)
  void clearCitizenRecord() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get enlistedDate => $_getI64(4);
  @$pb.TagNumber(5)
  set enlistedDate($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnlistedDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnlistedDate() => $_clearField(5);
}

/// 登录响应
class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $core.String? uuid,
    GameUserInfo? userInfo,
    $fixnum.Int64? lastLoginTime,
  }) {
    final result = create();
    if (uuid != null) result.uuid = uuid;
    if (userInfo != null) result.userInfo = userInfo;
    if (lastLoginTime != null) result.lastLoginTime = lastLoginTime;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uuid')
    ..aOM<GameUserInfo>(2, _omitFieldNames ? '' : 'userInfo',
        subBuilder: GameUserInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'lastLoginTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse copyWith(void Function(LoginResponse) updates) =>
      super.copyWith((message) => updates(message as LoginResponse))
          as LoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  @$core.override
  LoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  GameUserInfo get userInfo => $_getN(1);
  @$pb.TagNumber(2)
  set userInfo(GameUserInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  GameUserInfo ensureUserInfo() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get lastLoginTime => $_getI64(2);
  @$pb.TagNumber(3)
  set lastLoginTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastLoginTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastLoginTime() => $_clearField(3);
}

/// 预注册请求
class PreRegisterRequest extends $pb.GeneratedMessage {
  factory PreRegisterRequest({
    $core.String? uuid,
    $core.String? gameUserId,
  }) {
    final result = create();
    if (uuid != null) result.uuid = uuid;
    if (gameUserId != null) result.gameUserId = gameUserId;
    return result;
  }

  PreRegisterRequest._();

  factory PreRegisterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PreRegisterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreRegisterRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uuid')
    ..aOS(2, _omitFieldNames ? '' : 'gameUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreRegisterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreRegisterRequest copyWith(void Function(PreRegisterRequest) updates) =>
      super.copyWith((message) => updates(message as PreRegisterRequest))
          as PreRegisterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreRegisterRequest create() => PreRegisterRequest._();
  @$core.override
  PreRegisterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PreRegisterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreRegisterRequest>(create);
  static PreRegisterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gameUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGameUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameUserId() => $_clearField(2);
}

/// 预注册响应
class PreRegisterResponse extends $pb.GeneratedMessage {
  factory PreRegisterResponse({
    $core.String? verificationCode,
    $fixnum.Int64? expireTime,
  }) {
    final result = create();
    if (verificationCode != null) result.verificationCode = verificationCode;
    if (expireTime != null) result.expireTime = expireTime;
    return result;
  }

  PreRegisterResponse._();

  factory PreRegisterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PreRegisterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreRegisterResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'verificationCode')
    ..aInt64(2, _omitFieldNames ? '' : 'expireTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreRegisterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreRegisterResponse copyWith(void Function(PreRegisterResponse) updates) =>
      super.copyWith((message) => updates(message as PreRegisterResponse))
          as PreRegisterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreRegisterResponse create() => PreRegisterResponse._();
  @$core.override
  PreRegisterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PreRegisterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreRegisterResponse>(create);
  static PreRegisterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get verificationCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set verificationCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVerificationCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerificationCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expireTime => $_getI64(1);
  @$pb.TagNumber(2)
  set expireTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpireTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpireTime() => $_clearField(2);
}

/// 注册请求
class RegisterRequest extends $pb.GeneratedMessage {
  factory RegisterRequest({
    $core.String? uuid,
    $core.String? gameUserId,
  }) {
    final result = create();
    if (uuid != null) result.uuid = uuid;
    if (gameUserId != null) result.gameUserId = gameUserId;
    return result;
  }

  RegisterRequest._();

  factory RegisterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uuid')
    ..aOS(2, _omitFieldNames ? '' : 'gameUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRequest copyWith(void Function(RegisterRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterRequest))
          as RegisterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterRequest create() => RegisterRequest._();
  @$core.override
  RegisterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(create);
  static RegisterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gameUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGameUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameUserId() => $_clearField(2);
}

/// 注册响应
class RegisterResponse extends $pb.GeneratedMessage {
  factory RegisterResponse({
    $core.String? partyRoomSecretKey,
    GameUserInfo? userInfo,
  }) {
    final result = create();
    if (partyRoomSecretKey != null)
      result.partyRoomSecretKey = partyRoomSecretKey;
    if (userInfo != null) result.userInfo = userInfo;
    return result;
  }

  RegisterResponse._();

  factory RegisterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'partyRoomSecretKey')
    ..aOM<GameUserInfo>(2, _omitFieldNames ? '' : 'userInfo',
        subBuilder: GameUserInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterResponse copyWith(void Function(RegisterResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterResponse))
          as RegisterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterResponse create() => RegisterResponse._();
  @$core.override
  RegisterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterResponse>(create);
  static RegisterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get partyRoomSecretKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set partyRoomSecretKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPartyRoomSecretKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPartyRoomSecretKey() => $_clearField(1);

  @$pb.TagNumber(2)
  GameUserInfo get userInfo => $_getN(1);
  @$pb.TagNumber(2)
  set userInfo(GameUserInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  GameUserInfo ensureUserInfo() => $_ensure(1);
}

/// 注销请求
class UnregisterRequest extends $pb.GeneratedMessage {
  factory UnregisterRequest() => create();

  UnregisterRequest._();

  factory UnregisterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnregisterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnregisterRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnregisterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnregisterRequest copyWith(void Function(UnregisterRequest) updates) =>
      super.copyWith((message) => updates(message as UnregisterRequest))
          as UnregisterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnregisterRequest create() => UnregisterRequest._();
  @$core.override
  UnregisterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnregisterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnregisterRequest>(create);
  static UnregisterRequest? _defaultInstance;
}

/// 注销响应
class UnregisterResponse extends $pb.GeneratedMessage {
  factory UnregisterResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  UnregisterResponse._();

  factory UnregisterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnregisterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnregisterResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnregisterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnregisterResponse copyWith(void Function(UnregisterResponse) updates) =>
      super.copyWith((message) => updates(message as UnregisterResponse))
          as UnregisterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnregisterResponse create() => UnregisterResponse._();
  @$core.override
  UnregisterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnregisterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnregisterResponse>(create);
  static UnregisterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 验证 token 请求
class ValidateTokenRequest extends $pb.GeneratedMessage {
  factory ValidateTokenRequest({
    $core.String? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  ValidateTokenRequest._();

  factory ValidateTokenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ValidateTokenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateTokenRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateTokenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateTokenRequest copyWith(void Function(ValidateTokenRequest) updates) =>
      super.copyWith((message) => updates(message as ValidateTokenRequest))
          as ValidateTokenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateTokenRequest create() => ValidateTokenRequest._();
  @$core.override
  ValidateTokenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ValidateTokenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateTokenRequest>(create);
  static ValidateTokenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

/// 验证 token 响应
class ValidateTokenResponse extends $pb.GeneratedMessage {
  factory ValidateTokenResponse({
    $core.bool? valid,
    $core.String? domain,
    $fixnum.Int64? issuedAt,
    $fixnum.Int64? expiresAt,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (valid != null) result.valid = valid;
    if (domain != null) result.domain = domain;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  ValidateTokenResponse._();

  factory ValidateTokenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ValidateTokenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateTokenResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..aOS(2, _omitFieldNames ? '' : 'domain')
    ..aInt64(3, _omitFieldNames ? '' : 'issuedAt')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..aOS(5, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateTokenResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateTokenResponse copyWith(
          void Function(ValidateTokenResponse) updates) =>
      super.copyWith((message) => updates(message as ValidateTokenResponse))
          as ValidateTokenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateTokenResponse create() => ValidateTokenResponse._();
  @$core.override
  ValidateTokenResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ValidateTokenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateTokenResponse>(create);
  static ValidateTokenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get domain => $_getSZ(1);
  @$pb.TagNumber(2)
  set domain($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDomain() => $_has(1);
  @$pb.TagNumber(2)
  void clearDomain() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get issuedAt => $_getI64(2);
  @$pb.TagNumber(3)
  set issuedAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIssuedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssuedAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get errorMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorMessage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasErrorMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorMessage() => $_clearField(5);
}

/// 获取公钥请求
class GetPublicKeyRequest extends $pb.GeneratedMessage {
  factory GetPublicKeyRequest() => create();

  GetPublicKeyRequest._();

  factory GetPublicKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPublicKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPublicKeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPublicKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPublicKeyRequest copyWith(void Function(GetPublicKeyRequest) updates) =>
      super.copyWith((message) => updates(message as GetPublicKeyRequest))
          as GetPublicKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPublicKeyRequest create() => GetPublicKeyRequest._();
  @$core.override
  GetPublicKeyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPublicKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPublicKeyRequest>(create);
  static GetPublicKeyRequest? _defaultInstance;
}

/// 获取公钥响应
class GetPublicKeyResponse extends $pb.GeneratedMessage {
  factory GetPublicKeyResponse({
    $core.String? publicKeyPem,
    $core.String? keyId,
    $core.String? algorithm,
  }) {
    final result = create();
    if (publicKeyPem != null) result.publicKeyPem = publicKeyPem;
    if (keyId != null) result.keyId = keyId;
    if (algorithm != null) result.algorithm = algorithm;
    return result;
  }

  GetPublicKeyResponse._();

  factory GetPublicKeyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPublicKeyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPublicKeyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'publicKeyPem')
    ..aOS(2, _omitFieldNames ? '' : 'keyId')
    ..aOS(3, _omitFieldNames ? '' : 'algorithm')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPublicKeyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPublicKeyResponse copyWith(void Function(GetPublicKeyResponse) updates) =>
      super.copyWith((message) => updates(message as GetPublicKeyResponse))
          as GetPublicKeyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPublicKeyResponse create() => GetPublicKeyResponse._();
  @$core.override
  GetPublicKeyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPublicKeyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPublicKeyResponse>(create);
  static GetPublicKeyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publicKeyPem => $_getSZ(0);
  @$pb.TagNumber(1)
  set publicKeyPem($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicKeyPem() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKeyPem() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get keyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get algorithm => $_getSZ(2);
  @$pb.TagNumber(3)
  set algorithm($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAlgorithm() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlgorithm() => $_clearField(3);
}

/// JWT 域名信息
class JWTDomainInfo extends $pb.GeneratedMessage {
  factory JWTDomainInfo({
    $core.String? domain,
    $core.String? name,
  }) {
    final result = create();
    if (domain != null) result.domain = domain;
    if (name != null) result.name = name;
    return result;
  }

  JWTDomainInfo._();

  factory JWTDomainInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JWTDomainInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JWTDomainInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'domain')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JWTDomainInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JWTDomainInfo copyWith(void Function(JWTDomainInfo) updates) =>
      super.copyWith((message) => updates(message as JWTDomainInfo))
          as JWTDomainInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JWTDomainInfo create() => JWTDomainInfo._();
  @$core.override
  JWTDomainInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JWTDomainInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JWTDomainInfo>(create);
  static JWTDomainInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get domain => $_getSZ(0);
  @$pb.TagNumber(1)
  set domain($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDomain() => $_has(0);
  @$pb.TagNumber(1)
  void clearDomain() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

/// 获取 JWT 域名列表请求
class GetJWTDomainListRequest extends $pb.GeneratedMessage {
  factory GetJWTDomainListRequest() => create();

  GetJWTDomainListRequest._();

  factory GetJWTDomainListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetJWTDomainListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetJWTDomainListRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJWTDomainListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJWTDomainListRequest copyWith(
          void Function(GetJWTDomainListRequest) updates) =>
      super.copyWith((message) => updates(message as GetJWTDomainListRequest))
          as GetJWTDomainListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJWTDomainListRequest create() => GetJWTDomainListRequest._();
  @$core.override
  GetJWTDomainListRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetJWTDomainListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetJWTDomainListRequest>(create);
  static GetJWTDomainListRequest? _defaultInstance;
}

/// 获取 JWT 域名列表响应
class GetJWTDomainListResponse extends $pb.GeneratedMessage {
  factory GetJWTDomainListResponse({
    $core.Iterable<JWTDomainInfo>? domains,
  }) {
    final result = create();
    if (domains != null) result.domains.addAll(domains);
    return result;
  }

  GetJWTDomainListResponse._();

  factory GetJWTDomainListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetJWTDomainListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetJWTDomainListResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'auth'),
      createEmptyInstance: create)
    ..pPM<JWTDomainInfo>(1, _omitFieldNames ? '' : 'domains',
        subBuilder: JWTDomainInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJWTDomainListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetJWTDomainListResponse copyWith(
          void Function(GetJWTDomainListResponse) updates) =>
      super.copyWith((message) => updates(message as GetJWTDomainListResponse))
          as GetJWTDomainListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJWTDomainListResponse create() => GetJWTDomainListResponse._();
  @$core.override
  GetJWTDomainListResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetJWTDomainListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetJWTDomainListResponse>(create);
  static GetJWTDomainListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<JWTDomainInfo> get domains => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
