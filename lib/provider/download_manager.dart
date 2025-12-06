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
    required String workingDir,
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
    if (appGlobalState.applicationSupportDir == null) {
      throw Exception("applicationSupportDir is null");
    }
    ref.onDispose(() {
      _disposed = true;
    });
    ref.keepAlive();

    // Working directory for session data (in appSupport)
    final workingDir = "${appGlobalState.applicationSupportDir}${Platform.pathSeparator}downloader";
    // Default download directory (can be customized)
    final downloadDir = "${appGlobalState.applicationBinaryModuleDir}${Platform.pathSeparator}downloads";

    // Lazy load init
    () async {
      await Future.delayed(const Duration(milliseconds: 16));
      try {
        // Check if there are pending tasks to restore (without starting the downloader)
        if (downloader_api.downloaderHasPendingSessionTasks(workingDir: workingDir)) {
          dPrint("Launch download manager - found pending session tasks");
          await initDownloader();
        } else {
          dPrint("LazyLoad download manager - no pending tasks");
        }
      } catch (e) {
        dPrint("DownloadManager.checkLazyLoad Error:$e");
      }
    }();

    return DownloadManagerState(workingDir: workingDir, downloadDir: downloadDir);
  }

  Future<void> initDownloader({int? uploadLimitBps, int? downloadLimitBps}) async {
    if (state.isInitialized) return;

    try {
      // Create working directory if it doesn't exist
      final workingDir = Directory(state.workingDir);
      if (!await workingDir.exists()) {
        await workingDir.create(recursive: true);
      }

      // Create download directory if it doesn't exist
      final downloadDir = Directory(state.downloadDir);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Initialize the Rust downloader with optional speed limits
      await downloader_api.downloaderInit(
        workingDir: state.workingDir,
        defaultDownloadDir: state.downloadDir,
        uploadLimitBps: uploadLimitBps,
        downloadLimitBps: downloadLimitBps,
      );

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

        // Auto-remove completed tasks (no seeding behavior)
        await removeCompletedTasks();
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

  Future<bool> isNameInTask(String name, {bool downloadingOnly = true}) async {
    if (!state.isInitialized) {
      return false;
    }
    return await downloader_api.downloaderIsNameInTask(name: name, downloadingOnly: downloadingOnly);
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

  /// Shutdown the downloader completely (allows restart with new settings)
  Future<void> shutdown() async {
    await downloader_api.downloaderShutdown();
    state = state.copyWith(isInitialized: false, globalStat: null);
  }

  /// Restart the downloader with new speed limit settings
  Future<void> restart({int? uploadLimitBps, int? downloadLimitBps}) async {
    await shutdown();
    await initDownloader(uploadLimitBps: uploadLimitBps, downloadLimitBps: downloadLimitBps);
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

  /// Remove all completed tasks (equivalent to aria2's --seed-time=0 behavior)
  /// Returns the number of tasks removed
  Future<int> removeCompletedTasks() async {
    if (!state.isInitialized) {
      return 0;
    }
    final removed = await downloader_api.downloaderRemoveCompletedTasks();
    return removed;
  }

  /// Check if there are any active (non-completed) download tasks
  Future<bool> hasActiveTasks() async {
    if (!state.isInitialized) {
      return false;
    }
    return await downloader_api.downloaderHasActiveTasks();
  }

  /// Get all completed tasks from cache (tasks that were removed by removeCompletedTasks)
  /// This cache is cleared when the downloader is shutdown/restarted
  List<downloader_api.DownloadTaskInfo> getCompletedTasksCache() {
    return downloader_api.downloaderGetCompletedTasksCache();
  }

  /// Clear the completed tasks cache manually
  void clearCompletedTasksCache() {
    downloader_api.downloaderClearCompletedTasksCache();
  }
}
