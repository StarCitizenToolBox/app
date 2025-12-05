import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:starcitizen_doctor/common/rust/api/downloader_api.dart';

import 'home_downloader_ui_model.dart';

class HomeDownloaderUI extends HookConsumerWidget {
  const HomeDownloaderUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeDownloaderUIModelProvider);
    final model = ref.read(homeDownloaderUIModelProvider.notifier);

    return makeDefaultPage(
      context,
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
                const MapEntry("settings", FluentIcons.settings): S.current.downloader_speed_limit_settings,
                if (state.activeTasks.isNotEmpty)
                  const MapEntry("pause_all", FluentIcons.pause): S.current.downloader_action_pause_all,
                if (state.waitingTasks.isNotEmpty)
                  const MapEntry("resume_all", FluentIcons.download): S.current.downloader_action_resume_all,
                if (state.activeTasks.isNotEmpty || state.waitingTasks.isNotEmpty)
                  const MapEntry("cancel_all", FluentIcons.cancel): S.current.downloader_action_cancel_all,
              }.entries)
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Button(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(children: [Icon(item.key.value), const SizedBox(width: 6), Text(item.value)]),
                    ),
                    onPressed: () => model.onTapButton(context, item.key.key),
                  ),
                ),
              const SizedBox(width: 12),
            ],
          ),
          if (model.getTasksLen() == 0)
            Expanded(child: Center(child: Text(S.current.downloader_info_no_download_tasks)))
          else
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final (task, type, isFirstType) = model.getTaskAndType(index);
                  final nt = HomeDownloaderUIModel.getTaskTypeAndName(task);
                  final statusStr = model.getStatusString(task.status);
                  final isActive = task.status == DownloadTaskStatus.live;
                  final isPaused = task.status == DownloadTaskStatus.paused;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isFirstType)
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 24, right: 24, top: index == 0 ? 0 : 12, bottom: 12),
                              margin: const EdgeInsets.only(top: 6, bottom: 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "${model.listHeaderStatusMap[type]}",
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      Container(
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: FluentTheme.of(context).cardColor.withValues(alpha: .06),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nt.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      S.current.downloader_info_total_size(FileSize.getSize(task.totalBytes.toInt())),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 12),
                                    if (isActive)
                                      Text(
                                        S.current.downloader_info_downloading((task.progress * 100).toStringAsFixed(2)),
                                      )
                                    else
                                      Text(S.current.downloader_info_status(model.statusMap[statusStr] ?? "Unknown")),
                                    const SizedBox(width: 24),
                                    if (isActive)
                                      Text(
                                        "ETA:  ${model.formatter.format(DateTime.now().add(Duration(seconds: model.getETA(task))))}",
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.current.downloader_info_uploaded(FileSize.getSize(task.uploadedBytes.toInt()))),
                                Text(
                                  S.current.downloader_info_downloaded(FileSize.getSize(task.downloadedBytes.toInt())),
                                ),
                              ],
                            ),
                            const SizedBox(width: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("↑：${FileSize.getSize(task.uploadSpeed.toInt())}/s"),
                                Text("↓：${FileSize.getSize(task.downloadSpeed.toInt())}/s"),
                              ],
                            ),
                            const SizedBox(width: 32),
                            if (type != "stopped")
                              DropDownButton(
                                closeAfterClick: false,
                                title: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Text(S.current.downloader_action_options),
                                ),
                                items: [
                                  if (isPaused)
                                    MenuFlyoutItem(
                                      leading: const Icon(FluentIcons.download),
                                      text: Text(S.current.downloader_action_continue_download),
                                      onPressed: () => model.resumeTask(task.id.toInt()),
                                    )
                                  else if (isActive)
                                    MenuFlyoutItem(
                                      leading: const Icon(FluentIcons.pause),
                                      text: Text(S.current.downloader_action_pause_download),
                                      onPressed: () => model.pauseTask(task.id.toInt()),
                                    ),
                                  const MenuFlyoutSeparator(),
                                  MenuFlyoutItem(
                                    leading: const Icon(FluentIcons.chrome_close, size: 14),
                                    text: Text(S.current.downloader_action_cancel_download),
                                    onPressed: () => model.cancelTask(context, task.id.toInt()),
                                  ),
                                  MenuFlyoutItem(
                                    leading: const Icon(FluentIcons.folder_open, size: 14),
                                    text: Text(S.current.action_open_folder),
                                    onPressed: () => model.openFolder(task),
                                  ),
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
              ),
            ),
          Container(
            color: FluentTheme.of(context).cardColor.withValues(alpha: .06),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 3, top: 3),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: state.isAvailable ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    S.current.downloader_info_download_upload_speed(
                      FileSize.getSize((state.globalStat?.downloadSpeed ?? BigInt.zero).toInt()),
                      FileSize.getSize((state.globalStat?.uploadSpeed ?? BigInt.zero).toInt()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      useBodyContainer: true,
    );
  }
}
