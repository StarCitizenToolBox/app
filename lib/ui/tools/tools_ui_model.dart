import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/ui/tools/downloader/downloader_dialog_ui_model.dart';

import 'downloader/downloader_dialog_ui.dart';

class ToolsUIModel extends BaseUIModel {
  bool _working = false;

  String scInstalledPath = "";
  String rsiLauncherInstalledPath = "";

  List<String> scInstallPaths = [];
  List<String> rsiLauncherInstallPaths = [];

  set working(bool b) {
    _working = b;
    notifyListeners();
  }

  bool get working => _working;

  var items = <_ToolsItemData>[];

  bool isItemLoading = false;

  @override
  Future loadData({bool skipPathScan = false}) async {
    items.clear();
    notifyListeners();
    if (!skipPathScan) {
      await reScanPath();
    }
    try {
      items = [
        _ToolsItemData(
          "systeminfo",
          "查看系统信息",
          "查看系统关键信息，用于快速问诊 \n\n耗时操作，请耐心等待。",
          const Icon(FluentIcons.system, size: 28),
          onTap: _showSystemInfo,
        ),
        _ToolsItemData(
          "p4k_downloader",
          "P4K 分流下载",
          "使用星际公民中文百科提供的分流下载服务。 \n\n资源有限，请勿滥用。请确保您的硬盘拥有至少大于 200G 的可用空间。",
          const Icon(FontAwesomeIcons.download, size: 28),
          onTap: _downloadP4k,
        ),
        _ToolsItemData(
          "reinstall_eac",
          "重装 EasyAntiCheat 反作弊",
          "若您遇到 EAC 错误，且自动修复无效，请尝试使用此功能重装 EAC。",
          const Icon(FluentIcons.game, size: 28),
          onTap: _reinstallEAC,
        ),
        _ToolsItemData(
          "rsilauncher_admin_mode",
          "RSI Launcher 管理员模式",
          "在某些情况下 RSI启动器 无法正确获得管理员权限，您可尝试使用该功能以管理员模式运行启动器。",
          const Icon(FluentIcons.admin, size: 28),
          onTap: _adminRSILauncher,
        )
      ];
      isItemLoading = true;
      notifyListeners();
      items.addAll(await _addLogCard());
      notifyListeners();
      items.addAll(await _addNvmePatchCard());
      notifyListeners();
      items.add(await _addShaderCard());
      isItemLoading = false;
      notifyListeners();
    } catch (e) {
      showToast(context!, "初始化失败，请截图报告给开发者。$e");
    }
    notifyListeners();
  }

  Future<List<_ToolsItemData>> _addLogCard() async {
    double logPathLen = 0;
    try {
      logPathLen =
          (await File(await SCLoggerHelper.getLogFilePath() ?? "").length()) /
              1024 /
              1024;
    } catch (_) {}
    return [
      _ToolsItemData(
        "rsilauncher_log_select",
        "RSI Launcher Log 查看",
        "打开 RSI启动器 Log文件 所在文件夹",
        const Icon(FontAwesomeIcons.bookBible, size: 28),
        onTap: _selectLog,
      ),
      _ToolsItemData(
        "rsilauncher_log_fix",
        "RSI Launcher Log 修复",
        "在某些情况下 RSI启动器 的 log 文件会损坏，导致无法完成问题扫描，使用此工具清理损坏的 log 文件。\n\n当前日志文件大小：${(logPathLen.toStringAsFixed(4))} MB",
        const Icon(FontAwesomeIcons.bookBible, size: 28),
        onTap: _rsiLogFix,
      ),
    ];
  }

  Future<List<_ToolsItemData>> _addNvmePatchCard() async {
    final nvmePatchStatus = await SystemHelper.checkNvmePatchStatus();
    return [
      if (nvmePatchStatus)
        _ToolsItemData(
          "remove_nvme_settings",
          "移除 nvme 注册表补丁",
          "若您使用 nvme 补丁出现问题，请运行此工具。（可能导致游戏 安装/更新 不可用。）\n\n当前补丁状态：${(nvmePatchStatus) ? "已安装" : "未安装"}",
          const Icon(FluentIcons.hard_drive, size: 28),
          onTap: nvmePatchStatus
              ? () async {
                  working = true;
                  await SystemHelper.doRemoveNvmePath();
                  working = false;
                  showToast(context!, "已移除，重启生效！");
                  loadData(skipPathScan: true);
                }
              : null,
        ),
      if (!nvmePatchStatus)
        _ToolsItemData(
          "add_nvme_settings",
          "写入 nvme 注册表补丁",
          "手动写入NVM补丁，该功能仅在您知道自己在作什么的情况下使用",
          const Icon(FontAwesomeIcons.cashRegister, size: 28),
          onTap: () async {
            working = true;
            final r = await SystemHelper.addNvmePatch();
            if (r == "") {
              showToast(context!,
                  "修复成功，请尝试重启后继续安装游戏！ 若注册表修改操作导致其他软件出现兼容问题，请使用 工具 中的 NVME 注册表清理。");
              notifyListeners();
            } else {
              showToast(context!, "修复失败，$r");
            }
            working = false;
            loadData(skipPathScan: true);
          },
        )
    ];
  }

