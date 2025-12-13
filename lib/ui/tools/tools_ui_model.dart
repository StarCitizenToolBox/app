// ignore_for_file: avoid_build_context_in_providers
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/multi_window_manager.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/provider/download_manager.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xml/xml.dart';

import 'dialogs/hosts_booster_dialog_ui.dart';
import 'dialogs/rsi_launcher_enhance_dialog_ui.dart';

part 'tools_ui_model.g.dart';

part 'tools_ui_model.freezed.dart';

class ToolsItemData {
  String key;

  ToolsItemData(this.key, this.name, this.infoString, this.icon, {this.onTap});

  String name;
  String infoString;
  Widget icon;
  AsyncCallback? onTap;
}

@freezed
abstract class ToolsUIState with _$ToolsUIState {
  factory ToolsUIState({
    @Default(false) bool working,
    @Default("") String scInstalledPath,
    @Default("") String rsiLauncherInstalledPath,
    @Default([]) List<String> scInstallPaths,
    @Default([]) List<String> rsiLauncherInstallPaths,
    @Default([]) List<ToolsItemData> items,
    @Default(false) bool isItemLoading,
  }) = _ToolsUIState;
}

@riverpod
class ToolsUIModel extends _$ToolsUIModel {
  @override
  ToolsUIState build() {
    state = ToolsUIState();
    return state;
  }

  Future<void> loadToolsCard(BuildContext context, {bool skipPathScan = false}) async {
    if (state.isItemLoading) return;
    var items = <ToolsItemData>[];
    state = state.copyWith(items: items, isItemLoading: true);
    if (!skipPathScan) {
      await reScanPath(context);
    }
    try {
      items = [
        ToolsItemData(
          "systemnfo",
          S.current.tools_action_view_system_info,
          S.current.tools_action_info_view_critical_system_info,
          const Icon(FluentIcons.system, size: 24),
          onTap: () => _showSystemInfo(context),
        ),
      ];

      if (!context.mounted) return;
      items.add(await _addP4kCard(context));
      items.addAll([
        ToolsItemData(
          "hosts_booster",
          S.current.tools_action_hosts_acceleration_experimental,
          S.current.tools_action_info_hosts_acceleration_experimental_tip,
          const Icon(FluentIcons.virtual_network, size: 24),
          onTap: () => _doHostsBooster(context),
        ),
        ToolsItemData(
          "log_analyze",
          S.current.log_analyzer_title,
          S.current.log_analyzer_description,
          Icon(FluentIcons.analytics_logo),
          onTap: () => _showLogAnalyze(context),
        ),
        ToolsItemData(
          "rsilauncher_enhance_mod",
          S.current.tools_rsi_launcher_enhance_title,
          S.current.tools_action_rsi_launcher_enhance_info,
          const Icon(FluentIcons.c_plus_plus, size: 24),
          onTap: () => rsiEnhance(context),
        ),
        ToolsItemData(
          "reinstall_eac",
          S.current.tools_action_reinstall_easyanticheat,
          S.current.tools_action_info_reinstall_eac,
          const Icon(FluentIcons.game, size: 24),
          onTap: () => _reinstallEAC(context),
        ),
        ToolsItemData(
          "rsilauncher_admin_mode",
          S.current.tools_action_rsi_launcher_admin_mode,
          S.current.tools_action_info_run_rsi_as_admin,
          const Icon(FluentIcons.admin, size: 24),
          onTap: () => _adminRSILauncher(context),
        ),
        ToolsItemData(
          "unp4kc",
          S.current.tools_action_unp4k,
          S.current.tools_action_unp4k_info,
          const Icon(FontAwesomeIcons.fileZipper, size: 24),
          onTap: () => _unp4kc(context),
        ),
        ToolsItemData(
          "dcb_viewer",
          S.current.tools_action_dcb_viewer,
          S.current.tools_action_dcb_viewer_info,
          const Icon(FluentIcons.database, size: 24),
          onTap: () => _dcbViewer(context),
        ),
      ]);

      state = state.copyWith(items: items);
      if (!context.mounted) return;
      items.add(await _addGraphicsRendererCard(context));
      state = state.copyWith(items: items);
      if (!context.mounted) return;
      items.add(await _addShaderCard(context));
      state = state.copyWith(items: items);
      if (!context.mounted) return;
      items.add(await _addPhotographyCard(context));
      state = state.copyWith(items: items);
      if (!context.mounted) return;
      items.addAll(await _addNvmePatchCard(context));
      state = state.copyWith(items: items, isItemLoading: false);
    } catch (e) {
      if (!context.mounted) return;
      showToast(context, S.current.tools_action_info_init_failed(e));
    }
  }

