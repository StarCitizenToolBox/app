import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pb.dart';
import 'package:starcitizen_doctor/widgets/cache_image.dart';

import 'party_room_home_ui_model.dart';

class PartyRoomHomeUI extends BaseUI<PartyRoomHomeUIModel> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 16)).then((_) {
      ref.watch(provider).checkUIInit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final model = ref.watch(provider);
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("敬请期待！"),
        ],
      ),
    );
    // return PageView(
    //   controller: model.pageCtrl,
    //   physics: const NeverScrollableScrollPhysics(),
    //   children: [
    //     super.build(context),
    //     BaseUIContainer(
    //         uiCreate: () => PartyRoomChatUI(),
    //         modelCreate: () =>
    //             model.getChildUIModelProviders<PartyRoomChatUIModel>("chat"))
    //   ],
    // );
  }

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
        if (model.rooms == null)
          Expanded(child: makeLoading(context))
        else if (model.rooms!.isEmpty)
          const Expanded(
              child: Center(
            child: Text("没有符合条件的房间！"),
          ))
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: AlignedGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                itemCount: model.rooms!.length,
                itemBuilder: (context, index) {
                  return makeRoomItemWidget(context, model, index);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget makeRoomItemWidget(
    BuildContext context,
    PartyRoomHomeUIModel model,
    int index,
  ) {
    final item = model.rooms![index];
    final itemType = model.roomTypes?[item.roomTypeID];
    final itemSubTypes = {
      for (var t in itemType?.subTypes ?? <RoomSubtype>[]) t.id: t
    };
    final createTime =
        DateTime.fromMillisecondsSinceEpoch(item.createTime.toInt());
    return Tilt(
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            image: DecorationImage(
                image: ExtendedNetworkImageProvider(item.avatar, cache: true),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.4),
            borderRadius: BorderRadius.circular(13),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 12, bottom: 12),
                child: GestureDetector(
                  onTap: () => model.onTapRoom(item),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${itemType?.name ?? item.roomTypeID}房间",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 16),
                          Container(
                              padding: const EdgeInsets.only(
                                  top: 3, bottom: 3, left: 12, right: 12),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(1000)),
                              child: Text("${model.roomStatus[item.status]}")),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                makeItemRow("房主：", item.owner),
                                makeItemRow("玩家数量：",
                                    "${item.curPlayer} / ${item.maxPlayer}"),
                                makeItemRow("创建时间：", "${createTime.toLocal()}"),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: CacheNetImage(
                              url: item.avatar,
                              width: 64,
                              height: 64,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var value in item.roomSubTypeIds)
                              makeSubTypeTag(value, model, itemSubTypes),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeSubTypeTag(String id, PartyRoomHomeUIModel model,
      Map<String, RoomSubtype> itemSubTypes) {
    final name = itemSubTypes[id]?.name ?? id;
    final color = generateColorFromSeed(name).withOpacity(.6);
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
      margin: const EdgeInsets.only(right: 6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(
        name,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Color generateColorFromSeed(String seed) {
    int hash = utf8
        .encode(seed)
        .fold(0, (previousValue, element) => 31 * previousValue + element);
    Random random = Random(hash);
    return Color.fromARGB(
        255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
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
                onPressed: model.onRefreshRoom,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(FluentIcons.refresh),
                ),
              ),
              const SizedBox(width: 12),
              Button(
                onPressed: () => model.onCreateRoom(),
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
