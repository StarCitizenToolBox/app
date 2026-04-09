// ignore_for_file: avoid_build_context_in_providers
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:file/memory.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;
import 'package:starcitizen_doctor/common/rust/api/unp4k_model_api.dart'
    as unp4k_model_api;

part 'unp4kc.freezed.dart';

part 'unp4kc.g.dart';

/// 预览文件数据（内存中）
class PreviewFile {
  final String type; // "text", "image", "audio", "model", "loading", "unknown"
  final Uint8List? bytes;
  final String? filePath; // P4K 内部路径（用于显示/缓存键）

  const PreviewFile({required this.type, this.bytes, this.filePath});
}

/// 排序类型枚举
enum Unp4kSortType {
  /// 默认排序（文件夹优先，按名称）
  defaultSort,

  /// 文件大小升序
  sizeAsc,

  /// 文件大小降序
  sizeDesc,

  /// 修改时间升序
  dateAsc,

  /// 修改时间降序
  dateDesc,
}

enum Unp4kFilterMode { none, before, after, range }

enum Unp4kSizeUnit { k, kb, mb, gb }

@freezed
abstract class Unp4kcState with _$Unp4kcState {
  const factory Unp4kcState({
    required bool startUp,
    Map<String, AppUnp4kP4kItemData>? files,
    MemoryFileSystem? fs,
    required String curPath,
    String? endMessage,
    PreviewFile? tempOpenFile,
    String? currentPreviewPath,
    @Default("") String errorMessage,
    @Default(0) int loadingCurrent,
    @Default(0) int loadingTotal,
    @Default("") String searchQuery,
    @Default(<String>[]) List<String> availableSuffixes,
    @Default(false) bool isSearching,

    /// 搜索结果的虚拟文件系统（支持分级展示）
    MemoryFileSystem? searchFs,

    /// 搜索匹配的文件路径集合
    Set<String>? searchMatchedFiles,

    /// 搜索时保留的文件夹（当前目录模式下置顶显示）
    Set<String>? searchKeptDirectories,

    /// 搜索范围：true=全局搜索，false=当前目录
    @Default(false) bool isGlobalSearchScope,

    /// 搜索时的目录路径（当前目录模式时保存）
    String? searchPath,

    @Default(Unp4kSortType.defaultSort) Unp4kSortType sortType,

    /// 是否处于多选模式
    @Default(false) bool isMultiSelectMode,

    /// 多选模式下选中的文件路径集合
    @Default({}) Set<String> selectedItems,

    /// 大小筛选模式
    @Default(Unp4kFilterMode.none) Unp4kFilterMode sizeFilterMode,

    /// 大小筛选单位
    @Default(Unp4kSizeUnit.mb) Unp4kSizeUnit sizeFilterUnit,

    /// 大小筛选单值（用于前/后）
    double? sizeFilterSingleValue,

    /// 大小筛选范围起点
    double? sizeFilterRangeStart,

    /// 大小筛选范围终点
    double? sizeFilterRangeEnd,

    /// 日期筛选模式
    @Default(Unp4kFilterMode.none) Unp4kFilterMode dateFilterMode,

    /// 日期筛选单值（用于前/后）
    DateTime? dateFilterSingleDate,

    /// 日期筛选范围起点
    DateTime? dateFilterRangeStart,

    /// 日期筛选范围终点
    DateTime? dateFilterRangeEnd,

    /// 后缀筛选（多选）
    @Default({}) Set<String> suffixFilter,
  }) = _Unp4kcState;
}

@riverpod
class Unp4kCModel extends _$Unp4kCModel {
  final List<String> _backPathHistory = <String>[];
  final List<String> _forwardPathHistory = <String>[];
  final Map<String, List<String>> _suffixFilesIndex = <String, List<String>>{};

  _FilterState _browseFilters = _FilterState();
  _FilterState _searchFilters = _FilterState();
  String _savedCurPath = "\\";

  bool _isDdnaDdsPath(String lowerPath) {
    return RegExp(r"_ddna\.dds(\.\d+)?$").hasMatch(lowerPath);
  }

  void _saveCurrentFilters() {
    if (state.isSearching) {
      _searchFilters = _FilterState(
        sortType: state.sortType,
        sizeFilterMode: state.sizeFilterMode,
        sizeFilterUnit: state.sizeFilterUnit,
        sizeFilterSingleValue: state.sizeFilterSingleValue,
        sizeFilterRangeStart: state.sizeFilterRangeStart,
        sizeFilterRangeEnd: state.sizeFilterRangeEnd,
        dateFilterMode: state.dateFilterMode,
        dateFilterSingleDate: state.dateFilterSingleDate,
        dateFilterRangeStart: state.dateFilterRangeStart,
        dateFilterRangeEnd: state.dateFilterRangeEnd,
        suffixFilter: state.suffixFilter,
      );
    } else {
      _browseFilters = _FilterState(
        sortType: state.sortType,
        sizeFilterMode: state.sizeFilterMode,
        sizeFilterUnit: state.sizeFilterUnit,
        sizeFilterSingleValue: state.sizeFilterSingleValue,
        sizeFilterRangeStart: state.sizeFilterRangeStart,
        sizeFilterRangeEnd: state.sizeFilterRangeEnd,
        dateFilterMode: state.dateFilterMode,
        dateFilterSingleDate: state.dateFilterSingleDate,
        dateFilterRangeStart: state.dateFilterRangeStart,
        dateFilterRangeEnd: state.dateFilterRangeEnd,
        suffixFilter: state.suffixFilter,
      );
    }
  }

  Unp4kcState _applyFilterState(Unp4kcState s, _FilterState f) {
    return s.copyWith(
      sortType: f.sortType,
      sizeFilterMode: f.sizeFilterMode,
      sizeFilterUnit: f.sizeFilterUnit,
      sizeFilterSingleValue: f.sizeFilterSingleValue,
      sizeFilterRangeStart: f.sizeFilterRangeStart,
      sizeFilterRangeEnd: f.sizeFilterRangeEnd,
      dateFilterMode: f.dateFilterMode,
      dateFilterSingleDate: f.dateFilterSingleDate,
      dateFilterRangeStart: f.dateFilterRangeStart,
      dateFilterRangeEnd: f.dateFilterRangeEnd,
      suffixFilter: f.suffixFilter,
    );
  }

  @override
  Unp4kcState build() {
    state = Unp4kcState(
      startUp: false,
      curPath: '\\',
      endMessage: S.current.tools_unp4k_msg_init,
    );
    _init();
    return state;
  }

