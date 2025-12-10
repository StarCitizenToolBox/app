import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class UnP4kcUI extends HookConsumerWidget {
  const UnP4kcUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    final model = ref.read(unp4kCModelProvider.notifier);
    final files = model.getFiles();
    final paths = state.curPath.trim().split("\\");

    useEffect(() {
      AnalyticsApi.touch("unp4k_launch");
      return null;
    }, const []);

    return makeDefaultPage(
      context,
      title: S.current.tools_unp4k_title(model.getGamePath()),
      useBodyContainer: false,
      content: makeBody(context, state, model, files, paths),
    );
  }

  Widget makeBody(
    BuildContext context,
    Unp4kcState state,
    Unp4kCModel model,
    List<AppUnp4kP4kItemData>? files,
    List<String> paths,
  ) {
    if (state.errorMessage.isNotEmpty) {
      return UnP4kErrorWidget(errorMessage: state.errorMessage);
    }
    return state.files == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: makeLoading(context)),
              if (state.endMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${state.endMessage}", style: const TextStyle(fontSize: 12)),
                ),
            ],
          )
        : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(color: FluentTheme.of(context).cardColor.withValues(alpha: .06)),
                    height: 36,
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      children: [
                        // 搜索模式下显示返回按钮
                        if (state.searchFs != null) ...[
                          IconButton(
                            icon: const Icon(FluentIcons.back, size: 14),
                            onPressed: () {
                              model.clearSearch();
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "[${S.current.tools_unp4k_searching.replaceAll('...', '')}]",
                            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .7)),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: SuperListView.builder(
                            itemCount: paths.length - 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              var path = paths[index];
                              if (path.isEmpty) {
                                path = "\\";
                              }
                              final fullPath = "${paths.sublist(0, index + 1).join("\\")}\\";
                              return Row(
                                children: [
                                  IconButton(
                                    icon: Text(path),
                                    onPressed: () {
                                      model.changeDir(fullPath, fullPath: true);
                                    },
                                  ),
                                  const Icon(FluentIcons.chevron_right, size: 12),
                                ],
                              );
                            },
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
                          child: _FileListPanel(state: state, model: model, files: files),
                        ),
                        Expanded(
                          child: state.tempOpenFile == null
                              ? Center(child: Text(S.current.tools_unp4k_view_file))
                              : state.tempOpenFile?.key == "loading"
                              ? makeLoading(context)
                              : Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      if (state.tempOpenFile?.key == "text")
                                        Expanded(child: _TextTempWidget(state.tempOpenFile?.value ?? ""))
                                      else
                                        Expanded(
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  S.current.tools_unp4k_msg_unknown_file_type(
                                                    state.tempOpenFile?.value ?? "",
                                                  ),
                                                ),
                                                const SizedBox(height: 32),
                                                FilledButton(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4),
                                                    child: Text(S.current.action_open_folder),
                                                  ),
                                                  onPressed: () {
                                                    SystemHelper.openDir(state.tempOpenFile?.value ?? "");
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
                      child: Text("${state.endMessage}", style: const TextStyle(fontSize: 12)),
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
                        Text(S.current.tools_unp4k_searching, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
            ],
          );
  }
}

/// 文件列表面板组件
class _FileListPanel extends HookConsumerWidget {
  final Unp4kcState state;
  final Unp4kCModel model;
  final List<AppUnp4kP4kItemData>? files;

  const _FileListPanel({required this.state, required this.model, required this.files});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(text: state.searchQuery);

