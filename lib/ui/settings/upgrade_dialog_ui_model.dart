import 'dart:io';

import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';

class UpgradeDialogUIModel extends BaseUIModel {
  String? description;
  String downloadUrl = "";

  bool isUpgrading = false;

  double? progress;

  @override
  Future loadData() async {
    // get download url for gitlab release
    try {
      final r = await Api.getAppReleaseDataByVersionName(
          AppConf.networkVersionData!.lastVersion!);
      description = r["description"];
      final assetsLinks = List.of(r["assets"]?["links"] ?? []);
      for (var link in assetsLinks) {
        if (link["name"].toString().contains("SETUP.exe")) {
          downloadUrl = link["direct_asset_url"];
          break;
        }
      }
      notifyListeners();
    } catch (e) {
      Navigator.pop(context!, false);
    }
  }

  doUpgrade() async {
    isUpgrading = true;
    notifyListeners();
    final fileName = "${AppConf.getUpgradePath()}/next_SETUP.exe";
    try {
      await Dio().download(downloadUrl, fileName,
          onReceiveProgress: (int count, int total) {
        progress = (count / total) * 100;
        notifyListeners();
      });
    } catch (_) {
      isUpgrading = false;
      progress = null;
      showToast(context!, "下载失败，请尝试手动安装！");
      notifyListeners();
      return;
    }

    try {
      final r =
          await (Process.run("powershell", ["start", fileName, "/SILENT"]));
      if (r.stderr.toString().isNotEmpty) {
        throw r.stderr;
      }
      exit(0);
    } catch (_) {
      isUpgrading = false;
      progress = null;
      showToast(context!, "运行失败，请尝试手动安装！");
      Process.run("powershell.exe", ["explorer.exe", "/select,\"$fileName\""]);
      notifyListeners();
    }
  }

  void doCancel() {
    Navigator.pop(context!, true);
  }
}
