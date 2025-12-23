import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/rust/api/asar_api.dart' as asar_api;
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/generated/no_l10n_strings.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

part 'rsi_launcher_enhance_dialog_ui.freezed.dart';

@freezed
abstract class RSILauncherStateData with _$RSILauncherStateData {
  const factory RSILauncherStateData({
    required String version,
    required asar_api.RsiLauncherAsarData data,
    required String serverData,
    @Default(false) bool isPatchInstalled,
    String? enabledLocalization,
    bool? enableDownloaderBoost,
  }) = _RSILauncherStateData;
}

class RsiLauncherEnhanceDialogUI extends HookConsumerWidget {
  final bool showNotGameInstallMsg;

  const RsiLauncherEnhanceDialogUI({super.key, this.showNotGameInstallMsg = false});

  static const supportLocalizationMap = {
    "en": NoL10n.langEn,
    NoL10n.langCodeZhCn: NoL10n.langZHS,
    "zh_TW": NoL10n.langZHT,
    "fr": NoL10n.langFR,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workingText = useState("");

    final assarState = useState<RSILauncherStateData?>(null);

    final expandEnhance = useState(false);

    Future<void> readState() async {
      workingText.value = S.current.tools_rsi_launcher_enhance_init_msg1;
      assarState.value = await _readState(context).unwrap(context: context);
      if (assarState.value == null) {
        workingText.value = "";
        return;
      }
      workingText.value = S.current.tools_rsi_launcher_enhance_init_msg2;
      if (!context.mounted) return;
      await _loadEnhanceData(context, ref, assarState).unwrap(context: context).unwrap(context: context);
      workingText.value = "";
    }

    void doInstall() async {
      if (!context.mounted) return;
      workingText.value = S.current.tools_rsi_launcher_enhance_working_msg1;
      if ((await SystemHelper.getPID("RSI Launcher")).isNotEmpty) {
        if (!context.mounted) return;
        showToast(
          context,
          S.current.tools_action_info_rsi_launcher_running_warning,
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .35),
        );
        workingText.value = "";
        return;
      }
      if (!context.mounted) return;
      final newScript = await _genNewScript(assarState).unwrap(context: context);
      workingText.value = S.current.tools_rsi_launcher_enhance_working_msg2;
      if (!context.mounted) return;
      await assarState.value?.data.writeMainJs(content: utf8.encode(newScript)).unwrap(context: context);
      AnalyticsApi.touch("rsi_launcher_mod_apply");
      await readState();
    }

    useEffect(() {
      AnalyticsApi.touch("rsi_launcher_mod_launch");
      readState();
      return null;
    }, const []);

