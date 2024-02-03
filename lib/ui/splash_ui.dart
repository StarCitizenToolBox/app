import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';

import 'splash_ui_model.dart';

class SplashUI extends BaseUI<SplashUIModel> {
  @override
  Widget? buildBody(BuildContext context, SplashUIModel model) {
    return makeDefaultPage(context, model,
        content: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/app_logo.png", width: 192, height: 192),
              const SizedBox(height: 32),
              const ProgressRing(),
              const SizedBox(height: 32),
              if (model.step == 0) const Text("正在检测可用性，这可能需要一点时间..."),
              if (model.step == 1) const Text("正在检查更新..."),
              if (model.step == 2) const Text("即将完成..."),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        titleRow: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            children: [
              Image.asset(
                "assets/app_logo_mini.png",
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              const Text(
                  "SC汉化盒子  V${AppConf.appVersion} ${AppConf.isMSE ? "" : " Dev"}")
            ],
          ),
        ));
  }

  @override
  String getUITitle(BuildContext context, SplashUIModel model) => "";
}
