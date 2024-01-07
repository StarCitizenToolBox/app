import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/grpc/party_room_server.dart';

class PartyRoomHomeUIModel extends BaseUIModel {
  String? pingServerMessage;

  @override
  Future loadData() async {
    if (pingServerMessage != "") {
      pingServerMessage = null;
      notifyListeners();
    }
    await _pingServer();
  }

  _pingServer() async {
    try {
      final r = await PartyRoomGrpcServer.pingServer();
      dPrint(
          "[PartyRoomHomeUIModel] Connected! serverVersion ==> ${r.serverVersion}");
      pingServerMessage = "";
      notifyListeners();
    } catch (e) {
      pingServerMessage = "服务器连接失败，请稍后重试。\n$e";
      notifyListeners();
      return;
    }
  }
}
