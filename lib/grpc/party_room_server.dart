import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pbgrpc.dart';

class PartyRoomGrpcServer {
  static const clientVersion = 0;
  static final _channel = ClientChannel(
    "127.0.0.1",
    port: 39399,
    options: ChannelOptions(
      credentials: const ChannelCredentials.insecure(),
      codecRegistry:
          CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );

  static final _indexService = IndexServiceClient(_channel);

  static Future<PingData> pingServer() async {
    final r = await _indexService.pingServer(PingData(
        data: "PING", clientVersion: Int64.parseInt(clientVersion.toString())));
    dPrint(r.writeToJson());
    return r;
  }
}
