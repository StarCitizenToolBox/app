import 'dart:io';

import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;

part 'unp4kc.freezed.dart';

part 'unp4kc.g.dart';

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

@freezed
abstract class Unp4kcState with _$Unp4kcState {
  const factory Unp4kcState({
    required bool startUp,
    Map<String, AppUnp4kP4kItemData>? files,
    MemoryFileSystem? fs,
    required String curPath,
    String? endMessage,
    MapEntry<String, String>? tempOpenFile,
    @Default("") String errorMessage,
    @Default("") String searchQuery,
    @Default(false) bool isSearching,

    /// 搜索结果的虚拟文件系统（支持分级展示）
    MemoryFileSystem? searchFs,

    /// 搜索匹配的文件路径集合
    Set<String>? searchMatchedFiles,
    @Default(Unp4kSortType.defaultSort) Unp4kSortType sortType,

    /// 是否处于多选模式
    @Default(false) bool isMultiSelectMode,

    /// 多选模式下选中的文件路径集合
    @Default({}) Set<String> selectedItems,
  }) = _Unp4kcState;
}

@riverpod
class Unp4kCModel extends _$Unp4kCModel {
  @override
  Unp4kcState build() {
    state = Unp4kcState(startUp: false, curPath: '\\', endMessage: S.current.tools_unp4k_msg_init);
    _init();
    return state;
  }

  ToolsUIState get _toolsState => ref.read(toolsUIModelProvider);

  String getGamePath() => _toolsState.scInstalledPath;

  void _init() async {
    final gamePath = getGamePath();
    final gameP4kPath = "$gamePath\\Data.p4k";

    try {
      state = state.copyWith(endMessage: S.current.tools_unp4k_msg_reading);

      final loadStartTime = DateTime.now();

      await unp4k_api.p4KOpen(p4KPath: gameP4kPath);

      state = state.copyWith(endMessage: S.current.tools_unp4k_msg_reading2);

      final p4kFiles = await unp4k_api.p4KGetAllFiles();

      final files = <String, AppUnp4kP4kItemData>{};
      final fs = MemoryFileSystem(style: FileSystemStyle.posix);

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
          await fs.file(item.name.replaceAll("\\", "/")).create(recursive: true);
        }

        if (i == nextAwait) {
          state = state.copyWith(endMessage: S.current.tools_unp4k_msg_reading3(i, p4kFiles.length));
          await Future.delayed(Duration(milliseconds: 1));
          nextAwait += 30000;
        }
      }

