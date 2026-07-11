import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/api/news_api.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/rust/api/win32_api.dart' as win32;
import 'package:starcitizen_doctor/common/utils/async.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/common/utils/provider.dart';
import 'package:starcitizen_doctor/data/app_placard_data.dart';
import 'package:starcitizen_doctor/data/app_web_localization_versions_data.dart';
import 'package:starcitizen_doctor/data/citizen_news_data.dart';
import 'package:starcitizen_doctor/data/countdown_festival_item_data.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/home_game_login_dialog_ui.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/home_p4k_update_dialog_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as html_dom;
import '../webview/webview.dart';
import 'localization/localization_ui_model.dart';

part 'home_ui_model.freezed.dart';

part 'home_ui_model.g.dart';

@freezed
abstract class HomeUIModelState with _$HomeUIModelState {
  factory HomeUIModelState({
    AppPlacardData? appPlacardData,
    @Default(false) bool isFixing,
    @Default("") String isFixingString,
    String? scInstalledPath,
    @Default([]) List<String> scInstallPaths,
    AppWebLocalizationVersionsData? webLocalizationVersionsData,
    @Default("") String lastScreenInfo,
    CitizenNewsData? citizenNewsData,
    MapEntry<String, bool>? localizationUpdateInfo,
    List? scServerStatus,
    List<CountdownFestivalItemData>? countdownFestivalListData,
    @Default({}) Map<String, bool> isGameRunning,
  }) = _HomeUIModelState;
}

extension HomeUIModelStateEx on HomeUIModelState {
  bool get isCurGameRunning => isGameRunning[scInstalledPath] ?? false;
}

@riverpod
class HomeUIModel extends _$HomeUIModel {
  @override
  HomeUIModelState build() {
    state = HomeUIModelState();
    _init();
    _loadData();
    return state;
  }

  Future<void> closePlacard() async {
    final box = await Hive.openBox("app_conf");
    await box.put("close_placard", state.appPlacardData?.version);
    state = state.copyWith(appPlacardData: null);
  }

  Future<void> reScanPath() async {
    state = state.copyWith(
      scInstalledPath: "not_install",
      lastScreenInfo: S.current.home_action_info_scanning,
    );
    try {
      final listData = await SCLoggerHelper.getLauncherLogList();
      if (listData == null) {
        state = state.copyWith(scInstalledPath: "not_install");
        return;
      }
      final scInstallPaths = await SCLoggerHelper.getGameInstallPath(
        listData,
        withVersion: AppConf.gameChannels,
        checkExists: true,
      );

      String scInstalledPath = "not_install";

      if (scInstallPaths.isNotEmpty) {
        if (scInstallPaths.first.isNotEmpty) {
          scInstalledPath = scInstallPaths.first;
        }
      }
      final lastScreenInfo = S.current
          .home_action_info_scan_complete_valid_directories_found(
            scInstallPaths.length.toString(),
          );
      state = state.copyWith(
        scInstalledPath: scInstalledPath,
        scInstallPaths: scInstallPaths,
        lastScreenInfo: lastScreenInfo,
      );
    } catch (e) {
      state = state.copyWith(
        scInstalledPath: "not_install",
        lastScreenInfo: S.current.home_action_info_log_file_parse_fail,
      );
      AnalyticsApi.touch("error_launchLogs");
      // showToast(context!,
      //     "${S.current.home_action_info_log_file_parse_fail} \n请关闭游戏，退出RSI启动器后重试，若仍有问题，请使用工具箱中的 RSI Launcher log 修复。");
    }
  }

  String getRssImage(String? htmlString) {
    if (htmlString == null) return "";
    final h = html.parse(htmlString);
    if (h.body == null) return "";
    for (var node in h.body!.nodes) {
      if (node is html_dom.Element) {
        if (node.localName == "img") {
          return node.attributes["src"]?.trim() ?? "";
        }
      }
    }
    return "";
  }

