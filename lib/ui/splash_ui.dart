import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/aria2c.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class SplashUI extends HookConsumerWidget {
  const SplashUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepState = useState(0);
    final step = stepState.value;

    useEffect(() {
      final appModel = ref.read(appGlobalModelProvider.notifier);
      _initApp(context, appModel, stepState);
      return null;
    }, const []);

    return makeDefaultPage(context,
        content: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/app_logo.png", width: 192, height: 192),
              const SizedBox(height: 32),
              const ProgressRing(),
              const SizedBox(height: 32),
              if (step == 0) const Text("正在检测可用性，这可能需要一点时间..."),
              if (step == 1) const Text("正在检查更新..."),
              if (step == 2) const Text("即将完成..."),
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
                  "SC汉化盒子  V${ConstConf.appVersion} ${ConstConf.isMSE ? "" : " Dev"}")
            ],
          ),
        ));
  }

  void _initApp(BuildContext context, AppGlobalModel appModel,
      ValueNotifier<int> stepState) async {
    await appModel.initApp();
    AnalyticsApi.touch("launch");
    try {
      await URLConf.checkHost();
    } catch (e) {
      dPrint("checkHost Error:$e");
    }
    stepState.value = 1;
    if (!context.mounted) return;
    await appModel.checkUpdate(context);
    stepState.value = 2;
    await Aria2cManager.checkLazyLoad();
    // Navigator.pushAndRemoveUntil(
    //     context!,
    //     BaseUIContainer(
    //         uiCreate: () => IndexUI(),
    //         modelCreate: () => IndexUIModel()).makeRoute(context!),
    //         (route) => false);
  }
}
