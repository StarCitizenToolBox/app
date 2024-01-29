import 'package:file_sizes/file_sizes.dart';
import 'package:starcitizen_doctor/base/ui.dart';

import 'downloader_dialog_ui_model.dart';

class DownloaderDialogUI extends BaseUI<DownloaderDialogUIModel> {
  @override
  Widget? buildBody(BuildContext context, DownloaderDialogUIModel model) {
    return ContentDialog(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .54),
      title: const Text("文件下载..."),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("文件名：${model.fileName}"),
          const SizedBox(height: 6),
          Text("保存位置：${model.savePath}"),
          const SizedBox(height: 6),
          Text("线程数：${model.threadCount}"),
          const SizedBox(height: 6),
          Text(
              "文件大小： ${FileSize.getSize(model.count ?? 0)} / ${FileSize.getSize(model.total ?? 0)}"),
          const SizedBox(height: 6),
          Text("下载速度： ${FileSize.getSize(model.speed?.toInt() ?? 0)}/s"),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(getStatus(model)),
              const SizedBox(width: 24),
              Expanded(
                  child: ProgressBar(
                value: model.progress == 100 ? null : model.progress,
              )),
              const SizedBox(width: 24),
            ],
          ),
          if (model.isP4kDownload) ...[
            const SizedBox(height: 24),
            Text(
              "提示：因网络波动，若下载进度长时间卡住或速度变慢，可尝试点击暂停下载，之后重新点击P4K分流下载。",
              style:
                  TextStyle(fontSize: 13, color: Colors.white.withOpacity(.7)),
            ),
          ],
        ],
      ),
      actions: [
        FilledButton(
            child: const Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
              child: Text("暂停下载"),
            ),
            onPressed: () => model.doCancel()),
      ],
    );
  }

  @override
  String getUITitle(BuildContext context, DownloaderDialogUIModel model) => "";

  String getStatus(DownloaderDialogUIModel model) {
    if (model.progress == null && !model.isInMerging) return "准备中...";
    if (model.isInMerging) return "正在处理文件...";
    return "${model.progress?.toStringAsFixed(2) ?? "0"}%  ";
  }
}
