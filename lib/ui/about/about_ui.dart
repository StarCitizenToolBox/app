import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/widgets/src/flow_number_text.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUI extends HookConsumerWidget {
  const AboutUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTipTextCn = useState(false);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          const SizedBox(height: 32),
          Image.asset("assets/app_logo.png", width: 128, height: 128),
          const SizedBox(height: 6),
          Text(
              S.current.app_index_version_info(
                  ConstConf.appVersion, ConstConf.isMSE ? "" : " Dev"),
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          Button(
              onPressed: () => _onCheckUpdate(context, ref),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(S.current.about_check_update),
              )),
          const SizedBox(height: 32),
          Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    S.current.about_app_description,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: .9)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          makeAnalyticsWidget(context),
          const SizedBox(height: 24),
          makeLinksRow(),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: MediaQuery.of(context).size.width * .35,
                  decoration: BoxDecoration(
                      color: FluentTheme.of(context)
                          .cardColor
                          .withValues(alpha: .06),
                      borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        isTipTextCn.value ? tipTextCN : tipTextEN,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: .9)),
                      ),
                    ),
                    onPressed: () {
                      isTipTextCn.value = !isTipTextCn.value;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget makeLinksRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.question),
              const SizedBox(width: 8),
              Text(
                S.current.about_action_btn_faq,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString(URLConf.feedbackFAQUrl);
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.link),
              const SizedBox(width: 8),
              Text(
                S.current.about_online_feedback,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString(URLConf.feedbackUrl);
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.qq),
              const SizedBox(width: 8),
              Text(
                S.current.about_action_qq_group,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString(
                "https://qm.qq.com/cgi-bin/qm/qr?k=TdyR3QU-x77OeD0NQ5w--F0uiNxPq-Tn&jump_from=webapi&authKey=m8s5GhF/7bRCvm5vI4aNl7RQEx5KOViwkzzIl54K+u9w2hzFpr9N/3avG4W/HaVS");
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.envelope),
              const SizedBox(width: 8),
              Text(
                S.current.about_action_email,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString("mailto:xkeyc@qq.com");
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.github),
              const SizedBox(width: 8),
              Text(
                S.current.about_action_open_source,
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString("https://github.com/StarCitizenToolBox/app");
          },
        ),
      ],
    );
  }

  static const tipTextEN =
      "This is an unofficial Star Citizen fan-made tools, not affiliated with the Cloud Imperium group of companies. All content on this Software not authored by its host or users are property of their respective owners. \nStar Citizen®, Roberts Space Industries® and Cloud Imperium® are registered trademarks of Cloud Imperium Rights LLC.";

  static String get tipTextCN => S.current.about_disclaimer;

  Widget makeAnalyticsWidget(BuildContext context) {
    return LoadingWidget(
      onLoadData: AnalyticsApi.getAnalyticsData,
      autoRefreshDuration: const Duration(seconds: 60),
      childBuilder: (BuildContext context, Map<String, dynamic> data) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (data["total"] is List)
              for (var item in data["total"])
                if (item is Map)
                  if ([
                    "launch",
                    "gameLaunch",
                    "firstLaunch",
                    "install_localization",
                    "performance_apply",
                    "p4k_download",
                  ].contains(item["Type"]))
                    makeAnalyticsItem(
                        context: context,
                        name: item["Type"] as String,
                        value: item["Count"] as int)
          ],
        );
      },
    );
  }

  Widget makeAnalyticsItem(
      {required BuildContext context,
      required String name,
      required int value}) {
    final names = {
      "launch": S.current.about_analytics_launch,
      "gameLaunch": S.current.about_analytics_launch_game,
      "firstLaunch": S.current.about_analytics_total_users,
      "install_localization": S.current.about_analytics_install_translation,
      "performance_apply": S.current.about_analytics_performance_optimization,
      "p4k_download": S.current.about_analytics_p4k_redirection
    };
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
          color: FluentTheme.of(context).cardColor.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(
            names[name] ?? name,
            style: TextStyle(
                fontSize: 13, color: Colors.white.withValues(alpha: .6)),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FlowNumberText(
                targetValue: value,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                  " ${name == "firstLaunch" ? S.current.about_analytics_units_user : S.current.about_analytics_units_times}"),
            ],
          ),
        ],
      ),
    );
  }

  _onCheckUpdate(BuildContext context, WidgetRef ref) async {
    if (ConstConf.isMSE) {
      launchUrlString("ms-windows-store://pdp/?productid=9NF3SWFWNKL1");
      return;
    } else {
      final hasUpdate =
          await ref.read(appGlobalModelProvider.notifier).checkUpdate(context);
      if (!hasUpdate) {
        if (!context.mounted) return;
        showToast(context, S.current.about_info_latest_version);
      }
    }
  }
}
