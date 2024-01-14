import 'package:fixnum/fixnum.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/common/grpc/party_room_server.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pb.dart';
import 'package:starcitizen_doctor/global_ui_model.dart';
import 'package:starcitizen_doctor/ui/party_room/dialogs/party_room_create_dialog_ui_model.dart';

import 'dialogs/party_room_create_dialog_ui.dart';
import 'party_room_chat_ui_model.dart';

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

  int pageNum = 0;

  List<RoomData>? rooms;

  final pageCtrl = PageController();

  @override
  void initModel() {
    super.initModel();
    _loadTypes();
    _touchUser();
  }

  @override
  BaseUIModel? onCreateChildUIModel(modelKey) {
    switch (modelKey) {
      case "chat":
        return PartyRoomChatUIModel(this);
    }
    return null;
  }

  @override
  Future loadData() async {
    if (pingServerMessage != "") {
      pingServerMessage = null;
      notifyListeners();
      await _pingServer();
    }
    await _loadPage();
  }

  @override
  reloadData() async {
    pageNum = 0;
    rooms = null;
    notifyListeners();
    _touchUser();
    return super.reloadData();
  }

  _loadPage() async {
    final r = await handleError(() => PartyRoomGrpcServer.getRoomList(
        RoomListPageReqData(
            pageNum: Int64.tryParseInt("$pageNum"),
            typeID: selectedRoomType?.id ?? "",
            subTypeID: selectedRoomSubType?.id ?? "",
            status: selectedStatus)));
    if (r == null) return;
    if (r.pageData.hasNext) {
      pageNum++;
    } else {
      pageNum = -1;
    }
    rooms = r.rooms;
    notifyListeners();
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

  Future<void> _loadTypes() async {
    final r = await handleError(() => PartyRoomGrpcServer.getRoomTypes());
    if (r == null) return;
    selectedRoomType =
        RoomType(id: "", name: "全部", desc: "查看所有类型的房间，寻找一起玩的伙伴。");
    selectedRoomSubType = RoomSubtype(id: "", name: "全部");
    roomTypes = {"": selectedRoomType!};
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
    final allSubType = RoomSubtype(id: "", name: "全部");
    selectedRoomSubType ??= allSubType;
    return {"all": allSubType}..addAll(types);
  }

  void onChangeRoomType(RoomType? value) {
    selectedRoomType = value;
    selectedRoomSubType = null;
    reloadData();
    notifyListeners();
  }

  void onChangeRoomStatus(RoomStatus? value) {
    if (value == null) return;
    selectedStatus = value;
    reloadData();
    notifyListeners();
  }

  void onChangeRoomSort(RoomSortType? value) {
    if (value == null) return;
    selectedSortType = value;
    reloadData();
    notifyListeners();
  }

  void onChangeRoomSubType(RoomSubtype? value) {
    if (value == null) return;
    selectedRoomSubType = value;
    reloadData();
    notifyListeners();
  }

  onCreateRoom() async {
    final room = await showDialog(
      context: context!,
      dismissWithEsc: false,
      builder: (BuildContext context) {
        return BaseUIContainer(
            uiCreate: () => PartyRoomCreateDialogUI(),
            modelCreate: () =>
                PartyRoomCreateDialogUIModel(Map.from(roomTypes!)));
      },
    );
    if (room == null) return;
    dPrint(room);
    reloadData();
  }

  onRefreshRoom() {
    reloadData();
  }

  Future<void> _touchUser() async {
    if (getCreatedChildUIModel<PartyRoomChatUIModel>("chat")?.selectRoom ==
        null) {
      final userName = await globalUIModel.getRunningGameUser();
      if (userName == null) return;
      // 检测用户已加入的房间
      final room = await handleError(() =>
          PartyRoomGrpcServer.touchUserRoom(userName, AppConf.deviceUUID));
      dPrint("touch room == ${room?.toProto3Json()}");
      if (room == null || room.id == "") return;
      onTapRoom(room);
    }
  }

  onTapRoom(RoomData item) {
    getCreatedChildUIModel<PartyRoomChatUIModel>("chat", create: true)
        ?.setRoom(item);
    notifyListeners();
    pageCtrl.animateToPage(1,
        duration: const Duration(milliseconds: 100), curve: Curves.easeInExpo);
  }

  void checkUIInit() {
    if (getCreatedChildUIModel<PartyRoomChatUIModel>("chat")?.selectRoom !=
        null) {
      pageCtrl.jumpToPage(1);
    }
  }
}
