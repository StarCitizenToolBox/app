// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api/api.dart';
import 'base/ui_model.dart';
import 'common/conf.dart';
import 'ui/settings/upgrade_dialog_ui.dart';
import 'ui/settings/upgrade_dialog_ui_model.dart';

final globalUIModel = AppGlobalUIModel();
final globalUIModelProvider = ChangeNotifierProvider((ref) => globalUIModel);

class AppGlobalUIModel extends BaseUIModel {
  Future<bool> checkUpdate(BuildContext context, {bool init = true}) async {
    if (AppConf.isMSE) return true;
    if (!init) {
      try {
        AppConf.networkVersionData = await Api.getAppVersion();
      } catch (_) {}
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if (AppConf.networkVersionData == null) {
      showToast(context,
          "检查更新失败！请检查网络连接... \n进入离线模式.. \n\n请谨慎在离线模式中使用。 \n当前版本构建日期：${AppConf.appVersionDate}\n QQ群：940696487");
      return false;
    }
    if (((AppConf.networkVersionData?.lastVersionCode) ?? 0) >
        AppConf.appVersionCode) {
      // need update
      final r = await showDialog(
          dismissWithEsc: false,
          context: context,
          builder: (context) => BaseUIContainer(
              uiCreate: () => UpgradeDialogUI(),
              modelCreate: () => UpgradeDialogUIModel()));
      if (r != true) {
        showToast(context, "获取更新信息失败，请稍后重试。");
        return false;
      }
      return true;
    }
    return false;
  }
}
