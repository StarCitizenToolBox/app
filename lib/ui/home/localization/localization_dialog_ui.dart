import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'localization_ui_model.dart';

class LocalizationDialogUI extends HookConsumerWidget {
  const LocalizationDialogUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localizationUIModelProvider);
    final model = ref.read(localizationUIModelProvider.notifier);
    final curInstallInfo = state.apiLocalizationData?[state.patchStatus?.value];

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
                              state.patchStatus?.value ?? "")),
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
                      AnimatedSize(
                        duration: const Duration(milliseconds: 130),
                        child: (curInstallInfo != null &&
                                curInstallInfo.note != null &&
                                curInstallInfo.note!.isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: FluentTheme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.current.localization_info_note,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "${curInstallInfo.note}",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.8)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                              ),
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
                  context),
              const SizedBox(height: 12),
              IconButton(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(state.enableCustomize
                          ? FluentIcons.chevron_up
                          : FluentIcons.chevron_down),
                      const SizedBox(width: 12),
                      Text(S.current.localization_action_advanced_features),
                    ],
                  ),
                  onPressed: model.toggleCustomize),
              AnimatedSize(
                duration: const Duration(milliseconds: 130),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    state.enableCustomize
                        ? makeListContainer(
                            S.current.localization_info_custom_text,
                            [
                              if (state.customizeList == null)
                                makeLoading(context)
                              else if (state.customizeList!.isEmpty)
                                Center(
                                  child: Text(
                                    S.current.localization_info_no_custom_text,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(.8)),
                                  ),
                                )
                              else ...[
                                for (final file in state.customizeList!)
                                  Row(
                                    children: [
                                      Text(
                                        model.getCustomizeFileName(file),
                                      ),
                                      const Spacer(),
                                      if (state.workingVersion == file)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 12),
                                          child: ProgressRing(),
                                        )
                                      else
                                        Button(
                                            onPressed:
                                                model.doLocalInstall(file),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8,
                                                  right: 8,
                                                  top: 4,
                                                  bottom: 4),
                                              child: Text(S.current
                                                  .localization_action_install),
                                            ))
                                    ],
                                  )
                              ],
                            ],
                            context,
                            actions: [
                              Button(
                                  onPressed: () => model.openDir(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Row(
                                      children: [
                                        const Icon(FluentIcons.folder_open),
                                        const SizedBox(width: 6),
                                        Text(S.current.action_open_folder),
                                      ],
                                    ),
                                  )),
                            ])
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                          )
                  ],
                ),
              ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Column(
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
              const Spacer(),
              if (isMineWorking)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ProgressRing(),
                )
              else
                Button(
                    onPressed: ((item.value.enable == true &&
                            !isWorking &&
                            !isInstalled)
                        ? model.doRemoteInstall(context, item.value)
                        : null),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(isInstalled
                                ? FluentIcons.check_mark
                                : (item.value.enable ?? false)
                                    ? FluentIcons.download
                                    : FluentIcons.disable_updates),
                          ),
                          Text(isInstalled
                              ? S.current.localization_info_installed
                              : ((item.value.enable ?? false)
                                  ? S.current.localization_action_install
                                  : S.current.localization_info_unavailable)),
                        ],
                      ),
                    )),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            color: Colors.white.withOpacity(.05),
            height: 1,
          ),
        ],
      ),
    );
  }

  Widget makeListContainer(
      String title, List<Widget> children, BuildContext context,
      {List<Widget> actions = const []}) {
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
}
