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
  }

  $async.Future<$0.PingData> pingServer_Pre($grpc.ServiceCall call, $async.Future<$0.PingData> request) async {
    return pingServer(call, await request);
  }

  $async.Future<$0.RoomTypesData> getRoomTypes_Pre($grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getRoomTypes(call, await request);
  }

  $async.Future<$0.PingData> pingServer($grpc.ServiceCall call, $0.PingData request);
  $async.Future<$0.RoomTypesData> getRoomTypes($grpc.ServiceCall call, $0.Empty request);
}
