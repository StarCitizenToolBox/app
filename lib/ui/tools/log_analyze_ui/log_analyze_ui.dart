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
    final listSortReverse = useState<bool>(false);
    final selectedLogFile = useState<String?>(null); // null 表示使用当前 Game.log
    final availableLogFiles = useState<List<LogFileInfo>>([]);

    // 加载可用的日志文件列表
    useEffect(() {
      if (selectedPath.value != null) {
        getAvailableLogFiles(selectedPath.value!).then((files) {
          availableLogFiles.value = files;
          // 重置选择为当前日志
          selectedLogFile.value = null;
        });
      }
      return null;
    }, [selectedPath.value]);

    final provider = toolsLogAnalyzeProvider(
      selectedPath.value ?? "",
      listSortReverse.value,
      selectedLogFile: selectedLogFile.value,
    );
    final logResp = ref.watch(provider);
    final searchText = useState<String>("");
    final searchType = useState<String?>(null);
    final listCtrl = useScrollController();

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
                        ComboBoxItem<String>(value: path, child: Text(path)),
                    ],
                    onChanged: (value) {
                      selectedPath.value = value;
                      selectedLogFile.value = null; // 重置日志文件选择
                    },
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
                    // 重新加载日志文件列表
                    if (selectedPath.value != null) {
                      getAvailableLogFiles(selectedPath.value!).then((files) {
                        availableLogFiles.value = files;
                      });
                    }
                    ref.invalidate(provider);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 日志文件选择器
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Text("日志文件:"),
                const SizedBox(width: 10),
                Expanded(
                  child: ComboBox<String?>(
                    isExpanded: true,
                    value: selectedLogFile.value,
                    items: [
                      for (final logFile in availableLogFiles.value)
                        ComboBoxItem<String?>(
                          value: logFile.isCurrentLog ? null : logFile.path,
                          child: Text(
                            logFile.displayName,
                            style: logFile.isCurrentLog ? const TextStyle(fontWeight: FontWeight.bold) : null,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      selectedLogFile.value = value;
                    },
                    placeholder: const Text("选择日志文件"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 搜索，筛选
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                // 输入框
                Expanded(
                  child: TextFormBox(
                    prefix: Padding(padding: const EdgeInsets.only(left: 12), child: Icon(FluentIcons.search)),
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
                      .map((e) => ComboBoxItem<String>(value: e.key, child: Text(e.value)))
                      .toList(),
                  onChanged: (value) {
                    searchType.value = value;
                  },
                ),
                const SizedBox(width: 6),
                // 倒序 Icon
                Button(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Transform.rotate(
                      angle: listSortReverse.value ? 3.14 : 0,
                      child: const Icon(FluentIcons.sort_lines),
                    ),
                  ),
                  onPressed: () {
                    listSortReverse.value = !listSortReverse.value;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 3),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1)),
            ),
          ),
          // log analyze result
          if (!logResp.hasValue)
            Expanded(child: Center(child: ProgressRing()))
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
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _getIconWidget(item.type),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: item.title),
                                        if (item.dateTime != null)
                                          TextSpan(
                                            text: "   (${item.dateTime})",
                                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (item.data != null)
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text(
                                  item.data!,
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
}
