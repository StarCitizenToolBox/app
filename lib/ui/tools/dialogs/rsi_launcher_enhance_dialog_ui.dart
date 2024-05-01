import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
class RSILauncherStateData with _$RSILauncherStateData {
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
  const RsiLauncherEnhanceDialogUI({super.key});

  static const supportLocalizationMap = {
    "en": NoL10n.langEn,
    "zh_CN": NoL10n.langZHS,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workingText = useState("");

    final assarState = useState<RSILauncherStateData?>(null);

    Future<void> readState() async {
      workingText.value = "读取启动器信息...";
      assarState.value = await _readState(context).unwrap(context: context);
      if (assarState.value == null) {
        workingText.value = "";
        return;
      }
      workingText.value = "正在从网络获取增强数据...";
      if (!context.mounted) return;
      await _loadEnhanceData(context, ref, assarState)
          .unwrap(context: context)
          .unwrap(context: context);
      workingText.value = "";
    }

    void doInstall() async {
      workingText.value = "生成补丁 ...";
      final newScript =
          await _genNewScript(assarState).unwrap(context: context);
      workingText.value = "安装补丁，这需要一点时间，取决于您的计算机性能 ...";
      if (!context.mounted) return;
      await assarState.value?.data
          .writeMainJs(content: utf8.encode(newScript))
          .unwrap(context: context);
      await readState();
    }

    useEffect(() {
      readState();
      return null;
    }, const []);

    return ContentDialog(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .48),
      title: Row(children: [
        IconButton(
            icon: const Icon(
              FluentIcons.back,
              size: 22,
            ),
            onPressed:
                workingText.value.isEmpty ? Navigator.of(context).pop : null),
        const SizedBox(width: 12),
        const Text("RSI 启动器增强"),
      ]),
      content: AnimatedSize(
        duration: const Duration(milliseconds: 130),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      "启动器内部版本信息：${assarState.value?.version}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.6),
                      ),
                    ),
                  ),
                  Text(
                    "补丁状态：${(assarState.value?.isPatchInstalled ?? false) ? "已安装" : "未安装"}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.6),
                    ),
                  )
                ],
              ),
              if (assarState.value?.serverData.isEmpty ?? true) ...[
                const Text("获取增强数据失败，可能是网络问题或当前版本不支持"),
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
                              const Text("RSI 启动器本地化"),
                              const SizedBox(height: 3),
                              Text(
                                "为 RSI 启动器增加多语言支持。",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(.6),
                                ),
                              ),
                            ],
                          )),
                          ComboBox(
                            items: [
                              for (final key in supportLocalizationMap.keys)
                                ComboBoxItem(
                                    value: key,
                                    child: Text(supportLocalizationMap[key]!))
                            ],
                            value: assarState.value?.enabledLocalization,
                            onChanged: (v) {
                              assarState.value = assarState.value!
                                  .copyWith(enabledLocalization: v);
                            },
                          ),
                        ],
                      )),
                const SizedBox(height: 3),
                if (assarState.value?.enableDownloaderBoost != null)
                  Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("RSI 启动器下载增强"),
                            const SizedBox(height: 3),
                            Text(
                              "下载游戏时可使用更多线程以提升下载速度，启用后请在启动器设置修改线程数。",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(.6),
                              ),
                            ),
                          ],
                        )),
                        ToggleSwitch(
                          onChanged: (value) {
                            assarState.value = assarState.value
                                ?.copyWith(enableDownloaderBoost: value);
                          },
                          checked:
                              assarState.value?.enableDownloaderBoost ?? false,
                        )
                      ])),
                const SizedBox(height: 12),
                Center(
                    child: FilledButton(
                        onPressed: doInstall,
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          child: Text("安装增强补丁"),
                        ))),
              ],
              const SizedBox(height: 16),
              Text(
                "* 如需卸载增强补丁，请覆盖安装 RSI 启动器。",
                style: TextStyle(
                    color: Colors.white.withOpacity(.6), fontSize: 13),
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
      showToast(context, "未找到 RSI 启动器");
      return null;
    }
    dPrint("[RsiLauncherEnhanceDialogUI] rsiLauncherPath ==== $lPath");
    final dataPath = "${lPath}resources\\app.asar";
    dPrint("[RsiLauncherEnhanceDialogUI] rsiLauncherDataPath ==== $dataPath");
    try {
      final data = await asar_api.getRsiLauncherAsarData(asarPath: dataPath);
      dPrint(
          "[RsiLauncherEnhanceDialogUI] rsiLauncherPath main.js path == ${data.mainJsPath}");
      final version =
          RegExp(r"main\.(\w+)\.js").firstMatch(data.mainJsPath)?.group(1);
      if (version == null) {
        if (!context.mounted) return null;
        showToast(context, "读取启动器信息失败！");
        return null;
      }
      dPrint(
          "[RsiLauncherEnhanceDialogUI] rsiLauncherPath main.js version == $version");

      final mainJsString = String.fromCharCodes(data.mainJsContent);

      final (enabledLocalization, enableDownloaderBoost) =
          _readScriptState(mainJsString);

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
      showToast(context, "读取启动器信息失败：$e");
      return null;
    }
  }

  Future<String> _loadEnhanceData(BuildContext context, WidgetRef ref,
      ValueNotifier<RSILauncherStateData?> assarState) async {
    final globalModel = ref.read(appGlobalModelProvider);
    final enhancePath =
        "${globalModel.applicationSupportDir}/launcher_enhance_data";
    final enhanceFile =
        File("$enhancePath/${assarState.value?.version}.tar.gz");
    if (!await enhanceFile.exists()) {
      final downloadUrl =
          "${URLConf.gitApiRSILauncherEnhanceUrl}/archive/${assarState.value?.version}.tar.gz";
      final r = await RSHttp.get(downloadUrl).unwrap();
      if (r.statusCode != 200 || r.data == null) {
        return "";
      }
      await enhanceFile.create(recursive: true);
      await enhanceFile.writeAsBytes(r.data!, flush: true);
    }
    final severMainJS =
        await compute(_readArchive, (enhanceFile.path, "main.js"));
    final serverMainJSString = severMainJS.toString();
    final scriptState = _readScriptState(serverMainJSString);
    if (assarState.value?.enabledLocalization == null) {
      assarState.value =
          assarState.value?.copyWith(enabledLocalization: scriptState.$1);
      dPrint(
          "[RsiLauncherEnhanceDialogUI] _loadEnhanceData enabledLocalization == ${scriptState.$1}");
    }
    if (assarState.value?.enableDownloaderBoost == null) {
      assarState.value =
          assarState.value?.copyWith(enableDownloaderBoost: scriptState.$2);
      dPrint(
          "[RsiLauncherEnhanceDialogUI] _loadEnhanceData enableDownloaderBoost == ${scriptState.$2}");
    }
    assarState.value =
        assarState.value?.copyWith(serverData: serverMainJSString);
    return serverMainJSString;
  }

  static StringBuffer _readArchive((String savePath, String fileName) data) {
    final inputStream = InputFileStream(data.$1);
    final archive =
        TarDecoder().decodeBytes(GZipDecoder().decodeBuffer(inputStream));
    StringBuffer dataBuffer = StringBuffer("");
    for (var element in archive.files) {
      if (element.name.endsWith(data.$2)) {
        for (var value
            in (element.rawContent?.readString() ?? "").split("\n")) {
          final tv = value;
          if (tv.isNotEmpty) dataBuffer.writeln(tv);
        }
      }
    }
    archive.clear();
    return dataBuffer;
  }

  // ignore: constant_identifier_names
  static const SC_TOOLBOX_ENABLED_LOCALIZATION_SCRIPT_START =
      "const SC_TOOLBOX_ENABLED_LOCALIZATION = ";

  // ignore: constant_identifier_names
  static const SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START =
      "const SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST = ";

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
      } else if (lineTrim
          .startsWith(SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START)) {
        enableDownloaderBoost = lineTrim
                .substring(
                    SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START.length)
                .toLowerCase() ==
            "true;";
      }
    }
    return (enabledLocalization, enableDownloaderBoost);
  }

  Future<String> _genNewScript(
      ValueNotifier<RSILauncherStateData?> assarState) async {
    final serverScriptLines = assarState.value!.serverData.split("\n");
    final StringBuffer scriptBuffer = StringBuffer("");
    for (final line in serverScriptLines) {
      final lineTrim = line.trim();
      if (lineTrim.startsWith(SC_TOOLBOX_ENABLED_LOCALIZATION_SCRIPT_START)) {
        scriptBuffer.writeln(
            "$SC_TOOLBOX_ENABLED_LOCALIZATION_SCRIPT_START\"${assarState.value!.enabledLocalization}\";");
      } else if (lineTrim
          .startsWith(SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START)) {
        scriptBuffer.writeln(
            "$SC_TOOLBOX_ENABLE_DOWNLOADER_BOOST_SCRIPT_START${assarState.value!.enableDownloaderBoost};");
      } else {
        scriptBuffer.writeln(line);
      }
    }
    return scriptBuffer.toString();
  }
}
