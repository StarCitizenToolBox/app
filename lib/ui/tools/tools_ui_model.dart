import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/io/aria2c.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/ui/home/downloader/downloader_ui.dart';
import 'package:starcitizen_doctor/ui/home/downloader/downloader_ui_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xml/xml.dart';


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
    if (isItemLoading) return;
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
          "P4K 分流下载 / 修复",
          "使用星际公民中文百科提供的分流下载服务，可用于下载或修复 p4k。 \n资源有限，请勿滥用。",
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
          "以管理员身份运行RSI启动器，可能会解决一些问题。\n\n若设置了能效核心屏蔽参数，也会在此应用。",
          const Icon(FluentIcons.admin, size: 28),
          onTap: _adminRSILauncher,
        ),
      ];
      isItemLoading = true;
      items.add(await _addShaderCard());
      notifyListeners();
      items.add(await _addPhotographyCard());
      notifyListeners();
      items.addAll(await _addLogCard());
      notifyListeners();
      items.addAll(await _addNvmePatchCard());
      notifyListeners();
      // close loading
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

  Future<_ToolsItemData> _addPhotographyCard() async {
    // 获取配置文件状态
    final isEnable = await _checkPhotographyStatus();

    return _ToolsItemData(
      "photography_mode",
      isEnable ? "关闭摄影模式" : "开启摄影模式",
      isEnable
          ? "还原镜头摇晃效果。\n\n@拉邦那 Lapernum 提供参数信息。"
          : "一键关闭游戏内镜头晃动以便于摄影操作。\n\n @拉邦那 Lapernum 提供参数信息。",
      const Icon(FontAwesomeIcons.camera, size: 28),
      onTap: () => _onChangePhotographyMode(isEnable),
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
      dPrint(e);
      showToast(context!, "解析 log 文件失败！\n请尝试使用 RSI Launcher log 修复 工具！");
    }
    notifyListeners();

    if (rsiLauncherInstalledPath == "") {
      showToast(context!, "未找到 RSI 启动器，请尝试重新安装，或在设置中手动添加。");
    }
    if (scInstalledPath == "") {
      showToast(context!, "未找到星际公民游戏安装位置，请至少完成一次游戏启动操作 或在设置中手动添加。");
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
        "处理器：${await SystemHelper.getCpuName()}\n\n"
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

  openDir(path) async {
    await Process.run(
        SystemHelper.powershellPath, ["explorer.exe", "/select,\"$path\""]);
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
    String savePath = scInstalledPath;
    String fileName = "Data.p4k";

    if ((await SystemHelper.getPID("\"RSI Launcher\"")).isNotEmpty) {
      showToast(context!, "RSI启动器正在运行！请先关闭启动器再使用此功能！",
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context!).size.width * .35));
      return;
    }

    await showToast(
        context!,
        "P4k 是星际公民的核心游戏文件，高达 100GB+，盒子提供的离线下载是为了帮助一些p4k文件下载超级慢的用户 或用于修复官方启动器无法修复的 p4k 文件。"
        "\n\n接下来会弹窗询问您保存位置（可以选择星际公民文件夹也可以选择别处），下载完成后请确保 P4K 文件夹位于 LIVE 文件夹内，之后使用星际公民启动器校验更新即可。");

    try {
      working = true;
      notifyListeners();

      await Aria2cManager.launchDaemon();
      final aria2c = Aria2cManager.getClient();

      // check download task list
      for (var value in [
        ...await aria2c.tellActive(),
        ...await aria2c.tellWaiting(0, 100000)
      ]) {
        final t = DownloaderUIModel.getTaskTypeAndName(value);
        if (t.key == "torrent" && t.value.contains("Data.p4k")) {
          showToast(context!, "已经有一个p4k下载任务正在进行中，请前往下载管理器查看！");
          working = false;
          return;
        }
      }

      var torrentUrl = "";
      final l = await Api.getAppTorrentDataList();
      for (var torrent in l) {
        if (torrent.name == "Data.p4k") {
          torrentUrl = torrent.url!;
        }
      }
      if (torrentUrl == "") {
        working = false;
        showToast(context!, "功能维护中，请稍后重试！");
        return;
      }

      final userSelect = await FilePicker.platform.saveFile(
          initialDirectory: savePath,
          fileName: fileName,
          lockParentWindow: true);
      if (userSelect == null) {
        working = false;
        return;
      }

      savePath = userSelect;
      dPrint(savePath);
      notifyListeners();
      if (savePath.endsWith("\\$fileName")) {
        savePath = savePath.substring(0, savePath.length - fileName.length - 1);
      }

      final btData = await handleError(() => RSHttp.get(torrentUrl));
      if (btData == null || btData.data == null) {
        working = false;
        return;
      }
      final b64Str = base64Encode(btData.data!);

      final gid =
          await aria2c.addTorrent(b64Str, extraParams: {"dir": savePath});
      working = false;
      dPrint("Aria2cManager.aria2c.addUri resp === $gid");
      await aria2c.saveSession();
      AnalyticsApi.touch("p4k_download");

      BaseUIContainer(
          uiCreate: () => DownloaderUI(),
          modelCreate: () => DownloaderUIModel()).push(context!);
    } catch (e) {
      working = false;
      showToast(context!, "初始化失败！: $e");
    }
    await Future.delayed(const Duration(seconds: 3));
    launchUrlString(
        "https://citizenwiki.cn/SC%E6%B1%89%E5%8C%96%E7%9B%92%E5%AD%90#%E5%88%86%E6%B5%81%E4%B8%8B%E8%BD%BD%E6%95%99%E7%A8%8B");
  }

  Future<bool> _checkPhotographyStatus({bool? setMode}) async {
    const keys = ["AudioShakeStrength", "CameraSpringMovement", "ShakeScale"];
    final attributesFile = File(
        "$scInstalledPath\\USER\\Client\\0\\Profiles\\default\\attributes.xml");
    if (setMode == null) {
      bool isEnable = false;
      if (scInstalledPath.isNotEmpty) {
        if (await attributesFile.exists()) {
          final xmlFile =
              XmlDocument.parse(await attributesFile.readAsString());
          isEnable = true;
          for (var k in keys) {
            if (!isEnable) break;
            final e = xmlFile.rootElement.children
                .where((element) => element.getAttribute("name") == k)
                .firstOrNull;
            if (e != null && e.getAttribute("value") == "0") {
            } else {
              isEnable = false;
            }
          }
        }
      }
      return isEnable;
    } else {
      if (!await attributesFile.exists()) {
        showToast(context!, "配置文件不存在，请尝试运行一次游戏");
        return false;
      }
      final xmlFile = XmlDocument.parse(await attributesFile.readAsString());
      // clear all
      xmlFile.rootElement.children.removeWhere(
          (element) => keys.contains(element.getAttribute("name")));
      if (setMode) {
        for (var element in keys) {
          XmlElement newNode = XmlElement(XmlName('Attr'), [
            XmlAttribute(XmlName('name'), element),
            XmlAttribute(XmlName('value'), '0'),
          ]);
          xmlFile.rootElement.children.add(newNode);
        }
      }
      dPrint(xmlFile);
      await attributesFile.delete();
      await attributesFile.writeAsString(xmlFile.toXmlString(pretty: true));
    }
    return true;
  }

  _onChangePhotographyMode(bool isEnable) async {
    await handleError(() => _checkPhotographyStatus(setMode: !isEnable));
    reloadData();
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
