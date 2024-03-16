import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/provider/aria2c.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class SplashUI extends HookConsumerWidget {
  const SplashUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepState = useState(0);
    final step = stepState.value;

    useEffect(() {
      final appModel = ref.read(appGlobalModelProvider.notifier);
      _initApp(context, appModel, stepState, ref);
      return null;
    }, []);

    return makeDefaultPage(context,
        content: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/app_logo.png", width: 192, height: 192),
              const SizedBox(height: 32),
              const ProgressRing(),
              const SizedBox(height: 32),
              if (step == 0) Text(S.current.app_splash_checking_availability),
              if (step == 1) Text(S.current.app_splash_checking_for_updates),
              if (step == 2) Text(S.current.app_splash_almost_done),
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
              Text(S.current.app_index_version_info(
                  ConstConf.appVersion, ConstConf.isMSE ? "" : " Dev"))
            ],
          ),
        ));
  }

  void _initApp(BuildContext context, AppGlobalModel appModel,
      ValueNotifier<int> stepState, WidgetRef ref) async {
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
    ref.read(aria2cModelProvider);
    if (!context.mounted) return;
    context.go("/index");
  }
}