  String handleTitle(String? title) {
    if (title == null) return "";
    title = title.replaceAll("【", "[ ");
    title = title.replaceAll("】", " ] ");
    return title;
  }

  Future<void> goWebView(
    // ignore: avoid_build_context_in_providers
    BuildContext context,
    String title,
    String url, {
    bool useLocalization = false,
    bool loginMode = false,
    String loginChannel = "LIVE",
    RsiLoginCallback? rsiLoginCallback,
  }) async {
    if (useLocalization) {
      const tipVersion = 2;
      final box = await Hive.openBox("app_conf");
      final skip = await box.get(
        "skip_web_localization_tip_version",
        defaultValue: 0,
      );
      if (skip != tipVersion) {
        if (!context.mounted) return;
        final ok = await showConfirmDialogs(
          context,
          S.current.home_action_title_star_citizen_website_localization,
          Text(
            S.current.home_action_info_web_localization_plugin_disclaimer,
            style: const TextStyle(fontSize: 16),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .6,
          ),
        );
        if (!ok) {
          if (loginMode) {
            rsiLoginCallback?.call(null, false);
          }
          return;
        }
        await box.put("skip_web_localization_tip_version", tipVersion);
      }
    }
    // Rust WebView using wry + tao - no WebView2 runtime check needed as wry handles it internally
    if (!context.mounted) return;
    final webViewModel = WebViewModel(
      context,
      loginMode: loginMode,
      loginCallback: rsiLoginCallback,
      loginChannel: loginChannel,
    );
    if (useLocalization) {
      state = state.copyWith(
        isFixing: true,
        isFixingString: S.current.home_action_info_initializing_resources,
      );
      try {
        await webViewModel.initLocalization(state.webLocalizationVersionsData!);
      } catch (e) {
        if (!context.mounted) return;
        showToast(context, S.current.home_action_info_initialization_failed(e));
      }
      state = state.copyWith(isFixingString: "", isFixing: false);
    }
    await webViewModel.initWebView(
      title: title,
      applicationSupportDir: appGlobalState.applicationSupportDir!,
      appVersionData: appGlobalState.networkVersionData!,
    );

    await Future.delayed(const Duration(milliseconds: 500));
    await webViewModel.launch(url, appGlobalState.networkVersionData!);
  }

  bool isRSIServerStatusOK(Map map) {
    return (map["status"] == "ok" || map["status"] == "operational");
  }

  Timer? _serverUpdateTimer;
  Timer? _appUpdateTimer;

