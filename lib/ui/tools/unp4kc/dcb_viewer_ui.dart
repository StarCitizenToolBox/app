import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/xml.dart';
import 'package:re_highlight/styles/vs2015.dart';
import 'package:starcitizen_doctor/data/dcb_data.dart';
import 'package:starcitizen_doctor/provider/dcb_viewer.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// XML 代码折叠分析器
/// 分析 XML 标签的开始和结束，用于代码折叠功能
class XmlCodeChunkAnalyzer implements CodeChunkAnalyzer {
  const XmlCodeChunkAnalyzer();

  @override
  List<CodeChunk> run(CodeLines codeLines) {
    final List<CodeChunk> chunks = [];
    final List<_XmlTagInfo> tagStack = [];

    for (int i = 0; i < codeLines.length; i++) {
      final String line = codeLines[i].text;
      _processLine(line, i, tagStack, chunks);
    }

    return chunks;
  }

  void _processLine(String line, int lineIndex, List<_XmlTagInfo> tagStack, List<CodeChunk> chunks) {
    final trimmedLine = line.trim();

    // 跳过空行、注释和 XML 声明
    if (trimmedLine.isEmpty ||
        trimmedLine.startsWith('<!--') ||
        trimmedLine.startsWith('<?') ||
        trimmedLine.startsWith('<!')) {
      return;
    }

    // 查找所有标签
    final tagPattern = RegExp(r'<(/?)(\w+(?::\w+)?)[^>]*(/?)>');
    final matches = tagPattern.allMatches(line);

    for (final match in matches) {
      final isClosing = match.group(1) == '/';
      final tagName = match.group(2)!;
      final isSelfClosing = match.group(3) == '/';

      if (isSelfClosing) {
        // 自闭合标签，不需要处理
        continue;
      }

      if (isClosing) {
        // 关闭标签，查找匹配的开始标签
        for (int j = tagStack.length - 1; j >= 0; j--) {
          if (tagStack[j].tagName == tagName) {
            final startLine = tagStack[j].lineIndex;
            if (lineIndex > startLine) {
              chunks.add(CodeChunk(startLine, lineIndex));
            }
            tagStack.removeAt(j);
            break;
          }
        }
      } else {
        // 开始标签，检查同一行是否有对应的关闭标签
        final closePattern = RegExp('</$tagName\\s*>');
        if (!closePattern.hasMatch(line)) {
          tagStack.add(_XmlTagInfo(tagName, lineIndex));
        }
      }
    }
  }
}

class _XmlTagInfo {
  final String tagName;
  final int lineIndex;

  _XmlTagInfo(this.tagName, this.lineIndex);
}

/// DCB 查看器 UI
/// 用于查看 DataForge/DCB 文件内容
/// 支持两种模式：
/// 1. 独立打开 - 传入 initialFilePath 或让用户选择文件
/// 2. 从 P4K 内存数据打开 - 传入 dcbData 和 dcbFilePath
class DcbViewerUI extends HookConsumerWidget {
  /// DCB 文件路径
  final String? initialFilePath;

  const DcbViewerUI({super.key, this.initialFilePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dcbViewerModelProvider);
    final model = ref.read(dcbViewerModelProvider.notifier);

    // 初始化
    useEffect(() {
      if (initialFilePath != null) {
        () async {
          await Future.delayed(Duration(milliseconds: 16));
          model.initFromFilePath(initialFilePath!);
        }();
      }
      // 否则显示文件选择界面
      return null;
    }, const []);

    return makeDefaultPage(
      context,
      title:
          "${S.current.dcb_viewer_title_standalone}  ${state.viewMode == DcbViewMode.searchResults ? "'[${S.current.dcb_viewer_search_mode}]'" : ""} <${state.message}>",
      useBodyContainer: false,
      actions: [
        // 返回/重选按钮
        if (!state.needSelectFile)
          IconButton(
            icon: const Icon(FluentIcons.back, size: 16),
            onPressed: () {
              model.reset();
            },
          ),
        const SizedBox(width: 12),
        // 导出按钮（仅在加载完成后显示）
        if (!state.isLoading && !state.needSelectFile && state.errorMessage == null)
          _ExportButton(state: state, model: model),
      ],
      content: _buildBody(context, state, model),
    );
  }