  Future<ToolsItemData> _addP4kCard(BuildContext context) async {
    var torrentUrl = "";
    var versionInfo = "";
    try {
      final l = await Api.getAppTorrentDataList();
      for (var torrent in l) {
        if (torrent.name == "Data.p4k") {
          torrentUrl = torrent.url ?? "";
          versionInfo = torrent.info ?? "";
        }
      }
    } catch (e) {
      dPrint("get torrent url failed: $e");
    }

    return ToolsItemData(
      "p4k_downloader",
      S.current.tools_action_p4k_download_repair,
      S.current.tools_action_info_p4k_download_repair_tip(versionInfo),
      const Icon(FontAwesomeIcons.download, size: 24),
      onTap: () => _downloadP4k(context, torrentUrl),
    );
  }

  Future<List<ToolsItemData>> _addNvmePatchCard(BuildContext context) async {
    final nvmePatchStatus = await SystemHelper.checkNvmePatchStatus();
    return [
      if (nvmePatchStatus)
        ToolsItemData(
          "remove_nvme_settings",
          S.current.tools_action_remove_nvme_registry_patch,
          S.current.tools_action_info_nvme_patch_issue(
            nvmePatchStatus ? S.current.localization_info_installed : S.current.tools_action_info_not_installed,
          ),
          const Icon(FluentIcons.hard_drive, size: 24),
          onTap: nvmePatchStatus
              ? () async {
                  state = state.copyWith(working: true);
                  await SystemHelper.doRemoveNvmePath();
                  state = state.copyWith(working: false);
                  if (!context.mounted) return;
                  showToast(context, S.current.tools_action_info_removed_restart_effective);
                  loadToolsCard(context, skipPathScan: true);
                }
              : null,
        ),
      if (!nvmePatchStatus)
        ToolsItemData(
          "add_nvme_settings",
          S.current.tools_action_write_nvme_registry_patch,
          S.current.tools_action_info_manual_nvme_patch,
          const Icon(FontAwesomeIcons.cashRegister, size: 24),
          onTap: () async {
            state = state.copyWith(working: true);
            final r = await SystemHelper.addNvmePatch();
            if (r == "") {
              if (!context.mounted) return;
              showToast(context, S.current.tools_action_info_fix_success_restart);
            } else {
              if (!context.mounted) return;
              showToast(context, S.current.doctor_action_result_fix_fail(r));
            }
            state = state.copyWith(working: false);
            loadToolsCard(context, skipPathScan: true);
          },
        ),
    ];
  }

  Future<ToolsItemData> _addShaderCard(BuildContext context) async {
    final gameShaderCachePath = await SCLoggerHelper.getShaderCachePath();
    final shaderSize =
        ((await SystemHelper.getDirLen(gameShaderCachePath ?? "", skipPath: ["$gameShaderCachePath\\Crashes"])) /
                1024 /
                1024)
            .toStringAsFixed(4);
    return ToolsItemData(
      "clean_shaders",
      S.current.tools_action_clear_shader_cache,
      S.current.tools_action_info_shader_cache_issue(shaderSize),
      const Icon(FontAwesomeIcons.shapes, size: 24),
      onTap: () => _cleanShaderCache(context),
    );
  }

