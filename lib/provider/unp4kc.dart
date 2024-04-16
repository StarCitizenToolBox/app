import 'dart:convert';
import 'dart:io';

import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/conf/binary_conf.dart';
import 'package:starcitizen_doctor/common/rust/api/rs_process.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';

part 'unp4kc.freezed.dart';

part 'unp4kc.g.dart';

@freezed
class Unp4kcState with _$Unp4kcState {
  const factory Unp4kcState({
    required bool startUp,
    Map<String, AppUnp4kP4kItemData>? files,
    MemoryFileSystem? fs,
    required String curPath,
    String? endMessage,
    MapEntry<String, String>? tempOpenFile,
  }) = _Unp4kcState;
}

@riverpod
class Unp4kCModel extends _$Unp4kCModel {
  RsProcess? _process;

  @override
  Unp4kcState build() {
    state =
        const Unp4kcState(startUp: false, curPath: '\\', endMessage: "初始化中...");
    _init();
    return state;
  }

  ToolsUIState get _toolsState => ref.read(toolsUIModelProvider);

  String getGamePath() => _toolsState.scInstalledPath;

  void _init() async {
    final execDir = "${appGlobalState.applicationBinaryModuleDir}\\unp4kc";
    await BinaryModuleConf.extractModule(
        ["unp4kc"], appGlobalState.applicationBinaryModuleDir!);
    final exec = "$execDir\\unp4kc.exe";
    // final ps = await Process.start(exec, []);
    // StringBuffer stringBuffer = StringBuffer();

    _process = RsProcess();

    final stream = _process?.start(
        executable: exec, arguments: [], workingDirectory: execDir);

    stream?.listen((event) async {
      switch (event.dataType) {
        case RsProcessStreamDataType.output:
          try {
            final eventJson = await compute(json.decode, event.data);
            _handleMessage(eventJson);
          } catch (e) {
            dPrint("[unp4kc] json error: $e");
          }
          break;
        case RsProcessStreamDataType.error:
          dPrint("[unp4kc] stderr: ${event.data}");
          break;
        case RsProcessStreamDataType.exit:
          dPrint("[unp4kc] exit: ${event.data}");
          break;
      }
    });

    ref.onDispose(() {
      final pid = _process?.getPid();
      if (pid != null) {
        Process.killPid(pid);
        dPrint("[unp4kc] kill ...");
      }
    });
  }

  void _handleMessage(Map<String, dynamic> eventJson) async {
    final action = eventJson["action"];
    final data = eventJson["data"];
    final gamePath = getGamePath();
    final gameP4kPath = "$gamePath\\Data.p4k";
    switch (action.toString().trim()) {
      case "info: startup":
        _process?.write(data: "$gameP4kPath\n");
        state = state.copyWith(endMessage: "正在读取P4K 文件 ...");
        break;
      case "data: P4K_Files":
        final p4kFiles = (data as List<dynamic>);
        final files = <String, AppUnp4kP4kItemData>{};
        final fs = MemoryFileSystem(style: FileSystemStyle.posix);
        state = state.copyWith(endMessage: "正在处理文件 ...");
        for (var i = 0; i < p4kFiles.length; i++) {
          final item = AppUnp4kP4kItemData.fromJson(p4kFiles[i]);
          item.name = "${item.name}";
          files["\\${item.name}"] = item;
          await fs
              .file(item.name?.replaceAll("\\", "/") ?? "")
              .create(recursive: true);
        }
        state = state.copyWith(
            files: files, fs: fs, endMessage: "加载完毕：${files.length} 个文件");
        break;
      case "info: Extracted_Open":
        final filePath = data.toString();
        dPrint("[unp4kc] Extracted_Open file: $filePath");
        const textExt = [".txt", ".xml", ".json", ".lua", ".cfg", ".ini"];
        const imgExt = [".png"];
        String openType = "unknown";
        for (var element in textExt) {
          if (filePath.endsWith(element)) {
            openType = "text";
          }
        }
        for (var element in imgExt) {
          if (filePath.endsWith(element)) {
            openType = "image";
          }
        }
        state = state.copyWith(
            tempOpenFile: MapEntry(openType, filePath),
            endMessage: "打开文件：$filePath");
        break;
      default:
        dPrint("[unp4kc] unknown action: $action");
        break;
    }
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
        result.add(AppUnp4kP4kItemData(
            name: file.path.replaceAll("/", "\\"), isDirectory: true));
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

  openFile(String filePath) async {
    final tempPath = "${appGlobalState.applicationSupportDir}\\temp\\unp4k\\";
    state = state.copyWith(
        tempOpenFile: const MapEntry("loading", ""),
        endMessage: "读取文件：$filePath ...");
    extractFile(filePath, tempPath, mode: "extract_open");
  }

  extractFile(String filePath, String outputPath,
      {String mode = "extract"}) async {
    // remove first \\
    if (filePath.startsWith("\\")) {
      filePath = filePath.substring(1);
    }
    outputPath = "$outputPath$filePath";
    dPrint("extractFile .... $filePath");
    _process?.write(data: "$mode<:,:>$filePath<:,:>$outputPath");
  }
}
