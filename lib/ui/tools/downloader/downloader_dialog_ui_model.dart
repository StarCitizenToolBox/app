import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/rust/ffi.dart';

class DownloaderDialogUIModel extends BaseUIModel {
  final String fileName;
  String savePath;
  final String downloadUrl;
  final bool showChangeSavePathDialog;
  final int threadCount;

  DownloaderDialogUIModel(this.fileName, this.savePath, this.downloadUrl,
      {this.showChangeSavePathDialog = false, this.threadCount = 1});

  bool isInMerging = false;

  String? downloadTaskId;

  double? progress;
  int? speed;
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
    }

    if (savePath.endsWith("\\$fileName")) {
      savePath = savePath.substring(0, savePath.length - fileName.length - 1);
    }

    final downloaderSavePath = "$savePath//$fileName.downloading";

    try {
      rustFii
          .startDownload(
              url: downloadUrl,
              savePath: savePath,
              fileName: "$fileName.downloading",
              connectionCount: 10)
          .listen((event) async {
        dPrint(
            "id == ${event.id} p ==${event.progress} t==${event.total} s==${event.speed} st==${event.status}");

        downloadTaskId = event.id;
        count = event.progress;
        if (event.total != 0) {
          total = event.total;
        }
        speed = event.speed;
        if (total != null && total != 0 && event.progress != 0) {
          progress = (event.progress / total!) * 100;
        }
        notifyListeners();

        if (progress != null &&
            progress != 0 &&
            event.status == const MyDownloaderStatus.noStart()) {
          Navigator.pop(context!, "cancel");
          return;
        }

        if (event.status == const MyDownloaderStatus.finished()) {
          count = total;
          isInMerging = true;
          notifyListeners();
          await File(downloaderSavePath)
              .rename(downloaderSavePath.replaceAll(".downloading", ""));
          final bsonFile = File("$downloaderSavePath.bson");
          if (await bsonFile.exists()) {
            bsonFile.delete();
          }
          Navigator.pop(context!, "$savePath\\$fileName");
        }
      });
    } catch (e) {
      Navigator.pop(context!, e);
    }
  }

  doCancel() {
    try {
      if (downloadTaskId != null) {
        rustFii.cancelDownload(id: downloadTaskId!);
        downloadTaskId = null;
      } else {
        Navigator.pop(context!, "cancel");
      }
    } catch (_) {}
  }
}
