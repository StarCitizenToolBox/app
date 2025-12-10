import 'dart:io';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/data/dcb_data.dart';

part 'dcb_viewer.freezed.dart';

part 'dcb_viewer.g.dart';

/// DCB 查看器视图模式
enum DcbViewMode {
  /// 普通列表浏览模式
  browse,

  /// 全文搜索结果模式
  searchResults,
}

/// DCB 查看器输入源类型
enum DcbSourceType {
  /// 未初始化
  none,

  /// 从文件路径加载
  filePath,

  /// 从 P4K 内存数据加载
  p4kMemory,
}

@freezed
abstract class DcbViewerState with _$DcbViewerState {
  const factory DcbViewerState({
    /// 是否正在加载
    @Default(true) bool isLoading,

    /// 加载/错误消息
    @Default('') String message,

    /// 错误消息
    String? errorMessage,

    /// DCB 文件路径（用于显示标题）
    @Default('') String dcbFilePath,

    /// 数据源类型
    @Default(DcbSourceType.none) DcbSourceType sourceType,

    /// 所有记录列表
    @Default([]) List<DcbRecordData> allRecords,

    /// 当前过滤后的记录列表（用于列表搜索）
    @Default([]) List<DcbRecordData> filteredRecords,

    /// 当前选中的记录路径
    String? selectedRecordPath,

    /// 当前显示的 XML 内容
    @Default('') String currentXml,

    /// 列表搜索查询
    @Default('') String listSearchQuery,

    /// 全文搜索查询
    @Default('') String fullTextSearchQuery,

    /// 当前视图模式
    @Default(DcbViewMode.browse) DcbViewMode viewMode,

    /// 全文搜索结果
    @Default([]) List<DcbSearchResultData> searchResults,

    /// 是否正在搜索
    @Default(false) bool isSearching,

    /// 是否正在加载 XML
    @Default(false) bool isLoadingXml,

    /// 是否正在导出
    @Default(false) bool isExporting,

    /// 是否需要选择文件
    @Default(false) bool needSelectFile,
  }) = _DcbViewerState;
}

@riverpod
class DcbViewerModel extends _$DcbViewerModel {
  @override
  DcbViewerState build() {
    ref.onDispose(() async {
      try {
        await unp4k_api.dcbClose();
      } catch (e) {
        dPrint('[DCB Viewer] close error: $e');
      }
    });
    return const DcbViewerState(isLoading: false, needSelectFile: true);
  }

  /// 从磁盘文件路径加载 DCB
  Future<void> initFromFilePath(String filePath) async {
    state = state.copyWith(
      isLoading: true,
      message: S.current.dcb_viewer_loading,
      dcbFilePath: filePath,
      sourceType: DcbSourceType.filePath,
      needSelectFile: false,
      errorMessage: null,
    );

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        state = state.copyWith(isLoading: false, errorMessage: 'File not found: $filePath');
        return;
      }

