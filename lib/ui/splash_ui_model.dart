import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf/binary_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/ui/index_ui.dart';
import 'package:starcitizen_doctor/ui/index_ui_model.dart';

import '../common/conf/app_conf.dart';

class SplashUIModel extends BaseUIModel {
  int step = 0;

  @override
  void initModel() {
    _initApp();
    super.initModel();
  }

  Future<void> _initApp() async {
    AnalyticsApi.touch("launch");
    try {
      await URLConf.checkHost();
    } catch (e) {
      dPrint("checkHost Error:$e");
    }
    step = 1;
    notifyListeners();
    await AppConf.checkUpdate();
    step = 2;
    notifyListeners();
    await handleError(() => BinaryModuleConf.extractModel());
    Future.delayed(const Duration(milliseconds: 300));
    Navigator.pushAndRemoveUntil(
        context!,
        BaseUIContainer(
            uiCreate: () => IndexUI(),
            modelCreate: () => IndexUIModel()).makeRoute(context!),
        (route) => false);
  }
}
