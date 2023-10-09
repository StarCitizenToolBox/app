import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hyper_thread_downloader/hyper_thread_downloader.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';

class DownloaderDialogUIModel extends BaseUIModel {
  final String fileName;
  String savePath;
  final String downloadUrl;
  final bool showChangeSavePathDialog;
  final int threadCount;

  DownloaderDialogUIModel(this.fileName, this.savePath, this.downloadUrl,
      {this.showChangeSavePathDialog = false, this.threadCount = 1});

  final downloader = HyperDownload();

  int? downloadTaskId;

  bool isInMerging = false;

  double? progress;
  double? speed;
  double? remainTime;
  int? count;
  int? total;

  @override
  void initModel() {
    super.initModel();
    _initDownload();
  }

  _initDownload() async {
    if (showChangeSavePathDialog) {
      final userSelect = await FilePicker.platform.saveFile(
          initialDirectory: savePath,
          fileName: fileName,
          lockParentWindow: true);
      if (userSelect == null) {
        Navigator.pop(context!);
        return;
      }
      final f = File(userSelect);
      if (await f.exists()) {
        await f.delete();
      }
      savePath = userSelect;
      dPrint(savePath);
      notifyListeners();
    } else {
      savePath = "$savePath/$fileName";
    }
    // start download
    downloader.startDownload(
        url: downloadUrl,
        savePath: savePath,
        threadCount: threadCount,
        prepareWorking: (bool done) {},
        workingMerge: (bool done) {
          isInMerging = true;
          progress = null;
          notifyListeners();
        },
        downloadProgress: ({
          required double progress,
          required double speed,
          required double remainTime,
          required int count,
          required int total,
        }) {
          this.progress = ((progress) * 100);
          this.speed = speed;
          this.remainTime = remainTime;
          this.count = count;
          this.total = total;
          notifyListeners();
        },
        downloadComplete: () {
          notifyListeners();
          Navigator.pop(context!, savePath);
        },
        downloadFailed: (String reason) {
          notifyListeners();
          showToast(context!, "下载失败！ $reason");
        },
        downloadTaskId: (int id) {
          downloadTaskId = id;
        },
        downloadingLog: (String log) {});
  }

  doCancel() {
    if (downloadTaskId != null) {
      downloader.stopDownload(id: downloadTaskId!);
    }
    Navigator.pop(context!, "cancel");
  }
}
