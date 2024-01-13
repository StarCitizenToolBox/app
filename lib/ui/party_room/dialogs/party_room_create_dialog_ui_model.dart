import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pb.dart';
import 'package:starcitizen_doctor/global_ui_model.dart';
import 'package:starcitizen_doctor/grpc/party_room_server.dart';

class PartyRoomCreateDialogUIModel extends BaseUIModel {
  Map<String?, RoomType> roomTypes;

  RoomType? selectedRoomType;

  List<RoomSubtype> selectedSubType = [];

  PartyRoomCreateDialogUIModel(this.roomTypes);

  String? userName;

  bool isWorking = false;

  final playerMaxCtrl = TextEditingController(text: "8");
  final announcementCtrl = TextEditingController();

  @override
  initModel() {
    super.initModel();
    roomTypes.removeWhere((key, value) => key == "");
  }

  @override
  loadData() async {
    userName = await globalUIModel.getRunningGameUser();
    notifyListeners();
  }

  onBack() {
    if (isWorking) return null;
    return () {
      Navigator.pop(context!);
    };
  }

  void onChangeRoomType(RoomType? value) {
    selectedSubType = [];
    selectedRoomType = value;
    notifyListeners();
  }

  onTapSubType(RoomSubtype item) {
    if (!selectedSubType.contains(item)) {
      selectedSubType.add(item);
    } else {
      selectedSubType.remove(item);
    }
    notifyListeners();
  }

  onSubmit() {
    final maxPlayer = int.tryParse(playerMaxCtrl.text) ?? 0;
    if (selectedRoomType == null) return null;
    if (maxPlayer < 2 || maxPlayer > 32) return null;
    return () async {
      isWorking = true;
      notifyListeners();
      final room = await handleError(() => PartyRoomGrpcServer.createRoom(
          RoomData(
              roomTypeID: selectedRoomType?.id,
              roomSubTypeIds: [for (var value in selectedSubType) value.id],
              owner: userName,
              deviceUUID: AppConf.deviceUUID,
              maxPlayer: maxPlayer,
              announcement: announcementCtrl.text.trim())));
      isWorking = false;
      notifyListeners();
      if (room != null) {
        Navigator.pop(context!, room);
      }
    };
  }
}
