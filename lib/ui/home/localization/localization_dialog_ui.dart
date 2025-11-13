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
        minHeight: MediaQuery.of(context).size.height * .9,
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 130),
                child:
                    state.patchStatus?.key == true &&
                        state.patchStatus?.value == S.current.home_action_info_game_built_in
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InfoBar(
                          title: Text(S.current.home_action_info_warning),
                          content: Text(S.current.localization_info_machine_translation_warning),
                          severity: InfoBarSeverity.info,
                          style: InfoBarThemeData(
                            decoration: (severity) {
                              return const BoxDecoration(color: Color.fromRGBO(155, 7, 7, 1.0));
                            },
                            iconColor: (severity) {
                              return Colors.white;
                            },
                          ),
                        ),
                      )
                    : SizedBox(width: MediaQuery.of(context).size.width),
              ),
              makeToolsListContainer(context, model, state),
              makeListContainer(S.current.localization_info_translation, [
                if (state.patchStatus == null)
                  makeLoading(context)
                else ...[
                  const SizedBox(height: 6),
                  if (state.apiLocalizationData == null)
                    makeLoading(context)
                  else if (state.apiLocalizationData!.isEmpty)
                    Center(
                      child: Text(
                        S.current.localization_info_no_translation_available,
                        style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .8)),
                      ),
                    )
                  else
                    AlignedGridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      itemBuilder: (BuildContext context, int index) {
                        final item = state.apiLocalizationData!.entries.elementAt(index);
                        return makeRemoteList(context, model, item, state, index);
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.apiLocalizationData?.length ?? 0,
                    ),
                ],
              ], context),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeRemoteList(
    BuildContext context,
    LocalizationUIModel model,
    MapEntry<String, ScLocalizationData> item,
    LocalizationUIState state,
    int index,
  ) {
    final isWorking = state.workingVersion.isNotEmpty;
    final isMineWorking = state.workingVersion == item.key;
    final isInstalled = state.patchStatus?.value == item.key;
    final isItemEnabled = ((item.value.enable ?? false));
    final tapDisabled = isInstalled || isWorking || !isItemEnabled || isMineWorking;
    return GridItemAnimator(
      index: index,
      child: Tilt(
        shadowConfig: const ShadowConfig(maxIntensity: .3),
        borderRadius: BorderRadius.circular(7),
        disable: tapDisabled,
        child: GestureDetector(
          onTap: tapDisabled ? null : () => model.onRemoteInsTall(context, item, state),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: tapDisabled ? .03 : .05),
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
                          Text("${item.value.info}", style: const TextStyle(fontSize: 19)),
                          const SizedBox(height: 4),
                          Text(
                            S.current.localization_info_version_number(item.value.versionName ?? ""),
                            style: TextStyle(color: Colors.white.withValues(alpha: .6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            S.current.localization_info_channel(item.value.gameChannel ?? ""),
                            style: TextStyle(color: Colors.white.withValues(alpha: .6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            S.current.localization_info_update_time(item.value.updateAt ?? ""),
                            style: TextStyle(color: Colors.white.withValues(alpha: .6)),
                          ),
                        ],
                      ),
                    ),
                    if (isMineWorking)
                      const Padding(padding: EdgeInsets.only(right: 12), child: ProgressRing())
                    else ...[
                      Icon(
                        isInstalled
                            ? FluentIcons.check_mark
                            : isItemEnabled
                            ? FluentIcons.download
                            : FluentIcons.disable_updates,
                        color: Colors.white.withValues(alpha: .8),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isInstalled
                            ? S.current.localization_info_installed
                            : (isItemEnabled
                                  ? S.current.localization_action_install
                                  : S.current.localization_info_unavailable),
                        style: TextStyle(color: Colors.white.withValues(alpha: .8)),
                      ),
                      const SizedBox(width: 6),
                      if ((!isInstalled) && isItemEnabled)
                        Icon(FluentIcons.chevron_right, size: 14, color: Colors.white.withValues(alpha: .6)),
                    ],
                  ],
                ),
                if (item.value.note != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    "${item.value.note}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white.withValues(alpha: .4), fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeListContainer(
    String title,
    List<Widget> children,
    BuildContext context, {
    List<Widget> actions = const [],
    bool gridViewMode = false,
    int gridViewCrossAxisCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 130),
        child: Container(
          decoration: BoxDecoration(color: FluentTheme.of(context).cardColor, borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 22)),
                    const Spacer(),
                    if (actions.isNotEmpty) ...actions,
                  ],
                ),
                const SizedBox(height: 6),
                Container(color: Colors.white.withValues(alpha: .1), height: 1),
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
                  ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeTitle(BuildContext context, LocalizationUIModel model, LocalizationUIState state) {
    return Row(
      children: [
        IconButton(icon: const Icon(FluentIcons.back, size: 22), onPressed: model.onBack(context)),
        const SizedBox(width: 12),
        Text(S.current.home_action_localization_management),
        const SizedBox(width: 24),
        const Spacer(),
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Text(S.current.localization_info_language, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              ComboBox<String>(
                value: state.selectedLanguage,
                items: [
                  for (final lang in LocalizationUIModel.languageSupport.entries)
                    ComboBoxItem(value: lang.key, child: Text(lang.value)),
                ],
                onChanged: state.workingVersion.isNotEmpty
                    ? null
                    : (v) {
                        if (v == null) return;
                        model.selectLang(v);
                      },
              ),
              const SizedBox(width: 12),
              const Text("频道选择", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              ComboBox<String>(
                value: state.selectedChannel,
                items: const [
                  ComboBoxItem(value: "LIVE", child: Text("LIVE")),
                  ComboBoxItem(value: "PTU", child: Text("PTU")),
                ],
                onChanged: state.workingVersion.isNotEmpty
                    ? null
                    : (v) {
                        if (v == null) return;
                        model.selectChannel(v);
                      },
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Button(
          onPressed: model.doRefresh(),
          child: const Padding(padding: EdgeInsets.all(6), child: Icon(FluentIcons.refresh)),
        ),
      ],
    );
  }

  Widget makeToolsListContainer(BuildContext context, LocalizationUIModel model, LocalizationUIState state) {
    final toolsMenu = {
      "launcher_mod": (
        const Icon(FluentIcons.c_plus_plus, size: 24),
        (S.current.home_localization_action_rsi_launcher_localization),
      ),
      "advanced": (const Icon(FluentIcons.queue_advanced, size: 24), (S.current.home_localization_action_advanced)),
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
                          context.push("/advanced_localization");
                          break;
                        case "custom_files":
                          final sb = await showDialog(
                            context: context,
                            builder: (BuildContext context) => const LocalizationFromFileDialogUI(),
                          );
                          if (sb is (StringBuffer, bool)) {
                            if (!context.mounted) return;
                            await model.installFormString(
                              sb.$1,
                              S.current.localization_info_custom_files,
                              isEnableCommunityInputMethod: sb.$2,
                              context: context,
                            );
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
                    Icon(FluentIcons.chevron_right, size: 14, color: Colors.white.withValues(alpha: .6)),
                  ],
                ),
              ),
            ),
          ),
      ],
      context,
      gridViewMode: true,
      gridViewCrossAxisCount: 3,
    );
  }
}
