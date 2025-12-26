// This is a generated file - do not edit.
//
// Generated from proto/partroom/partroom.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'partroom.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'partroom.pbenum.dart';

/// 房间信息（列表用）
class RoomListItem extends $pb.GeneratedMessage {
  factory RoomListItem({
    $core.String? roomUuid,
    $core.String? ownerGameId,
    $core.String? ownerHandleName,
    $core.String? ownerAvatar,
    $core.String? mainTagId,
    $core.String? subTagId,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? ownerLastActive,
    $core.int? currentMembers,
    $core.int? targetMembers,
    $core.bool? hasPassword,
    $core.Iterable<$core.String>? socialLinks,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (ownerGameId != null) result.ownerGameId = ownerGameId;
    if (ownerHandleName != null) result.ownerHandleName = ownerHandleName;
    if (ownerAvatar != null) result.ownerAvatar = ownerAvatar;
    if (mainTagId != null) result.mainTagId = mainTagId;
    if (subTagId != null) result.subTagId = subTagId;
    if (createdAt != null) result.createdAt = createdAt;
    if (ownerLastActive != null) result.ownerLastActive = ownerLastActive;
    if (currentMembers != null) result.currentMembers = currentMembers;
    if (targetMembers != null) result.targetMembers = targetMembers;
    if (hasPassword != null) result.hasPassword = hasPassword;
    if (socialLinks != null) result.socialLinks.addAll(socialLinks);
    return result;
  }

  RoomListItem._();

  factory RoomListItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomListItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomListItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aOS(2, _omitFieldNames ? '' : 'ownerGameId')
    ..aOS(3, _omitFieldNames ? '' : 'ownerHandleName')
    ..aOS(4, _omitFieldNames ? '' : 'ownerAvatar')
    ..aOS(5, _omitFieldNames ? '' : 'mainTagId')
    ..aOS(6, _omitFieldNames ? '' : 'subTagId')
    ..aInt64(7, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(8, _omitFieldNames ? '' : 'ownerLastActive')
    ..aI(9, _omitFieldNames ? '' : 'currentMembers')
    ..aI(10, _omitFieldNames ? '' : 'targetMembers')
    ..aOB(11, _omitFieldNames ? '' : 'hasPassword')
    ..pPS(12, _omitFieldNames ? '' : 'socialLinks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomListItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomListItem copyWith(void Function(RoomListItem) updates) =>
      super.copyWith((message) => updates(message as RoomListItem))
          as RoomListItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomListItem create() => RoomListItem._();
  @$core.override
  RoomListItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomListItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomListItem>(create);
  static RoomListItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ownerGameId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerGameId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOwnerGameId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerGameId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerHandleName => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerHandleName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOwnerHandleName() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerHandleName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ownerAvatar => $_getSZ(3);
  @$pb.TagNumber(4)
  set ownerAvatar($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOwnerAvatar() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwnerAvatar() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get mainTagId => $_getSZ(4);
  @$pb.TagNumber(5)
  set mainTagId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMainTagId() => $_has(4);
  @$pb.TagNumber(5)
  void clearMainTagId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get subTagId => $_getSZ(5);
  @$pb.TagNumber(6)
  set subTagId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubTagId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubTagId() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdAt => $_getI64(6);
  @$pb.TagNumber(7)
  set createdAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get ownerLastActive => $_getI64(7);
  @$pb.TagNumber(8)
  set ownerLastActive($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOwnerLastActive() => $_has(7);
  @$pb.TagNumber(8)
  void clearOwnerLastActive() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get currentMembers => $_getIZ(8);
  @$pb.TagNumber(9)
  set currentMembers($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCurrentMembers() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrentMembers() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get targetMembers => $_getIZ(9);
  @$pb.TagNumber(10)
  set targetMembers($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTargetMembers() => $_has(9);
  @$pb.TagNumber(10)
  void clearTargetMembers() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get hasPassword => $_getBF(10);
  @$pb.TagNumber(11)
  set hasPassword($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHasPassword() => $_has(10);
  @$pb.TagNumber(11)
  void clearHasPassword() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get socialLinks => $_getList(11);
}

/// 获取房间列表请求
class GetRoomListRequest extends $pb.GeneratedMessage {
  factory GetRoomListRequest({
    $core.String? mainTagId,
    $core.String? subTagId,
    $core.String? searchOwnerName,
    $core.int? page,
    $core.int? pageSize,
  }) {
    final result = create();
    if (mainTagId != null) result.mainTagId = mainTagId;
    if (subTagId != null) result.subTagId = subTagId;
    if (searchOwnerName != null) result.searchOwnerName = searchOwnerName;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetRoomListRequest._();

  factory GetRoomListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomListRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mainTagId')
    ..aOS(2, _omitFieldNames ? '' : 'subTagId')
    ..aOS(3, _omitFieldNames ? '' : 'searchOwnerName')
    ..aI(4, _omitFieldNames ? '' : 'page')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomListRequest copyWith(void Function(GetRoomListRequest) updates) =>
      super.copyWith((message) => updates(message as GetRoomListRequest))
          as GetRoomListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomListRequest create() => GetRoomListRequest._();
  @$core.override
  GetRoomListRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomListRequest>(create);
  static GetRoomListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mainTagId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mainTagId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMainTagId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMainTagId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subTagId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subTagId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubTagId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubTagId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get searchOwnerName => $_getSZ(2);
  @$pb.TagNumber(3)
  set searchOwnerName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSearchOwnerName() => $_has(2);
  @$pb.TagNumber(3)
  void clearSearchOwnerName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get page => $_getIZ(3);
  @$pb.TagNumber(4)
  set page($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

/// 获取房间列表响应
class GetRoomListResponse extends $pb.GeneratedMessage {
  factory GetRoomListResponse({
    $core.Iterable<RoomListItem>? rooms,
    $core.int? total,
    $core.int? page,
    $core.int? pageSize,
  }) {
    final result = create();
    if (rooms != null) result.rooms.addAll(rooms);
    if (total != null) result.total = total;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetRoomListResponse._();

  factory GetRoomListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomListResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..pPM<RoomListItem>(1, _omitFieldNames ? '' : 'rooms',
        subBuilder: RoomListItem.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..aI(3, _omitFieldNames ? '' : 'page')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomListResponse copyWith(void Function(GetRoomListResponse) updates) =>
      super.copyWith((message) => updates(message as GetRoomListResponse))
          as GetRoomListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomListResponse create() => GetRoomListResponse._();
  @$core.override
  GetRoomListResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomListResponse>(create);
  static GetRoomListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RoomListItem> get rooms => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get page => $_getIZ(2);
  @$pb.TagNumber(3)
  set page($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

/// 创建房间请求
class CreateRoomRequest extends $pb.GeneratedMessage {
  factory CreateRoomRequest({
    $core.String? mainTagId,
    $core.String? subTagId,
    $core.int? targetMembers,
    $core.bool? hasPassword,
    $core.String? password_5,
    $core.Iterable<$core.String>? socialLinks,
  }) {
    final result = create();
    if (mainTagId != null) result.mainTagId = mainTagId;
    if (subTagId != null) result.subTagId = subTagId;
    if (targetMembers != null) result.targetMembers = targetMembers;
    if (hasPassword != null) result.hasPassword = hasPassword;
    if (password_5 != null) result.password_5 = password_5;
    if (socialLinks != null) result.socialLinks.addAll(socialLinks);
    return result;
  }

  CreateRoomRequest._();

  factory CreateRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mainTagId')
    ..aOS(2, _omitFieldNames ? '' : 'subTagId')
    ..aI(3, _omitFieldNames ? '' : 'targetMembers')
    ..aOB(4, _omitFieldNames ? '' : 'hasPassword')
    ..aOS(5, _omitFieldNames ? '' : 'password')
    ..pPS(6, _omitFieldNames ? '' : 'socialLinks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomRequest copyWith(void Function(CreateRoomRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRoomRequest))
          as CreateRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest create() => CreateRoomRequest._();
  @$core.override
  CreateRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomRequest>(create);
  static CreateRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mainTagId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mainTagId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMainTagId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMainTagId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subTagId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subTagId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubTagId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubTagId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get targetMembers => $_getIZ(2);
  @$pb.TagNumber(3)
  set targetMembers($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetMembers() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetMembers() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasPassword => $_getBF(3);
  @$pb.TagNumber(4)
  set hasPassword($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasPassword() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasPassword() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get password_5 => $_getSZ(4);
  @$pb.TagNumber(5)
  set password_5($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassword_5() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassword_5() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get socialLinks => $_getList(5);
}

/// 创建房间响应
class CreateRoomResponse extends $pb.GeneratedMessage {
  factory CreateRoomResponse({
    $core.String? roomUuid,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    return result;
  }

  CreateRoomResponse._();

  factory CreateRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomResponse copyWith(void Function(CreateRoomResponse) updates) =>
      super.copyWith((message) => updates(message as CreateRoomResponse))
          as CreateRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse create() => CreateRoomResponse._();
  @$core.override
  CreateRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomResponse>(create);
  static CreateRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);
}

/// 加入房间请求
class JoinRoomRequest extends $pb.GeneratedMessage {
  factory JoinRoomRequest({
    $core.String? roomUuid,
    $core.String? password,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (password != null) result.password = password;
    return result;
  }

  JoinRoomRequest._();

  factory JoinRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomRequest copyWith(void Function(JoinRoomRequest) updates) =>
      super.copyWith((message) => updates(message as JoinRoomRequest))
          as JoinRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest create() => JoinRoomRequest._();
  @$core.override
  JoinRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRoomRequest>(create);
  static JoinRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);
}

/// 加入房间响应
class JoinRoomResponse extends $pb.GeneratedMessage {
  factory JoinRoomResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  JoinRoomResponse._();

  factory JoinRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomResponse copyWith(void Function(JoinRoomResponse) updates) =>
      super.copyWith((message) => updates(message as JoinRoomResponse))
          as JoinRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse create() => JoinRoomResponse._();
  @$core.override
  JoinRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRoomResponse>(create);
  static JoinRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 离开房间请求
class LeaveRoomRequest extends $pb.GeneratedMessage {
  factory LeaveRoomRequest({
    $core.String? roomUuid,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    return result;
  }

  LeaveRoomRequest._();

  factory LeaveRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LeaveRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomRequest copyWith(void Function(LeaveRoomRequest) updates) =>
      super.copyWith((message) => updates(message as LeaveRoomRequest))
          as LeaveRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest create() => LeaveRoomRequest._();
  @$core.override
  LeaveRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveRoomRequest>(create);
  static LeaveRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);
}

/// 离开房间响应
class LeaveRoomResponse extends $pb.GeneratedMessage {
  factory LeaveRoomResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  LeaveRoomResponse._();

  factory LeaveRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LeaveRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomResponse copyWith(void Function(LeaveRoomResponse) updates) =>
      super.copyWith((message) => updates(message as LeaveRoomResponse))
          as LeaveRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse create() => LeaveRoomResponse._();
  @$core.override
  LeaveRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveRoomResponse>(create);
  static LeaveRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 解散房间请求
class DismissRoomRequest extends $pb.GeneratedMessage {
  factory DismissRoomRequest({
    $core.String? roomUuid,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    return result;
  }

  DismissRoomRequest._();

  factory DismissRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DismissRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRoomRequest copyWith(void Function(DismissRoomRequest) updates) =>
      super.copyWith((message) => updates(message as DismissRoomRequest))
          as DismissRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DismissRoomRequest create() => DismissRoomRequest._();
  @$core.override
  DismissRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DismissRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DismissRoomRequest>(create);
  static DismissRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);
}

/// 解散房间响应
class DismissRoomResponse extends $pb.GeneratedMessage {
  factory DismissRoomResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DismissRoomResponse._();

  factory DismissRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DismissRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRoomResponse copyWith(void Function(DismissRoomResponse) updates) =>
      super.copyWith((message) => updates(message as DismissRoomResponse))
          as DismissRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DismissRoomResponse create() => DismissRoomResponse._();
  @$core.override
  DismissRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DismissRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DismissRoomResponse>(create);
  static DismissRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 成员状态
class MemberStatus extends $pb.GeneratedMessage {
  factory MemberStatus({
    $core.String? currentLocation,
    $core.int? kills,
    $core.int? deaths,
    $fixnum.Int64? playTime,
  }) {
    final result = create();
    if (currentLocation != null) result.currentLocation = currentLocation;
    if (kills != null) result.kills = kills;
    if (deaths != null) result.deaths = deaths;
    if (playTime != null) result.playTime = playTime;
    return result;
  }

  MemberStatus._();

  factory MemberStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'currentLocation')
    ..aI(2, _omitFieldNames ? '' : 'kills')
    ..aI(3, _omitFieldNames ? '' : 'deaths')
    ..aInt64(4, _omitFieldNames ? '' : 'playTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberStatus copyWith(void Function(MemberStatus) updates) =>
      super.copyWith((message) => updates(message as MemberStatus))
          as MemberStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberStatus create() => MemberStatus._();
  @$core.override
  MemberStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberStatus>(create);
  static MemberStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get currentLocation => $_getSZ(0);
  @$pb.TagNumber(1)
  set currentLocation($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentLocation() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get kills => $_getIZ(1);
  @$pb.TagNumber(2)
  set kills($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKills() => $_has(1);
  @$pb.TagNumber(2)
  void clearKills() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get deaths => $_getIZ(2);
  @$pb.TagNumber(3)
  set deaths($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeaths() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeaths() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get playTime => $_getI64(3);
  @$pb.TagNumber(4)
  set playTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayTime() => $_clearField(4);
}

/// 房间成员
class RoomMember extends $pb.GeneratedMessage {
  factory RoomMember({
    $core.String? gameUserId,
    $core.String? handleName,
    $core.String? avatarUrl,
    $fixnum.Int64? joinedAt,
    $fixnum.Int64? lastActive,
    $core.bool? isOwner,
    MemberStatus? status,
  }) {
    final result = create();
    if (gameUserId != null) result.gameUserId = gameUserId;
    if (handleName != null) result.handleName = handleName;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (joinedAt != null) result.joinedAt = joinedAt;
    if (lastActive != null) result.lastActive = lastActive;
    if (isOwner != null) result.isOwner = isOwner;
    if (status != null) result.status = status;
    return result;
  }

  RoomMember._();

  factory RoomMember.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomMember.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomMember',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameUserId')
    ..aOS(2, _omitFieldNames ? '' : 'handleName')
    ..aOS(3, _omitFieldNames ? '' : 'avatarUrl')
    ..aInt64(4, _omitFieldNames ? '' : 'joinedAt')
    ..aInt64(5, _omitFieldNames ? '' : 'lastActive')
    ..aOB(6, _omitFieldNames ? '' : 'isOwner')
    ..aOM<MemberStatus>(7, _omitFieldNames ? '' : 'status',
        subBuilder: MemberStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMember clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMember copyWith(void Function(RoomMember) updates) =>
      super.copyWith((message) => updates(message as RoomMember)) as RoomMember;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomMember create() => RoomMember._();
  @$core.override
  RoomMember createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomMember getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomMember>(create);
  static RoomMember? _defaultInstance;

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
  $fixnum.Int64 get joinedAt => $_getI64(3);
  @$pb.TagNumber(4)
  set joinedAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJoinedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get lastActive => $_getI64(4);
  @$pb.TagNumber(5)
  set lastActive($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLastActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastActive() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isOwner => $_getBF(5);
  @$pb.TagNumber(6)
  set isOwner($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsOwner() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsOwner() => $_clearField(6);

  @$pb.TagNumber(7)
  MemberStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(MemberStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);
  @$pb.TagNumber(7)
  MemberStatus ensureStatus() => $_ensure(6);
}

/// 房间详情
class RoomInfo extends $pb.GeneratedMessage {
  factory RoomInfo({
    $core.String? roomUuid,
    $core.String? ownerGameId,
    $core.String? mainTagId,
    $core.String? subTagId,
    $core.int? targetMembers,
    $core.bool? hasPassword,
    $fixnum.Int64? createdAt,
    $core.int? currentMembers,
    $core.Iterable<$core.String>? socialLinks,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (ownerGameId != null) result.ownerGameId = ownerGameId;
    if (mainTagId != null) result.mainTagId = mainTagId;
    if (subTagId != null) result.subTagId = subTagId;
    if (targetMembers != null) result.targetMembers = targetMembers;
    if (hasPassword != null) result.hasPassword = hasPassword;
    if (createdAt != null) result.createdAt = createdAt;
    if (currentMembers != null) result.currentMembers = currentMembers;
    if (socialLinks != null) result.socialLinks.addAll(socialLinks);
    return result;
  }

  RoomInfo._();

  factory RoomInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aOS(2, _omitFieldNames ? '' : 'ownerGameId')
    ..aOS(3, _omitFieldNames ? '' : 'mainTagId')
    ..aOS(4, _omitFieldNames ? '' : 'subTagId')
    ..aI(5, _omitFieldNames ? '' : 'targetMembers')
    ..aOB(6, _omitFieldNames ? '' : 'hasPassword')
    ..aInt64(7, _omitFieldNames ? '' : 'createdAt')
    ..aI(8, _omitFieldNames ? '' : 'currentMembers')
    ..pPS(9, _omitFieldNames ? '' : 'socialLinks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomInfo copyWith(void Function(RoomInfo) updates) =>
      super.copyWith((message) => updates(message as RoomInfo)) as RoomInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomInfo create() => RoomInfo._();
  @$core.override
  RoomInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomInfo>(create);
  static RoomInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ownerGameId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerGameId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOwnerGameId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerGameId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get mainTagId => $_getSZ(2);
  @$pb.TagNumber(3)
  set mainTagId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMainTagId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMainTagId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subTagId => $_getSZ(3);
  @$pb.TagNumber(4)
  set subTagId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubTagId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubTagId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get targetMembers => $_getIZ(4);
  @$pb.TagNumber(5)
  set targetMembers($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetMembers() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetMembers() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get hasPassword => $_getBF(5);
  @$pb.TagNumber(6)
  set hasPassword($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHasPassword() => $_has(5);
  @$pb.TagNumber(6)
  void clearHasPassword() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdAt => $_getI64(6);
  @$pb.TagNumber(7)
  set createdAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get currentMembers => $_getIZ(7);
  @$pb.TagNumber(8)
  set currentMembers($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrentMembers() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrentMembers() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get socialLinks => $_getList(8);
}

/// 获取房间详情请求
class GetRoomInfoRequest extends $pb.GeneratedMessage {
  factory GetRoomInfoRequest({
    $core.String? roomUuid,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    return result;
  }

  GetRoomInfoRequest._();

  factory GetRoomInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomInfoRequest copyWith(void Function(GetRoomInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetRoomInfoRequest))
          as GetRoomInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomInfoRequest create() => GetRoomInfoRequest._();
  @$core.override
  GetRoomInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomInfoRequest>(create);
  static GetRoomInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);
}

/// 获取房间详情响应
class GetRoomInfoResponse extends $pb.GeneratedMessage {
  factory GetRoomInfoResponse({
    RoomInfo? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  GetRoomInfoResponse._();

  factory GetRoomInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOM<RoomInfo>(1, _omitFieldNames ? '' : 'room',
        subBuilder: RoomInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomInfoResponse copyWith(void Function(GetRoomInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetRoomInfoResponse))
          as GetRoomInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomInfoResponse create() => GetRoomInfoResponse._();
  @$core.override
  GetRoomInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomInfoResponse>(create);
  static GetRoomInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RoomInfo get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(RoomInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  RoomInfo ensureRoom() => $_ensure(0);
}

/// 获取房间成员请求
class GetRoomMembersRequest extends $pb.GeneratedMessage {
  factory GetRoomMembersRequest({
    $core.String? roomUuid,
    $core.int? page,
    $core.int? pageSize,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetRoomMembersRequest._();

  factory GetRoomMembersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomMembersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomMembersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aI(2, _omitFieldNames ? '' : 'page')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomMembersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomMembersRequest copyWith(
          void Function(GetRoomMembersRequest) updates) =>
      super.copyWith((message) => updates(message as GetRoomMembersRequest))
          as GetRoomMembersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomMembersRequest create() => GetRoomMembersRequest._();
  @$core.override
  GetRoomMembersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomMembersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomMembersRequest>(create);
  static GetRoomMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get page => $_getIZ(1);
  @$pb.TagNumber(2)
  set page($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

/// 获取房间成员响应
class GetRoomMembersResponse extends $pb.GeneratedMessage {
  factory GetRoomMembersResponse({
    $core.Iterable<RoomMember>? members,
    $core.int? total,
  }) {
    final result = create();
    if (members != null) result.members.addAll(members);
    if (total != null) result.total = total;
    return result;
  }

  GetRoomMembersResponse._();

  factory GetRoomMembersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomMembersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomMembersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..pPM<RoomMember>(1, _omitFieldNames ? '' : 'members',
        subBuilder: RoomMember.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomMembersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomMembersResponse copyWith(
          void Function(GetRoomMembersResponse) updates) =>
      super.copyWith((message) => updates(message as GetRoomMembersResponse))
          as GetRoomMembersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomMembersResponse create() => GetRoomMembersResponse._();
  @$core.override
  GetRoomMembersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomMembersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomMembersResponse>(create);
  static GetRoomMembersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RoomMember> get members => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

/// 心跳请求
class HeartbeatRequest extends $pb.GeneratedMessage {
  factory HeartbeatRequest({
    $core.String? roomUuid,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    return result;
  }

  HeartbeatRequest._();

  factory HeartbeatRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeartbeatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeartbeatRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatRequest copyWith(void Function(HeartbeatRequest) updates) =>
      super.copyWith((message) => updates(message as HeartbeatRequest))
          as HeartbeatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartbeatRequest create() => HeartbeatRequest._();
  @$core.override
  HeartbeatRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeartbeatRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeartbeatRequest>(create);
  static HeartbeatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);
}

/// 心跳响应
class HeartbeatResponse extends $pb.GeneratedMessage {
  factory HeartbeatResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  HeartbeatResponse._();

  factory HeartbeatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeartbeatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeartbeatResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatResponse copyWith(void Function(HeartbeatResponse) updates) =>
      super.copyWith((message) => updates(message as HeartbeatResponse))
          as HeartbeatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartbeatResponse create() => HeartbeatResponse._();
  @$core.override
  HeartbeatResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeartbeatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeartbeatResponse>(create);
  static HeartbeatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 获取我的房间请求
class GetMyRoomRequest extends $pb.GeneratedMessage {
  factory GetMyRoomRequest() => create();

  GetMyRoomRequest._();

  factory GetMyRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMyRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyRoomRequest copyWith(void Function(GetMyRoomRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyRoomRequest))
          as GetMyRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMyRoomRequest create() => GetMyRoomRequest._();
  @$core.override
  GetMyRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMyRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyRoomRequest>(create);
  static GetMyRoomRequest? _defaultInstance;
}

/// 获取我的房间响应
class GetMyRoomResponse extends $pb.GeneratedMessage {
  factory GetMyRoomResponse({
    RoomInfo? room,
    $core.bool? hasRoom_2,
  }) {
    final result = create();
    if (room != null) result.room = room;
    if (hasRoom_2 != null) result.hasRoom_2 = hasRoom_2;
    return result;
  }

  GetMyRoomResponse._();

  factory GetMyRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMyRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOM<RoomInfo>(1, _omitFieldNames ? '' : 'room',
        subBuilder: RoomInfo.create)
    ..aOB(2, _omitFieldNames ? '' : 'hasRoom')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyRoomResponse copyWith(void Function(GetMyRoomResponse) updates) =>
      super.copyWith((message) => updates(message as GetMyRoomResponse))
          as GetMyRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMyRoomResponse create() => GetMyRoomResponse._();
  @$core.override
  GetMyRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMyRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyRoomResponse>(create);
  static GetMyRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RoomInfo get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(RoomInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  RoomInfo ensureRoom() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get hasRoom_2 => $_getBF(1);
  @$pb.TagNumber(2)
  set hasRoom_2($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasRoom_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasRoom_2() => $_clearField(2);
}

/// 更新房间请求
class UpdateRoomRequest extends $pb.GeneratedMessage {
  factory UpdateRoomRequest({
    $core.String? roomUuid,
    $core.int? targetMembers,
    $core.String? password,
    $core.String? mainTagId,
    $core.String? subTagId,
    $core.Iterable<$core.String>? socialLinks,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (targetMembers != null) result.targetMembers = targetMembers;
    if (password != null) result.password = password;
    if (mainTagId != null) result.mainTagId = mainTagId;
    if (subTagId != null) result.subTagId = subTagId;
    if (socialLinks != null) result.socialLinks.addAll(socialLinks);
    return result;
  }

  UpdateRoomRequest._();

  factory UpdateRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aI(2, _omitFieldNames ? '' : 'targetMembers')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..aOS(4, _omitFieldNames ? '' : 'mainTagId')
    ..aOS(5, _omitFieldNames ? '' : 'subTagId')
    ..pPS(6, _omitFieldNames ? '' : 'socialLinks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomRequest copyWith(void Function(UpdateRoomRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRoomRequest))
          as UpdateRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomRequest create() => UpdateRoomRequest._();
  @$core.override
  UpdateRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomRequest>(create);
  static UpdateRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get targetMembers => $_getIZ(1);
  @$pb.TagNumber(2)
  set targetMembers($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetMembers() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetMembers() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get mainTagId => $_getSZ(3);
  @$pb.TagNumber(4)
  set mainTagId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMainTagId() => $_has(3);
  @$pb.TagNumber(4)
  void clearMainTagId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get subTagId => $_getSZ(4);
  @$pb.TagNumber(5)
  set subTagId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubTagId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubTagId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get socialLinks => $_getList(5);
}

/// 更新房间响应
class UpdateRoomResponse extends $pb.GeneratedMessage {
  factory UpdateRoomResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  UpdateRoomResponse._();

  factory UpdateRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomResponse copyWith(void Function(UpdateRoomResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateRoomResponse))
          as UpdateRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomResponse create() => UpdateRoomResponse._();
  @$core.override
  UpdateRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomResponse>(create);
  static UpdateRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 踢出成员请求
class KickMemberRequest extends $pb.GeneratedMessage {
  factory KickMemberRequest({
    $core.String? roomUuid,
    $core.String? targetGameUserId,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (targetGameUserId != null) result.targetGameUserId = targetGameUserId;
    return result;
  }

  KickMemberRequest._();

  factory KickMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickMemberRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aOS(2, _omitFieldNames ? '' : 'targetGameUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickMemberRequest copyWith(void Function(KickMemberRequest) updates) =>
      super.copyWith((message) => updates(message as KickMemberRequest))
          as KickMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickMemberRequest create() => KickMemberRequest._();
  @$core.override
  KickMemberRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickMemberRequest>(create);
  static KickMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetGameUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetGameUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetGameUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetGameUserId() => $_clearField(2);
}

/// 踢出成员响应
class KickMemberResponse extends $pb.GeneratedMessage {
  factory KickMemberResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  KickMemberResponse._();

  factory KickMemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickMemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickMemberResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickMemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickMemberResponse copyWith(void Function(KickMemberResponse) updates) =>
      super.copyWith((message) => updates(message as KickMemberResponse))
          as KickMemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickMemberResponse create() => KickMemberResponse._();
  @$core.override
  KickMemberResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickMemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickMemberResponse>(create);
  static KickMemberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 设置状态请求
class SetStatusRequest extends $pb.GeneratedMessage {
  factory SetStatusRequest({
    $core.String? roomUuid,
    MemberStatus? status,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (status != null) result.status = status;
    return result;
  }

  SetStatusRequest._();

  factory SetStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aOM<MemberStatus>(2, _omitFieldNames ? '' : 'status',
        subBuilder: MemberStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetStatusRequest copyWith(void Function(SetStatusRequest) updates) =>
      super.copyWith((message) => updates(message as SetStatusRequest))
          as SetStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetStatusRequest create() => SetStatusRequest._();
  @$core.override
  SetStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetStatusRequest>(create);
  static SetStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  MemberStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(MemberStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
  @$pb.TagNumber(2)
  MemberStatus ensureStatus() => $_ensure(1);
}

/// 设置状态响应
class SetStatusResponse extends $pb.GeneratedMessage {
  factory SetStatusResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  SetStatusResponse._();

  factory SetStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetStatusResponse copyWith(void Function(SetStatusResponse) updates) =>
      super.copyWith((message) => updates(message as SetStatusResponse))
          as SetStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetStatusResponse create() => SetStatusResponse._();
  @$core.override
  SetStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetStatusResponse>(create);
  static SetStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 发送信号请求
class SendSignalRequest extends $pb.GeneratedMessage {
  factory SendSignalRequest({
    $core.String? roomUuid,
    $core.String? signalId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? params,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (signalId != null) result.signalId = signalId;
    if (params != null) result.params.addEntries(params);
    return result;
  }

  SendSignalRequest._();

  factory SendSignalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendSignalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendSignalRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aOS(2, _omitFieldNames ? '' : 'signalId')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'params',
        entryClassName: 'SendSignalRequest.ParamsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('partroom'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendSignalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendSignalRequest copyWith(void Function(SendSignalRequest) updates) =>
      super.copyWith((message) => updates(message as SendSignalRequest))
          as SendSignalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendSignalRequest create() => SendSignalRequest._();
  @$core.override
  SendSignalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendSignalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendSignalRequest>(create);
  static SendSignalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get signalId => $_getSZ(1);
  @$pb.TagNumber(2)
  set signalId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSignalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignalId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get params => $_getMap(2);
}

/// 发送信号响应
class SendSignalResponse extends $pb.GeneratedMessage {
  factory SendSignalResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  SendSignalResponse._();

  factory SendSignalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendSignalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendSignalResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendSignalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendSignalResponse copyWith(void Function(SendSignalResponse) updates) =>
      super.copyWith((message) => updates(message as SendSignalResponse))
          as SendSignalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendSignalResponse create() => SendSignalResponse._();
  @$core.override
  SendSignalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendSignalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendSignalResponse>(create);
  static SendSignalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 房间事件
class RoomEvent extends $pb.GeneratedMessage {
  factory RoomEvent({
    RoomEventType? type,
    $core.String? roomUuid,
    $fixnum.Int64? timestamp,
    RoomMember? member,
    $core.String? signalId,
    $core.String? signalSender,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? signalParams,
    RoomInfo? roomInfo,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (timestamp != null) result.timestamp = timestamp;
    if (member != null) result.member = member;
    if (signalId != null) result.signalId = signalId;
    if (signalSender != null) result.signalSender = signalSender;
    if (signalParams != null) result.signalParams.addEntries(signalParams);
    if (roomInfo != null) result.roomInfo = roomInfo;
    return result;
  }

  RoomEvent._();

  factory RoomEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aE<RoomEventType>(1, _omitFieldNames ? '' : 'type',
        enumValues: RoomEventType.values)
    ..aOS(2, _omitFieldNames ? '' : 'roomUuid')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..aOM<RoomMember>(4, _omitFieldNames ? '' : 'member',
        subBuilder: RoomMember.create)
    ..aOS(5, _omitFieldNames ? '' : 'signalId')
    ..aOS(6, _omitFieldNames ? '' : 'signalSender')
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'signalParams',
        entryClassName: 'RoomEvent.SignalParamsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('partroom'))
    ..aOM<RoomInfo>(8, _omitFieldNames ? '' : 'roomInfo',
        subBuilder: RoomInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomEvent copyWith(void Function(RoomEvent) updates) =>
      super.copyWith((message) => updates(message as RoomEvent)) as RoomEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomEvent create() => RoomEvent._();
  @$core.override
  RoomEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomEvent>(create);
  static RoomEvent? _defaultInstance;

  @$pb.TagNumber(1)
  RoomEventType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(RoomEventType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomUuid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomUuid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);

  /// 根据事件类型使用不同的字段
  @$pb.TagNumber(4)
  RoomMember get member => $_getN(3);
  @$pb.TagNumber(4)
  set member(RoomMember value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMember() => $_has(3);
  @$pb.TagNumber(4)
  void clearMember() => $_clearField(4);
  @$pb.TagNumber(4)
  RoomMember ensureMember() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get signalId => $_getSZ(4);
  @$pb.TagNumber(5)
  set signalId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSignalId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignalId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get signalSender => $_getSZ(5);
  @$pb.TagNumber(6)
  set signalSender($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSignalSender() => $_has(5);
  @$pb.TagNumber(6)
  void clearSignalSender() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get signalParams => $_getMap(6);

  @$pb.TagNumber(8)
  RoomInfo get roomInfo => $_getN(7);
  @$pb.TagNumber(8)
  set roomInfo(RoomInfo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRoomInfo() => $_has(7);
  @$pb.TagNumber(8)
  void clearRoomInfo() => $_clearField(8);
  @$pb.TagNumber(8)
  RoomInfo ensureRoomInfo() => $_ensure(7);
}

/// 监听房间事件请求
class ListenRoomEventsRequest extends $pb.GeneratedMessage {
  factory ListenRoomEventsRequest({
    $core.String? roomUuid,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    return result;
  }

  ListenRoomEventsRequest._();

  factory ListenRoomEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListenRoomEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListenRoomEventsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListenRoomEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListenRoomEventsRequest copyWith(
          void Function(ListenRoomEventsRequest) updates) =>
      super.copyWith((message) => updates(message as ListenRoomEventsRequest))
          as ListenRoomEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListenRoomEventsRequest create() => ListenRoomEventsRequest._();
  @$core.override
  ListenRoomEventsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListenRoomEventsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListenRoomEventsRequest>(create);
  static ListenRoomEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);
}

/// 转移房主请求
class TransferOwnershipRequest extends $pb.GeneratedMessage {
  factory TransferOwnershipRequest({
    $core.String? roomUuid,
    $core.String? targetGameUserId,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (targetGameUserId != null) result.targetGameUserId = targetGameUserId;
    return result;
  }

  TransferOwnershipRequest._();

  factory TransferOwnershipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferOwnershipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferOwnershipRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aOS(2, _omitFieldNames ? '' : 'targetGameUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferOwnershipRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferOwnershipRequest copyWith(
          void Function(TransferOwnershipRequest) updates) =>
      super.copyWith((message) => updates(message as TransferOwnershipRequest))
          as TransferOwnershipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferOwnershipRequest create() => TransferOwnershipRequest._();
  @$core.override
  TransferOwnershipRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransferOwnershipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferOwnershipRequest>(create);
  static TransferOwnershipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetGameUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetGameUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetGameUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetGameUserId() => $_clearField(2);
}

/// 转移房主响应
class TransferOwnershipResponse extends $pb.GeneratedMessage {
  factory TransferOwnershipResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  TransferOwnershipResponse._();

  factory TransferOwnershipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferOwnershipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferOwnershipResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferOwnershipResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferOwnershipResponse copyWith(
          void Function(TransferOwnershipResponse) updates) =>
      super.copyWith((message) => updates(message as TransferOwnershipResponse))
          as TransferOwnershipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferOwnershipResponse create() => TransferOwnershipResponse._();
  @$core.override
  TransferOwnershipResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransferOwnershipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferOwnershipResponse>(create);
  static TransferOwnershipResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// 被踢出成员
class KickedMember extends $pb.GeneratedMessage {
  factory KickedMember({
    $core.String? gameUserId,
    $core.String? handleName,
    $core.String? avatarUrl,
    $fixnum.Int64? joinedAt,
    $fixnum.Int64? kickedAt,
  }) {
    final result = create();
    if (gameUserId != null) result.gameUserId = gameUserId;
    if (handleName != null) result.handleName = handleName;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (joinedAt != null) result.joinedAt = joinedAt;
    if (kickedAt != null) result.kickedAt = kickedAt;
    return result;
  }

  KickedMember._();

  factory KickedMember.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickedMember.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickedMember',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameUserId')
    ..aOS(2, _omitFieldNames ? '' : 'handleName')
    ..aOS(3, _omitFieldNames ? '' : 'avatarUrl')
    ..aInt64(4, _omitFieldNames ? '' : 'joinedAt')
    ..aInt64(5, _omitFieldNames ? '' : 'kickedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickedMember clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickedMember copyWith(void Function(KickedMember) updates) =>
      super.copyWith((message) => updates(message as KickedMember))
          as KickedMember;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickedMember create() => KickedMember._();
  @$core.override
  KickedMember createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickedMember getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickedMember>(create);
  static KickedMember? _defaultInstance;

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
  $fixnum.Int64 get joinedAt => $_getI64(3);
  @$pb.TagNumber(4)
  set joinedAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJoinedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get kickedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set kickedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasKickedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearKickedAt() => $_clearField(5);
}

/// 获取被踢出成员请求
class GetKickedMembersRequest extends $pb.GeneratedMessage {
  factory GetKickedMembersRequest({
    $core.String? roomUuid,
    $core.int? page,
    $core.int? pageSize,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetKickedMembersRequest._();

  factory GetKickedMembersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetKickedMembersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetKickedMembersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aI(2, _omitFieldNames ? '' : 'page')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKickedMembersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKickedMembersRequest copyWith(
          void Function(GetKickedMembersRequest) updates) =>
      super.copyWith((message) => updates(message as GetKickedMembersRequest))
          as GetKickedMembersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKickedMembersRequest create() => GetKickedMembersRequest._();
  @$core.override
  GetKickedMembersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetKickedMembersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetKickedMembersRequest>(create);
  static GetKickedMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get page => $_getIZ(1);
  @$pb.TagNumber(2)
  set page($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

/// 获取被踢出成员响应
class GetKickedMembersResponse extends $pb.GeneratedMessage {
  factory GetKickedMembersResponse({
    $core.Iterable<KickedMember>? members,
    $core.int? total,
  }) {
    final result = create();
    if (members != null) result.members.addAll(members);
    if (total != null) result.total = total;
    return result;
  }

  GetKickedMembersResponse._();

  factory GetKickedMembersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetKickedMembersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetKickedMembersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..pPM<KickedMember>(1, _omitFieldNames ? '' : 'members',
        subBuilder: KickedMember.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKickedMembersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKickedMembersResponse copyWith(
          void Function(GetKickedMembersResponse) updates) =>
      super.copyWith((message) => updates(message as GetKickedMembersResponse))
          as GetKickedMembersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetKickedMembersResponse create() => GetKickedMembersResponse._();
  @$core.override
  GetKickedMembersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetKickedMembersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetKickedMembersResponse>(create);
  static GetKickedMembersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KickedMember> get members => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

/// 移除被踢出成员请求
class RemoveKickedMemberRequest extends $pb.GeneratedMessage {
  factory RemoveKickedMemberRequest({
    $core.String? roomUuid,
    $core.String? gameUserId,
  }) {
    final result = create();
    if (roomUuid != null) result.roomUuid = roomUuid;
    if (gameUserId != null) result.gameUserId = gameUserId;
    return result;
  }

  RemoveKickedMemberRequest._();

  factory RemoveKickedMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveKickedMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveKickedMemberRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomUuid')
    ..aOS(2, _omitFieldNames ? '' : 'gameUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveKickedMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveKickedMemberRequest copyWith(
          void Function(RemoveKickedMemberRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveKickedMemberRequest))
          as RemoveKickedMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveKickedMemberRequest create() => RemoveKickedMemberRequest._();
  @$core.override
  RemoveKickedMemberRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveKickedMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveKickedMemberRequest>(create);
  static RemoveKickedMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gameUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGameUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameUserId() => $_clearField(2);
}

/// 移除被踢出成员响应
class RemoveKickedMemberResponse extends $pb.GeneratedMessage {
  factory RemoveKickedMemberResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  RemoveKickedMemberResponse._();

  factory RemoveKickedMemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveKickedMemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveKickedMemberResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'partroom'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveKickedMemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveKickedMemberResponse copyWith(
          void Function(RemoveKickedMemberResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RemoveKickedMemberResponse))
          as RemoveKickedMemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveKickedMemberResponse create() => RemoveKickedMemberResponse._();
  @$core.override
  RemoveKickedMemberResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveKickedMemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveKickedMemberResponse>(create);
  static RemoveKickedMemberResponse? _defaultInstance;

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