      final endTime = DateTime.now();
      state = state.copyWith(
        files: files,
        fs: fs,
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
        await unp4k_api.p4KClose();
      } catch (e) {
        dPrint("[unp4k] close error: $e");
      }
    });
  }

  List<AppUnp4kP4kItemData>? getFiles() {
    final path = state.curPath.replaceAll("\\", "/");

    // 如果有搜索结果，使用搜索的虚拟文件系统
    final fs = state.searchFs ?? state.fs;
    if (fs == null) return null;

    final dir = fs.directory(path);
    if (!dir.existsSync()) return [];
    final files = dir.listSync(recursive: false, followLinks: false);

    final result = <AppUnp4kP4kItemData>[];
    for (var file in files) {
      if (file is File) {
        final f = state.files?[file.path.replaceAll("/", "\\")];
        if (f != null) {
          if (!(f.name?.startsWith("\\") ?? true)) {
            f.name = "\\${f.name}";
          }
          result.add(f);
        }
      } else {
        result.add(AppUnp4kP4kItemData(name: file.path.replaceAll("/", "\\"), isDirectory: true));
      }
    }

    // 应用排序
    _sortFiles(result);
    return result;
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

  /// 执行搜索（异步）
  Future<void> search(String query) async {
    if (query.isEmpty) {
      // 清除搜索，返回根目录
      state = state.copyWith(
        searchQuery: "",
        searchFs: null,
        searchMatchedFiles: null,
        isSearching: false,
        curPath: "\\",
      );
      return;
    }

    // 保存当前路径，用于搜索后尝试保持
    final currentPath = state.curPath;

    state = state.copyWith(searchQuery: query, isSearching: true, endMessage: S.current.tools_unp4k_searching);

    // 使用 compute 在后台线程执行搜索
    final allFiles = state.files;
    if (allFiles == null) {
      state = state.copyWith(isSearching: false);
      return;
    }

    try {
      final searchResult = await compute(_searchFiles, _SearchParams(allFiles, query));
      final matchedFiles = searchResult.matchedFiles;

      // 构建搜索结果的虚拟文件系统
      final searchFs = MemoryFileSystem(style: FileSystemStyle.posix);
      for (var filePath in matchedFiles) {
        await searchFs.file(filePath.replaceAll("\\", "/")).create(recursive: true);
      }

      // 检查当前路径是否有搜索结果
      String targetPath = "\\";
      if (currentPath != "\\") {
        final checkPath = currentPath.replaceAll("\\", "/");
        final dir = searchFs.directory(checkPath);
        if (dir.existsSync() && dir.listSync().isNotEmpty) {
          // 当前目录有结果，保持当前路径
          targetPath = currentPath;
        }
      }

      state = state.copyWith(
        searchFs: searchFs,
        searchMatchedFiles: matchedFiles,
        isSearching: false,
        curPath: targetPath,
        endMessage: matchedFiles.isEmpty
            ? S.current.tools_unp4k_search_no_result
            : S.current.tools_unp4k_msg_read_completed(matchedFiles.length, 0),
      );
    } catch (e) {
      dPrint("[unp4k] search error: $e");
      state = state.copyWith(isSearching: false, endMessage: e.toString());
    }
  }

  /// 清除搜索
  void clearSearch() {
    state = state.copyWith(
      searchQuery: "",
      searchFs: null,
      searchMatchedFiles: null,
      isSearching: false,
      curPath: "\\",
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
    if (fullPath) {
      state = state.copyWith(curPath: name);
    } else {
      state = state.copyWith(curPath: "${state.curPath}$name\\");
    }
  }

  Future<void> openFile(String filePath) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = "${tempDir.absolute.path}\\SCToolbox_unp4kc\\${SCLoggerHelper.getGameChannelID(getGamePath())}\\";
    state = state.copyWith(
      tempOpenFile: const MapEntry("loading", ""),
      endMessage: S.current.tools_unp4k_msg_open_file(filePath),
    );
    await extractFile(filePath, tempPath, mode: "extract_open");
  }

  Future<void> extractFile(String filePath, String outputPath, {String mode = "extract"}) async {
    try {
      // remove first \\
      if (filePath.startsWith("\\")) {
        filePath = filePath.substring(1);
      }

      final fullOutputPath = "$outputPath$filePath";
      dPrint("extractFile .... $filePath -> $fullOutputPath");

      // 使用 Rust API 提取到磁盘
      await unp4k_api.p4KExtractToDisk(filePath: filePath, outputPath: outputPath);

      if (mode == "extract_open") {
        const textExt = [".txt", ".xml", ".json", ".lua", ".cfg", ".ini", ".mtl"];
        const imgExt = [".png"];
        String openType = "unknown";
        for (var element in textExt) {
          if (filePath.toLowerCase().endsWith(element)) {
            openType = "text";
          }
        }
        for (var element in imgExt) {
          if (filePath.endsWith(element)) {
            openType = "image";
          }
        }
        state = state.copyWith(
          tempOpenFile: MapEntry(openType, fullOutputPath),
          endMessage: S.current.tools_unp4k_msg_open_file(filePath),
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
            if (entry.key.startsWith(prefix) && !(entry.value.isDirectory ?? false)) {
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
            await unp4k_api.p4KExtractToDisk(filePath: entryPath, outputPath: outputDir);
          }

          state = state.copyWith(endMessage: S.current.tools_unp4k_extract_completed(current));
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

        await unp4k_api.p4KExtractToDisk(filePath: filePath, outputPath: outputDir);

        state = state.copyWith(endMessage: S.current.tools_unp4k_extract_completed(1));
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
          if (entry.key.startsWith(prefix) && !(entry.value.isDirectory ?? false)) {
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
              if (entry.key.startsWith(prefix) && !(entry.value.isDirectory ?? false)) {
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
            if (entry.key.startsWith(prefix) && !(entry.value.isDirectory ?? false)) {
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
        await unp4k_api.p4KExtractToDisk(filePath: extractPath, outputPath: outputDir);
      }

      state = state.copyWith(endMessage: S.current.tools_unp4k_extract_completed(current));
      return (true, current, null);
    } catch (e) {
      dPrint("[unp4k] extractSelectedItemsWithProgress error: $e");
      return (false, 0, e.toString());
    }
  }

  /// 从 P4K 文件中提取指定文件到内存
  /// [p4kPath] P4K 文件路径
  /// [filePath] 要提取的文件路径（P4K 内部路径）
  static Future<Uint8List> extractP4kFileToMemory(String p4kPath, String filePath) async {
    try {
      await unp4k_api.p4KOpen(p4KPath: p4kPath);
      final data = await unp4k_api.p4KExtractToMemory(filePath: filePath);
      await unp4k_api.p4KClose();
      return Uint8List.fromList(data);
    } catch (e) {
      throw Exception("extractP4kFileToMemory error: $e");
    }
  }
}

/// 搜索参数类
class _SearchParams {
  final Map<String, AppUnp4kP4kItemData> files;
  final String query;

  _SearchParams(this.files, this.query);
}

/// 搜索结果类
class _SearchResult {
  final Set<String> matchedFiles;

  _SearchResult(this.matchedFiles);
}

/// 在后台线程执行搜索
_SearchResult _searchFiles(_SearchParams params) {
  final matchedFiles = <String>{};

  // 尝试编译正则表达式，如果失败则使用普通字符串匹配
  RegExp? regex;
  try {
    regex = RegExp(params.query, caseSensitive: false);
  } catch (e) {
    // 正则无效，回退到普通字符串匹配
    regex = null;
  }

  for (var entry in params.files.entries) {
    final item = entry.value;
    final name = item.name ?? "";

    // 跳过文件夹本身
    if (item.isDirectory ?? false) continue;

    bool matches = false;
    if (regex != null) {
      matches = regex.hasMatch(name);
    } else {
      matches = name.toLowerCase().contains(params.query.toLowerCase());
    }

    if (matches) {
      // 添加匹配的文件路径
      matchedFiles.add(name.startsWith("\\") ? name : "\\$name");
    }
  }

  return _SearchResult(matchedFiles);
}
