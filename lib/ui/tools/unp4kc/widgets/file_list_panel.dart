import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../../widgets/widgets.dart';
import 'dialogs.dart';
import 'file_list_item.dart';
import 'models.dart';

class FileListPanel extends HookConsumerWidget {
  final Unp4kcState state;
  final Unp4kCModel model;
  final List<AppUnp4kP4kItemData>? files;

  const FileListPanel({
    super.key,
    required this.state,
    required this.model,
    required this.files,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(text: state.searchQuery);
    final suffixController = useTextEditingController(text: state.suffixFilter);
    final sizeSingleController = useTextEditingController(
      text: state.sizeFilterSingleValue?.toString() ?? "",
    );
    final sizeRangeStartController = useTextEditingController(
      text: state.sizeFilterRangeStart?.toString() ?? "",
    );
    final sizeRangeEndController = useTextEditingController(
      text: state.sizeFilterRangeEnd?.toString() ?? "",
    );
    void applySuffixFilter() {
      final raw = suffixController.text.trim();
      final normalized = raw.isEmpty || raw.startsWith(".") ? raw : ".$raw";
      model.setSuffixFilter(normalized.toLowerCase());
    }

    useEffect(() {
      final v = state.sizeFilterSingleValue?.toString() ?? "";
      if (sizeSingleController.text != v) {
        sizeSingleController.text = v;
      }
      return null;
    }, [state.sizeFilterSingleValue]);

    useEffect(() {
      final s = state.sizeFilterRangeStart?.toString() ?? "";
      final e = state.sizeFilterRangeEnd?.toString() ?? "";
      if (sizeRangeStartController.text != s) {
        sizeRangeStartController.text = s;
      }
      if (sizeRangeEndController.text != e) {
        sizeRangeEndController.text = e;
      }
      return null;
    }, [state.sizeFilterRangeStart, state.sizeFilterRangeEnd]);

    return Container(
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor.withValues(alpha: .01),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextBox(
                  controller: searchController,
                  placeholder: S.current.tools_unp4k_search_placeholder,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(FluentIcons.search, size: 14),
                  ),
                  suffix:
                      searchController.text.isNotEmpty ||
                          state.searchMatchedFiles != null
                      ? IconButton(
                          icon: const Icon(FluentIcons.clear, size: 12),
                          onPressed: () {
                            searchController.clear();
                            model.clearSearch();
                          },
                        )
                      : null,
                  onSubmitted: (value) {
                    applySuffixFilter();
                    model.search(value);
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ComboBox<Unp4kSortType>(
                      value: state.sortType,
                      items: [
                        ComboBoxItem(
                          value: Unp4kSortType.defaultSort,
                          child: Text(S.current.tools_unp4k_sort_default),
                        ),
                        ComboBoxItem(
                          value: Unp4kSortType.sizeAsc,
                          child: Text(S.current.tools_unp4k_sort_size_asc),
                        ),
                        ComboBoxItem(
                          value: Unp4kSortType.sizeDesc,
                          child: Text(S.current.tools_unp4k_sort_size_desc),
                        ),
                        ComboBoxItem(
                          value: Unp4kSortType.dateAsc,
                          child: Text(S.current.tools_unp4k_sort_date_asc),
                        ),
                        ComboBoxItem(
                          value: Unp4kSortType.dateDesc,
                          child: Text(S.current.tools_unp4k_sort_date_desc),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          model.setSortType(value);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextBox(
                        controller: suffixController,
                        placeholder: "后缀筛选(如 .xml)",
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(FluentIcons.filter, size: 14),
                        ),
                        suffix: suffixController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(FluentIcons.clear, size: 12),
                                onPressed: () {
                                  suffixController.clear();
                                  model.setSuffixFilter("");
                                },
                              )
                            : null,
                        onSubmitted: (_) {
                          applySuffixFilter();
                          model.search(searchController.text);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("大小"),
                    const SizedBox(width: 8),
                    ComboBox<Unp4kFilterMode>(
                      value: state.sizeFilterMode,
                      items: const [
                        ComboBoxItem(
                          value: Unp4kFilterMode.none,
                          child: Text("不限"),
                        ),
                        ComboBoxItem(
                          value: Unp4kFilterMode.before,
                          child: Text("小于"),
                        ),
                        ComboBoxItem(
                          value: Unp4kFilterMode.after,
                          child: Text("大于"),
                        ),
                        ComboBoxItem(
                          value: Unp4kFilterMode.range,
                          child: Text("范围"),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) model.setSizeFilterMode(v);
                      },
                    ),
                    const SizedBox(width: 8),
                    if (state.sizeFilterMode == Unp4kFilterMode.range) ...[
                      Expanded(
                        child: TextBox(
                          controller: sizeRangeStartController,
                          placeholder: "起始",
                          onSubmitted: (_) {
                            model.setSizeFilterRange(
                              _tryParseDouble(sizeRangeStartController.text),
                              _tryParseDouble(sizeRangeEndController.text),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextBox(
                          controller: sizeRangeEndController,
                          placeholder: "结束",
                          onSubmitted: (_) {
                            model.setSizeFilterRange(
                              _tryParseDouble(sizeRangeStartController.text),
                              _tryParseDouble(sizeRangeEndController.text),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: TextBox(
                          controller: sizeSingleController,
                          placeholder: "大小值",
                          onSubmitted: (_) {
                            model.setSizeFilterSingleValue(
                              _tryParseDouble(sizeSingleController.text),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    ComboBox<Unp4kSizeUnit>(
                      value: state.sizeFilterUnit,
                      items: const [
                        ComboBoxItem(value: Unp4kSizeUnit.k, child: Text("K")),
                        ComboBoxItem(
                          value: Unp4kSizeUnit.kb,
                          child: Text("KB"),
                        ),
                        ComboBoxItem(
                          value: Unp4kSizeUnit.mb,
                          child: Text("MB"),
                        ),
                        ComboBoxItem(
                          value: Unp4kSizeUnit.gb,
                          child: Text("GB"),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) model.setSizeFilterUnit(v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("日期"),
                    const SizedBox(width: 8),
                    ComboBox<Unp4kFilterMode>(
                      value: state.dateFilterMode,
                      items: const [
                        ComboBoxItem(
                          value: Unp4kFilterMode.none,
                          child: Text("不限"),
                        ),
                        ComboBoxItem(
                          value: Unp4kFilterMode.before,
                          child: Text("某日之前"),
                        ),
                        ComboBoxItem(
                          value: Unp4kFilterMode.after,
                          child: Text("某日之后"),
                        ),
                        ComboBoxItem(
                          value: Unp4kFilterMode.range,
                          child: Text("时间范围"),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) model.setDateFilterMode(v);
                      },
                    ),
                    const SizedBox(width: 8),
                    if (state.dateFilterMode == Unp4kFilterMode.range) ...[
                      Expanded(
                        child: DatePicker(
                          selected: state.dateFilterRangeStart,
                          showDay: true,
                          showMonth: true,
                          showYear: true,
                          onChanged: (d) => model.setDateFilterRange(
                            DateTime(d.year, d.month, d.day),
                            state.dateFilterRangeEnd,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: DatePicker(
                          selected: state.dateFilterRangeEnd,
                          showDay: true,
                          showMonth: true,
                          showYear: true,
                          onChanged: (d) => model.setDateFilterRange(
                            state.dateFilterRangeStart,
                            DateTime(d.year, d.month, d.day),
                          ),
                        ),
                      ),
                    ] else if (state.dateFilterMode !=
                        Unp4kFilterMode.none) ...[
                      Expanded(
                        child: DatePicker(
                          selected: state.dateFilterSingleDate,
                          showDay: true,
                          showMonth: true,
                          showYear: true,
                          onChanged: (d) => model.setDateFilterSingleDate(
                            DateTime(d.year, d.month, d.day),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Expanded(child: SizedBox.shrink()),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Button(
                      onPressed: () {
                        model.setSizeFilterSingleValue(
                          _tryParseDouble(sizeSingleController.text),
                        );
                        model.setSizeFilterRange(
                          _tryParseDouble(sizeRangeStartController.text),
                          _tryParseDouble(sizeRangeEndController.text),
                        );
                      },
                      child: const Text("应用筛选"),
                    ),
                    const SizedBox(width: 8),
                    Button(
                      onPressed: () {
                        sizeSingleController.clear();
                        sizeRangeStartController.clear();
                        sizeRangeEndController.clear();
                        model.clearSizeFilter();
                        model.clearDateFilter();
                      },
                      child: const Text("清空大小/日期"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (state.isMultiSelectMode)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: FluentTheme.of(
                  context,
                ).accentColor.withValues(alpha: .1),
                border: Border(
                  bottom: BorderSide(
                    color: FluentTheme.of(
                      context,
                    ).accentColor.withValues(alpha: .3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    S.current.tools_unp4k_action_export_selected(
                      state.selectedItems.length,
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Button(
                    child: Text(S.current.tools_unp4k_action_select_all),
                    onPressed: () => model.selectAll(files),
                  ),
                  const SizedBox(width: 4),
                  Button(
                    child: Text(S.current.tools_unp4k_action_deselect_all),
                    onPressed: () => model.deselectAll(files),
                  ),
                  const SizedBox(width: 4),
                  FilledButton(
                    onPressed: state.selectedItems.isNotEmpty
                        ? () => _exportSelected(context)
                        : null,
                    child: Text(S.current.tools_unp4k_action_save_as),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(FluentIcons.cancel, size: 14),
                    onPressed: () => model.exitMultiSelectMode(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: files == null || files!.isEmpty
                ? Center(
                    child: Text(
                      state.searchMatchedFiles != null
                          ? S.current.tools_unp4k_search_no_result
                          : '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .6),
                      ),
                    ),
                  )
                : SuperListView.builder(
                    padding: const EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                      left: 3,
                      right: 12,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final item = files![index];
                      return FileListItem(
                        item: item,
                        state: state,
                        model: model,
                      );
                    },
                    itemCount: files?.length ?? 0,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSelected(BuildContext context) async {
    final filesToExport = _collectSelectedFilesForExport();
    if (filesToExport.isEmpty) return;
    final hasConvertible = filesToExport.any(_canConvertPath);

    final options = await showDialog<BatchExportOptions>(
      context: context,
      builder: (dialogContext) {
        return BatchExportOptionsDialog(hasConvertible: hasConvertible);
      },
    );
    if (options == null || !context.mounted) return;

    String? outputDir;
    String? singleOutputPath;

    if (!options.includePath && filesToExport.length == 1) {
      final defaultName = _defaultExportName(
        filesToExport.first,
        options.convertWhenPossible,
      );
      singleOutputPath = await FilePicker.platform.saveFile(
        dialogTitle: options.convertWhenPossible ? "选择转换导出文件" : "选择导出文件",
        fileName: defaultName,
      );
      if (singleOutputPath == null) return;
    } else {
      outputDir = await FilePicker.platform.getDirectoryPath(
        dialogTitle: options.convertWhenPossible
            ? "选择转换导出位置"
            : S.current.tools_unp4k_action_save_as,
      );
      if (outputDir == null) return;
    }

    if (!context.mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AdvancedExportProgressDialog(
          filesToExport: filesToExport,
          outputDir: outputDir,
          singleOutputPath: singleOutputPath,
          options: options,
          model: model,
        );
      },
    );
    model.exitMultiSelectMode();
  }

  List<String> _collectSelectedFilesForExport() {
    final allFiles = state.files;
    if (allFiles == null) return const [];
    final result = <String>{};
    for (final selected in state.selectedItems) {
      final item = allFiles[selected];
      if (item != null && !(item.isDirectory ?? false)) {
        result.add(selected);
        continue;
      }
      final prefix = selected.endsWith("\\") ? selected : "$selected\\";
      for (final entry in allFiles.entries) {
        if (entry.key.startsWith(prefix) &&
            !(entry.value.isDirectory ?? false)) {
          result.add(entry.key);
        }
      }
    }
    final list = result.toList()..sort();
    return list;
  }

  bool _canConvertPath(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith(".wem") ||
        lower.endsWith(".dds") ||
        RegExp(r"\.dds\.\d+$").hasMatch(lower) ||
        lower.endsWith(".cgf") ||
        lower.endsWith(".cga");
  }

  String _defaultExportName(String p4kPath, bool convert) {
    final raw = p4kPath.split("\\").last;
    if (!convert) return raw;
    final lower = raw.toLowerCase();
    if (lower.endsWith(".wem")) {
      return "${raw.substring(0, raw.length - 4)}.wav";
    }
    final ddsChain = lower.indexOf(".dds.");
    if (ddsChain != -1) {
      return "${raw.substring(0, ddsChain)}.png";
    }
    if (lower.endsWith(".dds")) {
      return "${raw.substring(0, raw.length - 4)}.png";
    }
    if (lower.endsWith(".cgf") || lower.endsWith(".cga")) {
      return "${raw.substring(0, raw.length - 4)}.glb";
    }
    return raw;
  }

  double? _tryParseDouble(String text) {
    final v = double.tryParse(text.trim());
    if (v == null) return null;
    if (v < 0) return null;
    return v;
  }
}