  ToolsUIState get _toolsState => ref.read(toolsUIModelProvider);

  String getGamePath() => _toolsState.scInstalledPath;

  void _init() async {
    final gamePath = getGamePath();
    final gameP4kPath = "$gamePath\\Data.p4k".platformPath;

    try {
      state = state.copyWith(endMessage: S.current.tools_unp4k_msg_reading);

      final loadStartTime = DateTime.now();

      await unp4k_api.p4KOpen(p4KPath: gameP4kPath);

      state = state.copyWith(endMessage: S.current.tools_unp4k_msg_reading2);

      final p4kFiles = await unp4k_api.p4KGetAllFiles();
      state = state.copyWith(loadingCurrent: 0, loadingTotal: p4kFiles.length);

      final files = <String, AppUnp4kP4kItemData>{};
      final suffixes = <String>{};
      final fs = MemoryFileSystem(style: FileSystemStyle.posix);
      _suffixFilesIndex.clear();

      var nextAwait = 0;
      for (var i = 0; i < p4kFiles.length; i++) {
        final item = p4kFiles[i];
        final fileData = AppUnp4kP4kItemData(
          name: item.name,
          isDirectory: item.isDirectory,
          size: item.size.toInt(),
          compressedSize: item.compressedSize.toInt(),
          dateModified: item.dateModified,
        );

        files[item.name] = fileData;
        if (!item.isDirectory) {
          final ext = _extractFileExtension(item.name);
          if (ext.isNotEmpty) {
            suffixes.add(ext);
            (_suffixFilesIndex[ext] ??= <String>[]).add(item.name);
          }
        }

        if (!item.isDirectory) {
          await fs
              .file(item.name.replaceAll("\\", "/"))
              .create(recursive: true);
        }

        if (i == nextAwait) {
          state = state.copyWith(
            endMessage: S.current.tools_unp4k_msg_reading3(i, p4kFiles.length),
            loadingCurrent: i,
          );
          await Future.delayed(Duration(milliseconds: 1));
          nextAwait += 30000;
        }
      }

      final endTime = DateTime.now();
      state = state.copyWith(
        files: files,
        fs: fs,
        availableSuffixes: suffixes.toList()..sort(),
        loadingCurrent: p4kFiles.length,
        loadingTotal: p4kFiles.length,
        endMessage: S.current.tools_unp4k_msg_read_completed(
          files.length,
          endTime.difference(loadStartTime).inMilliseconds,
        ),
      );
    } catch (e) {
      dPrint("[unp4k] error: $e");
      state = state.copyWith(errorMessage: e.toString());
      AnalyticsApi.touch("unp4k_error");
    }

    ref.onDispose(() async {
      try {
        unawaited(clearTempWemCache());
        await unp4k_api.p4KClose();
      } catch (e) {
        dPrint("[unp4k] close error: $e");
      }
    });
  }

  /// 清理 P4K 预览临时音频缓存（.wem、旧 .ogg 预览缓存与 .preview.v2.wav）
  Future<void> clearTempWemCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final rootPath =
          "${tempDir.absolute.path}\\SCToolbox_unp4kc\\${SCLoggerHelper.getGameChannelID(getGamePath())}\\";
      final rootDir = Directory(rootPath.platformPath);
      if (!await rootDir.exists()) return;

