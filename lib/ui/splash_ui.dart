import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/provider/aria2c.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class SplashUI extends HookConsumerWidget {
  const SplashUI({super.key});

  static const _alertInfoVersion = 1;

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
    final appConf = await Hive.openBox("app_conf");
    final v = appConf.get("splash_alert_info_version", defaultValue: 0);
    AnalyticsApi.touch("launch");
    if (v < _alertInfoVersion) {
      if (!context.mounted) return;
      await _showAlert(context, appConf);
    }
    try {
      // crash on debug mode, why?
      if (!kDebugMode) await URLConf.checkHost();
    } catch (e) {
      dPrint("checkHost Error:$e");
    }
    stepState.value = 1;
    if (!context.mounted) return;
    dPrint("_initApp checkUpdate");
    await appModel.checkUpdate(context);
    stepState.value = 2;
    dPrint("_initApp aria2cModelProvider");
    ref.read(aria2cModelProvider);
    if (!context.mounted) return;
    context.go("/index");
  }

  _showAlert(BuildContext context, Box<dynamic> appConf) async {
    final userOk = await showConfirmDialogs(
        context,
        S.current.app_splash_dialog_u_a_p_p,
        MarkdownWidget(data: S.current.app_splash_dialog_u_a_p_p_content),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .5));
    if (userOk) {
      await appConf.put("splash_alert_info_version", _alertInfoVersion);
    } else {
      exit(0);
    }
  }
}
