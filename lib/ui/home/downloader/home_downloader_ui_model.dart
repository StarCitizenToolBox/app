// ignore_for_file: avoid_build_context_in_providers, avoid_public_notifier_properties

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/rust/api/downloader_api.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/provider/download_manager.dart';

import '../../../widgets/widgets.dart';

part 'home_downloader_ui_model.g.dart';

part 'home_downloader_ui_model.freezed.dart';

@freezed
abstract class HomeDownloaderUIState with _$HomeDownloaderUIState {
  factory HomeDownloaderUIState({
    @Default([]) List<DownloadTaskInfo> activeTasks,
    @Default([]) List<DownloadTaskInfo> waitingTasks,
    @Default([]) List<DownloadTaskInfo> stoppedTasks,
    DownloadGlobalStat? globalStat,
  }) = _HomeDownloaderUIState;
}

extension HomeDownloaderUIStateExtension on HomeDownloaderUIState {
  bool get isAvailable => globalStat != null;
}

@riverpod
class HomeDownloaderUIModel extends _$HomeDownloaderUIModel {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  bool _disposed = false;

  final statusMap = {
    "live": S.current.downloader_info_downloading_status,
    "initializing": S.current.downloader_info_waiting,
    "paused": S.current.downloader_info_paused,
    "error": S.current.downloader_info_download_failed,
    "finished": S.current.downloader_info_download_completed,
  };

  final listHeaderStatusMap = {
    "active": S.current.downloader_title_downloading,
    "waiting": S.current.downloader_info_waiting,
    "stopped": S.current.downloader_title_ended,
  };

  @override
  HomeDownloaderUIState build() {
    state = HomeDownloaderUIState();
    _listenDownloader();
    ref.onDispose(() {
      _disposed = true;
    });
    return state;
  }

  Future<void> onTapButton(BuildContext context, String key) async {
    final downloadManagerState = ref.read(downloadManagerProvider);
    final downloadManager = ref.read(downloadManagerProvider.notifier);

    switch (key) {
      case "pause_all":
        if (!downloadManagerState.isRunning) return;
        await downloadManager.pauseAll();
        return;
      case "resume_all":
        if (!downloadManagerState.isRunning) return;
        await downloadManager.resumeAll();
        return;
      case "cancel_all":
        final userOK = await showConfirmDialogs(
          context,
          S.current.downloader_action_confirm_cancel_all_tasks,
          Text(S.current.downloader_info_manual_file_deletion_note),
        );
        if (userOK == true) {
          if (!downloadManagerState.isRunning) return;
          try {
            final allTasks = [...state.activeTasks, ...state.waitingTasks];
            for (var task in allTasks) {
              await downloadManager.removeTask(task.id.toInt(), deleteFiles: false);
            }
          } catch (e) {
            dPrint("DownloadsUIModel cancel_all Error:  $e");
          }
        }
        return;
      case "settings":
        _showDownloadSpeedSettings(context);
        return;
    }
  }

  int getTasksLen() {
    return state.activeTasks.length + state.waitingTasks.length + state.stoppedTasks.length;
  }

  (DownloadTaskInfo, String, bool) getTaskAndType(int index) {
    final tempList = <DownloadTaskInfo>[...state.activeTasks, ...state.waitingTasks, ...state.stoppedTasks];
    if (index >= 0 && index < state.activeTasks.length) {
      return (tempList[index], "active", index == 0);
    }
    if (index >= state.activeTasks.length && index < state.activeTasks.length + state.waitingTasks.length) {
      return (tempList[index], "waiting", index == state.activeTasks.length);
    }
    if (index >= state.activeTasks.length + state.waitingTasks.length && index < tempList.length) {
      return (tempList[index], "stopped", index == state.activeTasks.length + state.waitingTasks.length);
    }
    throw Exception("Index out of range or element is null");
  }

  static MapEntry<String, String> getTaskTypeAndName(DownloadTaskInfo task) {
    // All tasks in rqbit are torrent-based
    return MapEntry("torrent", task.name);
  }

  int getETA(DownloadTaskInfo task) {
    if (task.downloadSpeed == BigInt.zero) return 0;
    final remainingBytes = task.totalBytes - task.downloadedBytes;
    return (remainingBytes ~/ task.downloadSpeed).toInt();
  }

  String getStatusString(DownloadTaskStatus status) {
    switch (status) {
      case DownloadTaskStatus.live:
        return "live";
      case DownloadTaskStatus.checking:
        return "checking";
      case DownloadTaskStatus.paused:
        return "paused";
      case DownloadTaskStatus.error:
        return "error";
      case DownloadTaskStatus.finished:
        return "finished";
    }
  }

  Future<void> resumeTask(int taskId) async {
    final downloadManager = ref.read(downloadManagerProvider.notifier);
    await downloadManager.resumeTask(taskId);
  }

  Future<void> pauseTask(int taskId) async {
    final downloadManager = ref.read(downloadManagerProvider.notifier);
    await downloadManager.pauseTask(taskId);
  }

