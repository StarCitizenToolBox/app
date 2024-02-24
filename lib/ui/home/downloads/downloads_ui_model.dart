import 'dart:io';

import 'package:aria2/aria2.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/io/aria2c.dart';

class DownloadsUIModel extends BaseUIModel {
  List<Aria2Task> tasks = [];
  List<Aria2Task> waitingTasks = [];
  List<Aria2Task> stoppedTasks = [];

  final statusMap = {
    "active": "下载中...",
    "waiting": "等待中",
    "paused": "已暂停",
    "error": "下载失败",
    "complete": "下载完成",
    "removed": "已删除",
  };

  final listHeaderStatusMap = {
    "active": "下载中",
    "waiting": "等待中",
    "stopped": "已结束",
  };

  @override
  initModel() {
    super.initModel();
    _listenDownloader();
  }

  onTapButton(String key) async {
    switch (key) {
      case "pause_all":
        await Aria2cManager.aria2c.pauseAll();
        return;
      case "resume_all":
        await Aria2cManager.aria2c.unpauseAll();
        return;
      case "cancel_all":
        final userOK = await showConfirmDialogs(
            context!, "确认取消全部任务？", const Text("如果文件不再需要，你可能需要手动删除下载文件。"));
        if (userOK == true) {
          try {
            for (var value in [...tasks, ...waitingTasks]) {
              await Aria2cManager.aria2c.remove(value.gid!);
            }
          } catch (e) {
            dPrint("DownloadsUIModel cancel_all Error:  $e");
          }
        }
        return;
    }
  }

  _listenDownloader() async {
    try {
      while (true) {
        if (!mounted) return;
        tasks.clear();
        tasks = await Aria2cManager.aria2c.tellActive();
        waitingTasks = await Aria2cManager.aria2c.tellWaiting(0, 1000000);
        stoppedTasks = await Aria2cManager.aria2c.tellStopped(0, 1000000);
        notifyListeners();
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      dPrint("[DownloadsUIModel]._listenDownloader Error: $e");
    }
  }

  int getTasksLen() {
    return tasks.length + waitingTasks.length + stoppedTasks.length;
  }

  (Aria2Task, String, bool) getTaskAndType(int index) {
    final tempList = <Aria2Task>[...tasks, ...waitingTasks, ...stoppedTasks];
    if (index >= 0 && index < tasks.length) {
      return (tempList[index], "active", index == 0);
    }
    if (index >= tasks.length && index < tasks.length + waitingTasks.length) {
      return (tempList[index], "waiting", index == tasks.length);
    }
    if (index >= tasks.length + waitingTasks.length &&
        index < tempList.length) {
      return (
        tempList[index],
        "stopped",
        index == tasks.length + waitingTasks.length
      );
    }
    throw Exception("Index out of range or element is null");
  }

  MapEntry<String, String> getTaskTypeAndName(Aria2Task task) {
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

  int getETA(Aria2Task task) {
    if (task.downloadSpeed == null || task.downloadSpeed == 0) return 0;
    final remainingBytes =
        (task.totalLength ?? 0) - (task.completedLength ?? 0);
    return remainingBytes ~/ (task.downloadSpeed!);
  }

  Future<void> resumeTask(String? gid) async {
    if (gid != null) {
      await Aria2cManager.aria2c.unpause(gid);
    }
  }

  Future<void> pauseTask(String? gid) async {
    if (gid != null) {
      await Aria2cManager.aria2c.pause(gid);
    }
  }

  Future<void> cancelTask(String? gid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (gid != null) {
      final ok = await showConfirmDialogs(
          context!, "确认取消下载？", const Text("如果文件不再需要，你可能需要手动删除下载文件。"));
      if (ok == true) {
        await Aria2cManager.aria2c.remove(gid);
      }
    }
  }

  openFolder(Aria2Task task) {
    final f = getFilesFormTask(task).firstOrNull;
    if (f != null) {
      SystemHelper.openDir(File(f.path!).absolute.path.replaceAll("/", "\\"));
    }
  }
}
