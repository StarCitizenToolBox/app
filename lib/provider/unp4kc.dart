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

      // 使用 Rust API 打开 P4K 文件（仅打开，不读取文件列表）
      await unp4k_api.p4KOpen(p4KPath: gameP4kPath);

      state = state.copyWith(endMessage: S.current.tools_unp4k_msg_reading2);

      // 获取所有文件列表（会触发文件列表加载）
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
          await Future.delayed(Duration.zero);
          nextAwait += 20000;
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
      state = state.copyWith(fs: null);
      try {
        await unp4k_api.p4KClose();
      } catch (e) {
        dPrint("[unp4k] close error: $e");
      }
    });
  }

  List<AppUnp4kP4kItemData>? getFiles() {
    final path = state.curPath.replaceAll("\\", "/");
    final fs = state.fs;
    if (fs == null) return null;
    final dir = fs.directory(path);
    if (!dir.existsSync()) return [];
    final files = dir.listSync(recursive: false, followLinks: false);
    files.sort((a, b) {
      if (a is Directory && b is File) {
        return -1;
      } else if (a is File && b is Directory) {
        return 1;
      } else {
        return a.path.compareTo(b.path);
      }
    });
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
    return result;
  }

  void changeDir(String name, {bool fullPath = false}) {
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
      await unp4k_api.p4KExtractToDisk(filePath: filePath, outputPath: fullOutputPath);

      if (mode == "extract_open") {
        const textExt = [".txt", ".xml", ".json", ".lua", ".cfg", ".ini"];
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
