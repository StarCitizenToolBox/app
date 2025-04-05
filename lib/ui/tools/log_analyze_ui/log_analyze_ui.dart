import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/utils/multi_window_manager.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

import 'log_analyze_provider.dart';

class ToolsLogAnalyzeDialogUI extends HookConsumerWidget {
  final MultiWindowAppState appState;

  const ToolsLogAnalyzeDialogUI({super.key, required this.appState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPath = useState<String?>(appState.gameInstallPaths.firstOrNull);
    final logResp = ref.watch(toolsLogAnalyzeProvider(selectedPath.value ?? ""));
    final searchText = useState<String>("");
    final searchType = useState<String?>(null);
    final lastListSize = useState<int>(0);

    final listCtrl = useScrollController();

    _diffData(logResp, lastListSize, listCtrl);
    return ScaffoldPage(
      content: Column(
        children: [
          // game Path selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text(S.current.log_analyzer_game_installation_path),
                const SizedBox(width: 10),
                Expanded(
                  child: ComboBox<String>(
                    isExpanded: true,
                    value: selectedPath.value,
                    items: [
                      for (final path in appState.gameInstallPaths)
                        ComboBoxItem<String>(
                          value: path,
                          child: Text(path),
                        ),
                    ],
                    onChanged: (value) => selectedPath.value = value,
                    placeholder: Text(S.current.log_analyzer_select_game_path),
                  ),
                ),
                const SizedBox(width: 10),
                // 刷新 IconButton
                Button(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: const Icon(FluentIcons.refresh),
                  ),
                  onPressed: () {
                    ref.invalidate(toolsLogAnalyzeProvider(selectedPath.value ?? ""));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // 搜索，筛选
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                // 输入框
                Expanded(
                  child: TextFormBox(
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(FluentIcons.search),
                    ),
                    placeholder: S.current.log_analyzer_search_placeholder,
                    onChanged: (value) {
                      searchText.value = value.trim();
                    },
                  ),
                ),
                SizedBox(width: 6),
                // 筛选 ComboBox
                ComboBox<String>(
                  isExpanded: false,
                  value: searchType.value,
                  placeholder: Text(S.current.log_analyzer_filter_all),
                  items: logAnalyzeSearchTypeMap.entries
                      .map((e) => ComboBoxItem<String>(
                            value: e.key,
                            child: Text(e.value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    searchType.value = value;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 3),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
          // log analyze result
          if (!logResp.hasValue)
            Expanded(
                child: Center(
              child: ProgressRing(),
            ))
          else
            Expanded(
                child: ListView.builder(
              controller: listCtrl,
              itemCount: logResp.value!.length,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemBuilder: (BuildContext context, int index) {
                final item = logResp.value![index];
                if (searchText.value.isNotEmpty) {
                  // 搜索
                  if (!item.toString().contains(searchText.value)) {
                    return const SizedBox.shrink();
                  }
                }
                if (searchType.value != null) {
                  if (item.type != searchType.value) {
                    return const SizedBox.shrink();
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SelectionArea(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getBackgroundColor(item.type),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _getIconWidget(item.type),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: item.title,
                                    ),
                                    if (item.dateTime != null)
                                      TextSpan(
                                        text: "   (${item.dateTime})",
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          if (item.data != null)
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Text(
                                item.data!,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ))
        ],
      ),
    );
  }

  Widget _getIconWidget(String key) {
    const iconMap = {
      "info": Icon(FluentIcons.info),
      "account_login": Icon(FluentIcons.accounts),
      "player_login": Icon(FontAwesomeIcons.solidIdCard),
      "fatal_collision": Icon(FontAwesomeIcons.personFallingBurst),
      "vehicle_destruction": Icon(FontAwesomeIcons.carBurst),
      "actor_death": Icon(FontAwesomeIcons.skull),
      "statistics": Icon(FontAwesomeIcons.chartSimple),
      "game_crash": Icon(FontAwesomeIcons.bug),
      "request_location_inventory": Icon(FontAwesomeIcons.box),
    };
    return iconMap[key] ?? const Icon(FluentIcons.info);
  }

  Color _getBackgroundColor(String type) {
    switch (type) {
      case "actor_death":
      case "fatal_collision":
        return Colors.red.withValues(alpha: .3);
      case "game_crash":
        return Color.fromRGBO(0, 0, 128, 1);
      case "vehicle_destruction":
        return Colors.yellow.withValues(alpha: .1);
      default:
        return Colors.white.withValues(alpha: .06);
    }
  }

  void _diffData(
      AsyncValue<List<LogAnalyzeLineData>> logResp, ValueNotifier<int> lastListSize, ScrollController listCtrl) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lastListSize.value == 0) {
        lastListSize.value = logResp.value?.length ?? 0;
      } else {
        // 判断当前列表是否在底部
        if (listCtrl.position.pixels >= listCtrl.position.maxScrollExtent) {
          // 如果在底部，判断数据是否有变化
          if ((logResp.value?.length ?? 0) > lastListSize.value) {
            Future.delayed(Duration(milliseconds: 100)).then((_) {
              listCtrl.jumpTo(listCtrl.position.maxScrollExtent);
            });
            lastListSize.value = logResp.value?.length ?? 0;
          } else {
            // 回顶部
            if (listCtrl.position.pixels > 0) {
              listCtrl.jumpTo(0);
            }
          }
        }
      }
    });
  }
}