  /// 获取所有可用的版本号
  Future<List<String>> _getAvailableGraphicsVersions() async {
    final gameShaderCachePath = await SCLoggerHelper.getShaderCachePath();
    if (gameShaderCachePath == null) return [];

    final dir = Directory(gameShaderCachePath);
    if (!await dir.exists()) return [];

    final versions = <String>[];
    await for (var entity in dir.list()) {
      if (entity is Directory) {
        final name = entity.path.split(Platform.pathSeparator).last;
        if (name.startsWith("starcitizen_")) {
          // 提取版本号，例如 starcitizen_1234567 -> 1234567
          final version = name.replaceFirst("starcitizen_", "");
          if (version.isNotEmpty) {
            versions.add(version);
          }
        }
      }
    }

    // 按版本号降序排序（最新的在前面）
    versions.sort((a, b) => b.compareTo(a));
    return versions;
  }

  /// 获取当前渲染器设置
  Future<(int, String?)> _getCurrentGraphicsRenderer() async {
    final gameShaderCachePath = await SCLoggerHelper.getShaderCachePath();
    if (gameShaderCachePath == null) return (-1, null);

    final versions = await _getAvailableGraphicsVersions();
    if (versions.isEmpty) return (-1, null);

    // 使用最新版本
    final latestVersion = versions.first;
    final settingsPath = "$gameShaderCachePath\\starcitizen_$latestVersion\\GraphicsSettings\\GraphicsSettings.json";

    final file = File(settingsPath);
    if (!await file.exists()) return (-1, latestVersion);

    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final graphicsSettings = json["GraphicsSettings"] as Map<String, dynamic>?;
      final renderer = graphicsSettings?["GraphicsRenderer"] as int? ?? 0;
      return (renderer, latestVersion);
    } catch (e) {
      dPrint("_getCurrentGraphicsRenderer error: $e");
      return (-1, latestVersion);
    }
  }

  /// 保存渲染器设置
  Future<void> _saveGraphicsRenderer(String version, int renderer) async {
    final gameShaderCachePath = await SCLoggerHelper.getShaderCachePath();
    if (gameShaderCachePath == null) throw "Shader cache path not found";

    final settingsDir = "$gameShaderCachePath\\starcitizen_$version\\GraphicsSettings";
    final settingsPath = "$settingsDir\\GraphicsSettings.json";

    // 确保目录存在
    await Directory(settingsDir).create(recursive: true);

    final json = {
      "GraphicsSettings": {"SettingsVersion": 1, "GraphicsRenderer": renderer},
    };

    await File(settingsPath).writeAsString(const JsonEncoder.withIndent('  ').convert(json));
  }

  /// 获取渲染器名称
  String _getRendererName(int renderer) {
    switch (renderer) {
      case 0:
        return S.current.tools_graphics_renderer_dx11;
      case 1:
        return S.current.tools_graphics_renderer_vulkan;
      default:
        return S.current.tools_graphics_renderer_unknown;
    }
  }

  Future<ToolsItemData> _addGraphicsRendererCard(BuildContext context) async {
    final (renderer, _) = await _getCurrentGraphicsRenderer();
    final rendererName = _getRendererName(renderer);

    return ToolsItemData(
      "graphics_renderer",
      S.current.tools_action_switch_graphics_renderer,
      S.current.tools_action_switch_graphics_renderer_info(rendererName),
      const Icon(FluentIcons.video, size: 24),
      onTap: () => _showGraphicsRendererDialog(context),
    );
  }

  Future<void> _showGraphicsRendererDialog(BuildContext context) async {
    final versions = await _getAvailableGraphicsVersions();
    final (currentRenderer, latestVersion) = await _getCurrentGraphicsRenderer();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => _GraphicsRendererDialog(
        versions: versions,
        initialVersion: latestVersion ?? "",
        initialRenderer: currentRenderer >= 0 ? currentRenderer : 0,
        onSave: (version, renderer) async {
          try {
            await _saveGraphicsRenderer(version, renderer);
            if (!context.mounted) return;
            showToast(context, S.current.tools_graphics_renderer_dialog_save_success);
            loadToolsCard(context, skipPathScan: true);
            Navigator.of(dialogContext).pop();
          } catch (e) {
            if (!context.mounted) return;
            showToast(context, S.current.tools_graphics_renderer_dialog_save_failed(e));
          }
        },
      ),
    );
  }

  Future<ToolsItemData> _addPhotographyCard(BuildContext context) async {
    // 获取配置文件状态
    final isEnable = await _checkPhotographyStatus(context);

    return ToolsItemData(
      "photography_mode",
      isEnable ? S.current.tools_action_close_photography_mode : S.current.tools_action_open_photography_mode,
      isEnable ? S.current.tools_action_info_restore_lens_shake : S.current.tools_action_info_one_key_close_lens_shake,
      const Icon(FontAwesomeIcons.camera, size: 24),
      onTap: () => _onChangePhotographyMode(context, isEnable),
    );
  }

  /// ---------------------------- func -------------------------------------------------------
  /// -----------------------------------------------------------------------------------------
  /// -----------------------------------------------------------------------------------------
  /// -----------------------------------------------------------------------------------------

  Future<void> reScanPath(BuildContext context, {bool checkActive = false, bool skipToast = false}) async {
    var scInstallPaths = <String>[];
    var rsiLauncherInstallPaths = <String>[];
    var scInstalledPath = "";
    var rsiLauncherInstalledPath = "";

    state = state.copyWith(
      scInstalledPath: scInstalledPath,
      rsiLauncherInstalledPath: rsiLauncherInstalledPath,
      scInstallPaths: scInstallPaths,
      rsiLauncherInstallPaths: rsiLauncherInstallPaths,
    );

    try {
      rsiLauncherInstalledPath = await SystemHelper.getRSILauncherPath();
      rsiLauncherInstallPaths.add(rsiLauncherInstalledPath);
      final listData = await SCLoggerHelper.getLauncherLogList();
      if (listData == null) {
        return;
      }
      scInstallPaths = await SCLoggerHelper.getGameInstallPath(
        listData,
        checkExists: checkActive,
        withVersion: AppConf.gameChannels,
      );
      if (scInstallPaths.isNotEmpty) {
        scInstalledPath = scInstallPaths.first;
      }
      state = state.copyWith(
        scInstalledPath: scInstalledPath,
        rsiLauncherInstalledPath: rsiLauncherInstalledPath,
        scInstallPaths: scInstallPaths,
        rsiLauncherInstallPaths: rsiLauncherInstallPaths,
      );
    } catch (e) {
      dPrint(e);
      if (!context.mounted) return;
      showToast(context, S.current.tools_action_info_log_file_parse_failed);
    }

    if (!skipToast) {
      if (rsiLauncherInstalledPath == "") {
        if (!context.mounted) return;
        showToast(context, S.current.tools_action_info_rsi_launcher_not_found);
      }
      if (scInstalledPath == "") {
        if (!context.mounted) return;
        showToast(context, S.current.tools_action_info_star_citizen_not_found);
      }
    }
  }

  /// 重装EAC
  Future<void> _reinstallEAC(BuildContext context) async {
    if (state.scInstalledPath.isEmpty) {
      showToast(context, S.current.tools_action_info_valid_game_directory_needed);
      return;
    }
    state = state.copyWith(working: true);
    try {
      final eacPath = "${state.scInstalledPath}\\EasyAntiCheat";
      final eacJsonPath = "$eacPath\\Settings.json";
      if (await File(eacJsonPath).exists()) {
        Map<String, String> envVars = Platform.environment;
        final eacJsonData = await File(eacJsonPath).readAsString();
        final Map eacJson = json.decode(eacJsonData);
        final eacID = eacJson["productid"];
        if (eacID != null) {
          final eacCacheDir = Directory("${envVars["appdata"]}\\EasyAntiCheat\\$eacID");
          if (await eacCacheDir.exists()) {
            await eacCacheDir.delete(recursive: true);
          }
        }
      }
      final dir = Directory(eacPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
      final eacLauncher = File("${state.scInstalledPath}\\StarCitizen_Launcher.exe");
      if (await eacLauncher.exists()) {
        await eacLauncher.delete(recursive: true);
      }
      if (!context.mounted) return;
      showToast(context, S.current.tools_action_info_eac_file_removed);
      _adminRSILauncher(context);
    } catch (e) {
      showToast(context, S.current.tools_action_info_error_occurred(e));
    }
    state = state.copyWith(working: false);
    loadToolsCard(context, skipPathScan: true);
  }

  Future<String> getSystemInfo() async {
    return S.current.tools_action_info_system_info_content(
      await SystemHelper.getSystemName(),
      await SystemHelper.getCpuName(),
      await SystemHelper.getSystemMemorySizeGB(),
      await SystemHelper.getGpuInfo(),
      await SystemHelper.getDiskInfo(),
    );
  }

  /// 管理员模式运行 RSI 启动器
  Future _adminRSILauncher(BuildContext context) async {
    if (state.rsiLauncherInstalledPath == "") {
      showToast(context, S.current.tools_action_info_rsi_launcher_directory_not_found);
    }
    SystemHelper.checkAndLaunchRSILauncher(state.rsiLauncherInstalledPath);
  }

  Future<void> openDir(dynamic path) async {
    SystemHelper.openDir(path);
  }

  Future _showSystemInfo(BuildContext context) async {
    state = state.copyWith(working: true);
    final systemInfo = await getSystemInfo();
    if (!context.mounted) return;
    showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(S.current.tools_action_info_system_info_title),
        content: Text(systemInfo),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .65),
        actions: [
          FilledButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              child: Text(S.current.action_close),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    state = state.copyWith(working: false);
  }

  static Future<void> cleanShaderCache() async {
    final gameShaderCachePath = await SCLoggerHelper.getShaderCachePath();
    final l = await Directory(gameShaderCachePath!).list(recursive: false).toList();
    for (var value in l) {
      if (value is Directory) {
        final dirName = value.path.split(Platform.pathSeparator).last;
        if (dirName == "Crashes") continue;

        // 对于 starcitizen_* 目录，手动遍历删除，保留 GraphicsSettings 文件夹
        if (dirName.startsWith("starcitizen_")) {
          await _cleanShaderCacheDirectory(value);
        } else {
          await value.delete(recursive: true);
        }
      }
    }
  }

  Future<void> _cleanShaderCache(BuildContext context) async {
    state = state.copyWith(working: true);
    await cleanShaderCache();
    if (!context.mounted) return;
    loadToolsCard(context, skipPathScan: true);
    state = state.copyWith(working: false);
  }

  /// 清理着色器缓存目录，保留 GraphicsSettings 文件夹
  static Future<void> _cleanShaderCacheDirectory(Directory dir) async {
    try {
      final contents = await dir.list(recursive: false).toList();
      for (var entity in contents) {
        final name = entity.path.split(Platform.pathSeparator).last;
        // 保留 GraphicsSettings 文件夹
        if (name == "GraphicsSettings") continue;

        if (entity is Directory) {
          await entity.delete(recursive: true);
        } else if (entity is File) {
          await entity.delete();
        }
      }
    } catch (e) {
      dPrint("_cleanShaderCacheDirectory error: $e");
    }
  }

  Future<void> _downloadP4k(BuildContext context, String torrentUrl) async {
    String savePath = state.scInstalledPath;
    String fileName = "Data.p4k";

    if ((await SystemHelper.getPID("RSI Launcher")).isNotEmpty) {
      if (!context.mounted) return;
      showToast(
        context,
        S.current.tools_action_info_rsi_launcher_running_warning,
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .35),
      );
      return;
    }

    if (!context.mounted) return;
    final ok = await showConfirmDialogs(
      context,
      S.current.tools_action_p4k_download_repair,
      Text(S.current.tools_action_info_p4k_file_description),
    );
    if (!ok) return;
    try {
      state = state.copyWith(working: true);
      final downloadManager = ref.read(downloadManagerProvider.notifier);
      await downloadManager.initDownloader();

      // check download task list
      if (await downloadManager.isNameInTask("Data.p4k")) {
        if (!context.mounted) return;
        showToast(context, S.current.tools_action_info_p4k_download_in_progress);
        state = state.copyWith(working: false);
        return;
      }

      if (torrentUrl == "") {
        state = state.copyWith(working: false);
        if (!context.mounted) return;
        showToast(context, S.current.tools_action_info_function_under_maintenance);
        return;
      }

      final userSelect = await FilePicker.platform.saveFile(
        initialDirectory: savePath,
        fileName: fileName,
        lockParentWindow: true,
      );
      if (userSelect == null) {
        state = state.copyWith(working: false);
        return;
      }

      savePath = userSelect;
      dPrint(savePath);

      if (savePath.endsWith("\\$fileName")) {
        savePath = savePath.substring(0, savePath.length - fileName.length - 1);
      }

      if (!context.mounted) return;
      final btData = await RSHttp.get(torrentUrl).unwrap(context: context);
      if (btData == null || btData.data == null) {
        state = state.copyWith(working: false);
        return;
      }

      final taskId = await downloadManager.addTorrent(btData.data!, outputFolder: savePath);
      state = state.copyWith(working: false);
      dPrint("DownloadManager.addTorrent resp === $taskId");
      AnalyticsApi.touch("p4k_download");
      if (!context.mounted) return;
      context.push("/index/downloader");
    } catch (e) {
      state = state.copyWith(working: false);
      if (!context.mounted) return;
      showToast(context, S.current.app_init_failed_with_reason(e));
      rethrow;
    }

    if (!context.mounted) return;
    launchUrlString("https://support.citizenwiki.cn/d/8");
  }

  Future<bool> _checkPhotographyStatus(BuildContext context, {bool? setMode}) async {
    final scInstalledPath = state.scInstalledPath;
    final keys = ["AudioShakeStrength", "CameraSpringMovement", "ShakeScale"];
    final attributesFile = File("$scInstalledPath\\USER\\Client\\0\\Profiles\\default\\attributes.xml");
    if (setMode == null) {
      bool isEnable = false;
      if (scInstalledPath.isNotEmpty) {
        if (await attributesFile.exists()) {
          final xmlFile = XmlDocument.parse(await attributesFile.readAsString());
          isEnable = true;
          for (var k in keys) {
            if (!isEnable) break;
            final e = xmlFile.rootElement.children.where((element) => element.getAttribute("name") == k).firstOrNull;
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
        if (!context.mounted) return false;
        showToast(context, S.current.tools_action_info_config_file_not_exist);
        return false;
      }
      final xmlFile = XmlDocument.parse(await attributesFile.readAsString());
      // clear all
      xmlFile.rootElement.children.removeWhere((element) => keys.contains(element.getAttribute("name")));
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

  Future<void> _onChangePhotographyMode(BuildContext context, bool isEnable) async {
    _checkPhotographyStatus(context, setMode: !isEnable).unwrap(context: context);
    loadToolsCard(context, skipPathScan: true);
  }

  void onChangeGamePath(String v) {
    state = state.copyWith(scInstalledPath: v);
  }

  void onChangeLauncherPath(String s) {
    state = state.copyWith(rsiLauncherInstalledPath: s);
  }

  Future<void> _doHostsBooster(BuildContext context) async {
    showDialog(context: context, builder: (BuildContext context) => const HostsBoosterDialogUI());
  }

  Future<void> _unp4kc(BuildContext context) async {
    context.push("/tools/unp4kc");
  }

  Future<void> _dcbViewer(BuildContext context) async {
    context.push("/tools/dcb_viewer");
  }

  static Future<void> rsiEnhance(BuildContext context, {bool showNotGameInstallMsg = false}) async {
    if ((await SystemHelper.getPID("RSI Launcher")).isNotEmpty) {
      if (!context.mounted) return;
      showToast(
        context,
        S.current.tools_action_info_rsi_launcher_running_warning,
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .35),
      );
      return;
    }
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) => RsiLauncherEnhanceDialogUI(showNotGameInstallMsg: showNotGameInstallMsg),
    );
  }

  Future<void> _showLogAnalyze(BuildContext context) async {
    if (state.scInstalledPath.isEmpty) {
      showToast(context, S.current.tools_action_info_valid_game_directory_needed);
      return;
    }
    if (!context.mounted) return;
    await MultiWindowManager.launchSubWindow(
      WindowTypes.logAnalyze,
      S.current.log_analyzer_window_title,
      appGlobalState,
    );
  }
}