      await for (final entity in rootDir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is! File) continue;
        final lower = entity.path.toLowerCase();
        if (lower.endsWith(".wem") ||
            lower.endsWith(".preview.v2.wav") ||
            lower.endsWith(".preview.mid10s.v1.wav") ||
            lower.endsWith(".preview.v2.ogg") ||
            lower.endsWith(".preview.mid10s.v1.ogg")) {
          try {
            await entity.delete();
          } catch (_) {}
        }
      }
    } catch (e) {
      dPrint("[unp4k] clearTempWemCache error: $e");
    }
  }

  List<AppUnp4kP4kItemData>? getFiles() {
    final result = <AppUnp4kP4kItemData>[];
    final allFiles = state.files;
    if (allFiles == null) return null;

    if (state.searchMatchedFiles != null) {
      // 先添加保留的文件夹（当前目录搜索模式下）
      if (state.searchKeptDirectories != null) {
        for (final dirPath in state.searchKeptDirectories!) {
          final d = allFiles[dirPath];
          if (d != null) {
            if (!(d.name?.startsWith("\\") ?? true)) {
              d.name = "\\${d.name}";
            }
            result.add(d);
          } else {
            // 创建虚拟文件夹项
            result.add(AppUnp4kP4kItemData(name: dirPath, isDirectory: true));
          }
        }
      }
      // 再添加匹配的文件
      for (final filePath in state.searchMatchedFiles!) {
        final f = allFiles[filePath];
        if (f == null) continue;
        if (!(f.name?.startsWith("\\") ?? true)) {
          f.name = "\\${f.name}";
        }
        result.add(f);
      }
    } else {
      final path = state.curPath.replaceAll("\\", "/");
      final fs = state.fs;
      if (fs == null) return null;

      final dir = fs.directory(path);
      if (!dir.existsSync()) return [];
      final files = dir.listSync(recursive: false, followLinks: false);

      for (var file in files) {
        if (file is File) {
          final f = allFiles[file.path.replaceAll("/", "\\")];
          if (f != null) {
            if (!(f.name?.startsWith("\\") ?? true)) {
              f.name = "\\${f.name}";
            }
            result.add(f);
          }
        } else {
          result.add(
            AppUnp4kP4kItemData(
              name: file.path.replaceAll("/", "\\"),
              isDirectory: true,
            ),
          );
        }
      }
    }

    _applyAdvancedFilters(result);
    _sortFiles(result);
    return result;
  }

  void _applyAdvancedFilters(List<AppUnp4kP4kItemData> files) {
    _applySuffixFilter(files);
    _applySizeFilter(files);
    _applyDateFilter(files);
  }

  void _applySuffixFilter(List<AppUnp4kP4kItemData> files) {
    if (state.suffixFilter.isEmpty) return;

    files.removeWhere((item) {
      // 文件夹始终保留
      if (item.isDirectory ?? false) return false;
      final name = item.name ?? "";
      final ext = _extractFileExtension(name);
      // 不在后缀列表中的文件移除
      return !state.suffixFilter.contains(ext);
    });
  }

  void _applySizeFilter(List<AppUnp4kP4kItemData> files) {
    if (state.sizeFilterMode == Unp4kFilterMode.none) return;

    // 检查必要的值是否已输入
    bool hasValidValue = false;
    if (state.sizeFilterMode == Unp4kFilterMode.range) {
      hasValidValue =
          state.sizeFilterRangeStart != null &&
          state.sizeFilterRangeEnd != null;
    } else {
      hasValidValue = state.sizeFilterSingleValue != null;
    }
    if (!hasValidValue) return;

    final unitBytes = _sizeUnitToBytes(state.sizeFilterUnit);
    final single = (state.sizeFilterSingleValue ?? 0) * unitBytes;
    final rangeStart = (state.sizeFilterRangeStart ?? 0) * unitBytes;
    final rangeEnd = (state.sizeFilterRangeEnd ?? 0) * unitBytes;

    files.removeWhere((item) {
      // 文件夹始终保留
      if (item.isDirectory ?? false) return false;
      final size = (item.size ?? 0).toDouble();
      switch (state.sizeFilterMode) {
        case Unp4kFilterMode.none:
          return false;
        case Unp4kFilterMode.before:
          return size > single;
        case Unp4kFilterMode.after:
          return size < single;
        case Unp4kFilterMode.range:
          final minV = math.min(rangeStart, rangeEnd);
          final maxV = math.max(rangeStart, rangeEnd);
          return size < minV || size > maxV;
      }
    });
  }

  void _applyDateFilter(List<AppUnp4kP4kItemData> files) {
    if (state.dateFilterMode == Unp4kFilterMode.none) return;

    // 检查必要的值是否已输入
    bool hasValidValue = false;
    if (state.dateFilterMode == Unp4kFilterMode.range) {
      hasValidValue =
          state.dateFilterRangeStart != null &&
          state.dateFilterRangeEnd != null;
    } else {
      hasValidValue = state.dateFilterSingleDate != null;
    }
    if (!hasValidValue) return;

    files.removeWhere((item) {
      // 文件夹始终保留
      if (item.isDirectory ?? false) return false;
      final ms = item.dateModified;
      if (ms == null) return true;
      final dt = DateTime.fromMillisecondsSinceEpoch(ms);
      final day = DateTime(dt.year, dt.month, dt.day);
      switch (state.dateFilterMode) {
        case Unp4kFilterMode.none:
          return false;
        case Unp4kFilterMode.before:
          final d = DateTime(
            state.dateFilterSingleDate!.year,
            state.dateFilterSingleDate!.month,
            state.dateFilterSingleDate!.day,
          );
          return day.isAfter(d);
        case Unp4kFilterMode.after:
          final d = DateTime(
            state.dateFilterSingleDate!.year,
            state.dateFilterSingleDate!.month,
            state.dateFilterSingleDate!.day,
          );
          return day.isBefore(d);
        case Unp4kFilterMode.range:
          final start = DateTime(
            state.dateFilterRangeStart!.year,
            state.dateFilterRangeStart!.month,
            state.dateFilterRangeStart!.day,
          );
          final end = DateTime(
            state.dateFilterRangeEnd!.year,
            state.dateFilterRangeEnd!.month,
            state.dateFilterRangeEnd!.day,
          );
          final minD = start.isBefore(end) ? start : end;
          final maxD = start.isBefore(end) ? end : start;
          return day.isBefore(minD) || day.isAfter(maxD);
      }
    });
  }

  double _sizeUnitToBytes(Unp4kSizeUnit unit) {
    switch (unit) {
      case Unp4kSizeUnit.k:
        return 1000;
      case Unp4kSizeUnit.kb:
        return 1024;
      case Unp4kSizeUnit.mb:
        return 1024 * 1024;
      case Unp4kSizeUnit.gb:
        return 1024 * 1024 * 1024;
    }
  }

  String _extractFileExtension(String? filePath) {
    if (filePath == null || filePath.isEmpty) return "";
    final normalized = filePath.replaceAll("/", "\\");
    final fileName = normalized.split("\\").last;
    final dotIndex = fileName.lastIndexOf(".");
    if (dotIndex <= 0 || dotIndex == fileName.length - 1) {
      return "";
    }
    return fileName.substring(dotIndex).toLowerCase();
  }

  /// 对文件列表进行排序
  void _sortFiles(List<AppUnp4kP4kItemData> files) {
    switch (state.sortType) {
      case Unp4kSortType.defaultSort:
        // 默认排序：文件夹优先，按名称排序
        files.sort((a, b) {
          if ((a.isDirectory ?? false) && !(b.isDirectory ?? false)) {
            return -1;
          } else if (!(a.isDirectory ?? false) && (b.isDirectory ?? false)) {
            return 1;
          } else {
            return (a.name ?? "").compareTo(b.name ?? "");
          }
        });
        break;
      case Unp4kSortType.sizeAsc:
        // 文件大小升序（文件夹大小视为0）
        files.sort((a, b) {
          if ((a.isDirectory ?? false) && !(b.isDirectory ?? false)) {
            return -1;
          } else if (!(a.isDirectory ?? false) && (b.isDirectory ?? false)) {
            return 1;
          }
          final sizeA = (a.isDirectory ?? false) ? 0 : (a.size ?? 0);
          final sizeB = (b.isDirectory ?? false) ? 0 : (b.size ?? 0);
          return sizeA.compareTo(sizeB);
        });
        break;
      case Unp4kSortType.sizeDesc:
        // 文件大小降序
        files.sort((a, b) {
          if ((a.isDirectory ?? false) && !(b.isDirectory ?? false)) {
            return -1;
          } else if (!(a.isDirectory ?? false) && (b.isDirectory ?? false)) {
            return 1;
          }
          final sizeA = (a.isDirectory ?? false) ? 0 : (a.size ?? 0);
          final sizeB = (b.isDirectory ?? false) ? 0 : (b.size ?? 0);
          return sizeB.compareTo(sizeA);
        });
        break;
      case Unp4kSortType.dateAsc:
        // 修改时间升序
        files.sort((a, b) {
          if ((a.isDirectory ?? false) && !(b.isDirectory ?? false)) {
            return -1;
          } else if (!(a.isDirectory ?? false) && (b.isDirectory ?? false)) {
            return 1;
          }
          final dateA = a.dateModified ?? 0;
          final dateB = b.dateModified ?? 0;
          return dateA.compareTo(dateB);
        });
        break;
      case Unp4kSortType.dateDesc:
        // 修改时间降序
        files.sort((a, b) {
          if ((a.isDirectory ?? false) && !(b.isDirectory ?? false)) {
            return -1;
          } else if (!(a.isDirectory ?? false) && (b.isDirectory ?? false)) {
            return 1;
          }
          final dateA = a.dateModified ?? 0;
          final dateB = b.dateModified ?? 0;
          return dateB.compareTo(dateA);
        });
        break;
    }
  }

  /// 设置排序类型
  void setSortType(Unp4kSortType sortType) {
    state = state.copyWith(sortType: sortType);
  }

  void setSizeFilterMode(Unp4kFilterMode mode) {
    state = state.copyWith(sizeFilterMode: mode);
  }

  void setSizeFilterUnit(Unp4kSizeUnit unit) {
    state = state.copyWith(sizeFilterUnit: unit);
  }

  void setSizeFilterSingleValue(double? value) {
    state = state.copyWith(sizeFilterSingleValue: value);
  }

  void setSizeFilterRange(double? start, double? end) {
    state = state.copyWith(
      sizeFilterRangeStart: start,
      sizeFilterRangeEnd: end,
    );
  }

  void clearSizeFilter() {
    state = state.copyWith(
      sizeFilterMode: Unp4kFilterMode.none,
      sizeFilterSingleValue: null,
      sizeFilterRangeStart: null,
      sizeFilterRangeEnd: null,
    );
  }

  void setDateFilterMode(Unp4kFilterMode mode) {
    state = state.copyWith(dateFilterMode: mode);
  }

  void setDateFilterSingleDate(DateTime? date) {
    state = state.copyWith(dateFilterSingleDate: date);
  }

  void setDateFilterRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      dateFilterRangeStart: start,
      dateFilterRangeEnd: end,
    );
  }

  void clearDateFilter() {
    state = state.copyWith(
      dateFilterMode: Unp4kFilterMode.none,
      dateFilterSingleDate: null,
      dateFilterRangeStart: null,
      dateFilterRangeEnd: null,
    );
  }

  /// 切换后缀筛选
  void toggleSuffixFilter(String suffix) {
    final current = Set<String>.from(state.suffixFilter);
    if (current.contains(suffix)) {
      current.remove(suffix);
    } else {
      current.add(suffix);
    }
    state = state.copyWith(suffixFilter: current);
  }

  /// 设置后缀筛选
  void setSuffixFilter(Set<String> suffixes) {
    state = state.copyWith(suffixFilter: suffixes);
  }

  /// 清除后缀筛选
  void clearSuffixFilter() {
    state = state.copyWith(suffixFilter: {});
  }

  /// 设置搜索范围
  void setSearchScope(bool isGlobal) {
    state = state.copyWith(isGlobalSearchScope: isGlobal);
  }

  /// 执行搜索（异步）
  Future<void> search(String query) async {
    if (query.isEmpty) {
      clearSearch();
      return;
    }

    _saveCurrentFilters();

    // 只在浏览模式下保存当前路径（搜索模式下 curPath 是根目录）
    if (state.searchMatchedFiles == null) {
      _savedCurPath = state.curPath;
    }

    final isGlobal = state.isGlobalSearchScope;
    String? pathPrefix;
    String? searchPath;
    if (!isGlobal) {
      pathPrefix = _savedCurPath.replaceAll("\\", "/");
      if (!pathPrefix.endsWith("/")) {
        pathPrefix = "$pathPrefix/";
      }
      searchPath = _savedCurPath;
    }

    state = _applyFilterState(
      state.copyWith(
        searchQuery: query,
        isSearching: true,
        searchPath: searchPath,
        endMessage: S.current.tools_unp4k_searching,
      ),
      _searchFilters,
    );

    final allFiles = state.files;
    if (allFiles == null) {
      state = state.copyWith(isSearching: false);
      return;
    }

    try {
      final searchResult = await compute(
        _searchFiles,
        _SearchParams(allFiles, query, pathPrefix),
      );
      final matchedFiles = searchResult.matchedFiles;
      final keptDirs = searchResult.keptDirectories;

      state = state.copyWith(
        searchMatchedFiles: matchedFiles,
        searchKeptDirectories: keptDirs,
        isSearching: false,
        curPath: "\\",
        endMessage: matchedFiles.isEmpty && keptDirs.isEmpty
            ? S.current.tools_unp4k_search_no_result
            : S.current.tools_unp4k_msg_read_completed(
                matchedFiles.length + keptDirs.length,
                0,
              ),
      );
    } catch (e) {
      dPrint("[unp4k] search error: $e");
      state = state.copyWith(isSearching: false, endMessage: e.toString());
    }
  }

  /// 清除搜索（恢复浏览模式筛选状态）
  /// [targetPath] 可选的目标路径，用于直接切换到新目录
  void clearSearch({String? targetPath}) {
    _saveCurrentFilters();
    final newPath = targetPath ?? _savedCurPath;
    _savedCurPath = newPath;
    state = _applyFilterState(
      state.copyWith(
        searchQuery: "",
        searchMatchedFiles: null,
        searchKeptDirectories: null,
        isSearching: false,
        curPath: newPath,
        searchPath: null,
      ),
      _browseFilters,
    );
  }

  /// 进入多选模式
  void enterMultiSelectMode() {
    state = state.copyWith(isMultiSelectMode: true, selectedItems: {});
  }

  /// 退出多选模式
  void exitMultiSelectMode() {
    state = state.copyWith(isMultiSelectMode: false, selectedItems: {});
  }

  /// 切换选中状态
  void toggleSelectItem(String itemPath) {
    final currentSelected = Set<String>.from(state.selectedItems);
    if (currentSelected.contains(itemPath)) {
      currentSelected.remove(itemPath);
    } else {
      currentSelected.add(itemPath);
    }
    state = state.copyWith(selectedItems: currentSelected);
  }

  /// 全选当前目录的文件
  void selectAll(List<AppUnp4kP4kItemData>? files) {
    if (files == null) return;
    final currentSelected = Set<String>.from(state.selectedItems);
    for (var file in files) {
      final path = file.name ?? "";
      if (path.isNotEmpty) {
        currentSelected.add(path);
      }
    }
    state = state.copyWith(selectedItems: currentSelected);
  }

  /// 取消全选当前目录的文件
  void deselectAll(List<AppUnp4kP4kItemData>? files) {
    if (files == null) return;
    final currentSelected = Set<String>.from(state.selectedItems);
    for (var file in files) {
      final path = file.name ?? "";
      currentSelected.remove(path);
    }
    state = state.copyWith(selectedItems: currentSelected);
  }

  void changeDir(String name, {bool fullPath = false}) {
    // 切换目录时退出多选模式
    if (state.isMultiSelectMode) {
      state = state.copyWith(isMultiSelectMode: false, selectedItems: {});
    }
    // 切换目录时不清除搜索，只改变当前路径
    final targetPath = fullPath ? name : "${state.curPath}$name\\";
    _navigateToPath(targetPath);
  }

  bool canGoBackPath() => _backPathHistory.isNotEmpty;

  bool canGoForwardPath() => _forwardPathHistory.isNotEmpty;

  void goBackPath() {
    if (_backPathHistory.isEmpty) return;
    final target = _backPathHistory.removeLast();
    final current = state.curPath;
    if (current != target) {
      _forwardPathHistory.add(current);
      state = state.copyWith(curPath: target);
    }
  }

  void goForwardPath() {
    if (_forwardPathHistory.isEmpty) return;
    final target = _forwardPathHistory.removeLast();
    final current = state.curPath;
    if (current != target) {
      _backPathHistory.add(current);
      state = state.copyWith(curPath: target);
    }
  }

  void _navigateToPath(String targetPath) {
    if (targetPath == state.curPath) return;
    if (_backPathHistory.isEmpty || _backPathHistory.last != state.curPath) {
      _backPathHistory.add(state.curPath);
    }
    _forwardPathHistory.clear();
    state = state.copyWith(curPath: targetPath);
  }

  /// 带路径存在性校验的目录切换
  bool changeDirValidated(String name, {bool fullPath = false}) {
    var targetPath = fullPath ? name : "${state.curPath}$name\\";
    targetPath = _normalizeDirPath(targetPath);

    final fs = state.fs;
    if (fs == null) return false;

    final exists = fs.directory(targetPath.replaceAll("\\", "/")).existsSync();
    if (!exists) {
      state = state.copyWith(endMessage: "路径不存在: $targetPath");
      return false;
    }

    changeDir(targetPath, fullPath: true);
    return true;
  }

  /// 搜索结果中跳转到文件所在目录
  void jumpToFileLocation(String filePath) {
    var normalized = filePath.replaceAll("/", "\\");
    if (!normalized.startsWith("\\")) {
      normalized = "\\$normalized";
    }

    final idx = normalized.lastIndexOf("\\");
    final dir = idx > 0 ? normalized.substring(0, idx + 1) : "\\";
    final ok = changeDirValidated(dir, fullPath: true);
    if (!ok) return;

    // 跳转到真实目录后退出搜索模式，便于继续浏览
    clearSearch();
    state = state.copyWith(curPath: dir);
  }

  String _normalizeDirPath(String path) {
    var normalized = path.trim().replaceAll("/", "\\");
    if (normalized.isEmpty) return "\\";
    if (!normalized.startsWith("\\")) {
      normalized = "\\$normalized";
    }
    if (!normalized.endsWith("\\")) {
      normalized = "$normalized\\";
    }
    return normalized;
  }

  Future<void> openFile(String filePath, {BuildContext? context}) async {
    state = state.copyWith(
      tempOpenFile: const PreviewFile(type: "loading"),
      currentPreviewPath: filePath,
      endMessage: S.current.tools_unp4k_msg_open_file(filePath),
    );
    await extractFile(
      filePath,
      mode: "extract_open",
      context: context,
    );
  }

  Future<void> extractFile(
    String filePath, {
    String mode = "extract",
    String? outputPath,
    BuildContext? context,
  }) async {
    try {
      // remove first \\
      if (filePath.startsWith("\\")) {
        filePath = filePath.substring(1);
      }

      if (mode == "extract_open") {
        // 预览模式：直接在内存中完成解码，不写临时文件
        final lowerFilePath = filePath.toLowerCase();

        // DCB 仍走磁盘（DCB Viewer 需要文件路径）
        if (context != null && lowerFilePath.endsWith(".dcb")) {
          final tempDir = await getTemporaryDirectory();
          final tempPath =
              "${tempDir.absolute.path}\\SCToolbox_unp4kc\\${SCLoggerHelper.getGameChannelID(getGamePath())}\\";
          final fullOutputPath = "$tempPath$filePath";
          await unp4k_api.p4KExtractToDisk(
            filePath: filePath,
            outputPath: tempPath,
          );
          // 关闭 loading 状态
          state = state.copyWith(
            tempOpenFile: null,
            endMessage: S.current.tools_unp4k_msg_open_file(filePath),
          );
          // 跳转至 DCBViewer
          if (context.mounted) {
            context.push("/tools/dcb_viewer", extra: {"path": fullOutputPath});
          }
          return;
        }

        // DDS: 使用内存解码
        final isDdsChain =
            lowerFilePath.endsWith(".dds") ||
            RegExp(r"\.dds\.\d+$").hasMatch(lowerFilePath);
        if (isDdsChain && !_isDdnaDdsPath(lowerFilePath)) {
          try {
            final result = await unp4k_api.p4KExtractDdsAsPng(
              filePath: filePath,
            );
            final pngBytes = result.$1;
            state = state.copyWith(
              tempOpenFile: PreviewFile(
                type: "image",
                bytes: pngBytes,
                filePath: filePath,
              ),
              endMessage: S.current.tools_unp4k_msg_open_file(filePath),
            );
            return;
          } catch (e) {
            dPrint("[unp4k] dds preview decode failed: $e");
          }
        }

        // 文件类型判断
        const textExt = [
          ".txt",
          ".xml",
          ".json",
          ".lua",
          ".cfg",
          ".ini",
          ".mtl",
        ];
        const imgExt = [".png", ".jpg", ".jpeg", ".bmp", ".gif", ".webp"];
        const audioExt = [".wem"];
        const modelExt = [".cgf", ".cga"];
        String openType = "unknown";
        for (var element in textExt) {
          if (lowerFilePath.endsWith(element)) {
            openType = "text";
          }
        }
        for (var element in imgExt) {
          if (lowerFilePath.endsWith(element)) {
            openType = "image";
          }
        }
        for (var element in audioExt) {
          if (lowerFilePath.endsWith(element)) {
            openType = "audio";
          }
        }
        for (var element in modelExt) {
          if (lowerFilePath.endsWith(element)) {
            try {
              final glbResult = await convertModelToGlbBytes(filePath);
              if (glbResult.$1 && glbResult.$2 != null) {
                state = state.copyWith(
                  tempOpenFile: PreviewFile(
                    type: "model",
                    bytes: glbResult.$2!,
                    filePath: filePath,
                  ),
                  endMessage: S.current.tools_unp4k_msg_open_file(filePath),
                );
                return;
              }
            } catch (e) {
              dPrint("[unp4k] model convert failed: $e");
            }
          }
        }

        // 对于已知可预览类型或 unknown，提取原始字节到内存
        if (openType != "unknown") {
          final rawBytes = await unp4k_api.p4KExtractToMemory(
            filePath: filePath,
          );
          state = state.copyWith(
            tempOpenFile: PreviewFile(
              type: openType,
              bytes: Uint8List.fromList(rawBytes),
              filePath: filePath,
            ),
            endMessage: S.current.tools_unp4k_msg_open_file(filePath),
          );
        } else {
          // 不可预览：提取原始字节用于导出
          final rawBytes = await unp4k_api.p4KExtractToMemory(
            filePath: filePath,
          );
          state = state.copyWith(
            tempOpenFile: PreviewFile(
              type: "unknown",
              bytes: Uint8List.fromList(rawBytes),
              filePath: filePath,
            ),
            endMessage: S.current.tools_unp4k_msg_open_file(filePath),
          );
        }
      } else {
        // 导出模式：仍走磁盘
        if (outputPath == null) return;
        await unp4k_api.p4KExtractToDisk(
          filePath: filePath,
          outputPath: outputPath,
        );
      }
    } catch (e) {
      dPrint("[unp4k] extractFile error: $e");
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 提取文件或文件夹到指定目录（带进度回调和取消支持）
  /// [item] 要提取的文件或文件夹
  /// [outputDir] 输出目录
  /// [onProgress] 进度回调 (当前文件索引, 总文件数, 当前文件名)
  /// [isCancelled] 取消检查函数，返回 true 表示取消
  /// 返回值：(是否成功, 已提取文件数, 错误信息)
  Future<(bool, int, String?)> extractToDirectoryWithProgress(
    AppUnp4kP4kItemData item,
    String outputDir, {
    void Function(int current, int total, String currentFile)? onProgress,
    bool Function()? isCancelled,
  }) async {
    try {
      final itemPath = item.name ?? "";
      var filePath = itemPath;
      if (filePath.startsWith("\\")) {
        filePath = filePath.substring(1);
      }

      if (item.isDirectory ?? false) {
        // 提取文件夹：遍历所有以该路径为前缀的文件
        final allFiles = state.files;
        if (allFiles != null) {
          final prefix = itemPath.endsWith("\\") ? itemPath : "$itemPath\\";

          // 收集所有需要提取的文件
          final filesToExtract = <MapEntry<String, AppUnp4kP4kItemData>>[];
          for (var entry in allFiles.entries) {
            if (entry.key.startsWith(prefix) &&
                !(entry.value.isDirectory ?? false)) {
              filesToExtract.add(entry);
            }
          }

          final total = filesToExtract.length;
          var current = 0;

          for (var entry in filesToExtract) {
            // 检查是否取消
            if (isCancelled?.call() == true) {
              return (false, current, S.current.tools_unp4k_extract_cancelled);
            }

            var entryPath = entry.key;
            if (entryPath.startsWith("\\")) {
              entryPath = entryPath.substring(1);
            }

            current++;
            onProgress?.call(current, total, entryPath);
            await unp4k_api.p4KExtractToDisk(
              filePath: entryPath,
              outputPath: outputDir,
            );
          }

          state = state.copyWith(
            endMessage: S.current.tools_unp4k_extract_completed(current),
          );
          return (true, current, null);
        }
        return (true, 0, null);
      } else {
        // 提取单个文件
        onProgress?.call(1, 1, filePath);

        // 检查是否取消
        if (isCancelled?.call() == true) {
          return (false, 0, S.current.tools_unp4k_extract_cancelled);
        }

        await unp4k_api.p4KExtractToDisk(
          filePath: filePath,
          outputPath: outputDir,
        );

        state = state.copyWith(
          endMessage: S.current.tools_unp4k_extract_completed(1),
        );
        return (true, 1, null);
      }
    } catch (e) {
      dPrint("[unp4k] extractToDirectoryWithProgress error: $e");
      return (false, 0, e.toString());
    }
  }

  /// 获取文件夹中需要提取的文件数量
  int getFileCountInDirectory(AppUnp4kP4kItemData item) {
    if (!(item.isDirectory ?? false)) {
      return 1;
    }

    final itemPath = item.name ?? "";
    final prefix = itemPath.endsWith("\\") ? itemPath : "$itemPath\\";
    final allFiles = state.files;

    if (allFiles == null) return 0;

    int count = 0;
    for (var entry in allFiles.entries) {
      if (entry.key.startsWith(prefix) && !(entry.value.isDirectory ?? false)) {
        count++;
      }
    }
    return count;
  }

  /// 获取多选项的总文件数量
  int getFileCountForSelectedItems(Set<String> selectedItems) {
    int count = 0;
    final allFiles = state.files;
    if (allFiles == null) return 0;

    for (var itemPath in selectedItems) {
      final item = allFiles[itemPath];
      if (item != null) {
        if (item.isDirectory ?? false) {
          count += getFileCountInDirectory(item);
        } else {
          count += 1;
        }
      } else {
        // 可能是文件夹（虚拟路径）
        final prefix = itemPath.endsWith("\\") ? itemPath : "$itemPath\\";
        for (var entry in allFiles.entries) {
          if (entry.key.startsWith(prefix) &&
              !(entry.value.isDirectory ?? false)) {
            count++;
          }
        }
      }
    }
    return count;
  }

  /// 批量提取多个选中项到指定目录（带进度回调和取消支持）
  Future<(bool, int, String?)> extractSelectedItemsWithProgress(
    Set<String> selectedItems,
    String outputDir, {
    void Function(int current, int total, String currentFile)? onProgress,
    bool Function()? isCancelled,
  }) async {
    try {
      final allFiles = state.files;
      if (allFiles == null) return (true, 0, null);

      // 收集所有需要提取的文件
      final filesToExtract = <String>[];

      for (var itemPath in selectedItems) {
        final item = allFiles[itemPath];
        if (item != null) {
          if (item.isDirectory ?? false) {
            // 文件夹：收集所有子文件
            final prefix = itemPath.endsWith("\\") ? itemPath : "$itemPath\\";
            for (var entry in allFiles.entries) {
              if (entry.key.startsWith(prefix) &&
                  !(entry.value.isDirectory ?? false)) {
                filesToExtract.add(entry.key);
              }
            }
          } else {
            // 单个文件
            filesToExtract.add(itemPath);
          }
        } else {
          // 可能是虚拟文件夹路径
          final prefix = itemPath.endsWith("\\") ? itemPath : "$itemPath\\";
          for (var entry in allFiles.entries) {
            if (entry.key.startsWith(prefix) &&
                !(entry.value.isDirectory ?? false)) {
              filesToExtract.add(entry.key);
            }
          }
        }
      }

      final total = filesToExtract.length;
      var current = 0;

      for (var filePath in filesToExtract) {
        // 检查是否取消
        if (isCancelled?.call() == true) {
          return (false, current, S.current.tools_unp4k_extract_cancelled);
        }

        var extractPath = filePath;
        if (extractPath.startsWith("\\")) {
          extractPath = extractPath.substring(1);
        }

        current++;
        onProgress?.call(current, total, extractPath);
        await unp4k_api.p4KExtractToDisk(
          filePath: extractPath,
          outputPath: outputDir,
        );
      }

      state = state.copyWith(
        endMessage: S.current.tools_unp4k_extract_completed(current),
      );
      return (true, current, null);
    } catch (e) {
      dPrint("[unp4k] extractSelectedItemsWithProgress error: $e");
      return (false, 0, e.toString());
    }
  }

  /// 从 P4K 文件中提取指定文件到内存
  /// [p4kPath] P4K 文件路径
  /// [filePath] 要提取的文件路径（P4K 内部路径）
  static Future<Uint8List> extractP4kFileToMemory(
    String p4kPath,
    String filePath,
  ) async {
    try {
      await unp4k_api.p4KOpen(p4KPath: p4kPath);
      final data = await unp4k_api.p4KExtractToMemory(filePath: filePath);
      await unp4k_api.p4KClose();
      return Uint8List.fromList(data);
    } catch (e) {
      throw Exception("extractP4kFileToMemory error: $e");
    }
  }

  /// 将 P4K 内模型转换为内嵌贴图 GLB 文件
  /// 返回：(是否成功, 输出路径, 错误信息)
  Future<(bool, String?, String?)> convertModelToGlb(
    String filePath,
    String outputDir,
  ) async {
    try {
      var modelPath = filePath;
      if (modelPath.startsWith("\\")) {
        modelPath = modelPath.substring(1);
      }
      final supported = await unp4k_model_api.p4KModelIsSupported(
        filePath: modelPath,
      );
      if (!supported) {
        final err = S.current.tools_unp4k_convert_unsupported;
        state = state.copyWith(endMessage: err);
        return (false, null, err);
      }

      final gameP4kPath = "${getGamePath()}\\Data.p4k".platformPath;
      final result = await unp4k_model_api.p4KModelConvertToGlb(
        p4KPath: gameP4kPath,
        modelPath: modelPath,
        outputDir: outputDir,
        options: const unp4k_model_api.ModelConvertOptions(
          embedTextures: true,
          overwrite: true,
          maxTextureSize: 4096,
        ),
      );

      if (result.success) {
        final outputPath = result.outputPath;
        state = state.copyWith(
          endMessage: outputPath == null
              ? S.current.tools_unp4k_convert_success
              : "${S.current.tools_unp4k_convert_success}\n$outputPath",
        );
        return (true, outputPath, null);
      }

      final errorCode = result.errorCode;
      final err = errorCode == "ERR_UNSUPPORTED_FORMAT"
          ? S.current.tools_unp4k_convert_unsupported
          : (result.errorMessage ?? errorCode ?? "Unknown");
      state = state.copyWith(
        endMessage: S.current.tools_unp4k_convert_failed(err),
      );
      return (false, null, err);
    } catch (e) {
      dPrint("[unp4k] convertModelToGlb error: $e");
      final err = e.toString();
      state = state.copyWith(
        endMessage: S.current.tools_unp4k_convert_failed(err),
      );
      return (false, null, err);
    }
  }

  /// 将 P4K 内模型转换为 GLB 字节（内存中）
  /// 返回：(是否成功, GLB字节, 错误信息)
  Future<(bool, Uint8List?, String?)> convertModelToGlbBytes(
    String filePath,
  ) async {
    try {
      var modelPath = filePath;
      if (modelPath.startsWith("\\")) {
        modelPath = modelPath.substring(1);
      }
      final supported = await unp4k_model_api.p4KModelIsSupported(
        filePath: modelPath,
      );
      if (!supported) {
        final err = S.current.tools_unp4k_convert_unsupported;
        state = state.copyWith(endMessage: err);
        return (false, null, err);
      }

      final gameP4kPath = "${getGamePath()}\\Data.p4k".platformPath;
      final result = await unp4k_model_api.p4KModelConvertToGlbBytes(
        p4KPath: gameP4kPath,
        modelPath: modelPath,
        options: const unp4k_model_api.ModelConvertOptions(
          embedTextures: true,
          overwrite: true,
          maxTextureSize: 4096,
        ),
      );

      if (result.success && result.glbBytes != null) {
        state = state.copyWith(
          endMessage: S.current.tools_unp4k_convert_success,
        );
        return (true, result.glbBytes!, null);
      }

      final errorCode = result.errorCode;
      final err = errorCode == "ERR_UNSUPPORTED_FORMAT"
          ? S.current.tools_unp4k_convert_unsupported
          : (result.errorMessage ?? errorCode ?? "Unknown");
      state = state.copyWith(
        endMessage: S.current.tools_unp4k_convert_failed(err),
      );
      return (false, null, err);
    } catch (e) {
      dPrint("[unp4k] convertModelToGlbBytes error: $e");
      final err = e.toString();
      state = state.copyWith(
        endMessage: S.current.tools_unp4k_convert_failed(err),
      );
      return (false, null, err);
    }
  }

  /// 将 P4K 内的 DDS（含 .dds.x）按预览解码链路转换为 PNG 并写入指定目录
  /// 返回：(是否成功, 输出路径, 错误信息)
  Future<(bool, String?, String?)> convertDdsToPng(
    String filePath,
    String outputDir,
  ) async {
    try {
      var normalizedPath = filePath;
      if (normalizedPath.startsWith("\\")) {
        normalizedPath = normalizedPath.substring(1);
      }
      final lower = normalizedPath.toLowerCase();
      if (_isDdnaDdsPath(lower)) {
        const err = "跳过 _ddna DDS：该类型不进行预览解码";
        state = state.copyWith(endMessage: "DDS 转 PNG 失败: $err");
        return (false, null, err);
      }

      final pngBytes = (await unp4k_api.p4KExtractDdsAsPng(
        filePath: normalizedPath,
      ))
          .$1;

      String relativeOutput = normalizedPath;
      final ddsChainIndex = lower.indexOf(".dds.");
      if (ddsChainIndex != -1) {
        relativeOutput = "${normalizedPath.substring(0, ddsChainIndex)}.dds";
      }
      if (relativeOutput.toLowerCase().endsWith(".dds")) {
        relativeOutput =
            "${relativeOutput.substring(0, relativeOutput.length - 4)}.png";
      } else {
        relativeOutput = "$relativeOutput.png";
      }

      final outputFile = File("$outputDir\\$relativeOutput".platformPath);
      await outputFile.parent.create(recursive: true);
      await outputFile.writeAsBytes(pngBytes, flush: true);

      state = state.copyWith(endMessage: "DDS 转 PNG 成功: ${outputFile.path}");
      return (true, outputFile.path, null);
    } catch (e) {
      final err = e.toString();
      state = state.copyWith(endMessage: "DDS 转 PNG 失败: $err");
      return (false, null, err);
    }
  }
}

/// 搜索参数类
class _SearchParams {
  final Map<String, AppUnp4kP4kItemData> files;
  final String query;
  final String? pathPrefix;

  _SearchParams(this.files, this.query, this.pathPrefix);
}

/// 搜索结果类
class _SearchResult {
  final Set<String> matchedFiles;
  final Set<String> keptDirectories;

  _SearchResult(this.matchedFiles, this.keptDirectories);
}

/// 在后台线程执行搜索
_SearchResult _searchFiles(_SearchParams params) {
  final matchedFiles = <String>{};
  final keptDirectories = <String>{};
  final pathPrefix = params.pathPrefix;

  // 尝试编译正则表达式，如果失败则使用普通字符串匹配
  RegExp? regex;
  try {
    regex = RegExp(params.query, caseSensitive: false);
  } catch (e) {
    // 正则无效，回退到普通字符串匹配
    regex = null;
  }

  // 如果有路径前缀（当前目录搜索），收集该目录下的直接子文件夹
  if (pathPrefix != null && pathPrefix.isNotEmpty) {
    for (var entry in params.files.entries) {
      final item = entry.value;
      final name = item.name ?? "";

      // 只处理文件夹
      if (!(item.isDirectory ?? false)) continue;

      final normalizedName = name.replaceAll("\\", "/");
      // 检查是否在目标目录下
      if (!normalizedName.startsWith(pathPrefix)) continue;

      // 获取相对于搜索目录的路径
      final relativePath = normalizedName.substring(pathPrefix.length);
      // 只保留直接子文件夹（不包含更多层级的）
      if (!relativePath.contains("/")) {
        keptDirectories.add(name.startsWith("\\") ? name : "\\$name");
      }
    }
  }

  for (var entry in params.files.entries) {
    final item = entry.value;
    final name = item.name ?? "";

    // 跳过文件夹本身
    if (item.isDirectory ?? false) continue;

    // 如果有路径前缀，只搜索该目录下的文件
    if (pathPrefix != null && pathPrefix.isNotEmpty) {
      final normalizedName = name.replaceAll("\\", "/");
      if (!normalizedName.startsWith(pathPrefix)) continue;
    }

    bool matches = false;
    if (regex != null) {
      // 对文件名进行匹配（不是完整路径）
      final fileName = name.split("\\").last;
      matches = regex.hasMatch(fileName);
    } else {
      matches = name.toLowerCase().contains(params.query.toLowerCase());
    }

    if (matches) {
      // 添加匹配的文件路径
      matchedFiles.add(name.startsWith("\\") ? name : "\\$name");
    }
  }

  return _SearchResult(matchedFiles, keptDirectories);
}

class _FilterState {
  final Unp4kSortType sortType;
  final Unp4kFilterMode sizeFilterMode;
  final Unp4kSizeUnit sizeFilterUnit;
  final double? sizeFilterSingleValue;
  final double? sizeFilterRangeStart;
  final double? sizeFilterRangeEnd;
  final Unp4kFilterMode dateFilterMode;
  final DateTime? dateFilterSingleDate;
  final DateTime? dateFilterRangeStart;
  final DateTime? dateFilterRangeEnd;
  final Set<String> suffixFilter;

  _FilterState({
    this.sortType = Unp4kSortType.defaultSort,
    this.sizeFilterMode = Unp4kFilterMode.none,
    this.sizeFilterUnit = Unp4kSizeUnit.mb,
    this.sizeFilterSingleValue,
    this.sizeFilterRangeStart,
    this.sizeFilterRangeEnd,
    this.dateFilterMode = Unp4kFilterMode.none,
    this.dateFilterSingleDate,
    this.dateFilterRangeStart,
    this.dateFilterRangeEnd,
    this.suffixFilter = const {},
  });

  _FilterState copyWith({
    Unp4kSortType? sortType,
    Unp4kFilterMode? sizeFilterMode,
    Unp4kSizeUnit? sizeFilterUnit,
    double? sizeFilterSingleValue,
    double? sizeFilterRangeStart,
    double? sizeFilterRangeEnd,
    Unp4kFilterMode? dateFilterMode,
    DateTime? dateFilterSingleDate,
    DateTime? dateFilterRangeStart,
    DateTime? dateFilterRangeEnd,
    Set<String>? suffixFilter,
  }) {
    return _FilterState(
      sortType: sortType ?? this.sortType,
      sizeFilterMode: sizeFilterMode ?? this.sizeFilterMode,
      sizeFilterUnit: sizeFilterUnit ?? this.sizeFilterUnit,
      sizeFilterSingleValue:
          sizeFilterSingleValue ?? this.sizeFilterSingleValue,
      sizeFilterRangeStart: sizeFilterRangeStart ?? this.sizeFilterRangeStart,
      sizeFilterRangeEnd: sizeFilterRangeEnd ?? this.sizeFilterRangeEnd,
      dateFilterMode: dateFilterMode ?? this.dateFilterMode,
      dateFilterSingleDate: dateFilterSingleDate ?? this.dateFilterSingleDate,
      dateFilterRangeStart: dateFilterRangeStart ?? this.dateFilterRangeStart,
      dateFilterRangeEnd: dateFilterRangeEnd ?? this.dateFilterRangeEnd,
      suffixFilter: suffixFilter ?? this.suffixFilter,
    );
  }
}