  Widget _buildBody(BuildContext context, DcbViewerState state, DcbViewerModel model) {
    // 需要选择文件
    if (state.needSelectFile) {
      return _FileSelectionView(model: model);
    }

    // 错误状态
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.error_badge, size: 48, color: Colors.warningPrimaryColor),
            const SizedBox(height: 16),
            Text(state.errorMessage!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => model.reset(), child: Text(S.current.dcb_viewer_select_another_file)),
          ],
        ),
      );
    }

    // 加载中
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const ProgressRing(), const SizedBox(height: 16), Text(state.message)],
        ),
      );
    }

    // 主内容
    return Stack(
      children: [
        Column(
          children: [
            // 主体内容
            Expanded(
              child: Row(
                children: [
                  // 左侧面板
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: state.viewMode == DcbViewMode.browse
                        ? _RecordListPanel(state: state, model: model)
                        : _SearchResultsPanel(state: state, model: model),
                  ),
                  // 右侧 XML 预览
                  Expanded(
                    child: _XmlPreviewPanel(state: state, model: model),
                  ),
                ],
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
                children: [const ProgressRing(), const SizedBox(height: 16), Text(S.current.dcb_viewer_searching)],
              ),
            ),
          ),
      ],
    );
  }
}

/// 文件选择视图
class _FileSelectionView extends StatelessWidget {
  final DcbViewerModel model;

  const _FileSelectionView({required this.model});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FluentIcons.database, size: 64, color: Colors.white),
          const SizedBox(height: 24),
          Text(
            S.current.dcb_viewer_select_file_title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            S.current.dcb_viewer_select_file_description,
            style: TextStyle(color: Colors.white.withValues(alpha: .7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () => _selectDcbFile(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(FluentIcons.document, size: 16),
                      const SizedBox(width: 8),
                      Text(S.current.dcb_viewer_select_dcb_file),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Button(
                onPressed: () => _selectP4kFile(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(FluentIcons.archive, size: 16),
                      const SizedBox(width: 8),
                      Text(S.current.dcb_viewer_select_p4k_file),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDcbFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: S.current.dcb_viewer_select_dcb_file,
      type: FileType.custom,
      allowedExtensions: ['dcb'],
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        model.initFromFilePath(path);
      }
    }
  }

  Future<void> _selectP4kFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: S.current.dcb_viewer_select_p4k_file,
      type: FileType.custom,
      allowedExtensions: ['p4k'],
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        model.initFromP4kFile(path);
      }
    }
  }
}

/// 导出按钮
class _ExportButton extends HookWidget {
  final DcbViewerState state;
  final DcbViewerModel model;

  const _ExportButton({required this.state, required this.model});

