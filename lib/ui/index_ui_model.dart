import 'dart:io';

import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/global_ui_model.dart';
import 'package:starcitizen_doctor/ui/about/about_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui_model.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IndexUIModel extends BaseUIModel {
  int curIndex = 0;

  @override
  void initModel() {
    _checkRunTime();
    Future.delayed(const Duration(milliseconds: 300))
        .then((value) => globalUIModel.checkUpdate(context!));
    super.initModel();
  }

  @override
  BaseUIModel? onCreateChildUIModel(modelKey) {
    switch (modelKey) {
      case "home":
        return HomeUIModel();
      case "tools":
        return ToolsUIModel();
      case "settings":
        return SettingUIModel();
      case "about":
        return AboutUIModel();
    }
    return null;
  }

  void onIndexMenuTap(String value) {
    final index = {
      "首页": 0,
      "工具": 1,
      "设置": 2,
      "关于": 3,
    };
    curIndex = index[value] ?? 0;
    switch (curIndex) {
      case 0:
        getCreatedChildUIModel("home")?.reloadData();
        break;
      case 1:
        getCreatedChildUIModel("tools")?.reloadData();
        break;
    }
    notifyListeners();
  }

  Future<void> _checkRunTime() async {
    Future<void> onError() async {
      await showToast(context!, "运行环境出错，请检查系统环境变量 （PATH）！");
      await launchUrlString(
          "https://answers.microsoft.com/zh-hans/windows/forum/all/%E7%B3%BB%E7%BB%9F%E7%8E%AF%E5%A2%83%E5%8F%98/b88369e6-2620-4a77-b07a-d0af50894a07");
      await AnalyticsApi.touch("error_powershell");
      exit(0);
    }

    try {
      var result = await Process.run(SystemHelper.powershellPath, ["echo", "ping"]);
      if (result.stdout.toString().startsWith("ping")) {
        dPrint("powershell check pass");
      } else {
        onError();
      }
    } catch (e) {
      onError();
    }
  }
}
