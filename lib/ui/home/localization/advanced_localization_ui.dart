import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/ini.dart';
import 'package:re_highlight/styles/vs2015.dart';
import 'package:starcitizen_doctor/data/app_advanced_localization_data.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/localization/advanced_localization_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'localization_form_file_dialog_ui.dart';

class AdvancedLocalizationUI extends HookConsumerWidget {
  const AdvancedLocalizationUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(advancedLocalizationUIModelProvider);
    final model = ref.read(advancedLocalizationUIModelProvider.notifier);
    final homeUIState = ref.watch(homeUIModelProvider);

    onSwitchFile() async {
      final sb = await showDialog(
        context: context,
        builder: (BuildContext context) => const LocalizationFromFileDialogUI(),
      );
      if (sb is StringBuffer) {
        model.setCustomizeGlobalIni(sb.toString());
      }
    }

    return makeDefaultPage(
        title: S.current.home_localization_advanced_title(
            homeUIState.scInstalledPath ?? "-"),
        context,
        content: state.workingText.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ProgressRing(),
                    const SizedBox(height: 12),
                    Text(state.workingText),
                  ],
                ),
              )
            : Column(
                children: [
                  if (state.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(state.errorMessage),
                      ),
                    )
                  else ...[
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                            child: Row(
                          children: [
                            Text(
                              S.current.home_localization_advanced_msg_version(
                                  state.apiLocalizationData?.versionName ??
                                      "-"),
                            ),
                            const SizedBox(width: 12),
                            Button(
                                onPressed: onSwitchFile,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  child: Icon(FluentIcons.switch_widget),
                                )),
                            if (state.customizeGlobalIni != null) ...[
                              const SizedBox(width: 12),
                              Button(
                                  onPressed: () {
                                    model.setCustomizeGlobalIni(null);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    child: Icon(FluentIcons.delete),
                                  )),
                            ]
                          ],
                        )),
                        Text(S.current.home_localization_advanced_title_msg(
                            state.serverGlobalIniLines,
                            state.p4kGlobalIniLines)),
                        const SizedBox(width: 32),
                        Button(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 4, bottom: 4),
                              child: Text(S.current
                                  .home_localization_advanced_action_install),
                            ),
                            onPressed: () async {
                              await model.doInstall().unwrap(context: context);
                            }),
                        const SizedBox(width: 12),
                      ],
                    ),
                    Expanded(
                        child:
                            _makeBody(context, homeUIState, state, ref, model)),
                  ]
                ],
              ));
  }

  Widget _makeBody(
      BuildContext context,
      HomeUIModelState homeUIState,
      AdvancedLocalizationUIState state,
      WidgetRef ref,
      AdvancedLocalizationUIModel model) {
    return AlignedGridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.all(12),
      itemBuilder: (BuildContext context, int index) {
        final item = state.classMap!.values.elementAt(index);
        return Container(
          padding: const EdgeInsets.only(top: 6, bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed:
                    item.isWorking ? null : () => _showContent(context, item),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "${item.className}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      )),
                      Text(
                        "${item.valuesMap.length}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(.6),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        FluentIcons.chevron_right,
                        color: Colors.white.withOpacity(.6),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 12),
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.white.withOpacity(.1),
              ),
              if (item.isWorking)
                Column(
                  children: [
                    makeLoading(context),
                    const SizedBox(height: 6),
                    Text(
                        S.current.home_localization_advanced_action_mod_change),
                  ],
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(S
                              .current.home_localization_advanced_action_mode)),
                      ComboBox(
                        value: item.mode,
                        items: [
                          for (final type
                              in AppAdvancedLocalizationClassKeysDataMode
                                  .values)
                            ComboBoxItem(
                              value: type,
                              child: Text(state.typeNames[type] ?? "-"),
                            ),
                        ],
                        onChanged: item.lockMod
                            ? null
                            : (v) => model.onChangeMod(item,
                                v as AppAdvancedLocalizationClassKeysDataMode),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 180,
                  child: SuperListView.builder(
                    itemCount: item.valuesMap.length,
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final itemKey = item.valuesMap.keys.elementAt(index);
                      return Text(
                        "${item.valuesMap[itemKey]}",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
      itemCount: state.classMap?.length ?? 0,
    );
  }

  _showContent(
      BuildContext context, AppAdvancedLocalizationClassKeysData item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HookConsumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final textData = useState("");

            loadData() async {
              final v = StringBuffer("");
              for (var element in item.valuesMap.entries) {
                v.write("${element.key}=${element.value}\n");
                await Future.delayed(Duration.zero);
              }
              textData.value = v.toString();
            }

            useEffect(() {
              loadData();
              return null;
            }, const []);

            return ContentDialog(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .8,
              ),
              title: Row(
                children: [
                  IconButton(
                      icon: const Icon(
                        FluentIcons.back,
                        size: 22,
                      ),
                      onPressed: () => context.pop()),
                  const SizedBox(
                    width: 24,
                  ),
                  Text(S.current.home_localization_advanced_title_preview(
                      item.className ?? "-")),
                ],
              ),
              content: textData.value.isEmpty
                  ? makeLoading(context)
                  : Container(
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: CodeEditor(
                        readOnly: true,
                        controller:
                            CodeLineEditingController.fromText(textData.value),
                        style: CodeEditorStyle(
                          codeTheme: CodeHighlightTheme(
                            languages: {
                              'ini': CodeHighlightThemeMode(mode: langIni)
                            },
                            theme: vs2015Theme,
                          ),
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