  @override
  Widget build(BuildContext context) {
    final flyoutController = useMemoized(() => FlyoutController());

    return FlyoutTarget(
      controller: flyoutController,
      child: Button(
        onPressed: state.isExporting
            ? null
            : () {
                flyoutController.showFlyout(
                  barrierColor: Colors.transparent,
                  builder: (ctx) => MenuFlyout(
                    items: [
                      MenuFlyoutItem(
                        leading: const Icon(FluentIcons.page, size: 16),
                        text: Text(S.current.dcb_viewer_export_single_xml),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _exportMerged(context);
                        },
                      ),
                      MenuFlyoutItem(
                        leading: const Icon(FluentIcons.folder, size: 16),
                        text: Text(S.current.dcb_viewer_export_multiple_xml),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _exportSeparate(context);
                        },
                      ),
                    ],
                  ),
                );
              },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.isExporting)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2)),
              ),
            Text(S.current.dcb_viewer_export),
            const SizedBox(width: 4),
            const Icon(FluentIcons.chevron_down, size: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _exportMerged(BuildContext context) async {
    final outputPath = await FilePicker.platform.saveFile(
      dialogTitle: S.current.dcb_viewer_export_single_xml,
      fileName: 'dataforge.xml',
      type: FileType.custom,
      allowedExtensions: ['xml'],
    );
    if (outputPath != null) {
      final error = await model.exportToDisk(outputPath, true);
      if (context.mounted) {
        if (error != null) {
          await displayInfoBar(
            context,
            builder: (ctx, close) {
              return InfoBar(
                title: Text(S.current.dcb_viewer_export_failed),
                content: Text(error),
                severity: InfoBarSeverity.error,
                onClose: close,
              );
            },
          );
        } else {
          await displayInfoBar(
            context,
            builder: (ctx, close) {
              return InfoBar(
                title: Text(S.current.dcb_viewer_export_success),
                severity: InfoBarSeverity.success,
                onClose: close,
              );
            },
          );
        }
      }
    }
  }

  Future<void> _exportSeparate(BuildContext context) async {
    final outputDir = await FilePicker.platform.getDirectoryPath(dialogTitle: S.current.dcb_viewer_export_multiple_xml);
    if (outputDir != null) {
      final error = await model.exportToDisk(outputDir, false);
      if (context.mounted) {
        if (error != null) {
          await displayInfoBar(
            context,
            builder: (ctx, close) {
              return InfoBar(
                title: Text(S.current.dcb_viewer_export_failed),
                content: Text(error),
                severity: InfoBarSeverity.error,
                onClose: close,
              );
            },
          );
        } else {
          await displayInfoBar(
            context,
            builder: (ctx, close) {
              return InfoBar(
                title: Text(S.current.dcb_viewer_export_success),
                severity: InfoBarSeverity.success,
                onClose: close,
              );
            },
          );
        }
      }
    }
  }
}

/// 记录列表面板（浏览模式）
class _RecordListPanel extends HookWidget {
  final DcbViewerState state;
  final DcbViewerModel model;

  const _RecordListPanel({required this.state, required this.model});

