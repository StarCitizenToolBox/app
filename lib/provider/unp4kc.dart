import 'dart:convert';
import 'dart:io';

import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/conf/binary_conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/rust/api/rs_process.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:starcitizen_doctor/common/rust/api/rs_process.dart'
    as rs_process;

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
  int? _rsPid;

  @override
  Unp4kcState build() {
    state = Unp4kcState(
        startUp: false,
        curPath: '\\',
        endMessage: S.current.tools_unp4k_msg_init);
    _init();
    return state;
  }

  ToolsUIState get _toolsState => ref.read(toolsUIModelProvider);

  String getGamePath() => _toolsState.scInstalledPath;

  bool _hasUnp4kRunTimeError = false;

  void _init() async {
    final execDir = "${appGlobalState.applicationBinaryModuleDir}\\unp4kc";
    await BinaryModuleConf.extractModule(
        ["unp4kc"], appGlobalState.applicationBinaryModuleDir!);
    final exec = "$execDir\\unp4kc.exe";

    final stream = rs_process.start(
        executable: exec, arguments: [], workingDirectory: execDir);

    stream.listen((event) async {
      switch (event.dataType) {
        case RsProcessStreamDataType.output:
          _rsPid = event.rsPid;
          try {
            final eventJson = await compute(json.decode, event.data);
            _handleMessage(eventJson, event.rsPid);
          } catch (e) {
            dPrint("[unp4kc] json error: $e");
          }
          break;
        case RsProcessStreamDataType.error:
          dPrint("[unp4kc] stderr: ${event.data}");
          if (state.errorMessage.isEmpty) {
            state = state.copyWith(errorMessage: event.data);
          } else {
            state = state.copyWith(
                errorMessage: "${state.errorMessage}\n${event.data}");
          }
          if (!_hasUnp4kRunTimeError) {
            if (checkRunTimeError(state.errorMessage)) {
              _hasUnp4kRunTimeError = true;
              AnalyticsApi.touch("unp4k_no_runtime");
            }
          }
          break;
        case RsProcessStreamDataType.exit:
          dPrint("[unp4kc] exit: ${event.data}");
          break;
      }
    });

    ref.onDispose(() {
      state = state.copyWith(fs: null);
      if (_rsPid != null) {
        Process.killPid(_rsPid!);
        dPrint("[unp4kc] kill ...");
      }
    });
  }

  DateTime? _loadStartTime;

  void _handleMessage(Map<String, dynamic> eventJson, int rsPid) async {
    final action = eventJson["action"];
    final data = eventJson["data"];
    final gamePath = getGamePath();
    final gameP4kPath = "$gamePath\\Data.p4k";
    switch (action.toString().trim()) {
      case "info: startup":
        rs_process.write(rsPid: rsPid, data: "$gameP4kPath\n");
        break;
      case "info: Reading_p4k_file":
        _loadStartTime = DateTime.now();
        state = state.copyWith(endMessage: S.current.tools_unp4k_msg_reading);
        break;
      case "info: All Ready":
        state = state.copyWith(endMessage: S.current.tools_unp4k_msg_reading2);
        break;
      case "data: P4K_Files":
        final p4kFiles = (data as List<dynamic>);
        final files = <String, AppUnp4kP4kItemData>{};
        final fs = MemoryFileSystem(style: FileSystemStyle.posix);

        var nextAwait = 0;
        for (var i = 0; i < p4kFiles.length; i++) {
          final item = AppUnp4kP4kItemData.fromJson(p4kFiles[i]);
          item.name = "${item.name}";
          files["\\${item.name}"] = item;
          await fs
              .file(item.name?.replaceAll("\\", "/") ?? "")
              .create(recursive: true);
          if (i == nextAwait) {
            state = state.copyWith(
                endMessage:
                    S.current.tools_unp4k_msg_reading3(i, p4kFiles.length));
            await Future.delayed(Duration.zero);
            nextAwait += 20000;
          }
        }
        final endTime = DateTime.now();
        state = state.copyWith(
            files: files,
            fs: fs,
            endMessage: S.current.tools_unp4k_msg_read_completed(files.length,
                endTime.difference(_loadStartTime!).inMilliseconds));
        _loadStartTime = null;
        break;
      case "info: Extracted_Open":
        final filePath = data.toString();
        dPrint("[unp4kc] Extracted_Open file: $filePath");
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
            tempOpenFile: MapEntry(openType, filePath),
            endMessage: S.current.tools_unp4k_msg_open_file(filePath));
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

  Future<void> openFile(String filePath) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath =
        "${tempDir.absolute.path}\\SCToolbox_unp4kc\\${SCLoggerHelper.getGameChannelID(getGamePath())}\\";
    state = state.copyWith(
        tempOpenFile: const MapEntry("loading", ""),
        endMessage: S.current.tools_unp4k_msg_open_file(filePath));
    extractFile(filePath, tempPath, mode: "extract_open");
  }

  Future<void> extractFile(String filePath, String outputPath,
      {String mode = "extract"}) async {
    // remove first \\
    if (filePath.startsWith("\\")) {
      filePath = filePath.substring(1);
    }
    outputPath = "$outputPath$filePath";
    dPrint("extractFile .... $filePath");
    if (_rsPid != null) {
      rs_process.write(
          rsPid: _rsPid!, data: "$mode<:,:>$filePath<:,:>$outputPath\n");
    }
  }

  static bool checkRunTimeError(String errorMessage) {
    if (errorMessage
            .contains("You must install .NET to run this application") ||
        errorMessage.contains(
            "You must install or update .NET to run this application") ||
        errorMessage.contains(
            "It was not possible to find any compatible framework version")) {
      AnalyticsApi.touch("unp4k_no_runtime");
      return true;
    }
    return false;
  }

  static Future<Uint8List> unp4kTools(
      String applicationBinaryModuleDir, List<String> args) async {
    await BinaryModuleConf.extractModule(
        ["unp4kc"], applicationBinaryModuleDir);
    final execDir = "$applicationBinaryModuleDir\\unp4kc";
    final exec = "$execDir\\unp4kc.exe";
    final r = await Process.run(exec, args);
    if (r.exitCode != 0) {
      Process.killPid(r.pid);
      throw Exception(
          "error: ${r.exitCode} , info= ${r.stdout} , err= ${r.stderr}");
    }
    final eventJson = await compute(json.decode, r.stdout.toString());
    if (eventJson["action"] == "data: Uint8List") {
      final data = eventJson["data"];
      return Uint8List.fromList((data as List).cast<int>());
    }
    throw Exception("error: data error");
  }
}
