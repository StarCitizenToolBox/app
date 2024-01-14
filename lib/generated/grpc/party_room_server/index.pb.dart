//
//  Generated code. Do not modify.
//  source: index.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'index.pbenum.dart';

export 'index.pbenum.dart';

class Empty extends $pb.GeneratedMessage {
  factory Empty() => create();
  Empty._() : super();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Empty', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class BaseRespData extends $pb.GeneratedMessage {
  factory BaseRespData({
    $core.int? code,
    $core.String? message,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  BaseRespData._() : super();
  factory BaseRespData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BaseRespData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BaseRespData', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BaseRespData clone() => BaseRespData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BaseRespData copyWith(void Function(BaseRespData) updates) => super.copyWith((message) => updates(message as BaseRespData)) as BaseRespData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BaseRespData create() => BaseRespData._();
  BaseRespData createEmptyInstance() => create();
  static $pb.PbList<BaseRespData> createRepeated() => $pb.PbList<BaseRespData>();
  @$core.pragma('dart2js:noInline')
  static BaseRespData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BaseRespData>(create);
  static BaseRespData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class BasePageRespData extends $pb.GeneratedMessage {
  factory BasePageRespData({
    $core.int? code,
    $core.String? message,
    $core.bool? hasNext,
    $fixnum.Int64? curPageNum,
    $fixnum.Int64? pageSize,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (hasNext != null) {
      $result.hasNext = hasNext;
    }
    if (curPageNum != null) {
      $result.curPageNum = curPageNum;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    return $result;
  }
  BasePageRespData._() : super();
  factory BasePageRespData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BasePageRespData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BasePageRespData', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'hasNext', protoName: 'hasNext')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'curPageNum', $pb.PbFieldType.OU6, protoName: 'curPageNum', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(5, _omitFieldNames ? '' : 'pageSize', protoName: 'pageSize')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BasePageRespData clone() => BasePageRespData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BasePageRespData copyWith(void Function(BasePageRespData) updates) => super.copyWith((message) => updates(message as BasePageRespData)) as BasePageRespData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BasePageRespData create() => BasePageRespData._();
  BasePageRespData createEmptyInstance() => create();
  static $pb.PbList<BasePageRespData> createRepeated() => $pb.PbList<BasePageRespData>();
  @$core.pragma('dart2js:noInline')
  static BasePageRespData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BasePageRespData>(create);
  static BasePageRespData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasNext => $_getBF(2);
  @$pb.TagNumber(3)
  set hasNext($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHasNext() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasNext() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get curPageNum => $_getI64(3);
  @$pb.TagNumber(4)
  set curPageNum($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurPageNum() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurPageNum() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get pageSize => $_getI64(4);
  @$pb.TagNumber(5)
  set pageSize($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => clearField(5);
}

class PingData extends $pb.GeneratedMessage {
  factory PingData({
    $core.String? data,
    $fixnum.Int64? clientVersion,
    $fixnum.Int64? serverVersion,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (clientVersion != null) {
      $result.clientVersion = clientVersion;
    }
    if (serverVersion != null) {
      $result.serverVersion = serverVersion;
    }
    return $result;
  }
  PingData._() : super();
  factory PingData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PingData', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'data')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'clientVersion', $pb.PbFieldType.OS6, protoName: 'clientVersion', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'serverVersion', $pb.PbFieldType.OS6, protoName: 'serverVersion', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingData clone() => PingData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingData copyWith(void Function(PingData) updates) => super.copyWith((message) => updates(message as PingData)) as PingData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingData create() => PingData._();
  PingData createEmptyInstance() => create();
  static $pb.PbList<PingData> createRepeated() => $pb.PbList<PingData>();
  @$core.pragma('dart2js:noInline')
  static PingData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingData>(create);
  static PingData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get data => $_getSZ(0);
  @$pb.TagNumber(1)
  set data($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get clientVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set clientVersion($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClientVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientVersion() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get serverVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set serverVersion($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasServerVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerVersion() => clearField(3);
}

class RoomTypesData extends $pb.GeneratedMessage {
  factory RoomTypesData({
    $core.Iterable<RoomType>? roomTypes,
  }) {
    final $result = create();
    if (roomTypes != null) {
      $result.roomTypes.addAll(roomTypes);
    }
    return $result;
  }
  RoomTypesData._() : super();
  factory RoomTypesData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomTypesData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomTypesData', createEmptyInstance: create)
    ..pc<RoomType>(1, _omitFieldNames ? '' : 'roomTypes', $pb.PbFieldType.PM, protoName: 'roomTypes', subBuilder: RoomType.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomTypesData clone() => RoomTypesData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomTypesData copyWith(void Function(RoomTypesData) updates) => super.copyWith((message) => updates(message as RoomTypesData)) as RoomTypesData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomTypesData create() => RoomTypesData._();
  RoomTypesData createEmptyInstance() => create();
  static $pb.PbList<RoomTypesData> createRepeated() => $pb.PbList<RoomTypesData>();
  @$core.pragma('dart2js:noInline')
  static RoomTypesData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomTypesData>(create);
  static RoomTypesData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<RoomType> get roomTypes => $_getList(0);
}

class RoomType extends $pb.GeneratedMessage {
  factory RoomType({
    $core.String? id,
    $core.String? name,
    $core.String? icon,
    $core.String? desc,
    $core.Iterable<RoomSubtype>? subTypes,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (icon != null) {
      $result.icon = icon;
    }
    if (desc != null) {
      $result.desc = desc;
    }
    if (subTypes != null) {
      $result.subTypes.addAll(subTypes);
    }
    return $result;
  }
  RoomType._() : super();
  factory RoomType.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomType.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomType', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aOS(4, _omitFieldNames ? '' : 'desc')
    ..pc<RoomSubtype>(5, _omitFieldNames ? '' : 'subTypes', $pb.PbFieldType.PM, protoName: 'subTypes', subBuilder: RoomSubtype.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomType clone() => RoomType()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomType copyWith(void Function(RoomType) updates) => super.copyWith((message) => updates(message as RoomType)) as RoomType;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomType create() => RoomType._();
  RoomType createEmptyInstance() => create();
  static $pb.PbList<RoomType> createRepeated() => $pb.PbList<RoomType>();
  @$core.pragma('dart2js:noInline')
  static RoomType getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomType>(create);
  static RoomType? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get desc => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<RoomSubtype> get subTypes => $_getList(4);
}

class RoomSubtype extends $pb.GeneratedMessage {
  factory RoomSubtype({
    $core.String? id,
    $core.String? name,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  RoomSubtype._() : super();
  factory RoomSubtype.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomSubtype.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomSubtype', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomSubtype clone() => RoomSubtype()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomSubtype copyWith(void Function(RoomSubtype) updates) => super.copyWith((message) => updates(message as RoomSubtype)) as RoomSubtype;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomSubtype create() => RoomSubtype._();
  RoomSubtype createEmptyInstance() => create();
  static $pb.PbList<RoomSubtype> createRepeated() => $pb.PbList<RoomSubtype>();
  @$core.pragma('dart2js:noInline')
  static RoomSubtype getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomSubtype>(create);
  static RoomSubtype? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class RoomData extends $pb.GeneratedMessage {
  factory RoomData({
    $core.String? id,
    $core.String? roomTypeID,
    $core.Iterable<$core.String>? roomSubTypeIds,
    $core.String? owner,
    $core.int? maxPlayer,
    $fixnum.Int64? createTime,
    $core.int? curPlayer,
    RoomStatus? status,
    $core.String? deviceUUID,
    $core.String? announcement,
    $core.String? avatar,
    $fixnum.Int64? updateTime,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (roomTypeID != null) {
      $result.roomTypeID = roomTypeID;
    }
    if (roomSubTypeIds != null) {
      $result.roomSubTypeIds.addAll(roomSubTypeIds);
    }
    if (owner != null) {
      $result.owner = owner;
    }
    if (maxPlayer != null) {
      $result.maxPlayer = maxPlayer;
    }
    if (createTime != null) {
      $result.createTime = createTime;
    }
    if (curPlayer != null) {
      $result.curPlayer = curPlayer;
    }
    if (status != null) {
      $result.status = status;
    }
    if (deviceUUID != null) {
      $result.deviceUUID = deviceUUID;
    }
    if (announcement != null) {
      $result.announcement = announcement;
    }
    if (avatar != null) {
      $result.avatar = avatar;
    }
    if (updateTime != null) {
      $result.updateTime = updateTime;
    }
    return $result;
  }
  RoomData._() : super();
  factory RoomData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomData', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'roomTypeID', protoName: 'roomTypeID')
    ..pPS(3, _omitFieldNames ? '' : 'roomSubTypeIds', protoName: 'roomSubTypeIds')
    ..aOS(4, _omitFieldNames ? '' : 'owner')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'maxPlayer', $pb.PbFieldType.O3, protoName: 'maxPlayer')
    ..aInt64(6, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'curPlayer', $pb.PbFieldType.O3, protoName: 'curPlayer')
    ..e<RoomStatus>(8, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: RoomStatus.All, valueOf: RoomStatus.valueOf, enumValues: RoomStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'deviceUUID', protoName: 'deviceUUID')
    ..aOS(10, _omitFieldNames ? '' : 'announcement')
    ..aOS(11, _omitFieldNames ? '' : 'avatar')
    ..aInt64(12, _omitFieldNames ? '' : 'updateTime', protoName: 'updateTime')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomData clone() => RoomData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomData copyWith(void Function(RoomData) updates) => super.copyWith((message) => updates(message as RoomData)) as RoomData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomData create() => RoomData._();
  RoomData createEmptyInstance() => create();
  static $pb.PbList<RoomData> createRepeated() => $pb.PbList<RoomData>();
  @$core.pragma('dart2js:noInline')
  static RoomData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomData>(create);
  static RoomData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomTypeID => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomTypeID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomTypeID() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomTypeID() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get roomSubTypeIds => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get owner => $_getSZ(3);
  @$pb.TagNumber(4)
  set owner($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOwner() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwner() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxPlayer => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxPlayer($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxPlayer() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxPlayer() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createTime => $_getI64(5);
  @$pb.TagNumber(6)
  set createTime($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCreateTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreateTime() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get curPlayer => $_getIZ(6);
  @$pb.TagNumber(7)
  set curPlayer($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCurPlayer() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurPlayer() => clearField(7);

  @$pb.TagNumber(8)
  RoomStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(RoomStatus v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get deviceUUID => $_getSZ(8);
  @$pb.TagNumber(9)
  set deviceUUID($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDeviceUUID() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeviceUUID() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get announcement => $_getSZ(9);
  @$pb.TagNumber(10)
  set announcement($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasAnnouncement() => $_has(9);
  @$pb.TagNumber(10)
  void clearAnnouncement() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get avatar => $_getSZ(10);
  @$pb.TagNumber(11)
  set avatar($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasAvatar() => $_has(10);
  @$pb.TagNumber(11)
  void clearAvatar() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get updateTime => $_getI64(11);
  @$pb.TagNumber(12)
  set updateTime($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasUpdateTime() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdateTime() => clearField(12);
}

class RoomListPageReqData extends $pb.GeneratedMessage {
  factory RoomListPageReqData({
    $core.String? typeID,
    $core.String? subTypeID,
    RoomStatus? status,
    RoomSortType? sort,
    $fixnum.Int64? pageNum,
  }) {
    final $result = create();
    if (typeID != null) {
      $result.typeID = typeID;
    }
    if (subTypeID != null) {
      $result.subTypeID = subTypeID;
    }
    if (status != null) {
      $result.status = status;
    }
    if (sort != null) {
      $result.sort = sort;
    }
    if (pageNum != null) {
      $result.pageNum = pageNum;
    }
    return $result;
  }
  RoomListPageReqData._() : super();
  factory RoomListPageReqData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomListPageReqData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomListPageReqData', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'typeID', protoName: 'typeID')
    ..aOS(2, _omitFieldNames ? '' : 'subTypeID', protoName: 'subTypeID')
    ..e<RoomStatus>(3, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: RoomStatus.All, valueOf: RoomStatus.valueOf, enumValues: RoomStatus.values)
    ..e<RoomSortType>(4, _omitFieldNames ? '' : 'sort', $pb.PbFieldType.OE, defaultOrMaker: RoomSortType.Default, valueOf: RoomSortType.valueOf, enumValues: RoomSortType.values)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'pageNum', $pb.PbFieldType.OU6, protoName: 'pageNum', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomListPageReqData clone() => RoomListPageReqData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomListPageReqData copyWith(void Function(RoomListPageReqData) updates) => super.copyWith((message) => updates(message as RoomListPageReqData)) as RoomListPageReqData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomListPageReqData create() => RoomListPageReqData._();
  RoomListPageReqData createEmptyInstance() => create();
  static $pb.PbList<RoomListPageReqData> createRepeated() => $pb.PbList<RoomListPageReqData>();
  @$core.pragma('dart2js:noInline')
  static RoomListPageReqData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomListPageReqData>(create);
  static RoomListPageReqData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get typeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set typeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTypeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearTypeID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get subTypeID => $_getSZ(1);
  @$pb.TagNumber(2)
  set subTypeID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSubTypeID() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubTypeID() => clearField(2);

  @$pb.TagNumber(3)
  RoomStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(RoomStatus v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);

  @$pb.TagNumber(4)
  RoomSortType get sort => $_getN(3);
  @$pb.TagNumber(4)
  set sort(RoomSortType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSort() => $_has(3);
  @$pb.TagNumber(4)
  void clearSort() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get pageNum => $_getI64(4);
  @$pb.TagNumber(5)
  set pageNum($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPageNum() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageNum() => clearField(5);
}

class RoomListData extends $pb.GeneratedMessage {
  factory RoomListData({
    BasePageRespData? pageData,
    $core.Iterable<RoomData>? rooms,
  }) {
    final $result = create();
    if (pageData != null) {
      $result.pageData = pageData;
    }
    if (rooms != null) {
      $result.rooms.addAll(rooms);
    }
    return $result;
  }
  RoomListData._() : super();
  factory RoomListData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomListData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomListData', createEmptyInstance: create)
    ..aOM<BasePageRespData>(1, _omitFieldNames ? '' : 'pageData', protoName: 'pageData', subBuilder: BasePageRespData.create)
    ..pc<RoomData>(2, _omitFieldNames ? '' : 'rooms', $pb.PbFieldType.PM, subBuilder: RoomData.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomListData clone() => RoomListData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomListData copyWith(void Function(RoomListData) updates) => super.copyWith((message) => updates(message as RoomListData)) as RoomListData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomListData create() => RoomListData._();
  RoomListData createEmptyInstance() => create();
  static $pb.PbList<RoomListData> createRepeated() => $pb.PbList<RoomListData>();
  @$core.pragma('dart2js:noInline')
  static RoomListData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomListData>(create);
  static RoomListData? _defaultInstance;

  @$pb.TagNumber(1)
  BasePageRespData get pageData => $_getN(0);
  @$pb.TagNumber(1)
  set pageData(BasePageRespData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPageData() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageData() => clearField(1);
  @$pb.TagNumber(1)
  BasePageRespData ensurePageData() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<RoomData> get rooms => $_getList(1);
}

class PreUser extends $pb.GeneratedMessage {
  factory PreUser({
    $core.String? userName,
    $core.String? deviceUUID,
    $core.String? roomID,
  }) {
    final $result = create();
    if (userName != null) {
      $result.userName = userName;
    }
    if (deviceUUID != null) {
      $result.deviceUUID = deviceUUID;
    }
    if (roomID != null) {
      $result.roomID = roomID;
    }
    return $result;
  }
  PreUser._() : super();
  factory PreUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PreUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PreUser', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userName', protoName: 'userName')
    ..aOS(2, _omitFieldNames ? '' : 'deviceUUID', protoName: 'deviceUUID')
    ..aOS(3, _omitFieldNames ? '' : 'roomID', protoName: 'roomID')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PreUser clone() => PreUser()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PreUser copyWith(void Function(PreUser) updates) => super.copyWith((message) => updates(message as PreUser)) as PreUser;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreUser create() => PreUser._();
  PreUser createEmptyInstance() => create();
  static $pb.PbList<PreUser> createRepeated() => $pb.PbList<PreUser>();
  @$core.pragma('dart2js:noInline')
  static PreUser getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreUser>(create);
  static PreUser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userName => $_getSZ(0);
  @$pb.TagNumber(1)
  set userName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserName() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceUUID => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceUUID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceUUID() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceUUID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get roomID => $_getSZ(2);
  @$pb.TagNumber(3)
  set roomID($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRoomID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomID() => clearField(3);
}

class RoomUserData extends $pb.GeneratedMessage {
  factory RoomUserData({
    $core.String? id,
    $core.String? playerName,
    $core.String? avatar,
    RoomUserStatus? status,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (playerName != null) {
      $result.playerName = playerName;
    }
    if (avatar != null) {
      $result.avatar = avatar;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  RoomUserData._() : super();
  factory RoomUserData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomUserData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomUserData', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'playerName', protoName: 'playerName')
    ..aOS(3, _omitFieldNames ? '' : 'Avatar', protoName: 'Avatar')
    ..e<RoomUserStatus>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: RoomUserStatus.RoomUserStatusJoin, valueOf: RoomUserStatus.valueOf, enumValues: RoomUserStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomUserData clone() => RoomUserData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomUserData copyWith(void Function(RoomUserData) updates) => super.copyWith((message) => updates(message as RoomUserData)) as RoomUserData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomUserData create() => RoomUserData._();
  RoomUserData createEmptyInstance() => create();
  static $pb.PbList<RoomUserData> createRepeated() => $pb.PbList<RoomUserData>();
  @$core.pragma('dart2js:noInline')
  static RoomUserData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomUserData>(create);
  static RoomUserData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get playerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set playerName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get avatar => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatar($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => clearField(3);

  @$pb.TagNumber(4)
  RoomUserStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(RoomUserStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);
}

class RoomUpdateMessage extends $pb.GeneratedMessage {
  factory RoomUpdateMessage({
    RoomData? roomData,
    $core.Iterable<RoomUserData>? usersData,
    RoomUpdateType? roomUpdateType,
  }) {
    final $result = create();
    if (roomData != null) {
      $result.roomData = roomData;
    }
    if (usersData != null) {
      $result.usersData.addAll(usersData);
    }
    if (roomUpdateType != null) {
      $result.roomUpdateType = roomUpdateType;
    }
    return $result;
  }
  RoomUpdateMessage._() : super();
  factory RoomUpdateMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomUpdateMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomUpdateMessage', createEmptyInstance: create)
    ..aOM<RoomData>(1, _omitFieldNames ? '' : 'roomData', protoName: 'roomData', subBuilder: RoomData.create)
    ..pc<RoomUserData>(2, _omitFieldNames ? '' : 'usersData', $pb.PbFieldType.PM, protoName: 'usersData', subBuilder: RoomUserData.create)
    ..e<RoomUpdateType>(3, _omitFieldNames ? '' : 'roomUpdateType', $pb.PbFieldType.OE, protoName: 'roomUpdateType', defaultOrMaker: RoomUpdateType.RoomUpdateData, valueOf: RoomUpdateType.valueOf, enumValues: RoomUpdateType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomUpdateMessage clone() => RoomUpdateMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomUpdateMessage copyWith(void Function(RoomUpdateMessage) updates) => super.copyWith((message) => updates(message as RoomUpdateMessage)) as RoomUpdateMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomUpdateMessage create() => RoomUpdateMessage._();
  RoomUpdateMessage createEmptyInstance() => create();
  static $pb.PbList<RoomUpdateMessage> createRepeated() => $pb.PbList<RoomUpdateMessage>();
  @$core.pragma('dart2js:noInline')
  static RoomUpdateMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomUpdateMessage>(create);
  static RoomUpdateMessage? _defaultInstance;

  @$pb.TagNumber(1)
  RoomData get roomData => $_getN(0);
  @$pb.TagNumber(1)
  set roomData(RoomData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomData() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomData() => clearField(1);
  @$pb.TagNumber(1)
  RoomData ensureRoomData() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<RoomUserData> get usersData => $_getList(1);

  @$pb.TagNumber(3)
  RoomUpdateType get roomUpdateType => $_getN(2);
  @$pb.TagNumber(3)
  set roomUpdateType(RoomUpdateType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRoomUpdateType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomUpdateType() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