  @override
  Widget build(BuildContext context) {
    final listSearchController = useTextEditingController(text: state.listSearchQuery);
    final fullTextSearchController = useTextEditingController(text: state.fullTextSearchQuery);

    return Container(
      decoration: BoxDecoration(color: FluentTheme.of(context).cardColor.withValues(alpha: .01)),
      child: Column(
        children: [
          // 全文搜索框
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: TextBox(
              controller: fullTextSearchController,
              placeholder: S.current.dcb_viewer_search_fulltext_placeholder,
              prefix: const Padding(padding: EdgeInsets.only(left: 8), child: Icon(FluentIcons.search_data, size: 14)),
              suffix: fullTextSearchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(FluentIcons.clear, size: 12),
                      onPressed: () {
                        fullTextSearchController.clear();
                        model.exitSearchMode();
                      },
                    )
                  : null,
              onSubmitted: (value) => model.searchFullText(value),
            ),
          ),
          // 列表过滤搜索框
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: TextBox(
              controller: listSearchController,
              placeholder: S.current.dcb_viewer_search_list_placeholder,
              prefix: const Padding(padding: EdgeInsets.only(left: 8), child: Icon(FluentIcons.filter, size: 14)),
              suffix: listSearchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(FluentIcons.clear, size: 12),
                      onPressed: () {
                        listSearchController.clear();
                        model.searchList('');
                      },
                    )
                  : null,
              onChanged: (value) => model.searchList(value),
            ),
          ),
          // 记录列表
          Expanded(
            child: state.filteredRecords.isEmpty
                ? Center(
                    child: Text(
                      S.current.dcb_viewer_no_records,
                      style: TextStyle(color: Colors.white.withValues(alpha: .6)),
                    ),
                  )
                : SuperListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 8),
                    itemCount: state.filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = state.filteredRecords[index];
                      final isSelected = state.selectedRecordPath == record.path;
                      return _RecordListItem(
                        record: record,
                        isSelected: isSelected,
                        onTap: () => model.selectRecord(record),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 记录列表项
class _RecordListItem extends StatelessWidget {
  final DcbRecordData record;
  final bool isSelected;
  final VoidCallback onTap;

  const _RecordListItem({required this.record, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? FluentTheme.of(context).accentColor.withValues(alpha: .2)
            : FluentTheme.of(context).cardColor.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              const Icon(FluentIcons.file_code, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record.path,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 搜索结果面板（全文搜索模式）
class _SearchResultsPanel extends HookWidget {
  final DcbViewerState state;
  final DcbViewerModel model;

  const _SearchResultsPanel({required this.state, required this.model});

  @override
  Widget build(BuildContext context) {
    // 筛选查询
    final filterController = useTextEditingController();
    final filterQuery = useState('');

    // 过滤后的搜索结果
    final filteredResults = useMemoized(() {
      if (filterQuery.value.isEmpty) {
        return state.searchResults;
      }
      final lowerQuery = filterQuery.value.toLowerCase();
      return state.searchResults.where((result) => result.path.toLowerCase().contains(lowerQuery)).toList();
    }, [state.searchResults, filterQuery.value]);

    return Container(
      decoration: BoxDecoration(color: FluentTheme.of(context).cardColor.withValues(alpha: .01)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索信息
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(FluentIcons.search, size: 14, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '"${state.fullTextSearchQuery}"',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 显示结果数量
                      Text(
                        '${filteredResults.length}/${state.searchResults.length}',
                        style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .6)),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(FluentIcons.clear, size: 12),
                        onPressed: () {
                          model.exitSearchMode();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 文件路径筛选框
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: TextBox(
              controller: filterController,
              placeholder: S.current.dcb_viewer_search_list_placeholder,
              prefix: const Padding(padding: EdgeInsets.only(left: 8), child: Icon(FluentIcons.filter, size: 14)),
              suffix: filterController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(FluentIcons.clear, size: 12),
                      onPressed: () {
                        filterController.clear();
                        filterQuery.value = '';
                      },
                    )
                  : null,
              onChanged: (value) => filterQuery.value = value,
            ),
          ),
          const Divider(),
          // 搜索结果列表
          Expanded(
            child: filteredResults.isEmpty
                ? Center(
                    child: Text(
                      S.current.dcb_viewer_no_search_results,
                      style: TextStyle(color: Colors.white.withValues(alpha: .6)),
                    ),
                  )
                : SuperListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 8),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final result = filteredResults[index];
                      return _SearchResultItem(
                        result: result,
                        isSelected: state.selectedRecordPath == result.path,
                        searchQuery: state.fullTextSearchQuery,
                        onTap: () => model.selectFromSearchResult(result),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 搜索结果项（类似 VSCode 风格）
class _SearchResultItem extends StatelessWidget {
  final DcbSearchResultData result;
  final bool isSelected;
  final String searchQuery;
  final VoidCallback onTap;

  const _SearchResultItem({
    required this.result,
    required this.isSelected,
    required this.searchQuery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? FluentTheme.of(context).accentColor.withValues(alpha: .2)
            : FluentTheme.of(context).cardColor.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 文件路径
              Row(
                children: [
                  const Icon(FluentIcons.file_code, size: 12),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      result.path,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Text(
                    '${result.matches.length}',
                    style: TextStyle(fontSize: 11, color: FluentTheme.of(context).accentColor),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              // 匹配摘要
              if (result.matches.isNotEmpty) ...[
                const SizedBox(height: 4),
                ...result.matches
                    .take(3)
                    .map(
                      (match) => Padding(
                        padding: const EdgeInsets.only(left: 18, top: 2),
                        child: Row(
                          children: [
                            Text(
                              'L${match.lineNumber}:',
                              style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .5)),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: _HighlightedText(text: match.lineContent.trim(), query: searchQuery),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 高亮匹配文本
class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;

  const _HighlightedText({required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .7)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .7)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      );
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      text: TextSpan(
        style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: .7)),
        children: [
          TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, startIndex + query.length),
            style: TextStyle(backgroundColor: Colors.yellow.withValues(alpha: .3), color: Colors.white),
          ),
          TextSpan(text: text.substring(startIndex + query.length)),
        ],
      ),
    );
  }
}

/// XML 预览面板
class _XmlPreviewPanel extends HookWidget {
  final DcbViewerState state;
  final DcbViewerModel model;

  const _XmlPreviewPanel({required this.state, required this.model});

  @override
  Widget build(BuildContext context) {
    // 创建代码编辑控制器
    final codeController = useMemoized(() => CodeLineEditingController.fromText(state.currentXml), [state.currentXml]);

    // 创建搜索控制器
    final findController = useMemoized(() => CodeFindController(codeController), [codeController]);

    // 创建滚动控制器
    final scrollController = useMemoized(() => CodeScrollController(), []);

    // 持有内部 chunkController 的引用（从 indicatorBuilder 中获取）
    final chunkControllerRef = useRef<CodeChunkController?>(null);

    // 折叠状态追踪
    final isAllCollapsed = useState(false);

    // 当 XML 内容变化时更新 controller
    useEffect(() {
      codeController.text = state.currentXml;
      // 关闭搜索面板
      findController.close();
      // 重置折叠状态
      isAllCollapsed.value = false;
      return null;
    }, [state.currentXml]);

    // 清理资源
    useEffect(() {
      return () {
        codeController.dispose();
        findController.dispose();
        scrollController.dispose();
      };
    }, const []);

    // 监听搜索控制器变化以触发重建
    useListenable(findController);

    if (state.selectedRecordPath == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FluentIcons.code, size: 48, color: Colors.white.withValues(alpha: .7)),
            const SizedBox(height: 16),
            Text(S.current.dcb_viewer_select_record, style: TextStyle(color: Colors.white.withValues(alpha: .6))),
          ],
        ),
      );
    }

    if (state.isLoadingXml) {
      return const Center(child: ProgressRing());
    }

    return Column(
      children: [
        // 文件路径和搜索切换按钮
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // 搜索按钮
              IconButton(
                icon: Icon(
                  FluentIcons.search,
                  size: 14,
                  color: findController.value != null ? FluentTheme.of(context).accentColor : null,
                ),
                onPressed: () {
                  if (findController.value != null) {
                    findController.close();
                  } else {
                    findController.findMode();
                  }
                },
              ),
              // 折叠/展开全部按钮
              const SizedBox(width: 4),
              Tooltip(
                message: S.current.dcb_viewer_fold_all,
                child: IconButton(
                  icon: Icon(isAllCollapsed.value ? FluentIcons.expand_all : FluentIcons.collapse_content, size: 14),
                  onPressed: () {
                    final controller = chunkControllerRef.value;
                    if (controller == null) return;

                    final chunks = controller.value;
                    if (chunks.isEmpty) return;

                    if (isAllCollapsed.value) {
                      // 展开全部：从内层到外层展开
                      for (final chunk in chunks.reversed) {
                        controller.expand(chunk.index);
                      }
                      isAllCollapsed.value = false;
                    } else {
                      // 折叠全部：从外层到内层折叠
                      for (final chunk in chunks) {
                        controller.collapse(chunk.index);
                      }
                      isAllCollapsed.value = true;
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              // 当前记录路径
              Expanded(
                child: Text(
                  state.selectedRecordPath ?? '',
                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .6)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        // XML 编辑器
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .4),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: CodeEditor(
                controller: codeController,
                findController: findController,
                scrollController: scrollController,
                readOnly: true,
                wordWrap: false,
                chunkAnalyzer: const XmlCodeChunkAnalyzer(),
                style: CodeEditorStyle(
                  fontSize: 14,
                  codeTheme: CodeHighlightTheme(
                    languages: {'xml': CodeHighlightThemeMode(mode: langXml)},
                    theme: vs2015Theme,
                  ),
                ),
                indicatorBuilder: (context, editingController, chunkController, notifier) {
                  // 保存 chunkController 引用供外部使用
                  chunkControllerRef.value = chunkController;
                  return Row(
                    children: [
                      DefaultCodeLineNumber(controller: editingController, notifier: notifier),
                      DefaultCodeChunkIndicator(width: 20, controller: chunkController, notifier: notifier),
                    ],
                  );
                },
                findBuilder: (context, controller, readOnly) => _CodeFindPanel(controller: controller),
                shortcutsActivatorsBuilder: const _XmlCodeShortcutsActivatorsBuilder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 自定义快捷键构建器
class _XmlCodeShortcutsActivatorsBuilder extends DefaultCodeShortcutsActivatorsBuilder {
  const _XmlCodeShortcutsActivatorsBuilder();

  @override
  List<ShortcutActivator>? build(CodeShortcutType type) {
    // 保留默认快捷键，包括 Ctrl+F 搜索
    return super.build(type);
  }
}

/// 搜索面板 UI（Fluent UI 风格）
class _CodeFindPanel extends HookWidget implements PreferredSizeWidget {
  final CodeFindController controller;

  const _CodeFindPanel({required this.controller});

  @override
  Size get preferredSize =>
      Size(double.infinity, controller.value == null ? 0 : (controller.value!.replaceMode ? 80 : 44));

  @override
  Widget build(BuildContext context) {
    useListenable(controller);

    if (controller.value == null) {
      return const SizedBox.shrink();
    }

    final value = controller.value!;
    final resultText = value.result == null
        ? S.current.dcb_viewer_search_no_results
        : '${value.result!.index + 1}/${value.result!.matches.length}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .8),
        border: Border(bottom: BorderSide(color: FluentTheme.of(context).resources.dividerStrokeColorDefault)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 搜索行
          Row(
            children: [
              // 搜索输入框
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: TextBox(
                    controller: controller.findInputController,
                    focusNode: controller.findInputFocusNode,
                    placeholder: S.current.dcb_viewer_search_in_file,
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 大小写敏感
                        _buildOptionButton(
                          context: context,
                          text: 'Aa',
                          isActive: value.option.caseSensitive,
                          onPressed: () => controller.toggleCaseSensitive(),
                          tooltip: S.current.dcb_viewer_search_case_sensitive,
                        ),
                        // 正则表达式
                        _buildOptionButton(
                          context: context,
                          text: '.*',
                          isActive: value.option.regex,
                          onPressed: () => controller.toggleRegex(),
                          tooltip: S.current.dcb_viewer_search_regex,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 结果计数
              SizedBox(
                width: 60,
                child: Text(
                  resultText,
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .7)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 4),
              // 上一个
              IconButton(
                icon: const Icon(FluentIcons.chevron_up, size: 12),
                onPressed: value.result == null ? null : () => controller.previousMatch(),
              ),
              // 下一个
              IconButton(
                icon: const Icon(FluentIcons.chevron_down, size: 12),
                onPressed: value.result == null ? null : () => controller.nextMatch(),
              ),
              // 关闭
              IconButton(icon: const Icon(FluentIcons.chrome_close, size: 12), onPressed: () => controller.close()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String text,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.only(right: 2),
        child: SizedBox(
          width: 42,
          height: 24,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                isActive ? FluentTheme.of(context).accentColor.withValues(alpha: .3) : Colors.transparent,
              ),
            ),
            icon: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? FluentTheme.of(context).accentColor : Colors.white.withValues(alpha: .7),
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
