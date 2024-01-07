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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
