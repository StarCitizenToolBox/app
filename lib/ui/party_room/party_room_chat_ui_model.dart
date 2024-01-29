import 'package:grpc/grpc.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/common/grpc/party_room_server.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pb.dart';
import 'package:starcitizen_doctor/global_ui_model.dart';

import 'party_room_home_ui_model.dart';

class PartyRoomChatUIModel extends BaseUIModel {
  PartyRoomHomeUIModel partyRoomHomeUIModel;

  PartyRoomChatUIModel(this.partyRoomHomeUIModel);

  RoomData? selectRoom;

  RoomData? serverResultRoomData;

  ResponseStream<RoomUpdateMessage>? roomStream;

  Map<String, RoomUserData>? playersMap;

  setRoom(RoomData? selectRoom) {
    if (this.selectRoom == null) {
      this.selectRoom = selectRoom;
      notifyListeners();
      loadRoom();
    }
    notifyListeners();
  }

  final playerStatusMap = {
    RoomUserStatus.RoomUserStatusJoin: "在线",
    RoomUserStatus.RoomUserStatusLostOffline: "离线",
    RoomUserStatus.RoomUserStatusLeave: "已离开",
    RoomUserStatus.RoomUserStatusWaitingConnect: "正在连接...",
  };

  onClose() async {
    final ok = await showConfirmDialogs(
        context!, "确认离开房间？", const Text("离开房间后，您的位置将被释放。"));
    if (ok == true) {
      partyRoomHomeUIModel.pageCtrl.animateToPage(0,
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeInOutSine);
      disposeRoom();
    }
  }

  loadRoom() async {
    if (selectRoom == null) return;
    final userName = await globalUIModel.getRunningGameUser();
    if (userName == null) return;
    roomStream = PartyRoomGrpcServer.joinRoom(
        selectRoom!.id, userName, AppConf.deviceUUID);
    roomStream!.listen((value) {
      dPrint("PartyRoomChatUIModel.roomStream.listen === $value");
      if (value.roomUpdateType == RoomUpdateType.RoomClose) {
      } else if (value.roomUpdateType == RoomUpdateType.RoomUpdateData) {
        if (value.hasRoomData()) {
          serverResultRoomData = value.roomData;
        }
        if (value.usersData.isNotEmpty) {
          _updatePlayerList(value.usersData);
        }
        notifyListeners();
      }
    })
      ..onError((err) {
        // showToast(context!, "连接到服务器出现错误：$err");
        dPrint("PartyRoomChatUIModel.roomStream  onError $err");
      })
      ..onDone(() {
        // showToast(context!, "房间已关闭");
        dPrint("PartyRoomChatUIModel.roomStream  onDone");
      });
  }

  disposeRoom() {
    selectRoom = null;
    roomStream?.cancel();
    roomStream = null;
    notifyListeners();
  }

  void _updatePlayerList(List<RoomUserData> usersData) {
    playersMap ??= {};
    for (var element in usersData) {
      playersMap![element.playerName] = element;
    }
    notifyListeners();
  }
}
