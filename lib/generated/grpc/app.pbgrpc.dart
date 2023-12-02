//
//  Generated code. Do not modify.
//  source: app.proto
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

import 'app.pb.dart' as $0;

export 'app.pb.dart';

@$pb.GrpcServiceName('PingService')
class PingServiceClient extends $grpc.Client {
  static final _$pingServer = $grpc.ClientMethod<$0.PingRequest, $0.PingResult>(
      '/PingService/PingServer',
      ($0.PingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PingResult.fromBuffer(value));

  PingServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.PingResult> pingServer($0.PingRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$pingServer, request, options: options);
  }
}

@$pb.GrpcServiceName('PingService')
abstract class PingServiceBase extends $grpc.Service {
  $core.String get $name => 'PingService';

  PingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PingRequest, $0.PingResult>(
        'PingServer',
        pingServer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PingRequest.fromBuffer(value),
        ($0.PingResult value) => value.writeToBuffer()));
  }

  $async.Future<$0.PingResult> pingServer_Pre($grpc.ServiceCall call, $async.Future<$0.PingRequest> request) async {
    return pingServer(call, await request);
  }

  $async.Future<$0.PingResult> pingServer($grpc.ServiceCall call, $0.PingRequest request);
}
