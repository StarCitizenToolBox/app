import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:re_editor/re_editor.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/rust/rust_audio_player.dart';
import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

final Map<String, List<double>> _audioWaveformCache = <String, List<double>>{};
final Map<String, Future<void>> _wemFullDecodeInFlight =
    <String, Future<void>>{};
double _audioLastVolume = 1.0;

class UnP4kcUI extends HookConsumerWidget {
  const UnP4kcUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    final model = ref.read(unp4kCModelProvider.notifier);
    final files = model.getFiles();
    final paths = state.curPath.trim().split("\\");
    final pathController = useTextEditingController(text: state.curPath);
    final isPathEditing = useState(false);
    final pathFocusNode = useFocusNode();

    useEffect(() {
      if (!isPathEditing.value && pathController.text != state.curPath) {
        pathController.text = state.curPath;
      }
      return null;
    }, [state.curPath, isPathEditing.value]);

    useEffect(() {
      void listener() {
        if (!pathFocusNode.hasFocus && isPathEditing.value) {
          isPathEditing.value = false;
        }
      }

      pathFocusNode.addListener(listener);
      return () => pathFocusNode.removeListener(listener);
    }, [pathFocusNode, isPathEditing.value]);

    useEffect(() {
      AnalyticsApi.touch("unp4k_launch");
      return null;
    }, const []);