/// 图形渲染器切换对话框
class _GraphicsRendererDialog extends StatefulWidget {
  final List<String> versions;
  final String initialVersion;
  final int initialRenderer;
  final Future<void> Function(String version, int renderer) onSave;

  const _GraphicsRendererDialog({
    required this.versions,
    required this.initialVersion,
    required this.initialRenderer,
    required this.onSave,
  });

  @override
  State<_GraphicsRendererDialog> createState() => _GraphicsRendererDialogState();
}

class _GraphicsRendererDialogState extends State<_GraphicsRendererDialog> {
  late TextEditingController _versionController;
  late int _selectedRenderer;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _versionController = TextEditingController(text: widget.initialVersion);
    _selectedRenderer = widget.initialRenderer;
  }

  @override
  void dispose() {
    _versionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(S.current.tools_graphics_renderer_dialog_title),
      constraints: const BoxConstraints(maxWidth: 460),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.versions.isEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: InfoBar(
                title: Text(S.current.tools_graphics_renderer_dialog_no_version),
                severity: InfoBarSeverity.warning,
              ),
            ),
          // 版本选择
          Text(S.current.tools_graphics_renderer_dialog_version),
          const SizedBox(height: 8),
          AutoSuggestBox<String>(
            controller: _versionController,
            placeholder: S.current.tools_graphics_renderer_dialog_version_hint,
            items: widget.versions.map((v) => AutoSuggestBoxItem<String>(value: v, label: v)).toList(),
            onSelected: (item) {
              setState(() {
                _versionController.text = item.value ?? "";
              });
            },
          ),
          const SizedBox(height: 16),
          // 渲染器选择
          Text(S.current.tools_graphics_renderer_dialog_renderer),
          const SizedBox(height: 8),
          ComboBox<int>(
            value: _selectedRenderer,
            items: [
              ComboBoxItem(value: 0, child: Text(S.current.tools_graphics_renderer_dx11)),
              ComboBoxItem(value: 1, child: Text(S.current.tools_graphics_renderer_vulkan)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedRenderer = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        Button(onPressed: _isSaving ? null : () => Navigator.of(context).pop(), child: Text(S.current.action_close)),
        FilledButton(
          onPressed: _isSaving || _versionController.text.isEmpty
              ? null
              : () async {
                  setState(() {
                    _isSaving = true;
                  });
                  try {
                    await widget.onSave(_versionController.text, _selectedRenderer);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isSaving = false;
                      });
                    }
                  }
                },
          child: _isSaving
              ? const SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2))
              : Text(S.current.tools_graphics_renderer_dialog_save),
        ),
      ],
    );
  }
}