  void _init() {
    reScanPath();
    _serverUpdateTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _updateSCServerStatus();
    });

    _appUpdateTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      checkLocalizationUpdate();
    });

    ref.onDispose(() {
      _serverUpdateTimer?.cancel();
      _serverUpdateTimer = null;
      _appUpdateTimer?.cancel();
      _appUpdateTimer = null;
    });
  }

  void _loadData() async {
    if (appGlobalState.networkVersionData == null) return;
    try {
      final r = await Api.getAppPlacard();
      final box = await Hive.openBox("app_conf");
      final version = box.get("close_placard", defaultValue: "");
      if (r.enable == true) {
        if (r.alwaysShow != true && version == r.version) {
        } else {
          state = state.copyWith(appPlacardData: r);
        }
      }

      final appWebLocalizationVersionsData =
          AppWebLocalizationVersionsData.fromJson(
            json.decode(
              (await RSHttp.getText(
                "${URLConf.webTranslateHomeUrl}/versions.json",
              )),
            ),
          );
      final countdownFestivalListData = await Api.getFestivalCountdownList();
      state = state.copyWith(
        webLocalizationVersionsData: appWebLocalizationVersionsData,
        countdownFestivalListData: _fixFestivalCountdownListDateTime(
          countdownFestivalListData,
        ),
      );
      _updateSCServerStatus();
      _loadNews();
    } catch (e) {
      dPrint(e);
    }
    // check Localization update
    checkLocalizationUpdate();
  }

  /// 节日已过7天时，更新为下一年的时间
  List<CountdownFestivalItemData> _fixFestivalCountdownListDateTime(
    List<CountdownFestivalItemData> list,
  ) {
    final now = DateTime.now();

    final fixedList = list.map((item) {
      if (item.time == null) return item;
      final itemDateTime = DateTime.fromMillisecondsSinceEpoch(item.time!);

      // 计算今年的节日日期
      final thisYearDate = DateTime(
        now.year,
        itemDateTime.month,
        itemDateTime.day,
        itemDateTime.hour,
        itemDateTime.minute,
        itemDateTime.second,
      );

      // 如果今年的节日日期 + 7天已经过了，使用明年的日期
      final thisYearDatePlusSeven = thisYearDate.add(const Duration(days: 7));
      if (thisYearDatePlusSeven.isBefore(now)) {
        final nextYearDate = DateTime(
          now.year + 1,
          itemDateTime.month,
          itemDateTime.day,
          itemDateTime.hour,
          itemDateTime.minute,
          itemDateTime.second,
        );
        final newTimestamp = (nextYearDate.millisecondsSinceEpoch).round();
        return CountdownFestivalItemData(
          name: item.name,
          time: newTimestamp,
          icon: item.icon,
        );
      }

      // 否则使用今年的日期
      final newTimestamp = (thisYearDate.millisecondsSinceEpoch).round();
      return CountdownFestivalItemData(
        name: item.name,
        time: newTimestamp,
        icon: item.icon,
      );
    }).toList();

    // Sort by time (ascending order - nearest festival first)
    fixedList.sort((a, b) {
      if (a.time == null && b.time == null) return 0;
      if (a.time == null) return 1;
      if (b.time == null) return -1;
      return a.time!.compareTo(b.time!);
    });

    return fixedList;
  }

  Future<void> _updateSCServerStatus() async {
    try {
      final s = await Api.getScServerStatus();
      dPrint("updateSCServerStatus===$s");
      state = state.copyWith(scServerStatus: s);
    } catch (e) {
      dPrint(e);
    }
  }

  Future _loadNews() async {
    final news = await NewsApi.getLatest();
    state = state.copyWith(citizenNewsData: news ?? CitizenNewsData());
  }

  Future<void> checkLocalizationUpdate({bool skipReload = false}) async {
    dPrint("_checkLocalizationUpdate");
    final updates = await (ref.read(
      localizationUIModelProvider.notifier,
    )).checkLangUpdate(skipReload: skipReload).unwrap<List<String>>();
    if (updates == null || updates.isEmpty) {
      state = state.copyWith(localizationUpdateInfo: null);
    } else {
      state = state.copyWith(
        localizationUpdateInfo: MapEntry(updates.first, true),
      );
      if (_appUpdateTimer != null) {
        _appUpdateTimer?.cancel();
        _appUpdateTimer = null;
        // 发送通知
        await win32.sendNotify(
          summary: S.current.home_localization_new_version_available,
          body: S.current.home_localization_new_version_installed(
            updates.first,
          ),
          appName: S.current.home_title_app_name,
          appId: ConstConf.win32AppId,
        );
      }
    }

    // 检查拓展更新
    final extUpdates = await (ref.read(
      localizationUIModelProvider.notifier,
    )).checkLocalizationExtensionUpdate();

    if (extUpdates.isNotEmpty) {
      await (ref.read(
        localizationUIModelProvider.notifier,
      )).sendExtensionUpdateNotification(extUpdates);
    }
  }

  // ignore: avoid_build_context_in_providers
  Future<void> launchRSI(BuildContext context) async {
    if (state.scInstalledPath == "not_install") {
      showToast(context, S.current.home_info_valid_installation_required);
      return;
    }

    if (ConstConf.isMSE) {
      if (state.isCurGameRunning) {
        await win32.killProcessByName(processName: "StarCitizen");
        return;
      }
      AnalyticsApi.touch("gameLaunch");
      showDialog(
        context: context,
        dismissWithEsc: false,
        builder: (context) => HomeGameLoginDialogUI(context),
      );
    } else {
      final ok = await showConfirmDialogs(
        context,
        S.current.home_info_one_click_launch_warning,
        Text(S.current.home_info_account_security_warning),
        confirm: S.current.home_action_install_microsoft_store_version,
        cancel: S.current.home_action_cancel,
      );
      if (ok == true) {
        await launchUrlString(
          "https://apps.microsoft.com/detail/9NF3SWFWNKL1?launch=true",
        );
        await Future.delayed(const Duration(seconds: 2));
        exit(0);
      }
    }
  }

  // ignore: avoid_build_context_in_providers
  Future<void> openP4kUpdater(BuildContext context) async {
    final installPath = await _resolveP4kInstallPath(context);
    if (installPath == null) return;
    if (!context.mounted) return;
    final pathError = _p4kInstallPathError(installPath);
    if (pathError != null) {
      showToast(context, pathError);
      return;
    }
    if (state.isCurGameRunning) {
      showToast(
        context,
        S.current.app_please_close_the_game_before_updating_p4k_game_files,
      );
      return;
    }
    if (appGlobalState.networkVersionData == null ||
        appGlobalState.applicationSupportDir == null) {
      showToast(
        context,
        S.current.app_common_network_error(
          ConstConf.appVersionDate,
          "networkVersionData is null",
        ),
      );
      return;
    }
    if (state.webLocalizationVersionsData == null) {
      showToast(
        context,
        S
            .current
            .app_the_web_login_resource_has_not_been_initialized_please_try_again,
      );
      return;
    }

    await goWebView(
      context,
      S.current.home_action_login_rsi_account,
      "https://robertsspaceindustries.com/en/connect?jumpto=/account/dashboard",
      loginMode: true,
      useLocalization: true,
      loginChannel: _getChannelID(installPath),
      rsiLoginCallback: (message, ok) async {
        if (message == null || !ok) {
          return;
        }
        final data = message["data"];
        final releaseInfo = data is Map ? data["releaseInfo"] : null;
        final webToken = data is Map ? data["webToken"]?.toString() ?? "" : "";
        final webCookie = data is Map
            ? data["webCookie"]?.toString() ?? ""
            : "";
        final webViewCookies = data is Map
            ? data["webViewCookies"]?.toString() ?? ""
            : "";
        if (releaseInfo is! Map) {
          if (!context.mounted) return;
          showToast(
            context,
            S.current.app_unable_to_read_releaseinfo_from_rsi_return_data,
          );
          return;
        }
        if (!context.mounted) return;
        final updated = await showDialog<bool>(
          context: context,
          dismissWithEsc: false,
          builder: (_) => HomeP4kUpdateDialogUI(
            releaseInfo: releaseInfo,
            installPath: installPath,
            applicationSupportDir: appGlobalState.applicationSupportDir!,
            webToken: webToken,
            webCookie: _mergeCookieHeaders([webCookie, webViewCookies]),
          ),
        );
        if (updated == true) {
          await reScanPath();
        }
      },
    );
  }

  Future<String?> _resolveP4kInstallPath(BuildContext context) async {
    final current = state.scInstalledPath;
    final currentValid = current != null && current != "not_install";
    if (currentValid &&
        await File("$current\\Data.p4k".platformPath).exists()) {
      final pathError = _p4kInstallPathError(current);
      if (pathError == null) {
        return current;
      }
      if (context.mounted) showToast(context, pathError);
    }

    final candidates = await _loadIncompleteInstallPaths();
    if (currentValid &&
        _p4kInstallPathError(current) == null &&
        !candidates.any((p) => p.toLowerCase() == current.toLowerCase())) {
      candidates.insert(0, current);
    }
    if (!context.mounted) return null;
    final selected = await showDialog<String>(
      context: context,
      dismissWithEsc: true,
      builder: (_) => _P4kInstallPathDialog(initialPaths: candidates),
    );
    if (selected != null) {
      state = state.copyWith(scInstalledPath: selected);
    }
    return selected;
  }

  Future<List<String>> _loadIncompleteInstallPaths() async {
    final paths = <String>[];
    void addPath(String? path) {
      if (path == null || path.isEmpty || path == "not_install") return;
      final normalized = path.platformPath;
      if (_p4kInstallPathError(normalized) != null) return;
      if (!paths.any((p) => p.toLowerCase() == normalized.toLowerCase())) {
        paths.add(normalized);
      }
    }

    for (final path in state.scInstallPaths) {
      addPath(path);
    }
    final listData = await SCLoggerHelper.getLauncherLogList();
    if (listData != null) {
      final detected = await SCLoggerHelper.getGameInstallPath(
        listData,
        withVersion: AppConf.gameChannels,
        checkExists: false,
      );
      for (final path in detected) {
        addPath(path);
      }
    }
    return paths;
  }

  String _mergeCookieHeaders(List<String> headers) {
    final values = <String, String>{};
    for (final header in headers) {
      for (final part in header.split(';')) {
        final trimmed = part.trim();
        final eq = trimmed.indexOf('=');
        if (eq <= 0) continue;
        values[trimmed.substring(0, eq)] = trimmed.substring(eq + 1);
      }
    }
    return values.entries
        .map((entry) => "${entry.key}=${entry.value}")
        .join('; ');
  }

  String _getChannelID(String installPath) {
    final pathLower = installPath.platformPath.toLowerCase();
    if (pathLower.endsWith('\\live'.platformPath)) {
      return "LIVE";
    }
    return installPath.platformPath.split('\\'.platformPath).last.toUpperCase();
  }

  void onChangeInstallPath(String? value) {
    if (value == null) return;
    state = state.copyWith(scInstalledPath: value);
    ref
        .read(localizationUIModelProvider.notifier)
        .onChangeGameInstallPath(value);
  }

  Future<void> doLaunchGame(
    // ignore: avoid_build_context_in_providers
    BuildContext context,
    String launchExe,
    List<String> args,
    String installPath,
    String? processorAffinity,
  ) async {
    var runningMap = Map<String, bool>.from(state.isGameRunning);
    runningMap[installPath] = true;
    state = state.copyWith(isGameRunning: runningMap);
    try {
      late ProcessResult result;
      if (processorAffinity == null) {
        result = await Process.run(launchExe, args);
      } else {
        dPrint("set Affinity === $processorAffinity launchExe === $launchExe");
        result = await Process.run("cmd.exe", [
          '/C',
          'Start',
          '"StarCitizen"',
          '/High',
          '/Affinity',
          processorAffinity,
          launchExe,
          ...args,
        ]);
      }
      dPrint('Exit code: ${result.exitCode}');
      dPrint('stdout: ${result.stdout}');
      dPrint('stderr: ${result.stderr}');

      if (result.exitCode != 0) {
        final logs = await SCLoggerHelper.getGameRunningLogs(installPath);
        MapEntry<String, String>? exitInfo;
        bool hasUrl = false;
        if (logs != null) {
          exitInfo = SCLoggerHelper.getGameRunningLogInfo(logs);
          if (exitInfo!.value.startsWith("https://")) {
            hasUrl = true;
          }
        }
        if (!context.mounted) return;
        // showToast(context,
        //     "游戏非正常退出\nexitCode=${result.exitCode}\nstdout=${result.stdout ?? ""}\nstderr=${result.stderr ?? ""}\n\n诊断信息：${exitInfo == null ? "未知错误，请通过一键诊断加群反馈。" : exitInfo.key} \n${hasUrl ? "请查看弹出的网页链接获得详细信息。" : exitInfo?.value ?? ""}");
        // S.current.home_action_info_abnormal_game_exit
        showToast(
          context,
          S.current.home_action_info_abnormal_game_exit(
            result.exitCode.toString(),
            result.stdout ?? "",
            result.stderr ?? "",
            exitInfo == null
                ? S.current.home_action_info_unknown_error
                : exitInfo.key,
            hasUrl
                ? S.current.home_action_info_check_web_link
                : exitInfo?.value ?? "",
          ),
        );
        if (hasUrl) {
          await Future.delayed(const Duration(seconds: 3));
          launchUrlString(exitInfo!.value);
        }
      }

      final launchFile = File("$installPath\\loginData.json");
      if (await launchFile.exists()) {
        await launchFile.delete();
      }
    } catch (_) {}
    runningMap = Map<String, bool>.from(state.isGameRunning);
    runningMap[installPath] = false;
    state = state.copyWith(isGameRunning: runningMap);
  }
}

