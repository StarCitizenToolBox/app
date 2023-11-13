// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

import 'base/ui_model.dart';
import 'common/conf.dart';
import 'ui/settings/upgrade_dialog_ui.dart';
import 'ui/settings/upgrade_dialog_ui_model.dart';

final globalUIModel = AppGlobalUIModel();
final globalUIModelProvider = ChangeNotifierProvider((ref) => globalUIModel);

class AppGlobalUIModel extends BaseUIModel {
  Timer? activityThemeColorTimer;

  Future<bool> doCheckUpdate(BuildContext context, {bool init = true}) async {
    if (!init) {
      try {
        await AppConf.checkUpdate();
      } catch (_) {}
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if (AppConf.networkVersionData == null) {
      showToast(context,
          "检查更新失败！请检查网络连接... \n进入离线模式.. \n\n请谨慎在离线模式中使用。 \n当前版本构建日期：${AppConf.appVersionDate}\n QQ群：940696487");
      return false;
    }
    final lastVersion = AppConf.isMSE
        ? AppConf.networkVersionData?.mSELastVersionCode
        : AppConf.networkVersionData?.lastVersionCode;
    if ((lastVersion ?? 0) > AppConf.appVersionCode) {
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

  checkActivityThemeColor() {
    if (activityThemeColorTimer != null) {
      activityThemeColorTimer?.cancel();
      activityThemeColorTimer = null;
    }
    if (AppConf.networkVersionData == null ||
        AppConf.networkVersionData?.activityColors?.enable != true) return;

    final startTime = AppConf.networkVersionData!.activityColors?.startTime;
    final endTime = AppConf.networkVersionData!.activityColors?.endTime;
    if (startTime == null || endTime == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;

    dPrint("now == $now  start == $startTime end == $endTime");
    if (now < startTime) {
      activityThemeColorTimer = Timer(
          Duration(milliseconds: startTime - now), checkActivityThemeColor);
      dPrint("start Timer ....");
    } else if (now >= startTime && now <= endTime) {
      dPrint("update Color ....");
      // update Color
      final colorCfg = AppConf.networkVersionData!.activityColors;
      AppConf.colorBackground =
          HexColor(colorCfg?.background ?? "#132431").withOpacity(.75);
      AppConf.colorMenu =
          HexColor(colorCfg?.menu ?? "#132431").withOpacity(.95);
      AppConf.colorMica = HexColor(colorCfg?.mica ?? "#0A3142");
      notifyListeners();
      // wait for end
      activityThemeColorTimer =
          Timer(Duration(milliseconds: endTime - now), checkActivityThemeColor);
    } else {
      dPrint("reset Color ....");
      AppConf.colorBackground = HexColor("#132431").withOpacity(.75);
      AppConf.colorMenu = HexColor("#132431").withOpacity(.95);
      AppConf.colorMica = HexColor("#0A3142");
      notifyListeners();
    }
    notifyListeners();
  }
}
