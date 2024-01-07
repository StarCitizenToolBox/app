import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pb.dart';
import 'package:starcitizen_doctor/grpc/party_room_server.dart';

class PartyRoomHomeUIModel extends BaseUIModel {
  String? pingServerMessage;

  Map<String?, RoomType>? roomTypes;

  RoomType? selectedRoomType;

  RoomSubtype? selectedRoomSubType;

  final roomStatus = <RoomStatus, String>{
    RoomStatus.All: "全部",
    RoomStatus.Open: "开启中",
    RoomStatus.Full: "已满员",
    RoomStatus.Closed: "已封闭",
    RoomStatus.WillOffline: "房主离线",
    RoomStatus.Offline: "已离线",
  };

  RoomStatus selectedStatus = RoomStatus.All;

  final roomSorts = <RoomSortType, String>{
    RoomSortType.Default: "默认",
    RoomSortType.MostPlayerNumber: "最多玩家",
    RoomSortType.MinimumPlayerNumber: "最少玩家",
    RoomSortType.RecentlyCreated: "最近创建",
    RoomSortType.OldestCreated: "最久创建",
  };

  RoomSortType selectedSortType = RoomSortType.Default;

  @override
  Future loadData() async {
    if (pingServerMessage != "") {
      pingServerMessage = null;
      notifyListeners();
    }
    await _pingServer();
    await _loadTypes();
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

  _loadTypes() async {
    final r = await handleError(() => PartyRoomGrpcServer.getRoomTypes());
    if (r == null) return;
    selectedRoomType =
        RoomType(id: null, name: "全部", desc: "查看所有类型的房间，寻找一起玩的伙伴。");
    selectedRoomSubType = RoomSubtype(id: "all", name: "全部");
    roomTypes = {null: selectedRoomType!};
    for (var element in r.roomTypes) {
      roomTypes![element.id] = element;
    }
    notifyListeners();
  }

  Map<String, RoomSubtype>? getCurRoomSubTypes() {
    if (selectedRoomType?.subTypes == null) return null;
    Map<String, RoomSubtype> types = {};
    for (var element in selectedRoomType!.subTypes) {
      types[element.id] = element;
    }
    if (types.isEmpty) return null;
    final allSubType = RoomSubtype(id: "all", name: "全部");
    selectedRoomSubType ??= allSubType;
    return {"all": allSubType}..addAll(types);
  }

  void onChangeRoomType(RoomType? value) {
    selectedRoomType = value;
    selectedRoomSubType = null;
    notifyListeners();
  }

  void onChangeRoomStatus(RoomStatus? value) {
    if (value == null) return;
    selectedStatus = value;
    notifyListeners();
  }

  void onChangeRoomSort(RoomSortType? value) {
    if (value == null) return;
    selectedSortType = value;
    notifyListeners();
  }

  void onChangeRoomSubType(RoomSubtype? value) {
    if (value == null) return;
    selectedRoomSubType = value;
    notifyListeners();
  }
}
