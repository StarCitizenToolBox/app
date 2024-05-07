import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'game_doctor_ui_model.dart';

class HomeGameDoctorUI extends HookConsumerWidget {
  const HomeGameDoctorUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeGameDoctorUIModelProvider);
    final homeState = ref.watch(homeUIModelProvider);
    final model = ref.read(homeGameDoctorUIModelProvider.notifier);

    useEffect(() {
      AnalyticsApi.touch("auto_scan_issues");
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        dPrint("HomeGameDoctorUI useEffect doCheck timeStamp === $timeStamp");
        model.doCheck(context);
      });
      return null;
    }, []);

    return makeDefaultPage(context,
        title: S.current
            .doctor_title_one_click_diagnosis(homeState.scInstalledPath ?? ""),
        useBodyContainer: true,
        content: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (final item in {
                      "rsi_log": S.current.doctor_action_rsi_launcher_log,
                      "game_log": S.current.doctor_action_game_run_log,
                    }.entries)
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Button(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  const Icon(FluentIcons.folder_open),
                                  const SizedBox(width: 6),
                                  Text(item.value),
                                ],
                              ),
                            ),
                            onPressed: () =>
                                _onTapButton(context, item.key, homeState)),
                      ),
                  ],
                ),
                if (state.isChecking)
                  Expanded(
                      child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ProgressRing(),
                        const SizedBox(height: 12),
                        Text(state.lastScreenInfo)
                      ],
                    ),
                  ))
                else if (state.checkResult == null ||
                    state.checkResult!.isEmpty) ...[
                  Expanded(
                      child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Text(S.current.doctor_info_scan_complete_no_issues,
                            maxLines: 1),
                        const SizedBox(height: 64),
                      ],
                    ),
                  ))
                ] else
                  ...makeResult(context, state, model),
              ],
            ),
            if (state.isFixing)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(150),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ProgressRing(),
                      const SizedBox(height: 12),
                      Text(state.isFixingString.isNotEmpty
                          ? state.isFixingString
                          : S.current.doctor_info_processing),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              right: 20,
              child: makeRescueBanner(context),
            )
          ],
        ));
  }

  Widget makeRescueBanner(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showToast(
            context, S.current.doctor_info_game_rescue_service_note);
        launchUrlString(
            "https://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=-M4wEme_bCXbUGT4LFKLH0bAYTFt70Ad&authKey=vHVr0TNgRmKu%2BHwywoJV6EiLa7La2VX74Vkyixr05KA0H9TqB6qWlCdY%2B9jLQ4Ha&noverify=0&group_code=536454632");
      },
      child: Tilt(
        shadowConfig: const ShadowConfig(maxIntensity: .2),
        borderRadius: BorderRadius.circular(12),
        child: Container(
            decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/rescue.png", width: 24, height: 24),
                  const SizedBox(width: 12),
                  Text(S.current.doctor_info_need_help),
                ],
              ),
            )),
      ),
    );
  }

  List<Widget> makeResult(BuildContext context, HomeGameDoctorState state,
      HomeGameDoctorUIModel model) {
    return [
      const SizedBox(height: 24),
      Text(state.lastScreenInfo, maxLines: 1),
      const SizedBox(height: 12),
      Text(
        S.current.doctor_info_tool_check_result_note,
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
      const SizedBox(height: 24),
      ListView.builder(
        itemCount: state.checkResult!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final item = state.checkResult![index];
          return makeResultItem(context, item, state, model);
        },
      ),
      const SizedBox(height: 64),
    ];
  }

  Widget makeResultItem(BuildContext context, MapEntry<String, String> item,
      HomeGameDoctorState state, HomeGameDoctorUIModel model) {
    final errorNames = {
      "unSupport_system": MapEntry(S.current.doctor_info_result_unsupported_os,
          S.current.doctor_info_result_upgrade_system(item.value)),
      "no_live_path": MapEntry(S.current.doctor_info_result_missing_live_folder,
          S.current.doctor_info_result_create_live_folder(item.value)),
      "nvme_PhysicalBytes": MapEntry(
          S.current.doctor_info_result_incompatible_nvme_device,
          S.current.doctor_info_result_add_registry_value(item.value)),
      "eac_file_miss": MapEntry(
          S.current.doctor_info_result_missing_easyanticheat_files,
          S.current.doctor_info_result_verify_files_with_rsi_launcher),
      "eac_not_install": MapEntry(
          S.current.doctor_info_result_easyanticheat_not_installed,
          S.current.doctor_info_result_install_easyanticheat),
      "cn_user_name": MapEntry(S.current.doctor_info_result_chinese_username,
          S.current.doctor_info_result_chinese_username_error),
      "cn_install_path": MapEntry(
          S.current.doctor_info_result_chinese_install_path,
          S.current.doctor_info_result_chinese_install_path_error(item.value)),
      "low_ram": MapEntry(S.current.doctor_info_result_low_physical_memory,
          S.current.doctor_info_result_memory_requirement(item.value)),
    };
    bool isCheckedError = errorNames.containsKey(item.key);

    if (isCheckedError) {
      return Container(
        decoration: BoxDecoration(
          color: FluentTheme.of(context).cardColor,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text(
            errorNames[item.key]?.key ?? "",
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Column(
              children: [
                const SizedBox(height: 4),
                Text(
                  S.current.doctor_info_result_fix_suggestion(
                      errorNames[item.key]?.value ??
                          S.current.doctor_info_result_no_solution),
                  style: TextStyle(
                      fontSize: 14, color: Colors.white.withOpacity(.7)),
                ),
              ],
            ),
          ),
          trailing: Button(
            onPressed: (errorNames[item.key]?.value == null || state.isFixing)
                ? null
                : () async {
                    await model.doFix(context, item);
                  },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
              child: Text(S.current.doctor_info_action_fix),
            ),
          ),
        ),
      );
    }

    final isSubTitleUrl = item.value.startsWith("https://");

    return Container(
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          item.key,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: isSubTitleUrl
            ? null
            : Column(
                children: [
                  const SizedBox(height: 4),
                  Text(
                    item.value,
                    style: TextStyle(
                        fontSize: 14, color: Colors.white.withOpacity(.7)),
                  ),
                ],
              ),
        trailing: isSubTitleUrl
            ? Button(
                onPressed: () {
                  launchUrlString(item.value);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 4),
                  child: Text(S.current.doctor_action_view_solution),
                ),
              )
            : null,
      ),
    );
  }

  _onTapButton(
      BuildContext context, String key, HomeUIModelState homeState) async {
    switch (key) {
      case "rsi_log":
        final path = await SCLoggerHelper.getLogFilePath();
        if (path == null) return;
        SystemHelper.openDir(path);
        return;
      case "game_log":
        if (homeState.scInstalledPath == "not_install" ||
            homeState.scInstalledPath == null) {
          showToast(context, S.current.doctor_tip_title_select_game_directory);
          return;
        }
        SystemHelper.openDir("${homeState.scInstalledPath}\\Game.log");
        return;
    }
  }
}
