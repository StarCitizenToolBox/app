import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/global_ui_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUIModel extends BaseUIModel {
  Future<void> checkUpdate() async {
    if (AppConf.isMSE) {
      launchUrlString("ms-windows-store://pdp/?productid=9NF3SWFWNKL1");
      return;
    }
    final hasUpdate = await globalUIModel.checkUpdate(context!);
    if (!hasUpdate) {
      if (mounted) showToast(context!, "已是最新版本");
    }
  }
}
