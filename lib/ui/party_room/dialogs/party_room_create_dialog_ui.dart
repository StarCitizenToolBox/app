import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/generated/grpc/party_room_server/index.pb.dart';

import 'party_room_create_dialog_ui_model.dart';

class PartyRoomCreateDialogUI extends BaseUI<PartyRoomCreateDialogUIModel> {
  @override
  Widget? buildBody(BuildContext context, PartyRoomCreateDialogUIModel model) {
    return ContentDialog(
      title: makeTitle(context, model),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
      content: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (model.userName == null) ...[
                SizedBox(
                  height: 200,
                  child: makeLoading(context),
                )
              ] else ...[
                Row(
                  children: [
                    const Text("请选择一种玩法"),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                          height: 36,
                          child: ComboBox<RoomType>(
                              value: model.selectedRoomType,
                              items: [
                                for (final t in model.roomTypes.entries)
                                  ComboBoxItem(
                                    value: t.value,
                                    child: Text(t.value.name),
                                  )
                              ],
                              onChanged: model.onChangeRoomType)),
                    )
                  ],
                ),
                if (model.selectedRoomType != null &&
                    (model.selectedRoomType?.subTypes.isNotEmpty ?? false))
                  ...makeSubTypeSelectWidgets(context, model),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text("游戏用户名（自动获取）"),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormBox(
                        initialValue: model.userName,
                        enabled: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text("最大玩家数（2 ~ 32）"),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormBox(
                        controller: model.playerMaxCtrl,
                        onChanged: (_) => model.notifyListeners(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("公告（可选）"),
                const SizedBox(height: 12),
                TextFormBox(
                  controller: model.announcementCtrl,
                  maxLines: 5,
                  placeholder: "可编写 任务简报，集合地点，船只要求，活动规则等，公告将会自动发送给进入房间的玩家。",
                  placeholderStyle:
                      TextStyle(color: Colors.white.withOpacity(.4)),
                ),
                const SizedBox(height: 32),
                for (var v in [
                  "创建房间后，其他玩家可以在大厅首页看到您的房间和您选择的玩法，当一个玩家选择加入房间时，你们将可以互相看到对方的用户名。当房间人数达到最大玩家数时，将不再接受新的玩家加入。",
                  "这是《SC汉化盒子》提供的公益服务，请勿滥用，我们保留拒绝服务的权力。"
                ]) ...[
                  Text(
                    v,
                    style: TextStyle(
                        fontSize: 14, color: Colors.white.withOpacity(.6)),
                  ),
                  const SizedBox(height: 6),
                ],
              ]
            ],
          ),
        ),
      ),
      actions: [
        if (model.isWorking)
          const ProgressRing()
        else
          FilledButton(
              onPressed: model.onSubmit(),
              child: const Padding(
                padding: EdgeInsets.all(3),
                child: Text("创建房间"),
              ))
      ],
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

  List<Widget> makeSubTypeSelectWidgets(
      BuildContext context, PartyRoomCreateDialogUIModel model) {
    bool isItemSelected(RoomSubtype subtype) {
      return model.selectedSubType.contains(subtype);
    }

    return [
      const SizedBox(height: 24),
      const Text("标签（可选）"),
      const SizedBox(height: 12),
      Row(
        children: [
          for (var item in model.selectedRoomType!.subTypes)
            Container(
              decoration: BoxDecoration(
                  color: isItemSelected(item)
                      ? generateColorFromSeed(item.name).withOpacity(.4)
                      : FluentTheme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(1000)),
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
              margin: const EdgeInsets.only(right: 12),
              child: IconButton(
                  icon: Row(
                    children: [
                      Icon(isItemSelected(item)
                          ? FluentIcons.check_mark
                          : FluentIcons.add),
                      const SizedBox(width: 12),
                      Text(
                        item.name,
                        style: TextStyle(
                            fontSize: 13,
                            color: isItemSelected(item)
                                ? null
                                : Colors.white.withOpacity(.4)),
                      ),
                    ],
                  ),
                  onPressed: () => model.onTapSubType(item)),
            )
        ],
      )
    ];
  }

  Widget makeTitle(BuildContext context, PartyRoomCreateDialogUIModel model) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(
              FluentIcons.back,
              size: 22,
            ),
            onPressed: model.onBack()),
        const SizedBox(width: 12),
        Text(getUITitle(context, model)),
      ],
    );
  }

  @override
  String getUITitle(BuildContext context, PartyRoomCreateDialogUIModel model) =>
      "创建房间";
}
