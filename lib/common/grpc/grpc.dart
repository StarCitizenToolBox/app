import 'package:grpc/grpc.dart';
import 'package:starcitizen_doctor/common/conf.dart';

class GrpcClient {
  static final channel = ClientChannel(
    'grpc.sctoolbox.xkeyc.com',
    port: 8439,
    options: ChannelOptions(
      credentials: ChannelCredentials.secure(
        certificates: AppConf.certData,
        authority: 'grpc.sctoolbox.fake.bilibili.com',
      ),
      codecRegistry:
          CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    ),
  );
}