String get _p4kLiveOnlyMessage => S
    .current
    .p4k_update_p4k_download_update_does_not_currently_support_ptu_the_target_pa;

String? _p4kInstallPathError(String path) {
  final normalized = path.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '');
  if (normalized.isEmpty) return _p4kLiveOnlyMessage;
  return normalized.split('/').last.toUpperCase() == 'LIVE'
      ? null
      : _p4kLiveOnlyMessage;
}

class _P4kInstallPathDialog extends StatefulWidget {
  const _P4kInstallPathDialog({required this.initialPaths});

  final List<String> initialPaths;

  @override
  State<_P4kInstallPathDialog> createState() => _P4kInstallPathDialogState();
}

class _P4kInstallPathDialogState extends State<_P4kInstallPathDialog> {
  late final List<String> _paths = [...widget.initialPaths];
  String? _selectedPath;

  @override
  void initState() {
    super.initState();
    _selectedPath = _paths.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(S.current.app_select_game_download_directory),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S
                .current
                .app_there_is_currently_no_data_p4k_available_out_of_the_box_please_s,
          ),
          const SizedBox(height: 12),
          if (_paths.isNotEmpty) ...[
            Text(S.current.app_discovered_installation_directories),
            const SizedBox(height: 6),
            ComboBox<String>(
              value: _selectedPath,
              isExpanded: true,
              items: [
                for (final path in _paths)
                  ComboBoxItem(value: path, child: Text(path)),
              ],
              onChanged: (value) => setState(() => _selectedPath = value),
            ),
            const SizedBox(height: 12),
          ],
          Button(
            child: Text(S.current.app_select_new_directory),
            onPressed: () async {
              final selected = await FilePicker.getDirectoryPath(
                dialogTitle: S.current.app_select_game_download_directory,
                initialDirectory: _selectedPath,
                lockParentWindow: true,
              );
              if (selected == null || !mounted) return;
              final normalized = selected.platformPath;
              final pathError = _p4kInstallPathError(normalized);
              if (pathError != null) {
                if (!context.mounted) return;
                showToast(context, pathError);
                return;
              }
              setState(() {
                if (!_paths.any(
                  (path) => path.toLowerCase() == normalized.toLowerCase(),
                )) {
                  _paths.insert(0, normalized);
                }
                _selectedPath = normalized;
              });
            },
          ),
        ],
      ),
      actions: [
        Button(
          child: Text(S.current.app_common_tip_cancel),
          onPressed: () => Navigator.pop(context),
        ),
        FilledButton(
          onPressed: _selectedPath == null || _selectedPath!.trim().isEmpty
              ? null
              : () {
                  final selected = _selectedPath!;
                  final pathError = _p4kInstallPathError(selected);
                  if (pathError != null) {
                    showToast(context, pathError);
                    return;
                  }
                  Navigator.pop(context, selected);
                },
          child: Text(S.current.app_splash_free_software_notice_confirm),
        ),
      ],
    );
  }
}