  Future<void> cancelTask(BuildContext context, int taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!context.mounted) return;
    final ok = await showConfirmDialogs(
      context,
      S.current.downloader_action_confirm_cancel_download,
      Text(S.current.downloader_info_manual_file_deletion_note),
    );
    if (ok == true) {
      final downloadManager = ref.read(downloadManagerProvider.notifier);
      await downloadManager.removeTask(taskId, deleteFiles: false);
    }
  }

  void openFolder(DownloadTaskInfo task) {
    final outputFolder = task.outputFolder;
    if (outputFolder.isNotEmpty) {
      SystemHelper.openDir(outputFolder.replaceAll("/", "\\"));
    }
  }

  Future<void> _listenDownloader() async {
    try {
      while (true) {
        if (_disposed) return;
        final downloadManagerState = ref.read(downloadManagerProvider);
        if (downloadManagerState.isRunning) {
          final downloadManager = ref.read(downloadManagerProvider.notifier);
          final allTasks = await downloadManager.getAllTasks();

          final activeTasks = <DownloadTaskInfo>[];
          final waitingTasks = <DownloadTaskInfo>[];
          final stoppedTasks = <DownloadTaskInfo>[];

          for (var task in allTasks) {
            switch (task.status) {
              case DownloadTaskStatus.live:
                activeTasks.add(task);
                break;
              case DownloadTaskStatus.checking:
              case DownloadTaskStatus.paused:
                waitingTasks.add(task);
                break;
              case DownloadTaskStatus.finished:
              case DownloadTaskStatus.error:
                stoppedTasks.add(task);
                break;
            }
          }

          state = state.copyWith(
            activeTasks: activeTasks,
            waitingTasks: waitingTasks,
            stoppedTasks: stoppedTasks,
            globalStat: downloadManagerState.globalStat,
          );
        } else {
          state = state.copyWith(activeTasks: [], waitingTasks: [], stoppedTasks: [], globalStat: null);
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      dPrint("[DownloadsUIModel]._listenDownloader Error: $e");
    }
  }

  Future<void> _showDownloadSpeedSettings(BuildContext context) async {
    final box = await Hive.openBox("app_conf");

    final upCtrl = TextEditingController(text: box.get("downloader_up_limit", defaultValue: ""));
    final downCtrl = TextEditingController(text: box.get("downloader_down_limit", defaultValue: ""));

    final ifr = FilteringTextInputFormatter.allow(RegExp(r'^\d*[km]?$'));

    if (!context.mounted) return;
    final ok = await showConfirmDialogs(
      context,
      S.current.downloader_speed_limit_settings,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.downloader_info_p2p_network_note,
            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6)),
          ),
          const SizedBox(height: 24),
          Text(S.current.downloader_info_download_unit_input_prompt),
          const SizedBox(height: 12),
          Text(S.current.downloader_input_upload_speed_limit),
          const SizedBox(height: 6),
          TextFormBox(
            placeholder: "1、100k、10m、0",
            controller: upCtrl,
            placeholderStyle: TextStyle(color: Colors.white.withValues(alpha: .6)),
            inputFormatters: [ifr],
          ),
          const SizedBox(height: 12),
          Text(S.current.downloader_input_download_speed_limit),
          const SizedBox(height: 6),
          TextFormBox(
            placeholder: "1、100k、10m、0",
            controller: downCtrl,
            placeholderStyle: TextStyle(color: Colors.white.withValues(alpha: .6)),
            inputFormatters: [ifr],
          ),
          const SizedBox(height: 24),
          Text(
            S.current.downloader_input_info_p2p_upload_note,
            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .6)),
          ),
        ],
      ),
    );
    if (ok == true) {
      // Save the settings
      await box.put('downloader_up_limit', upCtrl.text.trim());
      await box.put('downloader_down_limit', downCtrl.text.trim());

      // Ask user if they want to restart the download manager now
      if (context.mounted) {
        final restartNow = await showDialog<bool>(
          context: context,
          builder: (context) => ContentDialog(
            title: Text(S.current.downloader_speed_limit_settings),
            content: Text(S.current.downloader_info_restart_manager_to_apply),
            actions: [
              Button(
                child: Text(S.current.downloader_action_restart_later),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FilledButton(
                child: Text(S.current.downloader_action_restart_now),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );

        if (restartNow == true) {
          // Get the download manager and restart it with new settings
          final downloadManager = ref.read(downloadManagerProvider.notifier);
          final upLimit = downloadManager.textToByte(upCtrl.text.trim());
          final downLimit = downloadManager.textToByte(downCtrl.text.trim());

          try {
            await downloadManager.restart(
              uploadLimitBps: upLimit > 0 ? upLimit : null,
              downloadLimitBps: downLimit > 0 ? downLimit : null,
            );
            if (context.mounted) {
              showToast(context, S.current.downloader_info_speed_limit_saved_restart_required);
            }
          } catch (e) {
            dPrint("Failed to restart download manager: $e");
            if (context.mounted) {
              showToast(context, "Failed to restart: $e");
            }
          }
        }
      }
    }
  }
}
