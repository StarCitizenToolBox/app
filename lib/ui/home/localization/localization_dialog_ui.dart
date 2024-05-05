import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'localization_form_file_dialog_ui.dart';
import 'localization_ui_model.dart';

class LocalizationDialogUI extends HookConsumerWidget {
  const LocalizationDialogUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localizationUIModelProvider);
    final model = ref.read(localizationUIModelProvider.notifier);
    // final curInstallInfo = state.apiLocalizationData?[state.patchStatus?.value];

    useEffect(() {
      addPostFrameCallback(() {
        model.checkUserCfg(context);
      });
      return null;
    }, []);

    return ContentDialog(
      title: makeTitle(context, model, state),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .7,
          minHeight: MediaQuery.of(context).size.height * .9),
      content: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 130),
                child: state.patchStatus?.key == true &&
                        state.patchStatus?.value ==
                            S.current.home_action_info_game_built_in
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InfoBar(
                          title: Text(S.current.home_action_info_warning),
                          content: Text(S.current
                              .localization_info_machine_translation_warning),
                          severity: InfoBarSeverity.info,
                          style: InfoBarThemeData(decoration: (severity) {
                            return const BoxDecoration(
                                color: Color.fromRGBO(155, 7, 7, 1.0));
                          }, iconColor: (severity) {
                            return Colors.white;
                          }),
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                      ),
              ),
              makeListContainer(
                  S.current.localization_info_translation_status,
                  [
                    if (state.patchStatus == null)
                      makeLoading(context)
                    else ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Center(
                            child: Text(S.current.localization_info_enabled(
                                LocalizationUIModel.languageSupport[
                                        state.selectedLanguage] ??
                                    "")),
                          ),
                          const Spacer(),
                          ToggleSwitch(
                            checked: state.patchStatus?.key == true,
                            onChanged: model.updateLangCfg,
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(S.current.localization_info_installed_version(
                              "${state.patchStatus?.value ?? ""} ${(state.isInstalledAdvanced ?? false) ? S.current.home_localization_msg_version_advanced : ""}")),
                          const Spacer(),
                          if (state.patchStatus?.value !=
                              S.current.home_action_info_game_built_in)
                            Row(
                              children: [
                                Button(
                                    onPressed: model.goFeedback,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Row(
                                        children: [
                                          const Icon(FluentIcons.feedback),
                                          const SizedBox(width: 6),
                                          Text(S.current
                                              .localization_action_translation_feedback),
                                        ],
                                      ),
                                    )),
                                const SizedBox(width: 16),
                                Button(
                                    onPressed: model.doDelIniFile(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Row(
                                        children: [
                                          const Icon(FluentIcons.delete),
                                          const SizedBox(width: 6),
                                          Text(S.current
                                              .localization_action_uninstall_translation),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ],
                  context),
              makeListContainer(
                  S.current.localization_info_community_translation,
                  [
                    if (state.apiLocalizationData == null)
                      makeLoading(context)
                    else if (state.apiLocalizationData!.isEmpty)
                      Center(
                        child: Text(
                          S.current.localization_info_no_translation_available,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(.8)),
                        ),
                      )
                    else
                      for (final item in state.apiLocalizationData!.entries)
                        makeRemoteList(context, model, item, state),
                  ],
                  context,
                  gridViewMode: true),
              makeToolsListContainer(context, model, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeRemoteList(BuildContext context, LocalizationUIModel model,
      MapEntry<String, ScLocalizationData> item, LocalizationUIState state) {
    final isWorking = state.workingVersion.isNotEmpty;
    final isMineWorking = state.workingVersion == item.key;
    final isInstalled = state.patchStatus?.value == item.key;
    final isItemEnabled = ((item.value.enable ?? false));
    final tapDisabled =
        isInstalled || isWorking || !isItemEnabled || isMineWorking;
    return Tilt(
      shadowConfig: const ShadowConfig(maxIntensity: .3),
      borderRadius: BorderRadius.circular(7),
      disable: tapDisabled,
      child: GestureDetector(
        onTap:
            tapDisabled ? null : () => doInsTall(context, model, item, state),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(tapDisabled ? .03 : .05),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.value.info}",
                          style: const TextStyle(fontSize: 19),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.current.localization_info_version_number(
                              item.value.versionName ?? ""),
                          style: TextStyle(color: Colors.white.withOpacity(.6)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.current.localization_info_channel(
                              item.value.gameChannel ?? ""),
                          style: TextStyle(color: Colors.white.withOpacity(.6)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.current.localization_info_update_time(
                              item.value.updateAt ?? ""),
                          style: TextStyle(color: Colors.white.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ),
                  if (isMineWorking)
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: ProgressRing(),
                    )
                  else ...[
                    Icon(
                      isInstalled
                          ? FluentIcons.check_mark
                          : isItemEnabled
                              ? FluentIcons.download
                              : FluentIcons.disable_updates,
                      color: Colors.white.withOpacity(.8),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isInstalled
                          ? S.current.localization_info_installed
                          : (isItemEnabled
                              ? S.current.localization_action_install
                              : S.current.localization_info_unavailable),
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if ((!isInstalled) && isItemEnabled)
                      Icon(
                        FluentIcons.chevron_right,
                        size: 14,
                        color: Colors.white.withOpacity(.6),
                      )
                  ]
                ],
              ),
              if (item.value.note != null) ...[
                const SizedBox(height: 6),
                Text(
                  "${item.value.note}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget makeListContainer(
      String title, List<Widget> children, BuildContext context,
      {List<Widget> actions = const [],
      bool gridViewMode = false,
      int gridViewCrossAxisCount = 2}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 130),
        child: Container(
          decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor,
              borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const Spacer(),
                    if (actions.isNotEmpty) ...actions,
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  color: Colors.white.withOpacity(.1),
                  height: 1,
                ),
                const SizedBox(height: 12),
                if (gridViewMode)
                  AlignedGridView.count(
                    crossAxisCount: gridViewCrossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return children[index];
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: children.length,
                  )
                else
                  ...children
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeTitle(BuildContext context, LocalizationUIModel model,
      LocalizationUIState state) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(
              FluentIcons.back,
              size: 22,
            ),
            onPressed: model.onBack(context)),
        const SizedBox(width: 12),
        Text(S.current.home_action_localization_management),
        const SizedBox(width: 24),
        Text(
          "${model.getScInstallPath()}",
          style: const TextStyle(fontSize: 13),
        ),
        const Spacer(),
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Text(
                S.current.localization_info_language,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 12),
              ComboBox<String>(
                value: state.selectedLanguage,
                items: [
                  for (final lang
                      in LocalizationUIModel.languageSupport.entries)
                    ComboBoxItem(
                      value: lang.key,
                      child: Text(lang.value),
                    )
                ],
                onChanged: state.workingVersion.isNotEmpty
                    ? null
                    : (v) {
                        if (v == null) return;
                        model.selectLang(v);
                      },
              )
            ],
          ),
        ),
        const SizedBox(width: 12),
        Button(
            onPressed: model.doRefresh(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(FluentIcons.refresh),
            )),
      ],
    );
  }

  doInsTall(
      BuildContext context,
      LocalizationUIModel model,
      MapEntry<String, ScLocalizationData> item,
      LocalizationUIState state) async {
    final userOK = await showConfirmDialogs(
      context,
      "${item.value.info}",
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.localization_info_version_number(
                    item.value.versionName ?? ""),
                style: TextStyle(color: Colors.white.withOpacity(.6)),
              ),
              const SizedBox(height: 4),
              Text(
                S.current
                    .localization_info_channel(item.value.gameChannel ?? ""),
                style: TextStyle(color: Colors.white.withOpacity(.6)),
              ),
              const SizedBox(height: 4),
              Text(
                S.current
                    .localization_info_update_time(item.value.updateAt ?? ""),
                style: TextStyle(color: Colors.white.withOpacity(.6)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor,
                borderRadius: BorderRadius.circular(7)),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.value.note ?? S.current.home_localization_msg_no_note,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      confirm: S.current.localization_action_install,
      cancel: S.current.home_action_cancel,
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .45),
    );
    if (userOK) {
      if (!context.mounted) return;
      model.doRemoteInstall(context, item.value)?.call();
    }
  }

  Widget makeToolsListContainer(BuildContext context, LocalizationUIModel model,
      LocalizationUIState state) {
    final toolsMenu = {
      "launcher_mod": (
        const Icon(FluentIcons.c_plus_plus, size: 24),
        (S.current.home_localization_action_rsi_launcher_localization),
      ),
      "advanced": (
        const Icon(FluentIcons.queue_advanced, size: 24),
        (S.current.home_localization_action_advanced),
      ),
      "custom_files": (
        const Icon(FluentIcons.custom_activity, size: 24),
        (S.current.home_localization_action_install_customize),
      ),
    };

    final enableTap = state.workingVersion.isEmpty;

    return makeListContainer(
        S.current.home_localization_title_localization_tools,
        [
          for (final item in toolsMenu.entries)
            Tilt(
              disable: !enableTap,
              shadowConfig: const ShadowConfig(maxIntensity: .3),
              borderRadius: BorderRadius.circular(7),
              child: GestureDetector(
                onTap: enableTap
                    ? () async {
                        switch (item.key) {
                          case "launcher_mod":
                            ToolsUIModel.rsiEnhance(context);
                            break;
                          case "advanced":
                            context.push("/index/advanced_localization");
                            break;
                          case "custom_files":
                            final sb = await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  const LocalizationFromFileDialogUI(),
                            );
                            if (sb is StringBuffer) {
                              await model.installFormString(
                                  sb, S.current.localization_info_custom_files);
                            }
                            break;
                        }
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      item.value.$1,
                      const SizedBox(width: 12),
                      Text(item.value.$2),
                      const SizedBox(width: 12),
                      const Spacer(),
                      Icon(
                        FluentIcons.chevron_right,
                        size: 14,
                        color: Colors.white.withOpacity(.6),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
        context,
        gridViewMode: true,
        gridViewCrossAxisCount: 3);
  }
}