  Future<_ToolsItemData> _addShaderCard() async {
    final gameShaderCachePath = await SCLoggerHelper.getShaderCachePath();
    return _ToolsItemData(
      "clean_shaders",
      "清理着色器缓存",
      "若游戏画面出现异常或版本更新后可使用本工具清理过期的着色器（当大于500M时，建议清理） \n\n缓存大小：${((await SystemHelper.getDirLen(gameShaderCachePath ?? "", skipPath: [
                "$gameShaderCachePath\\Crashes"
              ])) / 1024 / 1024).toStringAsFixed(4)} MB",
      const Icon(FontAwesomeIcons.shapes, size: 28),
      onTap: _cleanShaderCache,
    );
  }

  /// ---------------------------- func -------------------------------------------------------
  /// -----------------------------------------------------------------------------------------
  /// -----------------------------------------------------------------------------------------
  /// -----------------------------------------------------------------------------------------

  Future<void> reScanPath() async {
    scInstallPaths.clear();
    rsiLauncherInstallPaths.clear();
    scInstalledPath = "";
    rsiLauncherInstalledPath = "";
    try {
      rsiLauncherInstalledPath = await SystemHelper.getRSILauncherPath();
      rsiLauncherInstallPaths.add(rsiLauncherInstalledPath);
      final listData = await SCLoggerHelper.getLauncherLogList();
      if (listData == null) {
        return;
      }
      scInstallPaths = await SCLoggerHelper.getGameInstallPath(listData,
          checkExists: false, withVersion: ["LIVE", "PTU", "EPTU"]);
      if (scInstallPaths.isNotEmpty) {
        scInstalledPath = scInstallPaths.first;
      }
    } catch (e) {
      showToast(context!, "解析 log 文件失败！\n请尝试使用 RSI Launcher log 修复 工具！");
    }
    notifyListeners();

    if (rsiLauncherInstalledPath == "") {
      showToast(context!,
          "未找到 RSI 启动器，请尝试重新安装。 \n\n下载链接：https://robertsspaceindustries.com/download");
    }
    if (scInstalledPath == "") {
      showToast(context!, "未找到星际公民游戏安装位置，请至少完成一次游戏启动操作。");
    }
  }

  /// 重装EAC
  Future<void> _reinstallEAC() async {
    if (scInstalledPath.isEmpty) {
      showToast(context!, "该功能需要一个有效的游戏安装目录");
      return;
    }
    working = true;
    try {
      final eacPath = "$scInstalledPath\\EasyAntiCheat";
      final eacJsonPath = "$eacPath\\Settings.json";
      if (await File(eacJsonPath).exists()) {
        Map<String, String> envVars = Platform.environment;
        final eacJsonData = await File(eacJsonPath).readAsString();
        final Map eacJson = json.decode(eacJsonData);
        final eacID = eacJson["productid"];
        if (eacID != null) {
          final eacCacheDir =
              Directory("${envVars["appdata"]}\\EasyAntiCheat\\$eacID");
          if (await eacCacheDir.exists()) {
            await eacCacheDir.delete(recursive: true);
          }
        }
      }
      final dir = Directory(eacPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
      final eacLauncher = File("$scInstalledPath\\StarCitizen_Launcher.exe");
      if (await eacLauncher.exists()) {
        await eacLauncher.delete(recursive: true);
      }
      showToast(context!,
          "已为您移除 EAC 文件，接下来将为您打开 RSI 启动器，请您前往 SETTINGS -> VERIFY 重装 EAC。");
      _adminRSILauncher();
    } catch (e) {
      showToast(context!, "出现错误：$e");
    }
    working = false;
    loadData(skipPathScan: true);
  }

  Future<String> getSystemInfo() async {
    return "系统：${await SystemHelper.getSystemName()}\n\n"
        "处理器：${await SystemHelper.getSystemCimInstance("Win32_Processor")}\n\n"
        "内存大小：${await SystemHelper.getSystemMemorySizeGB()}GB\n\n"
        "显卡信息：\n${await SystemHelper.getGpuInfo()}\n\n"
        "硬盘信息：\n${await SystemHelper.getDiskInfo()}\n\n";
  }

  /// 管理员模式运行 RSI 启动器
  Future _adminRSILauncher() async {
    if (rsiLauncherInstalledPath == "") {
      showToast(context!, "未找到 RSI 启动器目录，请您尝试手动操作。");
    }
    handleError(
        () => SystemHelper.checkAndLaunchRSILauncher(rsiLauncherInstalledPath));
  }

  Future<void> _rsiLogFix() async {
    working = true;
    final path = await SCLoggerHelper.getLogFilePath();
    if (!await File(path!).exists()) {
      showToast(
          context!, "日志文件不存在，请尝试进行一次游戏启动或游戏安装，并退出启动器，若无法解决问题，请尝试将启动器更新至最新版本！");
      return;
    }
    try {
      SystemHelper.killRSILauncher();
      await File(path).delete(recursive: true);
      showToast(context!, "清理完毕，请完成一次安装 / 游戏启动 操作。");
      SystemHelper.checkAndLaunchRSILauncher(rsiLauncherInstalledPath);
    } catch (_) {
      showToast(context!, "清理失败，请手动移除，文件位置：$path");
    }
    working = false;
  }

  Future<void> _selectLog() async {
    final path = await SCLoggerHelper.getLogFilePath();
    if (path == null) return;
    openDir(path);
  }

  openDir(path) async {
    await Process.run("powershell.exe", ["explorer.exe", "/select,\"$path\""]);
  }

  Future _showSystemInfo() async {
    working = true;
    final systemInfo = await getSystemInfo();
    showDialog<String>(
      context: context!,
      builder: (context) => ContentDialog(
        title: const Text('系统信息'),
        content: Text(systemInfo),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .65,
        ),
        actions: [
          FilledButton(
            child: const Padding(
              padding: EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              child: Text('关闭'),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    working = false;
  }

  Future<void> _cleanShaderCache() async {
    working = true;
    final gameShaderCachePath = await SCLoggerHelper.getShaderCachePath();
    final l =
        await Directory(gameShaderCachePath!).list(recursive: false).toList();
    for (var value in l) {
      if (value is Directory) {
        if (!value.absolute.path.contains("Crashes")) {
          await value.delete(recursive: true);
        }
      }
    }
    loadData(skipPathScan: true);
    working = false;
  }

  Future<void> _downloadP4k() async {
    final downloadUrl = AppConf.networkVersionData?.p4kDownloadUrl;
    if (downloadUrl == null || downloadUrl.isEmpty) {
      showToast(context!, "该功能维护中，请稍后再试！");
      return;
    }
    if ((await SystemHelper.getPID("RSI Launcher.exe")).isNotEmpty) {
      showToast(context!, "RSI启动器正在运行，请手动退出启动器再使用此功能。");
      return;
    }
    await showToast(
        context!,
        "P4k 是星际公民的核心游戏文件，高达近 100GB，盒子提供的离线下载是为了帮助一些p4k文件下载超级慢的用户。"
        "\n\n接下来会弹窗询问您保存位置（可以选择星际公民文件夹也可以选择别处），下载完成后请确保 P4K 文件夹位于 LIVE 文件夹内，之后使用星际公民启动器校验更新即可。");

    final r = await showDialog(
        context: context!,
        dismissWithEsc: false,
        builder: (context) {
          return BaseUIContainer(
              uiCreate: () => DownloaderDialogUI(),
              modelCreate: () => DownloaderDialogUIModel(
                  "Data.p4k", scInstalledPath, downloadUrl,
                  showChangeSavePathDialog: true, threadCount: 10));
        });
    if (r != null) {
      if (r == "cancel") {
        return showToast(context!, "下载已取消，下载进度已保留，如果您无需恢复下载，请手动删除下载临时文件。");
      }
      showToast(context!, "下载完毕，文件已保存到：$r");
    }
  }
}

class _ToolsItemData {
  String key;

  _ToolsItemData(this.key, this.name, this.infoString, this.icon, {this.onTap});

  String name;
  String infoString;
  Widget icon;
  AsyncCallback? onTap;
}