      final data = await file.readAsBytes();
      await _loadDcbData(data, filePath);
    } catch (e) {
      dPrint('[DCB Viewer] init from file error: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// 从 P4K 文件中提取并加载 DCB (Data/Game2.dcb)
  Future<void> initFromP4kFile(String p4kPath) async {
    state = state.copyWith(
      isLoading: true,
      message: S.current.dcb_viewer_loading,
      dcbFilePath: 'Data/Game2.dcb',
      sourceType: DcbSourceType.p4kMemory,
      needSelectFile: false,
      errorMessage: null,
    );

    try {
      // 打开 P4K 文件
      state = state.copyWith(message: S.current.tools_unp4k_msg_reading);
      await unp4k_api.p4KOpen(p4KPath: p4kPath);

      // 提取 DCB 文件到内存
      state = state.copyWith(message: S.current.dcb_viewer_loading);
      final data = await unp4k_api.p4KExtractToMemory(filePath: '\\Data\\Game2.dcb');

      // 关闭 P4K（已完成提取）
      await unp4k_api.p4KClose();

      // 将数据写入临时文件并加载
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/SCToolbox_dcb/Game2.dcb';
      final tempFile = File(tempPath);
      await tempFile.parent.create(recursive: true);
      await tempFile.writeAsBytes(data);

      state = state.copyWith(dcbFilePath: tempPath);
      await _loadDcbData(Uint8List.fromList(data), tempPath);
    } catch (e) {
      dPrint('[DCB Viewer] init from P4K error: $e');
      // 确保关闭 P4K
      try {
        await unp4k_api.p4KClose();
      } catch (_) {}
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// 从内存数据初始化 DCB 查看器
  Future<void> initFromData(Uint8List data, String filePath) async {
    state = state.copyWith(
      isLoading: true,
      message: S.current.dcb_viewer_loading,
      dcbFilePath: filePath,
      sourceType: DcbSourceType.p4kMemory,
      needSelectFile: false,
      errorMessage: null,
    );

    await _loadDcbData(data, filePath);
  }

  /// 内部方法：加载 DCB 数据
  Future<void> _loadDcbData(Uint8List data, String filePath) async {
    try {
      // 检查是否为 DCB 格式
      final isDataforge = await unp4k_api.dcbIsDataforge(data: data);
      if (!isDataforge) {
        state = state.copyWith(isLoading: false, errorMessage: S.current.dcb_viewer_error_not_dcb);
        return;
      }

      // 解析 DCB 文件
      state = state.copyWith(message: S.current.dcb_viewer_parsing);
      await unp4k_api.dcbOpen(data: data);

      // 获取记录列表
      state = state.copyWith(message: S.current.dcb_viewer_loading_records);
      final apiRecords = await unp4k_api.dcbGetRecordList();

      // 转换为本地数据类型
      final records = apiRecords.map((r) => DcbRecordData(path: r.path, index: r.index.toInt())).toList();

      state = state.copyWith(
        isLoading: false,
        message: S.current.dcb_viewer_loaded_records(records.length),
        allRecords: records,
        filteredRecords: records,
      );
    } catch (e) {
      dPrint('[DCB Viewer] load data error: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// 选择一条记录并加载其 XML
  Future<void> selectRecord(DcbRecordData record) async {
    if (state.selectedRecordPath == record.path) return;

    state = state.copyWith(selectedRecordPath: record.path, isLoadingXml: true, currentXml: '');

    try {
      final xml = await unp4k_api.dcbRecordToXml(path: record.path);
      state = state.copyWith(isLoadingXml: false, currentXml: xml);
    } catch (e) {
      dPrint('[DCB Viewer] load xml error: $e');
      state = state.copyWith(isLoadingXml: false, currentXml: '<!-- Error loading XML: $e -->');
    }
  }

  /// 列表搜索（过滤路径）
  void searchList(String query) {
    state = state.copyWith(listSearchQuery: query);

    if (query.isEmpty) {
      state = state.copyWith(filteredRecords: state.allRecords);
      return;
    }

    final queryLower = query.toLowerCase();
    final filtered = state.allRecords.where((record) {
      return record.path.toLowerCase().contains(queryLower);
    }).toList();

    state = state.copyWith(filteredRecords: filtered);
  }

  /// 全文搜索
  Future<void> searchFullText(String query) async {
    if (query.isEmpty) {
      // 退出搜索模式
      state = state.copyWith(viewMode: DcbViewMode.browse, fullTextSearchQuery: '', searchResults: []);
      return;
    }

    state = state.copyWith(isSearching: true, fullTextSearchQuery: query, viewMode: DcbViewMode.searchResults);

    try {
      final apiResults = await unp4k_api.dcbSearchAll(query: query, maxResults: BigInt.from(1000000));

      // 转换为本地数据类型
      final results = apiResults.map((r) {
        return DcbSearchResultData(
          path: r.path,
          index: r.index.toInt(),
          matches: r.matches
              .map((m) => DcbSearchMatchData(lineNumber: m.lineNumber.toInt(), lineContent: m.lineContent))
              .toList(),
        );
      }).toList();

      state = state.copyWith(
        isSearching: false,
        searchResults: results,
        message: S.current.dcb_viewer_search_results(results.length),
      );
    } catch (e) {
      dPrint('[DCB Viewer] search error: $e');
      state = state.copyWith(isSearching: false, message: 'Search error: $e');
    }
  }

  /// 从搜索结果选择记录
  Future<void> selectFromSearchResult(DcbSearchResultData result) async {
    final record = DcbRecordData(path: result.path, index: result.index);
    await selectRecord(record);
  }

  /// 退出搜索模式
  void exitSearchMode() {
    state = state.copyWith(
      viewMode: DcbViewMode.browse,
      fullTextSearchQuery: '',
      searchResults: [],
      message: S.current.dcb_viewer_loaded_records(state.allRecords.length),
    );
  }

  /// 导出 DCB（合并或分离模式）
  Future<String?> exportToDisk(String outputPath, bool merge) async {
    state = state.copyWith(isExporting: true);

    try {
      await unp4k_api.dcbExportToDisk(outputPath: outputPath, merge: merge, dcbPath: state.dcbFilePath);
      state = state.copyWith(isExporting: false);
      return null; // 成功
    } catch (e) {
      dPrint('[DCB Viewer] export error: $e');
      state = state.copyWith(isExporting: false);
      return e.toString();
    }
  }

  /// 重置状态，回到选择文件界面
  void reset() {
    state = const DcbViewerState(isLoading: false, needSelectFile: true);
  }
}