    return Container(
      decoration: BoxDecoration(color: FluentTheme.of(context).cardColor.withValues(alpha: .01)),
      child: Column(
        children: [
          // 搜索栏和排序选择器
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextBox(
                    controller: searchController,
                    placeholder: S.current.tools_unp4k_search_placeholder,
                    prefix: const Padding(padding: EdgeInsets.only(left: 8), child: Icon(FluentIcons.search, size: 14)),
                    suffix: searchController.text.isNotEmpty || state.searchFs != null
                        ? IconButton(
                            icon: const Icon(FluentIcons.clear, size: 12),
                            onPressed: () {
                              searchController.clear();
                              model.clearSearch();
                            },
                          )
                        : null,
                    onSubmitted: (value) {
                      model.search(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ComboBox<Unp4kSortType>(
                  value: state.sortType,
                  items: [
                    ComboBoxItem(value: Unp4kSortType.defaultSort, child: Text(S.current.tools_unp4k_sort_default)),
                    ComboBoxItem(value: Unp4kSortType.sizeAsc, child: Text(S.current.tools_unp4k_sort_size_asc)),
                    ComboBoxItem(value: Unp4kSortType.sizeDesc, child: Text(S.current.tools_unp4k_sort_size_desc)),
                    ComboBoxItem(value: Unp4kSortType.dateAsc, child: Text(S.current.tools_unp4k_sort_date_asc)),
                    ComboBoxItem(value: Unp4kSortType.dateDesc, child: Text(S.current.tools_unp4k_sort_date_desc)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      model.setSortType(value);
                    }
                  },
                ),
              ],
            ),
          ),
          // 多选模式工具栏
          if (state.isMultiSelectMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor.withValues(alpha: .1),
                border: Border(
                  bottom: BorderSide(color: FluentTheme.of(context).accentColor.withValues(alpha: .3), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    S.current.tools_unp4k_action_export_selected(state.selectedItems.length),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Button(child: Text(S.current.tools_unp4k_action_select_all), onPressed: () => model.selectAll(files)),
                  const SizedBox(width: 4),
                  Button(
                    child: Text(S.current.tools_unp4k_action_deselect_all),
                    onPressed: () => model.deselectAll(files),
                  ),
                  const SizedBox(width: 4),
                  FilledButton(
                    onPressed: state.selectedItems.isNotEmpty ? () => _exportSelected(context) : null,
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
                      state.searchFs != null ? S.current.tools_unp4k_search_no_result : '',
                      style: TextStyle(color: Colors.white.withValues(alpha: .6)),
                    ),
                  )
                : SuperListView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 3, right: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final item = files![index];
                      return _FileListItem(item: item, state: state, model: model);
                    },
                    itemCount: files?.length ?? 0,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSelected(BuildContext context) async {
    final outputDir = await FilePicker.platform.getDirectoryPath(dialogTitle: S.current.tools_unp4k_action_save_as);
    if (outputDir != null && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return _MultiExtractProgressDialog(selectedItems: state.selectedItems, outputDir: outputDir, model: model);
        },
      );
      // 提取完成后退出多选模式
      model.exitMultiSelectMode();
    }
  }
}

/// 文件列表项组件
class _FileListItem extends HookWidget {
  final AppUnp4kP4kItemData item;
  final Unp4kcState state;
  final Unp4kCModel model;

  const _FileListItem({required this.item, required this.state, required this.model});

  @override
  Widget build(BuildContext context) {
    final flyoutController = useMemoized(() => FlyoutController());
    // 显示相对于当前路径的文件名
    final fileName = item.name?.replaceAll(state.curPath.trim(), "") ?? "?";
    final itemPath = item.name ?? "";
    final isSelected = state.selectedItems.contains(itemPath);

    return FlyoutTarget(
      controller: flyoutController,
      child: GestureDetector(
        onSecondaryTapUp: (details) => _showContextMenu(context, flyoutController),
        child: Container(
          margin: const EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? FluentTheme.of(context).accentColor.withValues(alpha: .2)
                : FluentTheme.of(context).cardColor.withValues(alpha: .05),
          ),
          child: IconButton(
            onPressed: () {
              if (state.isMultiSelectMode) {
                // 多选模式下点击切换选中状态
                model.toggleSelectItem(itemPath);
              } else if (item.isDirectory ?? false) {
                final dirName = item.name?.replaceAll(state.curPath.trim(), "") ?? "";
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
                    const Icon(FluentIcons.folder_fill, color: Color.fromRGBO(255, 224, 138, 1))
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
                              child: Text(fileName, style: const TextStyle(fontSize: 13), textAlign: TextAlign.start),
                            ),
                          ],
                        ),
                        if (!(item.isDirectory ?? true)) ...[
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              Text(
                                FileSize.getSize(item.size),
                                style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .6)),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.dateModified != null
                                    ? DateTime.fromMillisecondsSinceEpoch(
                                        item.dateModified!,
                                      ).toString().substring(0, 19)
                                    : "",
                                style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .6)),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(FluentIcons.chevron_right, size: 14, color: Colors.white.withValues(alpha: .6)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, FlyoutController controller) {
    // 保存外部 context，因为 flyout 的 context 在关闭后会失效
    final outerContext = context;
    controller.showFlyout(
      autoModeConfiguration: FlyoutAutoConfiguration(preferredMode: FlyoutPlacementMode.bottomCenter),
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

  Future<void> _saveAs(BuildContext context) async {
    final outputDir = await FilePicker.platform.getDirectoryPath(dialogTitle: S.current.tools_unp4k_action_save_as);
    if (outputDir != null && context.mounted) {
      await _showExtractProgressDialog(context, outputDir);
    }
  }

  Future<void> _showExtractProgressDialog(BuildContext context, String outputDir) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ExtractProgressDialog(item: item, outputDir: outputDir, model: model);
      },
    );
  }
}

/// 提取进度对话框
class _ExtractProgressDialog extends HookWidget {
  final AppUnp4kP4kItemData item;
  final String outputDir;
  final Unp4kCModel model;

  const _ExtractProgressDialog({required this.item, required this.outputDir, required this.model});

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
      _startExtraction(isCancelled, currentFile, currentIndex, totalFiles, isCompleted, errorMessage, extractedCount);
      return null;
    }, const []);

