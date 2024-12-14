// ignore_for_file: avoid_build_context_in_providers, avoid_public_notifier_properties
import 'dart:io';

import 'package:aria2/aria2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/provider/aria2c.dart';

import '../../../widgets/widgets.dart';

part 'home_downloader_ui_model.g.dart';

part 'home_downloader_ui_model.freezed.dart';

@freezed
class HomeDownloaderUIState with _$HomeDownloaderUIState {
  factory HomeDownloaderUIState({
    @Default([]) List<Aria2Task> tasks,
    @Default([]) List<Aria2Task> waitingTasks,
    @Default([]) List<Aria2Task> stoppedTasks,
    Aria2GlobalStat? globalStat,
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
    "active": S.current.downloader_info_downloading_status,
    "waiting": S.current.downloader_info_waiting,
    "paused": S.current.downloader_info_paused,
    "error": S.current.downloader_info_download_failed,
    "complete": S.current.downloader_info_download_completed,
    "removed": S.current.downloader_info_deleted,
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

  onTapButton(BuildContext context, String key) async {
    final aria2cState = ref.read(aria2cModelProvider);
    switch (key) {
      case "pause_all":
        if (!aria2cState.isRunning) return;
        await aria2cState.aria2c?.pauseAll();
        await aria2cState.aria2c?.saveSession();
        return;
      case "resume_all":
        if (!aria2cState.isRunning) return;
        await aria2cState.aria2c?.unpauseAll();
        await aria2cState.aria2c?.saveSession();
        return;
      case "cancel_all":
        final userOK = await showConfirmDialogs(
            context,
            S.current.downloader_action_confirm_cancel_all_tasks,
            Text(S.current.downloader_info_manual_file_deletion_note));
        if (userOK == true) {
          if (!aria2cState.isRunning) return;
          try {
            for (var value in [...state.tasks, ...state.waitingTasks]) {
              await aria2cState.aria2c?.remove(value.gid!);
            }
            await aria2cState.aria2c?.saveSession();
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
    return state.tasks.length +
        state.waitingTasks.length +
        state.stoppedTasks.length;
  }

  (Aria2Task, String, bool) getTaskAndType(int index) {
    final tempList = <Aria2Task>[
      ...state.tasks,
      ...state.waitingTasks,
      ...state.stoppedTasks
    ];
    if (index >= 0 && index < state.tasks.length) {
      return (tempList[index], "active", index == 0);
    }
    if (index >= state.tasks.length &&
        index < state.tasks.length + state.waitingTasks.length) {
      return (tempList[index], "waiting", index == state.tasks.length);
    }
    if (index >= state.tasks.length + state.waitingTasks.length &&
        index < tempList.length) {
      return (
        tempList[index],
        "stopped",
        index == state.tasks.length + state.waitingTasks.length
      );
    }
    throw Exception("Index out of range or element is null");
  }

  static MapEntry<String, String> getTaskTypeAndName(Aria2Task task) {
    if (task.bittorrent == null) {
      String uri = task.files?[0]['uris'][0]['uri'] as String;
      return MapEntry("url", uri.split('/').last);
    } else if (task.bittorrent != null) {
      if (task.bittorrent!.containsKey('info')) {
        var btName = task.bittorrent?["info"]["name"];
        return MapEntry("torrent", btName ?? 'torrent');
      } else {
        return MapEntry("magnet", '[METADATA]${task.infoHash}');
      }
    } else {
      return const MapEntry("metaLink", '==========metaLink============');
    }
  }

  int getETA(Aria2Task task) {
    if (task.downloadSpeed == null || task.downloadSpeed == 0) return 0;
    final remainingBytes =
        (task.totalLength ?? 0) - (task.completedLength ?? 0);
    return remainingBytes ~/ (task.downloadSpeed!);
  }

  Future<void> resumeTask(String? gid) async {
    final aria2c = ref.read(aria2cModelProvider).aria2c;
    if (gid != null) {
      await aria2c?.unpause(gid);
    }
  }

  Future<void> pauseTask(String? gid) async {
    final aria2c = ref.read(aria2cModelProvider).aria2c;
    if (gid != null) {
      await aria2c?.pause(gid);
    }
  }

  Future<void> cancelTask(BuildContext context, String? gid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (gid != null) {
      if (!context.mounted) return;
      final ok = await showConfirmDialogs(
          context,
          S.current.downloader_action_confirm_cancel_download,
          Text(S.current.downloader_info_manual_file_deletion_note));
      if (ok == true) {
        final aria2c = ref.read(aria2cModelProvider).aria2c;
        await aria2c?.remove(gid);
        await aria2c?.saveSession();
      }
    }
  }

  List<Aria2File> getFilesFormTask(Aria2Task task) {
    List<Aria2File> l = [];
    if (task.files != null) {
      for (var element in task.files!) {
        final f = Aria2File.fromJson(element);
        l.add(f);
      }
    }
    return l;
  }

  openFolder(Aria2Task task) {
    final f = getFilesFormTask(task).firstOrNull;
    if (f != null) {
      SystemHelper.openDir(File(f.path!).absolute.path.replaceAll("/", "\\"));
    }
  }

  _listenDownloader() async {
    try {
      while (true) {
        final aria2cState = ref.read(aria2cModelProvider);
        if (_disposed) return;
        if (aria2cState.isRunning) {
          final aria2c = aria2cState.aria2c!;
          final tasks = await aria2c.tellActive();
          final waitingTasks = await aria2c.tellWaiting(0, 1000000);
          final stoppedTasks = await aria2c.tellStopped(0, 1000000);
          final globalStat = await aria2c.getGlobalStat();
          state = state.copyWith(
            tasks: tasks,
            waitingTasks: waitingTasks,
            stoppedTasks: stoppedTasks,
            globalStat: globalStat,
          );
        } else {
          state = state.copyWith(
            tasks: [],
            waitingTasks: [],
            stoppedTasks: [],
            globalStat: null,
          );
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      dPrint("[DownloadsUIModel]._listenDownloader Error: $e");
    }
  }

  Future<void> _showDownloadSpeedSettings(BuildContext context) async {
    final box = await Hive.openBox("app_conf");

    final upCtrl = TextEditingController(
        text: box.get("downloader_up_limit", defaultValue: ""));
    final downCtrl = TextEditingController(
        text: box.get("downloader_down_limit", defaultValue: ""));

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
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: .6),
              ),
            ),
            const SizedBox(height: 24),
            Text(S.current.downloader_info_download_unit_input_prompt),
            const SizedBox(height: 12),
            Text(S.current.downloader_input_upload_speed_limit),
            const SizedBox(height: 6),
            TextFormBox(
              placeholder: "1、100k、10m、0",
              controller: upCtrl,
              placeholderStyle:
                  TextStyle(color: Colors.white.withValues(alpha: .6)),
              inputFormatters: [ifr],
            ),
            const SizedBox(height: 12),
            Text(S.current.downloader_input_download_speed_limit),
            const SizedBox(height: 6),
            TextFormBox(
              placeholder: "1、100k、10m、0",
              controller: downCtrl,
              placeholderStyle:
                  TextStyle(color: Colors.white.withValues(alpha: .6)),
              inputFormatters: [ifr],
            ),
            const SizedBox(height: 24),
            Text(
              S.current.downloader_input_info_p2p_upload_note,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: .6),
              ),
            )
          ],
        ));
    if (ok == true) {
      final aria2cState = ref.read(aria2cModelProvider);
      final aria2cModel = ref.read(aria2cModelProvider.notifier);
      await aria2cModel
          .launchDaemon(appGlobalState.applicationBinaryModuleDir!);
      final aria2c = aria2cState.aria2c!;
      final upByte = aria2cModel.textToByte(upCtrl.text.trim());
      final downByte = aria2cModel.textToByte(downCtrl.text.trim());
      final r = await aria2c
          .changeGlobalOption(Aria2Option()
            ..maxOverallUploadLimit = upByte
            ..maxOverallDownloadLimit = downByte)
          .unwrap();
      if (r != null) {
        await box.put('downloader_up_limit', upCtrl.text.trim());
        await box.put('downloader_down_limit', downCtrl.text.trim());
      }
    }
  }
}