    return makeDefaultPage(
      context,
      automaticallyImplyLeading: false,
      title: S.current.tools_unp4k_title(model.getGamePath()),
      titleRow: Row(
        children: [
          IconButton(
            icon: const Icon(FluentIcons.home, size: 14),
            onPressed: () async {
              final shouldLeave = await _confirmExitToHome(context);
              if (shouldLeave && context.mounted) {
                await model.clearTempWemCache();
                if (!context.mounted) return;
                _audioWaveformCache.clear();
                context.go('/index');
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              S.current.tools_unp4k_title(model.getGamePath()),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      useBodyContainer: false,
      content: makeBody(
        context,
        state,
        model,
        files,
        paths,
        pathController,
        isPathEditing,
        pathFocusNode,
      ),
    );
  }

  Widget makeBody(
    BuildContext context,
    Unp4kcState state,
    Unp4kCModel model,
    List<AppUnp4kP4kItemData>? files,
    List<String> paths,
    TextEditingController pathController,
    ValueNotifier<bool> isPathEditing,
    FocusNode pathFocusNode,
  ) {
    if (state.errorMessage.isNotEmpty) {
      return UnP4kErrorWidget(errorMessage: state.errorMessage);
    }
    return state.files == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 420,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.loadingTotal > 0) ...[
                          ProgressBar(
                            value:
                                (state.loadingCurrent / state.loadingTotal) *
                                100,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${state.loadingCurrent}/${state.loadingTotal} (${((state.loadingCurrent / state.loadingTotal) * 100).toStringAsFixed(1)}%)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: .75),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          makeLoading(context),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (state.endMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${state.endMessage}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          )
        : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FluentTheme.of(
                        context,
                      ).cardColor.withValues(alpha: .06),
                    ),
                    height: 36,
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      children: [
                        // 搜索模式下显示返回按钮
                        if (state.searchMatchedFiles != null) ...[
                          IconButton(
                            icon: const Icon(FluentIcons.back, size: 14),
                            onPressed: () {
                              model.clearSearch();
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "[${S.current.tools_unp4k_searching.replaceAll('...', '')}]",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: .7),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        IconButton(
                          icon: const Icon(FluentIcons.back, size: 14),
                          onPressed: model.canGoBackPath()
                              ? () {
                                  model.goBackPath();
                                }
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(FluentIcons.forward, size: 14),
                          onPressed: model.canGoForwardPath()
                              ? () {
                                  model.goForwardPath();
                                }
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: isPathEditing.value
                              ? TextBox(
                                  controller: pathController,
                                  focusNode: pathFocusNode,
                                  placeholder: r"\data\...",
                                  autofocus: true,
                                  onSubmitted: (value) {
                                    final normalized = _normalizeInputPath(
                                      value,
                                    );
                                    final ok = model.changeDirValidated(
                                      normalized,
                                      fullPath: true,
                                    );
                                    if (ok) {
                                      isPathEditing.value = false;
                                    }
                                  },
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          isPathEditing.value = true;
                                        },
                                        child: SuperListView.builder(
                                          itemCount: paths.length - 1,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder:
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                var path = paths[index];
                                                if (path.isEmpty) {
                                                  path = "\\";
                                                }
                                                final fullPath =
                                                    "${paths.sublist(0, index + 1).join("\\")}\\";
                                                return Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Text(path),
                                                      onPressed: () {
                                                        model
                                                            .changeDirValidated(
                                                              fullPath,
                                                              fullPath: true,
                                                            );
                                                      },
                                                    ),
                                                    const Icon(
                                                      FluentIcons.chevron_right,
                                                      size: 12,
                                                    ),
                                                  ],
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: _FileListPanel(
                            state: state,
                            model: model,
                            files: files,
                          ),
                        ),
                        Expanded(
                          child: state.tempOpenFile == null
                              ? Center(
                                  child: Text(S.current.tools_unp4k_view_file),
                                )
                              : state.tempOpenFile?.key == "loading"
                              ? makeLoading(context)
                              : Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      if (state.tempOpenFile?.key == "text")
                                        Expanded(
                                          child: _TextTempWidget(
                                            state.tempOpenFile?.value ?? "",
                                          ),
                                        )
                                      else if (state.tempOpenFile?.key ==
                                          "image")
                                        Expanded(
                                          child: _ImageTempWidget(
                                            state.tempOpenFile?.value ?? "",
                                          ),
                                        )
                                      else if (state.tempOpenFile?.key ==
                                          "audio")
                                        Expanded(
                                          child: _AudioTempWidget(
                                            state.tempOpenFile?.value ?? "",
                                          ),
                                        )
                                      else
                                        Expanded(
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  S.current
                                                      .tools_unp4k_msg_unknown_file_type(
                                                        state
                                                                .tempOpenFile
                                                                ?.value ??
                                                            "",
                                                      ),
                                                ),
                                                const SizedBox(height: 32),
                                                FilledButton(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Text(
                                                      S
                                                          .current
                                                          .action_open_folder,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    SystemHelper.openDir(
                                                      state
                                                              .tempOpenFile
                                                              ?.value ??
                                                          "",
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  if (state.endMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${state.endMessage}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              // 搜索加载遮罩
              if (state.isSearching)
                Container(
                  color: Colors.black.withValues(alpha: .7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ProgressRing(),
                        const SizedBox(height: 16),
                        Text(
                          S.current.tools_unp4k_searching,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
  }

  String _normalizeInputPath(String value) {
    var path = value.trim().replaceAll("/", "\\");
    if (path.isEmpty) return "\\";
    if (!path.startsWith("\\")) {
      path = "\\$path";
    }
    if (!path.endsWith("\\")) {
      path = "$path\\";
    }
    return path;
  }

  Future<bool> _confirmExitToHome(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return ContentDialog(
          title: const Text("返回首页"),
          content: const Text("退出后需要重新加载 P4K，确认返回首页吗？"),
          actions: [
            Button(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(S.current.home_action_cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text("确认返回"),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}

/// 文件列表面板组件
class _FileListPanel extends HookConsumerWidget {
  final Unp4kcState state;
  final Unp4kCModel model;
  final List<AppUnp4kP4kItemData>? files;

  const _FileListPanel({
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
          // 搜索栏和排序选择器
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
          // 多选模式工具栏
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
          // 文件列表
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
                      return _FileListItem(
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

    final options = await showDialog<_BatchExportOptions>(
      context: context,
      builder: (dialogContext) {
        return _BatchExportOptionsDialog(hasConvertible: hasConvertible);
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
        return _AdvancedExportProgressDialog(
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

/// 文件列表项组件
class _FileListItem extends HookWidget {
  final AppUnp4kP4kItemData item;
  final Unp4kcState state;
  final Unp4kCModel model;

  const _FileListItem({
    required this.item,
    required this.state,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final flyoutController = useMemoized(() => FlyoutController());
    final fullPath = item.name ?? "?";
    final isFlatResultMode =
        state.searchMatchedFiles != null ||
        (state.searchQuery.trim().isEmpty &&
            state.suffixFilter.trim().isNotEmpty);
    final normalized = fullPath.replaceAll("/", "\\");
    final lowerPath = normalized.toLowerCase();
    final lastSep = normalized.lastIndexOf("\\");
    final baseName = lastSep >= 0
        ? normalized.substring(lastSep + 1)
        : normalized;
    final parentPath = lastSep > 0 ? normalized.substring(0, lastSep) : "\\";
    // 非搜索模式显示相对当前目录；搜索模式标题显示文件名
    final fileName = isFlatResultMode
        ? baseName
        : (item.name?.replaceAll(state.curPath.trim(), "") ?? "?");
    final itemPath = item.name ?? "";
    final isSelected = state.selectedItems.contains(itemPath);
    final isPreviewing = state.currentPreviewPath == itemPath;

    return FlyoutTarget(
      controller: flyoutController,
      child: GestureDetector(
        onSecondaryTapUp: (details) =>
            _showContextMenu(context, flyoutController),
        child: Container(
          margin: const EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? FluentTheme.of(context).accentColor.withValues(alpha: .2)
                : isPreviewing
                ? FluentTheme.of(context).accentColor.withValues(alpha: .12)
                : FluentTheme.of(context).cardColor.withValues(alpha: .05),
          ),
          child: IconButton(
            onPressed: () {
              if (state.isMultiSelectMode) {
                // 多选模式下点击切换选中状态
                model.toggleSelectItem(itemPath);
              } else if (item.isDirectory ?? false) {
                final dirName =
                    item.name?.replaceAll(state.curPath.trim(), "") ?? "";
                model.changeDir(dirName);
              } else {
                model.openFile(item.name ?? "", context: context);
              }
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Row(
                children: [
                  // 多选模式下显示复选框
                  if (state.isMultiSelectMode) ...[
                    Checkbox(
                      checked: isSelected,
                      onChanged: (value) {
                        model.toggleSelectItem(itemPath);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (item.isDirectory ?? false)
                    const Icon(
                      FluentIcons.folder_fill,
                      color: Color.fromRGBO(255, 224, 138, 1),
                    )
                  else if (_isConvertibleModel(lowerPath))
                    const Icon(FluentIcons.cube_shape)
                  else if (_isConvertibleAudio(lowerPath))
                    const Icon(FluentIcons.volume3)
                  else if (_isConvertibleDds(lowerPath))
                    const Icon(FluentIcons.picture)
                  else if (fileName.endsWith(".xml"))
                    const Icon(FluentIcons.file_code)
                  else
                    const Icon(FluentIcons.open_file),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                fileName,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        if (isFlatResultMode) ...[
                          const SizedBox(height: 1),
                          Text(
                            parentPath,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: .55),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (!(item.isDirectory ?? true)) ...[
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              Text(
                                FileSize.getSize(item.size),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: .6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.dateModified != null
                                    ? DateTime.fromMillisecondsSinceEpoch(
                                        item.dateModified!,
                                      ).toString().substring(0, 19)
                                    : "",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: .6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    FluentIcons.chevron_right,
                    size: 14,
                    color: Colors.white.withValues(alpha: .6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isConvertibleModel(String lowerPath) {
    return lowerPath.endsWith(".cgf") || lowerPath.endsWith(".cga");
  }

  bool _isConvertibleAudio(String lowerPath) {
    return lowerPath.endsWith(".wem");
  }

  bool _isConvertibleDds(String lowerPath) {
    return (lowerPath.endsWith(".dds") ||
            RegExp(r"\.dds\.\d+$").hasMatch(lowerPath)) &&
        !RegExp(r"_ddna\.dds(\.\d+)?$").hasMatch(lowerPath);
  }

  void _showContextMenu(BuildContext context, FlyoutController controller) {
    // 保存外部 context，因为 flyout 的 context 在关闭后会失效
    final outerContext = context;
    controller.showFlyout(
      autoModeConfiguration: FlyoutAutoConfiguration(
        preferredMode: FlyoutPlacementMode.bottomCenter,
      ),
      barrierColor: Colors.transparent,
      builder: (flyoutContext) {
        return MenuFlyout(
          items: [
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.save_as, size: 16),
              text: Text(S.current.tools_unp4k_action_save_as),
              onPressed: () async {
                Navigator.of(flyoutContext).pop();
                await _saveAs(outerContext);
              },
            ),
            if (_isWemFile(item.name ?? ""))
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.volume3, size: 16),
                text: const Text("导出 WAV"),
                onPressed: () async {
                  Navigator.of(flyoutContext).pop();
                  await _exportWav(outerContext);
                },
              ),
            if (_canConvertToGlb(item.name ?? ""))
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.export, size: 16),
                text: Text(S.current.tools_unp4k_action_convert_glb),
                onPressed: () async {
                  Navigator.of(flyoutContext).pop();
                  await _convertToGlb(outerContext);
                },
              ),
            if (_canConvertDdsToPng(item.name ?? ""))
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.picture, size: 16),
                text: const Text("DDS 转 PNG"),
                onPressed: () async {
                  Navigator.of(flyoutContext).pop();
                  await _convertDdsToPng(outerContext);
                },
              ),
            if (state.searchMatchedFiles != null)
              MenuFlyoutItem(
                leading: const Icon(
                  FluentIcons.open_folder_horizontal,
                  size: 16,
                ),
                text: const Text("跳转到文件位置"),
                onPressed: () {
                  Navigator.of(flyoutContext).pop();
                  model.jumpToFileLocation(item.name ?? "");
                },
              ),
            // 多选模式切换
            if (!state.isMultiSelectMode)
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.checkbox_composite, size: 16),
                text: Text(S.current.tools_unp4k_action_multi_select),
                onPressed: () {
                  Navigator.of(flyoutContext).pop();
                  model.enterMultiSelectMode();
                  // 自动选中当前项
                  model.toggleSelectItem(item.name ?? "");
                },
              ),
          ],
        );
      },
    );
  }

  bool _canConvertToGlb(String fullPath) {
    if ((item.isDirectory ?? false)) return false;
    final lower = fullPath.toLowerCase();
    return lower.endsWith('.cgf') || lower.endsWith('.cga');
  }

  bool _canConvertDdsToPng(String fullPath) {
    if ((item.isDirectory ?? false)) return false;
    final lower = fullPath.toLowerCase();
    return lower.endsWith('.dds') || RegExp(r"\.dds\.\d+$").hasMatch(lower);
  }

  bool _isWemFile(String fullPath) {
    if (item.isDirectory ?? false) return false;
    return fullPath.toLowerCase().endsWith('.wem');
  }

  Future<void> _saveAs(BuildContext context) async {
    final outputDir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: S.current.tools_unp4k_action_save_as,
    );
    if (outputDir != null && context.mounted) {
      await _showExtractProgressDialog(context, outputDir);
    }
  }

  Future<void> _showExtractProgressDialog(
    BuildContext context,
    String outputDir,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ExtractProgressDialog(
          item: item,
          outputDir: outputDir,
          model: model,
        );
      },
    );
  }

  Future<void> _convertToGlb(BuildContext context) async {
    final outputDir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: S.current.tools_unp4k_action_convert_glb,
    );
    if (outputDir != null && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return _ConvertProgressDialog(
            filePath: item.name ?? '',
            outputDir: outputDir,
            model: model,
          );
        },
      );
    }
  }

  Future<void> _exportWav(BuildContext context) async {
    try {
      var p4kPath = item.name ?? "";
      if (p4kPath.isEmpty) return;
      var sourceName = p4kPath.split("\\").last;
      if (sourceName.isEmpty) sourceName = "audio.wem";
      final wavName = sourceName.toLowerCase().endsWith(".wem")
          ? "${sourceName.substring(0, sourceName.length - 4)}.wav"
          : "$sourceName.wav";

      final outputPath = await FilePicker.platform.saveFile(
        dialogTitle: "导出 WAV",
        fileName: wavName,
        type: FileType.custom,
        allowedExtensions: const ["wav"],
      );
      if (outputPath == null) return;

      if (p4kPath.startsWith("\\")) {
        p4kPath = p4kPath.substring(1);
      }
      final tempDir = await getTemporaryDirectory();
      final tempRoot =
          "${tempDir.absolute.path}\\SCToolbox_unp4kc\\${SCLoggerHelper.getGameChannelID(model.getGamePath())}\\";
      final extractedWemPath = "$tempRoot$p4kPath";
      final cachedWavPath = "$extractedWemPath.preview.v2.wav";

      final outFile = File(outputPath);
      await outFile.parent.create(recursive: true);

      final cachedWavFile = File(cachedWavPath);
      if (await cachedWavFile.exists()) {
        final stat = await cachedWavFile.stat();
        if (stat.size > 44) {
          await cachedWavFile.copy(outputPath);
          if (!context.mounted) return;
          await displayInfoBar(
            context,
            builder: (ctx, close) {
              return InfoBar(
                title: const Text("WAV 导出成功"),
                content: Text("${outFile.path}\n(来自缓存)"),
                severity: InfoBarSeverity.success,
                onClose: close,
              );
            },
          );
          return;
        }
      }

      final wemBytes = await unp4k_api.p4KExtractToMemory(filePath: p4kPath);
      final exportTempDir = Directory(
        "${Directory.systemTemp.path}\\SCToolbox_unp4kc_export",
      );
      await exportTempDir.create(recursive: true);
      final tempWemPath =
          "${exportTempDir.path}\\${DateTime.now().microsecondsSinceEpoch}_${sourceName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')}";
      final tempWemFile = File(tempWemPath);
      await tempWemFile.writeAsBytes(wemBytes, flush: true);
      try {
        await unp4k_api.p4KDecodeWemToWav(
          inputPath: tempWemPath,
          outputPath: outputPath,
        );
      } finally {
        if (await tempWemFile.exists()) {
          await tempWemFile.delete();
        }
      }

      if (!context.mounted) return;
      await displayInfoBar(
        context,
        builder: (ctx, close) {
          return InfoBar(
            title: const Text("WAV 导出成功"),
            content: Text(outFile.path),
            severity: InfoBarSeverity.success,
            onClose: close,
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      await displayInfoBar(
        context,
        builder: (ctx, close) {
          return InfoBar(
            title: const Text("WAV 导出失败"),
            content: Text(e.toString()),
            severity: InfoBarSeverity.error,
            onClose: close,
          );
        },
      );
    }
  }

  Future<void> _convertDdsToPng(BuildContext context) async {
    final outputDir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "DDS 转 PNG",
    );
    if (outputDir == null || !context.mounted) return;

    final (success, outputPath, error) = await model.convertDdsToPng(
      item.name ?? '',
      outputDir,
    );

    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: Text(success ? "转换成功" : "转换失败"),
        content: Text(
          success ? (outputPath ?? outputDir) : (error ?? "Unknown"),
        ),
        actions: [
          if (success)
            Button(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                SystemHelper.openDir(outputDir);
              },
              child: Text(S.current.action_open_folder),
            ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(S.current.action_close),
          ),
        ],
      ),
    );
  }
}

/// 提取进度对话框
class _ExtractProgressDialog extends HookWidget {
  final AppUnp4kP4kItemData item;
  final String outputDir;
  final Unp4kCModel model;

  const _ExtractProgressDialog({
    required this.item,
    required this.outputDir,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isCancelled = useState(false);
    final currentFile = useState("");
    final currentIndex = useState(0);
    final totalFiles = useState(0);
    final isCompleted = useState(false);
    final errorMessage = useState<String?>(null);
    final extractedCount = useState(0);

    useEffect(() {
      // 获取文件数量
      totalFiles.value = model.getFileCountInDirectory(item);

      // 开始提取
      _startExtraction(
        isCancelled,
        currentFile,
        currentIndex,
        totalFiles,
        isCompleted,
        errorMessage,
        extractedCount,
      );
      return null;
    }, const []);

    final progress = totalFiles.value > 0
        ? currentIndex.value / totalFiles.value
        : 0.0;

    return ContentDialog(
      title: Text(S.current.tools_unp4k_extract_dialog_title),
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 300),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCompleted.value && errorMessage.value == null) ...[
            // 进度条
            ProgressBar(value: progress * 100),
            const SizedBox(height: 12),
            // 进度文本
            Text(
              S.current.tools_unp4k_extract_progress(
                currentIndex.value,
                totalFiles.value,
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            // 当前文件
            Text(
              S.current.tools_unp4k_extract_current_file(
                currentFile.value.length > 60
                    ? "...${currentFile.value.substring(currentFile.value.length - 60)}"
                    : currentFile.value,
              ),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: .7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (errorMessage.value != null) ...[
            // 错误信息
            const Icon(
              FluentIcons.error_badge,
              size: 48,
              color: Color(0xFFE81123),
            ),
            const SizedBox(height: 12),
            Text(errorMessage.value!, style: const TextStyle(fontSize: 14)),
          ] else ...[
            // 完成
            const Icon(
              FluentIcons.completed_solid,
              size: 48,
              color: Color(0xFF107C10),
            ),
            const SizedBox(height: 12),
            Text(
              S.current.tools_unp4k_extract_completed(extractedCount.value),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ],
      ),
      actions: [
        if (!isCompleted.value && errorMessage.value == null)
          Button(
            onPressed: () {
              isCancelled.value = true;
            },
            child: Text(S.current.home_action_cancel),
          )
        else
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.current.action_close),
          ),
      ],
    );
  }

  Future<void> _startExtraction(
    ValueNotifier<bool> isCancelled,
    ValueNotifier<String> currentFile,
    ValueNotifier<int> currentIndex,
    ValueNotifier<int> totalFiles,
    ValueNotifier<bool> isCompleted,
    ValueNotifier<String?> errorMessage,
    ValueNotifier<int> extractedCount,
  ) async {
    final result = await model.extractToDirectoryWithProgress(
      item,
      outputDir,
      onProgress: (current, total, file) {
        currentIndex.value = current;
        totalFiles.value = total;
        currentFile.value = file;
      },
      isCancelled: () => isCancelled.value,
    );

    final (success, count, error) = result;
    extractedCount.value = count;

    if (!success && error != null) {
      errorMessage.value = error;
    } else {
      isCompleted.value = true;
    }
  }
}

class _BatchExportOptions {
  final bool convertWhenPossible;
  final bool includePath;

  const _BatchExportOptions({
    required this.convertWhenPossible,
    required this.includePath,
  });
}

class _BatchExportOptionsDialog extends HookWidget {
  final bool hasConvertible;

  const _BatchExportOptionsDialog({required this.hasConvertible});

  @override
  Widget build(BuildContext context) {
    final convert = useState(hasConvertible);
    final includePath = useState(true);
    return ContentDialog(
      title: const Text("批量导出选项"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasConvertible)
            ToggleSwitch(
              checked: convert.value,
              onChanged: (v) => convert.value = v,
              content: const Text(
                "可转换格式自动转换导出（WEM->WAV, DDS->PNG, CGA/CGF->GLB）",
              ),
            )
          else
            const Text("当前选择中没有可转换格式，将按原文件导出。"),
          const SizedBox(height: 8),
          ToggleSwitch(
            checked: includePath.value,
            onChanged: (v) => includePath.value = v,
            content: const Text("保留目录结构导出"),
          ),
          const SizedBox(height: 4),
          Text(
            includePath.value ? "导出时包含原始路径。" : "直接按文件名导出；单文件时将直接选择保存文件。",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: .7),
            ),
          ),
        ],
      ),
      actions: [
        Button(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.home_action_cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              _BatchExportOptions(
                convertWhenPossible: hasConvertible ? convert.value : false,
                includePath: includePath.value,
              ),
            );
          },
          child: const Text("开始导出"),
        ),
      ],
    );
  }
}

class _AdvancedExportProgressDialog extends HookWidget {
  final List<String> filesToExport;
  final String? outputDir;
  final String? singleOutputPath;
  final _BatchExportOptions options;
  final Unp4kCModel model;

  const _AdvancedExportProgressDialog({
    required this.filesToExport,
    required this.outputDir,
    required this.singleOutputPath,
    required this.options,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isCancelled = useState(false);
    final currentFile = useState("");
    final currentIndex = useState(0);
    final totalFiles = useState(filesToExport.length);
    final isCompleted = useState(false);
    final errorMessage = useState<String?>(null);
    final exportedCount = useState(0);

    useEffect(() {
      _startExport(
        isCancelled,
        currentFile,
        currentIndex,
        totalFiles,
        isCompleted,
        errorMessage,
        exportedCount,
      );
      return null;
    }, const []);

    final progress = totalFiles.value > 0
        ? currentIndex.value / totalFiles.value
        : 0.0;

    return ContentDialog(
      title: const Text("批量导出"),
      constraints: const BoxConstraints(maxWidth: 520, maxHeight: 320),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCompleted.value && errorMessage.value == null) ...[
            ProgressBar(value: progress * 100),
            const SizedBox(height: 12),
            Text("进度: ${currentIndex.value}/${totalFiles.value}"),
            const SizedBox(height: 8),
            Text(
              currentFile.value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: .7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (errorMessage.value != null) ...[
            const Icon(
              FluentIcons.error_badge,
              size: 48,
              color: Color(0xFFE81123),
            ),
            const SizedBox(height: 8),
            Text(errorMessage.value!),
          ] else ...[
            const Icon(
              FluentIcons.completed_solid,
              size: 48,
              color: Color(0xFF107C10),
            ),
            const SizedBox(height: 8),
            Text("导出完成，共 ${exportedCount.value} 个文件"),
          ],
        ],
      ),
      actions: [
        if (!isCompleted.value && errorMessage.value == null)
          Button(
            onPressed: () => isCancelled.value = true,
            child: Text(S.current.home_action_cancel),
          )
        else ...[
          if ((outputDir ?? "").isNotEmpty)
            Button(
              onPressed: () {
                Navigator.of(context).pop();
                SystemHelper.openDir(outputDir!);
              },
              child: Text(S.current.action_open_folder),
            ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.current.action_close),
          ),
        ],
      ],
    );
  }

  Future<void> _startExport(
    ValueNotifier<bool> isCancelled,
    ValueNotifier<String> currentFile,
    ValueNotifier<int> currentIndex,
    ValueNotifier<int> totalFiles,
    ValueNotifier<bool> isCompleted,
    ValueNotifier<String?> errorMessage,
    ValueNotifier<int> exportedCount,
  ) async {
    try {
      final usedNames = <String, int>{};
      final jobs = <_ExportJob>[];
      for (final src in filesToExport) {
        final outPath = await _buildOutputPath(src, usedNames);
        jobs.add(_ExportJob(sourcePath: src, outputPath: outPath));
      }

      totalFiles.value = jobs.length;
      final workerCount = _computeWorkerCount(jobs.length);
      var nextJobIndex = 0;
      Object? firstError;
      StackTrace? firstStack;

      Future<void> workerLoop() async {
        while (true) {
          if (isCancelled.value || firstError != null) return;
          if (nextJobIndex >= jobs.length) return;

          final job = jobs[nextJobIndex];
          nextJobIndex += 1;
          currentFile.value = job.sourcePath;

          try {
            await _exportOne(job.sourcePath, job.outputPath);
            exportedCount.value = exportedCount.value + 1;
            currentIndex.value = exportedCount.value;
          } catch (e, st) {
            firstError ??= e;
            firstStack ??= st;
            return;
          }
        }
      }

      await Future.wait(List.generate(workerCount, (_) => workerLoop()));

      if (isCancelled.value) {
        errorMessage.value = S.current.tools_unp4k_extract_cancelled;
        return;
      }
      if (firstError != null) {
        errorMessage.value = firstStack == null
            ? firstError.toString()
            : "$firstError\n$firstStack";
        return;
      }

      isCompleted.value = true;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  int _computeWorkerCount(int totalJobs) {
    if (totalJobs <= 1) return 1;
    final cpuBased = (Platform.numberOfProcessors / 2).ceil();
    final preferred = cpuBased.clamp(2, 6);
    return totalJobs < preferred ? totalJobs : preferred;
  }

  Future<void> _exportOne(String sourcePath, String outputPath) async {
    final lower = sourcePath.toLowerCase();
    final normalized = _normalizeP4kPath(sourcePath);
    final outFile = File(outputPath);
    await outFile.parent.create(recursive: true);

    if (options.convertWhenPossible && lower.endsWith(".wem")) {
      final cached = await _tryLoadCachedWav(normalized);
      if (cached != null) {
        await outFile.writeAsBytes(cached, flush: true);
        return;
      }
      final wemBytes = await unp4k_api.p4KExtractToMemory(filePath: normalized);
      final tempDir = Directory(
        "${Directory.systemTemp.path}\\SCToolbox_unp4kc_export",
      );
      await tempDir.create(recursive: true);
      final safeName = normalized.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final tempWem = File(
        "${tempDir.path}\\${DateTime.now().microsecondsSinceEpoch}_$safeName.wem",
      );
      await tempWem.writeAsBytes(wemBytes, flush: true);
      try {
        await unp4k_api.p4KDecodeWemToWav(
          inputPath: tempWem.path,
          outputPath: outputPath,
        );
      } finally {
        if (await tempWem.exists()) {
          await tempWem.delete();
        }
      }
      return;
    }

    if (options.convertWhenPossible &&
        (lower.endsWith(".dds") || RegExp(r"\.dds\.\d+$").hasMatch(lower)) &&
        !RegExp(r"_ddna\.dds(\.\d+)?$").hasMatch(lower)) {
      final png = await unp4k_api.p4KPreviewImagePng(filePath: normalized);
      await outFile.writeAsBytes(png, flush: true);
      return;
    }

    if (options.convertWhenPossible &&
        (lower.endsWith(".cgf") || lower.endsWith(".cga"))) {
      final (success, glbPath, error) = await model.convertModelToGlb(
        sourcePath,
        outFile.parent.path,
      );
      if (!success || glbPath == null || glbPath.isEmpty) {
        throw Exception(error ?? "GLB conversion failed");
      }
      final produced = File(glbPath);
      if (!await produced.exists()) {
        throw Exception("GLB output missing: $glbPath");
      }
      final samePath =
          produced.absolute.path.toLowerCase() ==
          outFile.absolute.path.toLowerCase();
      if (!samePath) {
        if (await outFile.exists()) {
          await outFile.delete();
        }
        await produced.copy(outFile.path);
      }
      return;
    }

    final data = await unp4k_api.p4KExtractToMemory(filePath: normalized);
    await outFile.writeAsBytes(data, flush: true);
  }

  Future<Uint8List?> _tryLoadCachedWav(String normalizedNoLeading) async {
    final tempDir = await getTemporaryDirectory();
    final tempRoot =
        "${tempDir.absolute.path}\\SCToolbox_unp4kc\\${SCLoggerHelper.getGameChannelID(model.getGamePath())}\\";
    final cachedPath = "$tempRoot$normalizedNoLeading.preview.v2.wav";
    final file = File(cachedPath);
    if (!await file.exists()) return null;
    final stat = await file.stat();
    if (stat.size <= 44) return null;
    return file.readAsBytes();
  }

  Future<String> _buildOutputPath(
    String sourcePath,
    Map<String, int> usedNames,
  ) async {
    if (singleOutputPath != null) return singleOutputPath!;
    final dir = outputDir!;
    final relative = _buildRelativeOutputPath(sourcePath);
    final safeRelative = options.includePath
        ? relative
        : relative.split("\\").last;
    var candidate = "$dir\\$safeRelative";
    if (options.includePath) {
      return candidate;
    }
    final lower = candidate.toLowerCase();
    final n = usedNames[lower] ?? 0;
    if (n == 0) {
      usedNames[lower] = 1;
      return candidate;
    }
    final dot = candidate.lastIndexOf(".");
    final withIndex = dot > 0
        ? "${candidate.substring(0, dot)}_${n + 1}${candidate.substring(dot)}"
        : "${candidate}_${n + 1}";
    usedNames[lower] = n + 1;
    return withIndex;
  }

  String _buildRelativeOutputPath(String sourcePath) {
    final normalized = sourcePath.startsWith("\\")
        ? sourcePath.substring(1)
        : sourcePath;
    if (!options.convertWhenPossible) return normalized;
    final lower = normalized.toLowerCase();
    if (lower.endsWith(".wem")) {
      return "${normalized.substring(0, normalized.length - 4)}.wav";
    }
    final ddsChain = lower.indexOf(".dds.");
    if (ddsChain != -1) {
      return "${normalized.substring(0, ddsChain)}.png";
    }
    if (lower.endsWith(".dds") && !RegExp(r"_ddna\.dds$").hasMatch(lower)) {
      return "${normalized.substring(0, normalized.length - 4)}.png";
    }
    if (lower.endsWith(".cgf") || lower.endsWith(".cga")) {
      return "${normalized.substring(0, normalized.length - 4)}.glb";
    }
    return normalized;
  }

  String _normalizeP4kPath(String filePath) {
    var p = filePath;
    if (p.startsWith("\\")) {
      p = p.substring(1);
    }
    return p;
  }
}

class _ExportJob {
  final String sourcePath;
  final String outputPath;

  const _ExportJob({required this.sourcePath, required this.outputPath});
}

/// 模型转换进度对话框
class _ConvertProgressDialog extends HookWidget {
  final String filePath;
  final String outputDir;
  final Unp4kCModel model;

  const _ConvertProgressDialog({
    required this.filePath,
    required this.outputDir,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = useState(true);
    final errorMessage = useState<String?>(null);
    final resultPath = useState<String?>(null);

    useEffect(() {
      _startConversion(isRunning, errorMessage, resultPath);
      return null;
    }, const []);

    return ContentDialog(
      title: Text(S.current.tools_unp4k_action_convert_glb),
      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 260),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRunning.value) ...[
              const ProgressRing(),
              const SizedBox(height: 12),
              Text(
                S.current.tools_unp4k_convert_in_progress,
                style: const TextStyle(fontSize: 14),
              ),
            ] else if (errorMessage.value != null) ...[
              const Icon(
                FluentIcons.error_badge,
                size: 48,
                color: Color(0xFFE81123),
              ),
              const SizedBox(height: 16),
              Text(
                S.current.tools_unp4k_convert_failed(errorMessage.value!),
                style: const TextStyle(fontSize: 14),
              ),
            ] else ...[
              const Icon(
                FluentIcons.completed_solid,
                size: 48,
                color: Color(0xFF107C10),
              ),
              const SizedBox(height: 16),
              Text(
                S.current.tools_unp4k_convert_success,
                style: const TextStyle(fontSize: 14),
              ),
              if ((resultPath.value ?? outputDir).isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  resultPath.value ?? outputDir,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: .65),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        if (!isRunning.value && errorMessage.value == null)
          Button(
            onPressed: () {
              SystemHelper.openDir(outputDir);
            },
            child: Text(S.current.action_open_folder),
          ),
        FilledButton(
          onPressed: isRunning.value ? null : () => Navigator.of(context).pop(),
          child: Text(S.current.action_close),
        ),
      ],
    );
  }

  Future<void> _startConversion(
    ValueNotifier<bool> isRunning,
    ValueNotifier<String?> errorMessage,
    ValueNotifier<String?> resultPath,
  ) async {
    final result = await model.convertModelToGlb(filePath, outputDir);
    final (success, glbPath, error) = result;
    resultPath.value = glbPath;
    if (!success) {
      errorMessage.value = error ?? "Unknown error";
    }
    isRunning.value = false;
  }
}

class _TextTempWidget extends HookConsumerWidget {
  final String filePath;

  const _TextTempWidget(this.filePath);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textData = useState<String?>(null);

    useEffect(() {
      File(filePath).readAsBytes().then((data) {
        // 处理可能的 BOM
        if (data.length > 3 &&
            data[0] == 0xEF &&
            data[1] == 0xBB &&
            data[2] == 0xBF) {
          data = data.sublist(3);
        }
        final text = utf8.decode(data, allowMalformed: true);
        textData.value = text;
      });
      return null;
    }, const []);

    if (textData.value == null) return makeLoading(context);

    return CodeEditor(
      controller: CodeLineEditingController.fromText('${textData.value}'),
      readOnly: true,
    );
  }
}

class _ImageTempWidget extends HookWidget {
  final String filePath;

  const _ImageTempWidget(this.filePath);

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);
    if (!file.existsSync()) {
      return Center(
        child: Text(
          S.current.tools_unp4k_msg_unknown_file_type(filePath),
          textAlign: TextAlign.center,
        ),
      );
    }

    return InteractiveViewer(
      minScale: 0.1,
      maxScale: 8,
      child: Center(
        child: Image.file(
          file,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Text(
              S.current.tools_unp4k_msg_unknown_file_type(filePath),
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}

class _AudioTempWidget extends HookWidget {
  final String filePath;

  const _AudioTempWidget(this.filePath);

  @override
  Widget build(BuildContext context) {
    final player = useMemoized(() => RustAudioPlayer());
    final duration = useState(Duration.zero);
    final position = useState(Duration.zero);
    final isPlaying = useState(false);
    final isPaused = useState(false);
    final waveform = useState<List<double>>([]);
    final dragMs = useState<double?>(null);
    final dragVolume = useState<double?>(null);
    final volume = useState(_audioLastVolume.clamp(0.0, 3.0));
    final estimatedDuration = useState(Duration.zero);
    final playablePath = useState<String?>(null);
    final errorMessage = useState<String?>(null);
    final isPreparing = useState(true);
    final isPreviewMode = useState(false);
    final isFullDecodeInProgress = useState(false);
    final previewTip = useState<String?>(null);
    final prepareTokenRef = useRef<int>(0);
    final pollTimerRef = useRef<Timer?>(null);
    final seekRequestRef = useRef<int>(0);

    void syncPlayerState(AudioPlaybackState state) {
      if (state.durationMs != null) {
        duration.value = Duration(milliseconds: state.durationMs!);
      }
      position.value = Duration(milliseconds: state.positionMs);
      isPlaying.value = state.isPlaying;
      isPaused.value = state.isPaused;
      volume.value = state.volume;
    }

    useEffect(() {
      var disposed = false;
      final currentToken = ++prepareTokenRef.value;
      pollTimerRef.value?.cancel();
      pollTimerRef.value = Timer.periodic(const Duration(milliseconds: 200), (
        _,
      ) async {
        if (disposed) return;
        try {
          final state = await player.refresh();
          if (disposed || prepareTokenRef.value != currentToken) return;
          syncPlayerState(state);
        } catch (e) {
          if (disposed || prepareTokenRef.value != currentToken) return;
          errorMessage.value = _friendlyAudioError(e);
        }
      });

      () async {
        try {
          if (disposed) return;
          await unp4k_api.p4KCancelWemDecode();
          isPreparing.value = true;
          errorMessage.value = null;
          isPreviewMode.value = false;
          isFullDecodeInProgress.value = false;
          previewTip.value = null;
          final prepared = await _preparePlayableFile(filePath);
          if (disposed) return;
          if (prepareTokenRef.value != currentToken) return;
          playablePath.value = prepared.playPath;
          isPreviewMode.value = prepared.isPreviewMode;
          isFullDecodeInProgress.value = prepared.fullDecodeFuture != null;
          previewTip.value = prepared.fullDecodeFuture == null
              ? null
              : "预览模式：完整文件解码中";
          final cachedWaveform = _audioWaveformCache[prepared.playPath];
          if (cachedWaveform != null) {
            waveform.value = cachedWaveform;
          } else {
            final data = await File(prepared.playPath).readAsBytes();
            if (disposed) return;
            if (prepareTokenRef.value != currentToken) return;
            estimatedDuration.value = _estimateDurationFromAudioBytes(data);
            final computed = await compute(_computeWaveformFromBytes, data);
            if (disposed || prepareTokenRef.value != currentToken) return;
            _audioWaveformCache[prepared.playPath] = computed;
            waveform.value = computed;
          }
          try {
            final state = await player.refresh();
            if (!disposed && prepareTokenRef.value == currentToken) {
              syncPlayerState(state);
            }
          } catch (e) {
            if (!disposed && prepareTokenRef.value == currentToken) {
              errorMessage.value = _friendlyAudioError(e);
            }
          }
          if (prepared.fullDecodeFuture != null) {
            unawaited(() async {
              try {
                await prepared.fullDecodeFuture;
              } catch (_) {}
              if (disposed || prepareTokenRef.value != currentToken) return;
              isFullDecodeInProgress.value = false;
              isPreviewMode.value = false;
              previewTip.value = null;
              final fullPath = prepared.fullWavPath;
              if (fullPath == null || !await File(fullPath).exists()) return;
              playablePath.value = fullPath;
              final cached = _audioWaveformCache[fullPath];
              if (cached != null) {
                waveform.value = cached;
                return;
              }
              final data = await File(fullPath).readAsBytes();
              if (disposed || prepareTokenRef.value != currentToken) return;
              estimatedDuration.value = _estimateDurationFromAudioBytes(data);
              final computed = await compute(_computeWaveformFromBytes, data);
              if (disposed || prepareTokenRef.value != currentToken) return;
              _audioWaveformCache[fullPath] = computed;
              waveform.value = computed;
            }());
          }
        } catch (e) {
          if (disposed) return;
          if (prepareTokenRef.value != currentToken) return;
          errorMessage.value = _friendlyAudioError(e);
        } finally {
          if (!disposed && prepareTokenRef.value == currentToken) {
            isPreparing.value = false;
          }
        }
      }();

      return () {
        disposed = true;
        pollTimerRef.value?.cancel();
        unawaited(unp4k_api.p4KCancelWemDecode());
        unawaited(player.dispose());
      };
    }, [filePath]);

    useEffect(() {
      final v = volume.value.clamp(0.0, 3.0);
      _audioLastVolume = v;
      unawaited(player.setVolume(v));
      return null;
    }, [volume.value]);

    if (isPreparing.value) {
      return makeLoading(context);
    }
    if (playablePath.value == null) {
      if (errorMessage.value != null) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB94A4A)),
                ),
                child: Text(
                  "音频预览失败：${errorMessage.value}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }
      return const Center(child: Text("音频预览失败：未找到可播放文件"));
    }

    final displayDuration = duration.value > estimatedDuration.value
        ? duration.value
        : estimatedDuration.value;
    final totalMs = displayDuration.inMilliseconds;
    final int currentMs = position.value.inMilliseconds.clamp(
      0,
      totalMs > 0 ? totalMs : 0,
    );
    final effectiveMs = dragMs.value ?? currentMs.toDouble();
    final progress = totalMs > 0
        ? (effectiveMs / totalMs).clamp(0.0, 1.0)
        : 0.0;
    final effectiveVolume = (dragVolume.value ?? volume.value).clamp(0.0, 3.0);

    Future<void> seekToPosition(
      int targetMs, {
      required bool resumeIfPlaying,
    }) async {
      final requestId = ++seekRequestRef.value;
      final clampedTargetMs = targetMs.clamp(0, totalMs);
      final previousPosition = position.value;
      position.value = Duration(milliseconds: clampedTargetMs);
      dragMs.value = clampedTargetMs.toDouble();

      try {
        final state = await player.seek(
          Duration(milliseconds: clampedTargetMs),
        );
        if (requestId != seekRequestRef.value) return;
        syncPlayerState(state);
        position.value = Duration(milliseconds: clampedTargetMs);
        if (resumeIfPlaying && state.isPaused) {
          final resumed = await player.resume();
          if (requestId != seekRequestRef.value) return;
          syncPlayerState(resumed);
          position.value = Duration(milliseconds: clampedTargetMs);
        }
      } catch (e) {
        if (requestId != seekRequestRef.value) return;
        position.value = previousPosition;
        errorMessage.value = e.toString();
      } finally {
        if (requestId == seekRequestRef.value) {
          dragMs.value = null;
        }
      }
    }

    Future<void> togglePlay() async {
      final sourcePath = playablePath.value;
      if (sourcePath == null) return;
      if (isPlaying.value) {
        try {
          final state = await player.pause();
          syncPlayerState(state);
        } catch (_) {}
        return;
      }
      final startAt = Duration(milliseconds: effectiveMs.round());
      try {
        final state = player.currentSourcePath == sourcePath && isPaused.value
            ? await player.resume()
            : await player.playFile(sourcePath, position: startAt);
        syncPlayerState(state);
      } catch (e) {
        errorMessage.value = e.toString();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (errorMessage.value != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF5A1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFB94A4A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    FluentIcons.error_badge,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "音频预览失败：${errorMessage.value}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Button(
                    onPressed: () => errorMessage.value = null,
                    child: const Text("关闭"),
                  ),
                ],
              ),
            ),
          ],
          if (isPreviewMode.value && isFullDecodeInProgress.value)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: .16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    previewTip.value ?? "预览模式：完整文件解码中",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: .9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const ProgressBar(),
                ],
              ),
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth <= 0
                    ? 1.0
                    : constraints.maxWidth;
                Offset? localOffsetFromGlobal(Offset globalPosition) {
                  final renderObject = context.findRenderObject();
                  if (renderObject is! RenderBox || !renderObject.hasSize) {
                    return null;
                  }
                  return renderObject.globalToLocal(globalPosition);
                }

                double dxToRatio(double dx) => (dx / width).clamp(0.0, 1.0);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) async {
                    if (totalMs <= 0) return;
                    final localPosition = localOffsetFromGlobal(
                      details.globalPosition,
                    );
                    if (localPosition == null) return;
                    final ratio = dxToRatio(localPosition.dx);
                    final target = (ratio * totalMs).round();
                    await seekToPosition(
                      target,
                      resumeIfPlaying: isPlaying.value,
                    );
                  },
                  onHorizontalDragStart: (details) {
                    if (totalMs <= 0) return;
                    final localPosition = localOffsetFromGlobal(
                      details.globalPosition,
                    );
                    if (localPosition == null) return;
                    dragMs.value = (dxToRatio(localPosition.dx) * totalMs)
                        .toDouble();
                  },
                  onHorizontalDragUpdate: (details) {
                    if (totalMs <= 0) return;
                    final localPosition = localOffsetFromGlobal(
                      details.globalPosition,
                    );
                    if (localPosition == null) return;
                    final ratio = dxToRatio(localPosition.dx);
                    dragMs.value = ratio * totalMs;
                  },
                  onHorizontalDragEnd: (_) async {
                    if (totalMs <= 0 || dragMs.value == null) return;
                    final target = dragMs.value!.round();
                    await seekToPosition(
                      target,
                      resumeIfPlaying: isPlaying.value,
                    );
                  },
                  onHorizontalDragCancel: () {
                    dragMs.value = null;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1B2434),
                          Color(0xFF111A27),
                          Color(0xFF0E1622),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .12),
                      ),
                    ),
                    child: CustomPaint(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _WaveformPainter(
                                samples: waveform.value,
                                progress: progress,
                                totalMs: totalMs,
                              ),
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
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _fmtDuration(Duration(milliseconds: effectiveMs.round())),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: .85),
                ),
              ),
              const Spacer(),
              Text(
                _fmtDuration(displayDuration),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: .7),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 4),
              Text(
                "${_fmtDuration(position.value)} / ${_fmtDuration(displayDuration)}",
                style: TextStyle(color: Colors.white.withValues(alpha: .75)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: GestureDetector(
              onTap: togglePlay,
              child: Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: FluentTheme.of(
                    context,
                  ).accentColor.withValues(alpha: .22),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .35),
                    width: 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isPlaying.value ? FluentIcons.pause : FluentIcons.play,
                  size: 20,
                  color: Colors.white.withValues(alpha: .96),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  effectiveVolume <= 0.001
                      ? FluentIcons.volume_disabled
                      : (effectiveVolume < 1.0
                            ? FluentIcons.volume1
                            : FluentIcons.volume3),
                  size: 14,
                ),
                onPressed: () async {
                  final target = effectiveVolume <= 0.001 ? 1.0 : 0.0;
                  volume.value = target;
                  final state = await player.setVolume(target);
                  syncPlayerState(state);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth <= 0
                        ? 1.0
                        : constraints.maxWidth;
                    Offset? localOffsetFromGlobal(Offset globalPosition) {
                      final renderObject = context.findRenderObject();
                      if (renderObject is! RenderBox || !renderObject.hasSize) {
                        return null;
                      }
                      return renderObject.globalToLocal(globalPosition);
                    }

                    double dxToRatio(double dx) => (dx / width).clamp(0.0, 1.0);

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (details) async {
                        final localPosition = localOffsetFromGlobal(
                          details.globalPosition,
                        );
                        if (localPosition == null) return;
                        final ratio = dxToRatio(localPosition.dx);
                        final v = ratio * 3.0;
                        dragVolume.value = v;
                        volume.value = v;
                        final state = await player.setVolume(v);
                        syncPlayerState(state);
                        dragVolume.value = null;
                      },
                      onHorizontalDragStart: (details) {
                        final localPosition = localOffsetFromGlobal(
                          details.globalPosition,
                        );
                        if (localPosition == null) return;
                        dragVolume.value = dxToRatio(localPosition.dx) * 3.0;
                      },
                      onHorizontalDragUpdate: (details) {
                        final localPosition = localOffsetFromGlobal(
                          details.globalPosition,
                        );
                        if (localPosition == null) return;
                        final ratio = dxToRatio(localPosition.dx);
                        dragVolume.value = ratio * 3.0;
                      },
                      onHorizontalDragEnd: (_) async {
                        if (dragVolume.value == null) return;
                        final v = dragVolume.value!.clamp(0.0, 3.0);
                        volume.value = v;
                        final state = await player.setVolume(v);
                        syncPlayerState(state);
                        dragVolume.value = null;
                      },
                      onHorizontalDragCancel: () {
                        dragVolume.value = null;
                      },
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: width * (effectiveVolume / 3.0),
                            decoration: BoxDecoration(
                              color: FluentTheme.of(
                                context,
                              ).accentColor.defaultBrushFor(Brightness.dark),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text("${(effectiveVolume * 100).round()}%"),
            ],
          ),
        ],
      ),
    );
  }

  Future<_PreparedPlayableFile> _preparePlayableFile(String sourcePath) async {
    final lower = sourcePath.toLowerCase();
    if (lower.endsWith(".wav") ||
        lower.endsWith(".mp3") ||
        lower.endsWith(".ogg") ||
        lower.endsWith(".flac") ||
        lower.endsWith(".m4a")) {
      return _PreparedPlayableFile(playPath: sourcePath);
    }

    if (lower.endsWith(".wem")) {
      final previewPath = "$sourcePath.preview.mid10s.v1.wav";
      final targetPath = "$sourcePath.preview.v2.wav";
      final sourceFile = File(sourcePath);
      final previewFile = File(previewPath);
      final targetFile = File(targetPath);
      final legacyPreviewOgg = File("$sourcePath.preview.mid10s.v1.ogg");
      final legacyTargetOgg = File("$sourcePath.preview.v2.ogg");
      String? previewDecodeError;
      String? fullDecodeError;

      Future<void> clearLegacyOggCache() async {
        for (final file in [legacyPreviewOgg, legacyTargetOgg]) {
          if (await file.exists()) {
            try {
              await file.delete();
            } catch (_) {}
          }
        }
      }

      await clearLegacyOggCache();

      bool isFreshCache(File f) {
        if (!f.existsSync()) return false;
        final srcStat = sourceFile.statSync();
        final outStat = f.statSync();
        return outStat.size > 0 &&
            (outStat.modified.isAfter(srcStat.modified) ||
                outStat.modified.isAtSameMomentAs(srcStat.modified));
      }

      Future<void>? warmupFullWavInBackground() {
        if (isFreshCache(targetFile)) return null;
        final existing = _wemFullDecodeInFlight[targetPath];
        if (existing != null) return existing;
        final task = () async {
          try {
            await unp4k_api.p4KDecodeWemToWav(
              inputPath: sourcePath,
              outputPath: targetPath,
            );
          } catch (e) {
            fullDecodeError ??= e.toString();
            rethrow;
          } finally {
            _wemFullDecodeInFlight.remove(targetPath);
          }
        }();
        _wemFullDecodeInFlight[targetPath] = task;
        return task;
      }

      if (isFreshCache(targetFile)) {
        return _PreparedPlayableFile(playPath: targetPath);
      }

      if (isFreshCache(previewFile)) {
        final fullTask = warmupFullWavInBackground();
        return _PreparedPlayableFile(
          playPath: previewPath,
          isPreviewMode: fullTask != null,
          fullWavPath: targetPath,
          fullDecodeFuture: fullTask,
        );
      }

      // 预览优先：直接生成中段10秒 clip（估算时长后取中段）
      try {
        await unp4k_api.p4KDecodeWemToWavPreview(
          inputPath: sourcePath,
          outputPath: previewPath,
          clipSeconds: 10,
        );
      } catch (e) {
        previewDecodeError = e.toString();
      }
      final ok = isFreshCache(previewFile);

      // 同时继续完整输出
      final fullTask = warmupFullWavInBackground();
      if (ok) {
        return _PreparedPlayableFile(
          playPath: previewPath,
          isPreviewMode: fullTask != null,
          fullWavPath: targetPath,
          fullDecodeFuture: fullTask,
        );
      }
      if (fullTask != null) {
        try {
          await fullTask;
        } catch (e) {
          fullDecodeError ??= e.toString();
        }
      }
      if (await targetFile.exists()) {
        final stat = await targetFile.stat();
        if (stat.size > 44) {
          return _PreparedPlayableFile(playPath: targetPath);
        }
      }
      if (await previewFile.exists()) {
        final stat = await previewFile.stat();
        if (stat.size > 44) {
          return _PreparedPlayableFile(playPath: previewPath);
        }
      }
      throw Exception(
        "WEM 转 WAV 失败：未生成可播放文件\n"
        "preview=${previewFile.path}\n"
        "full=${targetFile.path}\n"
        "previewError=${previewDecodeError ?? 'none'}\n"
        "fullError=${fullDecodeError ?? 'none'}",
      );
    }

    return _PreparedPlayableFile(playPath: sourcePath);
  }

  String _friendlyAudioError(Object error) {
    final raw = error.toString();
    final unsupported = RegExp(
      r"unsupported wem codec format=0x([0-9a-fA-F]+)",
    );
    final match = unsupported.firstMatch(raw);
    if (match != null) {
      final codec = match.group(1)?.toLowerCase() ?? "unknown";
      return "当前 WEM 编码不受内置解码支持（format=0x$codec）。\n"
          "当前版本支持 PCM (0x0001) 和 Wwise Vorbis (0xFFFF) 的 WEM 预览。";
    }
    return raw;
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) return "$h:$m:$s";
    return "$m:$s";
  }

  static List<double> _buildWaveform(Uint8List data, {int points = 120}) {
    if (data.isEmpty) return const [];
    final pcm = _extractPcm16Data(data);
    if (pcm != null) {
      return _bucketizePcm16(pcm, points);
    }
    return _bucketizeBytes(data, points);
  }

  static Uint8List? _extractPcm16Data(Uint8List bytes) {
    if (bytes.length < 44) return null;
    if (String.fromCharCodes(bytes.sublist(0, 4)) != "RIFF") return null;
    if (String.fromCharCodes(bytes.sublist(8, 12)) != "WAVE") return null;

    int? audioFormat;
    int? bitsPerSample;
    int? dataOffset;
    int? dataLength;
    int offset = 12;

    while (offset + 8 <= bytes.length) {
      final chunkId = String.fromCharCodes(bytes.sublist(offset, offset + 4));
      final chunkSize = bytes.buffer.asByteData().getUint32(
        offset + 4,
        Endian.little,
      );
      final chunkDataStart = offset + 8;
      final chunkDataEnd = chunkDataStart + chunkSize;
      if (chunkDataEnd > bytes.length) break;

      if (chunkId == "fmt " && chunkSize >= 16) {
        final bd = bytes.buffer.asByteData();
        audioFormat = bd.getUint16(chunkDataStart, Endian.little);
        bitsPerSample = bd.getUint16(chunkDataStart + 14, Endian.little);
      } else if (chunkId == "data") {
        dataOffset = chunkDataStart;
        dataLength = chunkSize;
      }

      offset = chunkDataEnd + (chunkSize.isOdd ? 1 : 0);
    }

    if (audioFormat != 1 ||
        bitsPerSample != 16 ||
        dataOffset == null ||
        dataLength == null) {
      return null;
    }
    return Uint8List.sublistView(bytes, dataOffset, dataOffset + dataLength);
  }

  static List<double> _bucketizePcm16(Uint8List pcm, int points) {
    final sampleCount = pcm.length ~/ 2;
    if (sampleCount == 0) return const [];
    final bd = pcm.buffer.asByteData(pcm.offsetInBytes, pcm.lengthInBytes);
    final bucket = math.max(1, sampleCount ~/ points).toInt();
    final out = <double>[];
    for (int i = 0; i < sampleCount; i += bucket) {
      final end = math.min(sampleCount, i + bucket);
      double peak = 0;
      for (int j = i; j < end; j++) {
        final v = bd.getInt16(j * 2, Endian.little).abs() / 32768.0;
        if (v > peak) peak = v;
      }
      out.add(peak.clamp(0.0, 1.0));
    }
    return out;
  }

  static List<double> _bucketizeBytes(Uint8List data, int points) {
    final bucket = math.max(1, data.length ~/ points).toInt();
    final out = <double>[];
    for (int i = 0; i < data.length; i += bucket) {
      final end = math.min(data.length, i + bucket);
      double peak = 0;
      for (int j = i; j < end; j++) {
        final v = (data[j] - 128).abs() / 128.0;
        if (v > peak) peak = v;
      }
      out.add(peak.clamp(0.0, 1.0));
    }
    return out;
  }

  static Duration _estimateDurationFromAudioBytes(Uint8List bytes) {
    if (bytes.length < 44) return Duration.zero;
    if (String.fromCharCodes(bytes.sublist(0, 4)) != "RIFF")
      return Duration.zero;
    if (String.fromCharCodes(bytes.sublist(8, 12)) != "WAVE")
      return Duration.zero;

    int? channels;
    int? sampleRate;
    int? bitsPerSample;
    int? dataLength;
    int offset = 12;

    while (offset + 8 <= bytes.length) {
      final chunkId = String.fromCharCodes(bytes.sublist(offset, offset + 4));
      final chunkSize = bytes.buffer.asByteData().getUint32(
        offset + 4,
        Endian.little,
      );
      final chunkDataStart = offset + 8;
      final chunkDataEnd = chunkDataStart + chunkSize;
      if (chunkDataEnd > bytes.length) break;

      if (chunkId == "fmt " && chunkSize >= 16) {
        final bd = bytes.buffer.asByteData();
        channels = bd.getUint16(chunkDataStart + 2, Endian.little);
        sampleRate = bd.getUint32(chunkDataStart + 4, Endian.little);
        bitsPerSample = bd.getUint16(chunkDataStart + 14, Endian.little);
      } else if (chunkId == "data") {
        dataLength = chunkSize;
      }

      offset = chunkDataEnd + (chunkSize.isOdd ? 1 : 0);
    }

    if (channels == null ||
        sampleRate == null ||
        bitsPerSample == null ||
        dataLength == null ||
        channels <= 0 ||
        sampleRate <= 0 ||
        bitsPerSample <= 0) {
      return Duration.zero;
    }

    final bytesPerSecond = sampleRate * channels * (bitsPerSample / 8.0);
    if (bytesPerSecond <= 0) return Duration.zero;
    final ms = (dataLength * 1000.0 / bytesPerSecond).round();
    return Duration(milliseconds: ms);
  }
}

List<double> _computeWaveformFromBytes(Uint8List data) {
  return _AudioTempWidget._buildWaveform(data, points: 160);
}

class _WaveformPainter extends CustomPainter {
  final List<double> samples;
  final double progress;
  final int totalMs;

  _WaveformPainter({
    required this.samples,
    required this.progress,
    required this.totalMs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty || size.width <= 0 || size.height <= 0) return;

    final topLabelH = 14.0;
    final bottomLabelH = 14.0;
    final timelineH = 16.0;
    final waveTop = topLabelH + 4;
    final waveBottom = size.height - bottomLabelH - timelineH - 4;
    if (waveBottom <= waveTop) return;

    final midY = (waveTop + waveBottom) / 2;
    final halfWave = (waveBottom - waveTop) / 2;
    final progressX = size.width * progress.clamp(0.0, 1.0);
    final marks = _buildMarks(totalMs);

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: .2)
      ..strokeWidth = 1;
    final centerPaint = Paint()
      ..color = Colors.white.withValues(alpha: .18)
      ..strokeWidth = 1;
    final timelinePaint = Paint()
      ..color = Colors.white.withValues(alpha: .4)
      ..strokeWidth = 2;
    final progressPaint = Paint()
      ..color = Colors.white.withValues(alpha: .95)
      ..strokeWidth = 1.2;

    canvas.drawLine(Offset(0, midY), Offset(size.width, midY), centerPaint);
    for (final mark in marks) {
      final x = size.width * mark.ratio;
      canvas.drawLine(Offset(x, waveTop), Offset(x, waveBottom), gridPaint);
      _paintTimeLabel(
        canvas,
        _fmtSeconds(mark.second),
        x,
        0,
        alignTop: true,
        canvasWidth: size.width,
      );
      _paintTimeLabel(
        canvas,
        _fmtSeconds(mark.second),
        x,
        size.height - bottomLabelH,
        alignTop: false,
        canvasWidth: size.width,
      );
    }

    final barWidth = size.width / samples.length;
    for (int i = 0; i < samples.length; i++) {
      final amp = samples[i].clamp(0.02, 1.0);
      final halfH = math.max(1.0, halfWave * amp);
      final x = i * barWidth;
      final base = const Color(0xFF56D4FF);
      final color = x <= progressX
          ? base.withValues(alpha: .96)
          : base.withValues(alpha: .45);
      final rect = Rect.fromLTWH(
        x,
        midY - halfH,
        math.max(1, barWidth - 1),
        halfH * 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1)),
        Paint()..color = color,
      );
    }

    final timelineY = size.height - bottomLabelH - (timelineH / 2);
    canvas.drawLine(
      Offset(0, timelineY),
      Offset(size.width, timelineY),
      timelinePaint,
    );
    canvas.drawLine(
      Offset(progressX, waveTop - 2),
      Offset(progressX, size.height - 1),
      progressPaint,
    );

    final currentSec = totalMs <= 0
        ? 0
        : ((totalMs * progress.clamp(0.0, 1.0)) / 1000).round();
    _paintCurrentTag(
      canvas,
      _fmtSeconds(currentSec),
      progressX,
      timelineY - 16,
      size.width,
    );
  }

  static List<_WaveMark> _buildMarks(int totalMs) {
    final totalSec = (totalMs / 1000).ceil();
    if (totalSec <= 0) return const [];
    int step = 300;
    if (totalSec <= 30) {
      step = 5;
    } else if (totalSec <= 120) {
      step = 15;
    } else if (totalSec <= 600) {
      step = 60;
    } else if (totalSec <= 1800) {
      step = 120;
    }
    final marks = <_WaveMark>[];
    for (int sec = step; sec < totalSec; sec += step) {
      marks.add(_WaveMark(sec / totalSec, sec));
    }
    return marks;
  }

  static String _fmtSeconds(int sec) {
    final m = (sec ~/ 60).toString();
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  void _paintTimeLabel(
    Canvas canvas,
    String text,
    double x,
    double y, {
    required bool alignTop,
    required double canvasWidth,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: .7),
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    final dx = ((x - (tp.width / 2)).clamp(
      0.0,
      math.max(0.0, canvasWidth - tp.width),
    )).toDouble();
    final dy = alignTop ? y : (y + (14 - tp.height));
    tp.paint(canvas, Offset(dx, dy));
  }

  void _paintCurrentTag(
    Canvas canvas,
    String text,
    double x,
    double y,
    double canvasWidth,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    final pad = 4.0;
    final rect = Rect.fromLTWH(
      ((x - tp.width / 2 - pad).clamp(
        0.0,
        math.max(0.0, canvasWidth - tp.width - pad * 2),
      )).toDouble(),
      y - tp.height / 2 - 2,
      tp.width + pad * 2,
      tp.height + 4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()..color = const Color(0xFF0B121B).withValues(alpha: .85),
    );
    tp.paint(canvas, Offset(rect.left + pad, rect.top + 2));
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.progress != progress ||
        oldDelegate.totalMs != totalMs;
  }
}

class _WaveMark {
  final double ratio;
  final int second;

  const _WaveMark(this.ratio, this.second);
}

class _PreparedPlayableFile {
  final String playPath;
  final bool isPreviewMode;
  final String? fullWavPath;
  final Future<void>? fullDecodeFuture;

  const _PreparedPlayableFile({
    required this.playPath,
    this.isPreviewMode = false,
    this.fullWavPath,
    this.fullDecodeFuture,
  });
}

class UnP4kErrorWidget extends StatelessWidget {
  final String errorMessage;

  const UnP4kErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(errorMessage)],
        ),
      ),
    );
  }
}
