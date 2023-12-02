import 'package:starcitizen_doctor/common/grpc/grpc.dart';
import 'package:starcitizen_doctor/generated/grpc/app.pbgrpc.dart';

import '../common/utils/base_utils.dart';

class GrpcApi {
  static final _pingClient = PingServiceClient(GrpcClient.channel);

  static Future pingServer() async {
    try {
      final result = await _pingClient.pingServer(PingRequest(name: "ping"));
      if (result.pong == "pong") {
        dPrint("[GrpcApi] gRPC service Connected");
        return;
      }
    } catch (e) {
      dPrint("[GrpcApi] pingServer Error: $e");
    }
  }
}
