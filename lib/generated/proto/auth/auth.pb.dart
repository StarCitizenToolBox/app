// This is a generated file - do not edit.
//
// Generated from proto/auth/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
