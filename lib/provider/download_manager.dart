import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';

import 'package:starcitizen_doctor/common/rust/api/downloader_api.dart' as downloader_api;
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';

part 'download_manager.g.dart';

part 'download_manager.freezed.dart';

@freezed
abstract class DownloadManagerState with _$DownloadManagerState {
  const factory DownloadManagerState({
    required String downloadDir,
    @Default(false) bool isInitialized,
    downloader_api.DownloadGlobalStat? globalStat,
  }) = _DownloadManagerState;
}

extension DownloadManagerStateExt on DownloadManagerState {
  bool get isRunning => isInitialized;

  bool get hasDownloadTask => globalStat != null && (globalStat!.numActive + globalStat!.numWaiting) > BigInt.zero;

  int get totalTaskNum => globalStat == null ? 0 : (globalStat!.numActive + globalStat!.numWaiting).toInt();
}

@riverpod
class DownloadManager extends _$DownloadManager {
  bool _disposed = false;

  @override
  DownloadManagerState build() {
    if (appGlobalState.applicationBinaryModuleDir == null) {
      throw Exception("applicationBinaryModuleDir is null");
    }
    ref.onDispose(() {
      _disposed = true;
    });
    ref.keepAlive();

    final downloadDir = "${appGlobalState.applicationBinaryModuleDir}${Platform.pathSeparator}downloads";

    // Lazy load init
    () async {
      try {
        // Check if there are existing tasks
        final dir = Directory(downloadDir);
        if (await dir.exists()) {
          dPrint("Launch download manager");
          await initDownloader();
        } else {
          dPrint("LazyLoad download manager");
        }
      } catch (e) {
        dPrint("DownloadManager.checkLazyLoad Error:$e");
      }
    }();

    return DownloadManagerState(downloadDir: downloadDir);
  }

  Future<void> initDownloader() async {
    if (state.isInitialized) return;

    try {
      // Create download directory if it doesn't exist
      final dir = Directory(state.downloadDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Initialize the Rust downloader
      downloader_api.downloaderInit(downloadDir: state.downloadDir);

      state = state.copyWith(isInitialized: true);

      // Start listening to state updates
      _listenState();

      dPrint("DownloadManager initialized");
    } catch (e) {
      dPrint("DownloadManager.initDownloader Error: $e");
      rethrow;
    }
  }

  Future<void> _listenState() async {
    dPrint("DownloadManager._listenState start");
    while (true) {
      if (_disposed || !state.isInitialized) {
        dPrint("DownloadManager._listenState end");
        return;
      }
      try {
        final globalStat = await downloader_api.downloaderGetGlobalStats();
        state = state.copyWith(globalStat: globalStat);
      } catch (e) {
        dPrint("globalStat update error:$e");
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// Add a torrent from base64 encoded bytes
  Future<int> addTorrent(List<int> torrentBytes, {String? outputFolder, List<String>? trackers}) async {
    await initDownloader();
    final taskId = await downloader_api.downloaderAddTorrent(
      torrentBytes: torrentBytes,
      outputFolder: outputFolder,
      trackers: trackers,
    );
    return taskId.toInt();
  }

  /// Add a torrent from magnet link
  Future<int> addMagnet(String magnetLink, {String? outputFolder, List<String>? trackers}) async {
    await initDownloader();
    final taskId = await downloader_api.downloaderAddMagnet(
      magnetLink: magnetLink,
      outputFolder: outputFolder,
      trackers: trackers,
    );
    return taskId.toInt();
  }

  /// Add a torrent from URL (only .torrent file URLs are supported)
  /// HTTP downloads are NOT supported - will throw an exception
  Future<int> addUrl(String url, {String? outputFolder, List<String>? trackers}) async {
    await initDownloader();
    final taskId = await downloader_api.downloaderAddUrl(url: url, outputFolder: outputFolder, trackers: trackers);
    return taskId.toInt();
  }

  Future<void> pauseTask(int taskId) async {
    await downloader_api.downloaderPause(taskId: BigInt.from(taskId));
  }

  Future<void> resumeTask(int taskId) async {
    await downloader_api.downloaderResume(taskId: BigInt.from(taskId));
  }

  Future<void> removeTask(int taskId, {bool deleteFiles = false}) async {
    await downloader_api.downloaderRemove(taskId: BigInt.from(taskId), deleteFiles: deleteFiles);
  }

  Future<downloader_api.DownloadTaskInfo> getTaskInfo(int taskId) async {
    return await downloader_api.downloaderGetTaskInfo(taskId: BigInt.from(taskId));
  }

  Future<List<downloader_api.DownloadTaskInfo>> getAllTasks() async {
    if (!state.isInitialized) {
      return [];
    }
    return await downloader_api.downloaderGetAllTasks();
  }

  Future<bool> isNameInTask(String name) async {
    if (!state.isInitialized) {
      return false;
    }
    return await downloader_api.downloaderIsNameInTask(name: name);
  }

  Future<void> pauseAll() async {
    await downloader_api.downloaderPauseAll();
  }

  Future<void> resumeAll() async {
    await downloader_api.downloaderResumeAll();
  }

  Future<void> stop() async {
    await downloader_api.downloaderStop();
    state = state.copyWith(isInitialized: false, globalStat: null);
  }

  /// Convert speed limit text to bytes per second
  /// Supports formats like: "1", "100k", "10m", "0"
  int textToByte(String text) {
    if (text.isEmpty || text == "0") {
      return 0;
    }
    final trimmed = text.trim().toLowerCase();
    if (int.tryParse(trimmed) != null) {
      return int.parse(trimmed);
    }
    if (trimmed.endsWith("k")) {
      return int.parse(trimmed.substring(0, trimmed.length - 1)) * 1024;
    }
    if (trimmed.endsWith("m")) {
      return int.parse(trimmed.substring(0, trimmed.length - 1)) * 1024 * 1024;
    }
    return 0;
  }
}