    final progress = totalFiles.value > 0 ? currentIndex.value / totalFiles.value : 0.0;

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
              S.current.tools_unp4k_extract_progress(currentIndex.value, totalFiles.value),
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
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .7)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (errorMessage.value != null) ...[
            // 错误信息
            const Icon(FluentIcons.error_badge, size: 48, color: Color(0xFFE81123)),
            const SizedBox(height: 12),
            Text(errorMessage.value!, style: const TextStyle(fontSize: 14)),
          ] else ...[
            // 完成
            const Icon(FluentIcons.completed_solid, size: 48, color: Color(0xFF107C10)),
            const SizedBox(height: 12),
            Text(S.current.tools_unp4k_extract_completed(extractedCount.value), style: const TextStyle(fontSize: 14)),
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
          FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(S.current.action_close)),
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

/// 批量提取进度对话框
class _MultiExtractProgressDialog extends HookWidget {
  final Set<String> selectedItems;
  final String outputDir;
  final Unp4kCModel model;

  const _MultiExtractProgressDialog({required this.selectedItems, required this.outputDir, required this.model});

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
      totalFiles.value = model.getFileCountForSelectedItems(selectedItems);

      // 开始提取
      _startExtraction(isCancelled, currentFile, currentIndex, totalFiles, isCompleted, errorMessage, extractedCount);
      return null;
    }, const []);

    final progress = totalFiles.value > 0 ? currentIndex.value / totalFiles.value : 0.0;

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
              S.current.tools_unp4k_extract_progress(currentIndex.value, totalFiles.value),
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
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .7)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (errorMessage.value != null) ...[
            // 错误信息
            const Icon(FluentIcons.error_badge, size: 48, color: Color(0xFFE81123)),
            const SizedBox(height: 12),
            Text(errorMessage.value!, style: const TextStyle(fontSize: 14)),
          ] else ...[
            // 完成
            const Icon(FluentIcons.completed_solid, size: 48, color: Color(0xFF107C10)),
            const SizedBox(height: 12),
            Text(S.current.tools_unp4k_extract_completed(extractedCount.value), style: const TextStyle(fontSize: 14)),
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
          FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(S.current.action_close)),
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
    final result = await model.extractSelectedItemsWithProgress(
      selectedItems,
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

class _TextTempWidget extends HookConsumerWidget {
  final String filePath;

  const _TextTempWidget(this.filePath);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textData = useState<String?>(null);

    useEffect(() {
      File(filePath).readAsBytes().then((data) {
        // 处理可能的 BOM
        if (data.length > 3 && data[0] == 0xEF && data[1] == 0xBB && data[2] == 0xBF) {
          data = data.sublist(3);
        }
        final text = utf8.decode(data, allowMalformed: true);
        textData.value = text;
      });
      return null;
    }, const []);

    if (textData.value == null) return makeLoading(context);

    return CodeEditor(controller: CodeLineEditingController.fromText('${textData.value}'), readOnly: true);
  }
}

class UnP4kErrorWidget extends StatelessWidget {
  final String errorMessage;

  const UnP4kErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [Text(errorMessage)]),
      ),
    );
  }
}
