import 'dart:io';

import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpgradeDialogUIModel extends BaseUIModel {
  String? description;
  String targetVersion = "";
  String downloadUrl = "";

  bool isUpgrading = false;

  double? progress;

  @override
  Future loadData() async {
    // get download url for gitlab release
    try {
      targetVersion = AppConf.isMSE
          ? AppConf.networkVersionData!.mSELastVersion!
          : AppConf.networkVersionData!.lastVersion!;
      final r = await Api.getAppReleaseDataByVersionName(targetVersion);
      description = r["body"];
      final assets = List.of(r["assets"] ?? []);
      for (var asset in assets) {
        if (asset["name"].toString().endsWith("SETUP.exe")) {
          downloadUrl = asset["browser_download_url"];
        }
      }
      notifyListeners();
    } catch (e) {
      Navigator.pop(context!, false);
    }
  }

  doUpgrade() async {
    if (AppConf.isMSE) {
      launchUrlString("ms-windows-store://pdp/?productid=9NF3SWFWNKL1");
      await Future.delayed(const Duration(seconds: 3));
      exit(0);
    }
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
      final r = await (Process.run(
          SystemHelper.powershellPath, ["start", fileName, "/SILENT"]));
      if (r.stderr.toString().isNotEmpty) {
        throw r.stderr;
      }
      exit(0);
    } catch (_) {
      isUpgrading = false;
      progress = null;
      showToast(context!, "运行失败，请尝试手动安装！");
      Process.run(SystemHelper.powershellPath,
          ["explorer.exe", "/select,\"$fileName\""]);
      notifyListeners();
    }
  }

  void doCancel() {
    Navigator.pop(context!, true);
  }
}
