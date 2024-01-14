import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pb.dart';
import 'package:starcitizen_doctor/widgets/cache_image.dart';

import 'party_room_chat_ui_model.dart';

class PartyRoomChatUI extends BaseUI<PartyRoomChatUIModel> {
  @override
  Widget? buildBody(BuildContext context, PartyRoomChatUIModel model) {
    final roomData = model.serverResultRoomData;
    if (roomData == null) return makeLoading(context);
    final typesMap = model.partyRoomHomeUIModel.roomTypes;
    final title =
        "${roomData.owner} 的 ${typesMap?[roomData.roomTypeID]?.name ?? roomData.roomTypeID}房间";
    // final createTime =
    //     DateTime.fromMillisecondsSinceEpoch(roomData.createTime.toInt());

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.black.withOpacity(.25)),
          child: makeTitleBar(model, title, roomData),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 220,
                padding: const EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(color: Colors.black.withOpacity(.07)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    makeItemRow("玩家数量：",
                        "${model.playersMap?.length ?? 0} / ${roomData.maxPlayer}"),
                    const SizedBox(height: 12),
                    if (model.playersMap == null)
                      Expanded(child: makeLoading(context))
                    else
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            final item = model.playersMap!.entries
                                .elementAt(index)
                                .value;
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: CacheNetImage(
                                    url: item.avatar,
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(child: Text(item.playerName)),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 3, bottom: 3, left: 12, right: 12),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  child: Text(
                                    "${model.playerStatusMap[item.status] ?? item.status}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: model.playersMap!.length,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget makeItemRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 1),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white.withOpacity(.6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }

  Widget makeTitleBar(
      PartyRoomChatUIModel model, String title, RoomData roomData) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: CacheNetImage(
            url: roomData.avatar,
            width: 32,
            height: 32,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 12),
        Container(
            padding:
                const EdgeInsets.only(top: 3, bottom: 3, left: 12, right: 12),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(1000)),
            child: Text(
                "${model.partyRoomHomeUIModel.roomStatus[roomData.status]}")),
        const SizedBox(width: 12),
        const Spacer(),
        IconButton(
            icon: const Icon(
              FluentIcons.leave,
              size: 20,
            ),
            onPressed: () => model.onClose())
      ],
    );
  }

  @override
  String getUITitle(BuildContext context, PartyRoomChatUIModel model) => "Chat";
}
