import 'package:file_sizes/file_sizes.dart';
import 'package:intl/intl.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/io/aria2c.dart';

import 'downloads_ui_model.dart';

class DownloadsUI extends BaseUI<DownloadsUIModel> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  Widget? buildBody(BuildContext context, DownloadsUIModel model) {
    return makeDefaultPage(context, model,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                const Spacer(),
                const SizedBox(width: 24),
                const SizedBox(width: 12),
                for (final item in <MapEntry<String, IconData>, String>{
                  const MapEntry("settings", FluentIcons.settings): "限速设置",
                  if (model.tasks.isNotEmpty)
                    const MapEntry("pause_all", FluentIcons.pause): "全部暂停",
                  if (model.waitingTasks.isNotEmpty)
                    const MapEntry("resume_all", FluentIcons.download): "恢复全部",
                  if (model.tasks.isNotEmpty || model.waitingTasks.isNotEmpty)
                    const MapEntry("cancel_all", FluentIcons.cancel): "全部取消",
                }.entries)
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: Button(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Icon(item.key.value),
                              const SizedBox(width: 6),
                              Text(item.value),
                            ],
                          ),
                        ),
                        onPressed: () => model.onTapButton(item.key.key)),
                  ),
                const SizedBox(width: 12),
              ],
            ),
            if (model.getTasksLen() == 0)
              const Expanded(
                  child: Center(
                child: Text("无下载任务"),
              ))
            else
              Expanded(
                  child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final (task, type, isFirstType) = model.getTaskAndType(index);
                  final nt = DownloadsUIModel.getTaskTypeAndName(task);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isFirstType)
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  top: index == 0 ? 0 : 12,
                                  bottom: 12),
                              margin: const EdgeInsets.only(top: 6, bottom: 6),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Row(
                                    children: [
                                      Text(
                                        "${model.listHeaderStatusMap[type]}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 12, bottom: 12),
                        margin: const EdgeInsets.only(
                            left: 12, right: 12, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: FluentTheme.of(context)
                              .cardColor
                              .withOpacity(.06),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nt.value,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      "总大小：${FileSize.getSize(task.totalLength ?? 0)}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 12),
                                    if (nt.key == "torrent" &&
                                        task.verifiedLength != null &&
                                        task.verifiedLength != 0)
                                      Text(
                                        "校验中...（${FileSize.getSize(task.verifiedLength)}）",
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    else if (task.status == "active")
                                      Text(
                                          "下载中... (${((task.completedLength ?? 0) / (task.totalLength ?? 1)).toStringAsFixed(4)}%)")
                                    else
                                      Text(
                                        "状态：${model.statusMap[task.status]}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    const SizedBox(width: 24),
                                    if (task.status == "active" &&
                                        task.verifiedLength == null)
                                      Text(
                                          "ETA:  ${formatter.format(DateTime.now().add(Duration(seconds: model.getETA(task))))}"),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "已上传：${FileSize.getSize(task.uploadLength)}"),
                                Text(
                                    "已下载：${FileSize.getSize(task.completedLength)}"),
                              ],
                            ),
                            const SizedBox(width: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "↑：${FileSize.getSize(task.uploadSpeed)}/s"),
                                Text(
                                    "↓：${FileSize.getSize(task.downloadSpeed)}/s"),
                              ],
                            ),
                            const SizedBox(width: 32),
                            if (type != "stopped")
                              DropDownButton(
                                closeAfterClick: false,
                                title: const Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Text('选项'),
                                ),
                                items: [
                                  if (task.status == "paused")
                                    MenuFlyoutItem(
                                        leading:
                                            const Icon(FluentIcons.download),
                                        text: const Text('继续下载'),
                                        onPressed: () =>
                                            model.resumeTask(task.gid))
                                  else if (task.status == "active")
                                    MenuFlyoutItem(
                                        leading: const Icon(FluentIcons.pause),
                                        text: const Text('暂停下载'),
                                        onPressed: () =>
                                            model.pauseTask(task.gid)),
                                  const MenuFlyoutSeparator(),
                                  MenuFlyoutItem(
                                      leading: const Icon(
                                        FluentIcons.chrome_close,
                                        size: 14,
                                      ),
                                      text: const Text('取消下载'),
                                      onPressed: () =>
                                          model.cancelTask(task.gid)),
                                  MenuFlyoutItem(
                                      leading: const Icon(
                                        FluentIcons.folder_open,
                                        size: 14,
                                      ),
                                      text: const Text('打开文件夹'),
                                      onPressed: () => model.openFolder(task)),
                                ],
                              ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                itemCount: model.getTasksLen(),
              )),
            Container(
              color: FluentTheme.of(context).cardColor.withOpacity(.06),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 3, top: 3),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Aria2cManager.isAvailable
                            ? Colors.green
                            : Colors.white,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "下载： ${FileSize.getSize(model.globalStat?.downloadSpeed ?? 0)}/s    上传：${FileSize.getSize(model.globalStat?.uploadSpeed ?? 0)}/s",
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  String getUITitle(BuildContext context, DownloadsUIModel model) => "下载管理";
}
