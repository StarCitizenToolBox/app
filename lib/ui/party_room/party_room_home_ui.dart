import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pb.dart';

import 'party_room_home_ui_model.dart';

class PartyRoomHomeUI extends BaseUI<PartyRoomHomeUIModel> {
  @override
  Widget? buildBody(BuildContext context, PartyRoomHomeUIModel model) {
    if (model.pingServerMessage == null) return makeLoading(context);
    if (model.pingServerMessage!.isNotEmpty) {
      return Center(
        child: Text("${model.pingServerMessage}"),
      );
    }
    if (model.roomTypes == null) return makeLoading(context);
    return Column(
      children: [
        makeHeader(context, model),
      ],
    );
  }

  Widget makeHeader(BuildContext context, PartyRoomHomeUIModel model) {
    final subTypes = model.getCurRoomSubTypes();
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("房间类型："),
              SizedBox(
                  height: 36,
                  child: ComboBox<RoomType>(
                      value: model.selectedRoomType,
                      items: [
                        for (final t in model.roomTypes!.entries)
                          ComboBoxItem(
                            value: t.value,
                            child: Text(t.value.name),
                          )
                      ],
                      onChanged: model.onChangeRoomType)),
              if (subTypes != null) ...[
                const SizedBox(width: 24),
                const Text("子类型："),
                SizedBox(
                    height: 36,
                    child: ComboBox<RoomSubtype>(
                        value: model.selectedRoomSubType,
                        items: [
                          for (final t in subTypes.entries)
                            ComboBoxItem(
                              value: t.value,
                              child: Text(t.value.name),
                            )
                        ],
                        onChanged: model.onChangeRoomSubType)),
              ],
              const SizedBox(width: 24),
              const Text("房间状态："),
              SizedBox(
                  height: 36,
                  child: ComboBox<RoomStatus>(
                      value: model.selectedStatus,
                      items: [
                        for (final t in model.roomStatus.entries)
                          ComboBoxItem(
                            value: t.key,
                            child: Text(t.value),
                          )
                      ],
                      onChanged: model.onChangeRoomStatus)),
              const SizedBox(width: 24),
              const Text("排序："),
              SizedBox(
                  height: 36,
                  child: ComboBox<RoomSortType>(
                      value: model.selectedSortType,
                      items: [
                        for (final t in model.roomSorts.entries)
                          ComboBoxItem(
                            value: t.key,
                            child: Text(t.value),
                          )
                      ],
                      onChanged: model.onChangeRoomSort)),
              const Spacer(),
              Button(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(FluentIcons.refresh),
                ),
              ),
              const SizedBox(width: 12),
              Button(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Icon(FluentIcons.add),
                      SizedBox(width: 6),
                      Text("创建房间")
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            model.selectedRoomType?.desc ?? "",
            style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(.4)),
          ),
        ],
      ),
    );
  }

  @override
  String getUITitle(BuildContext context, PartyRoomHomeUIModel model) =>
      "PartyRoom";
}
