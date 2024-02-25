import 'dart:io';

import 'package:aria2/aria2.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/io/aria2c.dart';

class DownloaderUIModel extends BaseUIModel {
  List<Aria2Task> tasks = [];
  List<Aria2Task> waitingTasks = [];
  List<Aria2Task> stoppedTasks = [];
  Aria2GlobalStat? globalStat;

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
        if (!Aria2cManager.isAvailable) return;
        await Aria2cManager.getClient().pauseAll();
        await Aria2cManager.getClient().saveSession();
        return;
      case "resume_all":
        if (!Aria2cManager.isAvailable) return;
        await Aria2cManager.getClient().unpauseAll();
        await Aria2cManager.getClient().saveSession();
        return;
      case "cancel_all":
        final userOK = await showConfirmDialogs(
            context!, "确认取消全部任务？", const Text("如果文件不再需要，你可能需要手动删除下载文件。"));
        if (userOK == true) {
          if (!Aria2cManager.isAvailable) return;
          try {
            for (var value in [...tasks, ...waitingTasks]) {
              await Aria2cManager.getClient().remove(value.gid!);
            }
            await Aria2cManager.getClient().saveSession();
          } catch (e) {
            dPrint("DownloadsUIModel cancel_all Error:  $e");
          }
        }
        return;
      case "settings":
        _showDownloadSpeedSettings();
        return;
    }
  }

  _listenDownloader() async {
    try {
      while (true) {
        if (!mounted) return;
        if (Aria2cManager.isAvailable) {
          final aria2c = Aria2cManager.getClient();
          tasks.clear();
          tasks = await aria2c.tellActive();
          waitingTasks = await aria2c.tellWaiting(0, 1000000);
          stoppedTasks = await aria2c.tellStopped(0, 1000000);
          globalStat = await aria2c.getGlobalStat();
          notifyListeners();
        }
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
    final aria2c = Aria2cManager.getClient();
    if (gid != null) {
      await aria2c.unpause(gid);
    }
  }

  Future<void> pauseTask(String? gid) async {
    final aria2c = Aria2cManager.getClient();

    if (gid != null) {
      await aria2c.pause(gid);
    }
  }

  Future<void> cancelTask(String? gid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (gid != null) {
      final ok = await showConfirmDialogs(
          context!, "确认取消下载？", const Text("如果文件不再需要，你可能需要手动删除下载文件。"));
      if (ok == true) {
        final aria2c = Aria2cManager.getClient();
        await aria2c.remove(gid);
      }
    }
  }

  openFolder(Aria2Task task) {
    final f = getFilesFormTask(task).firstOrNull;
    if (f != null) {
      SystemHelper.openDir(File(f.path!).absolute.path.replaceAll("/", "\\"));
    }
  }

  Future<void> _showDownloadSpeedSettings() async {
    final box = await Hive.openBox("app_conf");

    final upCtrl = TextEditingController(
        text: box.get("downloader_up_limit", defaultValue: ""));
    final downCtrl = TextEditingController(
        text: box.get("downloader_down_limit", defaultValue: ""));

    final ifr = FilteringTextInputFormatter.allow(RegExp(r'^\d*[km]?$'));

    final ok = await showConfirmDialogs(
        context!,
        "限速设置",
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SC 汉化盒子使用 p2p 网络来加速文件下载，如果您流量有限，可在此处将上传带宽设置为 1(byte)。",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(.6),
              ),
            ),
            const SizedBox(height: 24),
            const Text("请输入下载单位，如：1、100k、10m， 0或留空为不限速。"),
            const SizedBox(height: 12),
            const Text("上传限速："),
            const SizedBox(height: 6),
            TextFormBox(
              placeholder: "1、100k、10m、0",
              controller: upCtrl,
              placeholderStyle: TextStyle(color: Colors.white.withOpacity(.6)),
              inputFormatters: [ifr],
            ),
            const SizedBox(height: 12),
            const Text("下载限速："),
            const SizedBox(height: 6),
            TextFormBox(
              placeholder: "1、100k、10m、0",
              controller: downCtrl,
              placeholderStyle: TextStyle(color: Colors.white.withOpacity(.6)),
              inputFormatters: [ifr],
            ),
            const SizedBox(height: 24),
            Text(
              "* P2P 上传仅在下载文件时进行，下载完成后会关闭 p2p 连接。如您想参与做种，请通过关于页面联系我们。",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(.6),
              ),
            )
          ],
        ));
    if (ok == true) {
      await handleError(() => Aria2cManager.launchDaemon());
      final aria2c = Aria2cManager.getClient();
      final upByte = Aria2cManager.textToByte(upCtrl.text.trim());
      final downByte = Aria2cManager.textToByte(downCtrl.text.trim());
      final r = await handleError(() => aria2c.changeGlobalOption(Aria2Option()
        ..maxOverallUploadLimit = upByte
        ..maxOverallDownloadLimit = downByte));
      if (r != null) {
        await box.put('downloader_up_limit', upCtrl.text.trim());
        await box.put('downloader_down_limit', downCtrl.text.trim());
        notifyListeners();
      }
    }
  }
}
