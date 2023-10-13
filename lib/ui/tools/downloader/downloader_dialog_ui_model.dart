import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';

import 'dio_range_download.dart';

class DownloaderDialogUIModel extends BaseUIModel {
  final String fileName;
  String savePath;
  final String downloadUrl;
  final bool showChangeSavePathDialog;
  final int threadCount;

  DownloaderDialogUIModel(this.fileName, this.savePath, this.downloadUrl,
      {this.showChangeSavePathDialog = false, this.threadCount = 1});

  CancelToken? downloadCancelToken;

  int? downloadTaskId;

  bool isInMerging = false;

  double? progress;
  int? speed;
  DateTime? lastUpdateTime;
  int? lastUpdateCount;
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
    try {
      downloadCancelToken = CancelToken();
      final r = await RangeDownload.downloadWithChunks(downloadUrl, savePath,
          maxChunk: 10,
          cancelToken: downloadCancelToken,
          isRangeDownload: true, onReceiveProgress: (int count, int total) {
        lastUpdateTime ??= DateTime.now();
        if ((DateTime.now().difference(lastUpdateTime ?? DateTime.now()))
                .inSeconds >=
            1) {
          lastUpdateTime = DateTime.now();
          speed = (count - (lastUpdateCount ?? 0));
          lastUpdateCount = count;
          notifyListeners();
        }
        this.count = count;
        this.total = total;
        progress = count / total * 100;
        if (count == total) {
          isInMerging = true;
        }
        notifyListeners();
      });
      if (r.statusCode == 200) {
        Navigator.pop(context!, savePath);
      }
    } catch (e) {
      if (e is DioException && e.type != DioExceptionType.cancel) {
        if (mounted) showToast(context!, "下载失败：$e");
      }
    }
  }

  doCancel() {
    try {
      downloadCancelToken?.cancel();
      downloadCancelToken = null;
    } catch (_) {}
    Navigator.pop(context!, "cancel");
  }
}