    return ContentDialog(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .48),
      title: Row(
        children: [
          IconButton(
            icon: const Icon(FluentIcons.back, size: 22),
            onPressed: workingText.value.isEmpty ? Navigator.of(context).pop : null,
          ),
          const SizedBox(width: 12),
          Text(S.current.tools_rsi_launcher_enhance_title),
        ],
      ),
      content: AnimatedSize(
        duration: const Duration(milliseconds: 130),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showNotGameInstallMsg) ...[
              InfoBar(
                title: const SizedBox(),
                content: Text(S.current.home_localization_action_rsi_launcher_no_game_path_msg),
                style: InfoBarThemeData(
                  decoration: (severity) {
                    return BoxDecoration(color: Colors.orange);
                  },
                  iconColor: (severity) {
                    return Colors.white;
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (workingText.value.isNotEmpty) ...[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(),
                    const SizedBox(height: 12),
                    const ProgressRing(),
                    const SizedBox(height: 12),
                    Text(workingText.value),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.tools_rsi_launcher_enhance_msg_version(assarState.value?.version ?? ""),
                      style: TextStyle(color: Colors.white.withValues(alpha: .6)),
                    ),
                  ),
                  Text(
                    S.current.tools_rsi_launcher_enhance_msg_patch_status(
                      (assarState.value?.isPatchInstalled ?? false)
                          ? S.current.localization_info_installed
                          : S.current.tools_action_info_not_installed,
                    ),
                    style: TextStyle(color: Colors.white.withValues(alpha: .6)),
                  ),
                ],
              ),
              if (assarState.value?.serverData.isEmpty ?? true) ...[
                Text(S.current.tools_rsi_launcher_enhance_msg_error),
              ] else ...[
                const SizedBox(height: 24),
                if (assarState.value?.enabledLocalization != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.current.tools_rsi_launcher_enhance_title_localization),
                              const SizedBox(height: 3),
                              Text(
                                S.current.tools_rsi_launcher_enhance_subtitle_localization,
                                style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .6)),
                              ),
                            ],
                          ),
                        ),
                        ComboBox(
                          items: [
                            for (final key in supportLocalizationMap.keys)
                              ComboBoxItem(value: key, child: Text(supportLocalizationMap[key]!)),
                          ],
                          value: assarState.value?.enabledLocalization,
                          onChanged: (v) {
                            assarState.value = assarState.value!.copyWith(enabledLocalization: v);
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 3),
                if (assarState.value?.enableDownloaderBoost != null) ...[
                  IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 3),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(expandEnhance.value ? FluentIcons.chevron_up : FluentIcons.chevron_down),
                                  const SizedBox(width: 12),
                                  Text(
                                    expandEnhance.value
                                        ? S.current.tools_rsi_launcher_enhance_action_fold
                                        : S.current.tools_rsi_launcher_enhance_action_expand,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      if (!expandEnhance.value) {
                        final userOK = await showConfirmDialogs(
                          context,
                          S.current.tools_rsi_launcher_enhance_note_title,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [Text(S.current.tools_rsi_launcher_enhance_note_msg)],
                          ),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .55),
                        );
                        if (!userOK) return;
                      }
                      expandEnhance.value = !expandEnhance.value;
                    },
                  ),
                  if (expandEnhance.value)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.current.tools_rsi_launcher_enhance_title_download_booster),
                                const SizedBox(height: 3),
                                Text(
                                  S.current.tools_rsi_launcher_enhance_subtitle_download_booster,
                                  style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .6)),
                                ),
                              ],
                            ),
                          ),
                          ToggleSwitch(
                            onChanged: (value) {
                              assarState.value = assarState.value?.copyWith(enableDownloaderBoost: value);
                            },
                            checked: assarState.value?.enableDownloaderBoost ?? false,
                          ),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 12),
                Center(
                  child: FilledButton(
                    onPressed: doInstall,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      child: Text(S.current.tools_rsi_launcher_enhance_action_install),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                S.current.tools_rsi_launcher_enhance_msg_uninstall,
                style: TextStyle(color: Colors.white.withValues(alpha: .6), fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<RSILauncherStateData?> _readState(BuildContext context) async {
    final lPath = await SystemHelper.getRSILauncherPath(skipEXE: true);
    if (lPath.isEmpty) {
      if (!context.mounted) return null;
      showToast(context, S.current.tools_rsi_launcher_enhance_msg_error_launcher_notfound);
      return null;
    }
    dPrint("[RsiLauncherEnhanceDialogUI] rsiLauncherPath ==== $lPath");
    final dataPath = "${lPath}resources\\app.asar".platformPath;
    dPrint("[RsiLauncherEnhanceDialogUI] rsiLauncherDataPath ==== $dataPath");
    try {
      final data = await asar_api.getRsiLauncherAsarData(asarPath: dataPath);
      dPrint("[RsiLauncherEnhanceDialogUI] rsiLauncherPath main.js path == ${data.mainJsPath}");
      final version = RegExp(r"main\.(\w+)\.js").firstMatch(data.mainJsPath)?.group(1);
      if (version == null) {
        if (!context.mounted) return null;
        showToast(context, S.current.tools_rsi_launcher_enhance_msg_error_get_launcher_info_error);
        return null;
      }
      dPrint("[RsiLauncherEnhanceDialogUI] rsiLauncherPath main.js version == $version");

      final mainJsString = String.fromCharCodes(data.mainJsContent);

      final (enabledLocalization, enableDownloaderBoost) = _readScriptState(mainJsString);

      return RSILauncherStateData(
        version: version,
        data: data,
        serverData: "",
        isPatchInstalled: mainJsString.contains("SC_TOOLBOX"),
        enabledLocalization: enabledLocalization,
        enableDownloaderBoost: enableDownloaderBoost,
      );
    } catch (e) {
      if (!context.mounted) return null;
      showToast(context, S.current.tools_rsi_launcher_enhance_msg_error_get_launcher_info_error_with_args(e));
      return null;
    }
  }

  Future<String> _loadEnhanceData(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<RSILauncherStateData?> assarState,
  ) async {
    final globalModel = ref.read(appGlobalModelProvider);
    final enhancePath = "${globalModel.applicationSupportDir}/launcher_enhance_data";

    /// For debug
    final debugFile = File("$enhancePath/main.js");
    if (await debugFile.exists()) {
      final debugContent = await debugFile.readAsString();
      await _loadDebugData(debugContent, assarState);
      return debugContent;
    }
    final enhanceFile = File("$enhancePath/${assarState.value?.version}.tar.gz");
    if (!await enhanceFile.exists()) {
      final downloadUrl = "${URLConf.gitApiRSILauncherEnhanceUrl}/archive/${assarState.value?.version}.tar.gz";
      final r = await RSHttp.get(downloadUrl).unwrap();
      if (r.statusCode != 200 || r.data == null) {
        return "";
      }
      await enhanceFile.create(recursive: true);
      await enhanceFile.writeAsBytes(r.data!, flush: true);
    }
    final severMainJS = await compute(_readArchive, (enhanceFile.path, "main.js"));
    final serverMainJSString = severMainJS.toString();
    final scriptState = _readScriptState(serverMainJSString);
    if (assarState.value?.enabledLocalization == null) {
      assarState.value = assarState.value?.copyWith(enabledLocalization: scriptState.$1);
      dPrint("[RsiLauncherEnhanceDialogUI] _loadEnhanceData enabledLocalization == ${scriptState.$1}");
    }
    if (assarState.value?.enableDownloaderBoost == null) {
      assarState.value = assarState.value?.copyWith(enableDownloaderBoost: scriptState.$2);
      dPrint("[RsiLauncherEnhanceDialogUI] _loadEnhanceData enableDownloaderBoost == ${scriptState.$2}");
    }
    assarState.value = assarState.value?.copyWith(serverData: serverMainJSString);
    return serverMainJSString;
  }

  static StringBuffer _readArchive((String savePath, String fileName) data) {
    final inputStream = InputFileStream(data.$1);
    final output = GZipDecoder().decodeBytes(inputStream.toUint8List());
    final archive = TarDecoder().decodeBytes(output);
    StringBuffer dataBuffer = StringBuffer("");
    for (var element in archive.files) {
      if (element.rawContent == null) continue;
      final stringContent = utf8.decode(element.rawContent!.readBytes());
      if (element.name.endsWith(data.$2)) {
        for (var value in (stringContent).split("\n")) {
          final tv = value;
          if (tv.isNotEmpty) dataBuffer.writeln(tv);
        }
      }
    }
    archive.clear();
    return dataBuffer;
  }

  // ignore: constant_identifier_names
  static const SC_TOOLBOX_ENABLED_LOCALIZATION_SCRIPT_START = "const SC_TOOLBOX_ENABLED_LOCALIZATION = ";

  // ignore: constant_identifier_names
  static const SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START = "const SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST = ";

  (String?, bool?) _readScriptState(String mainJsString) {
    String? enabledLocalization;
    bool? enableDownloaderBoost;
    for (final line in mainJsString.split("\n")) {
      final lineTrim = line.trim();
      if (lineTrim.startsWith(SC_TOOLBOX_ENABLED_LOCALIZATION_SCRIPT_START)) {
        enabledLocalization = lineTrim
            .substring(SC_TOOLBOX_ENABLED_LOCALIZATION_SCRIPT_START.length)
            .replaceAll("\"", "")
            .replaceAll(";", "");
      } else if (lineTrim.startsWith(SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START)) {
        enableDownloaderBoost =
            lineTrim.substring(SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START.length).toLowerCase() == "true;";
      }
    }
    return (enabledLocalization, enableDownloaderBoost);
  }

  Future<String> _genNewScript(ValueNotifier<RSILauncherStateData?> assarState) async {
    final serverScriptLines = assarState.value!.serverData.split("\n");
    final StringBuffer scriptBuffer = StringBuffer("");
    for (final line in serverScriptLines) {
      final lineTrim = line.trim();
      if (lineTrim.startsWith(SC_TOOLBOX_ENABLED_LOCALIZATION_SCRIPT_START)) {
        scriptBuffer.writeln(
          "$SC_TOOLBOX_ENABLED_LOCALIZATION_SCRIPT_START\"${assarState.value!.enabledLocalization}\";",
        );
      } else if (lineTrim.startsWith(SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START)) {
        scriptBuffer.writeln(
          "$SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START${assarState.value!.enableDownloaderBoost};",
        );
      } else {
        scriptBuffer.writeln(line);
      }
    }
    return scriptBuffer.toString();
  }

  Future<void> _loadDebugData(String debugContent, ValueNotifier<RSILauncherStateData?> assarState) async {
    assarState.value = assarState.value?.copyWith(serverData: debugContent);
    dPrint("[RsiLauncherEnhanceDialogUI] _loadEnhanceData from debug file");
    final scriptState = _readScriptState(debugContent);
    if (assarState.value?.enabledLocalization == null) {
      assarState.value = assarState.value?.copyWith(enabledLocalization: scriptState.$1);
      dPrint("[RsiLauncherEnhanceDialogUI] _loadEnhanceData enabledLocalization == ${scriptState.$1}");
    }
    if (assarState.value?.enableDownloaderBoost == null) {
      assarState.value = assarState.value?.copyWith(enableDownloaderBoost: scriptState.$2);
      dPrint("[RsiLauncherEnhanceDialogUI] _loadEnhanceData enableDownloaderBoost == ${scriptState.$2}");
    }
    assarState.value = assarState.value?.copyWith(serverData: debugContent);
  }
}
