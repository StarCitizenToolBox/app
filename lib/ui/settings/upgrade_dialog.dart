import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Material;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher_string.dart';

class UpgradeDialogUI extends HookConsumerWidget {
  const UpgradeDialogUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appGlobalModelProvider);
    final appModel = ref.read(appGlobalModelProvider.notifier);
    final description = useState<String?>(null);
    final isUsingDiversion = useState(false);
    final isUpgrading = useState(false);
    final progress = useState(0.0);
    final downloadUrl = useState("");

    final targetVersion = ConstConf.isMSE
        ? appState.networkVersionData!.mSELastVersion!
        : appState.networkVersionData!.lastVersion!;

    final minVersionCode = ConstConf.isMSE
        ? appState.networkVersionData?.mSEMinVersionCode
        : appState.networkVersionData?.minVersionCode;

    useEffect(() {
      _getUpdateInfo(context, targetVersion, description, downloadUrl);
      return null;
    }, []);

    return Material(
      child: ContentDialog(
        title:
            Text(S.current.app_upgrade_title_new_version_found(targetVersion)),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .55),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (description.value == null) ...[
                      Center(
                        child: Column(
                          children: [
                            const ProgressRing(),
                            const SizedBox(height: 16),
                            Text(S.current
                                .app_upgrade_info_getting_new_version_details)
                          ],
                        ),
                      )
                    ] else
                      ...makeMarkdownView(description.value!,
                          attachmentsUrl: URLConf.giteaAttachmentsUrl),
                  ],
                ),
              ),
            )),
            if (isUsingDiversion.value) ...[
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _launchReleaseUrl,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.1),
                      borderRadius: BorderRadius.circular(7)),
                  child: Text(
                    S.current.app_upgrade_info_update_server_tip,
                    style: TextStyle(
                        fontSize: 14, color: Colors.white.withOpacity(.7)),
                  ),
                ),
              ),
            ],
            if (isUpgrading.value) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(progress.value == 100
                      ? S.current.app_upgrade_info_installing
                      : S.current.app_upgrade_info_downloading(
                          progress.value.toStringAsFixed(2))),
                  Expanded(
                      child: ProgressBar(
                    value: progress.value == 100 ? null : progress.value,
                  )),
                ],
              ),
            ],
          ],
        ),
        actions: isUpgrading.value
            ? null
            : [
                if (downloadUrl.value.isNotEmpty)
                  FilledButton(
                      onPressed: () => _doUpgrade(
                          context,
                          appState,
                          isUpgrading,
                          appModel,
                          downloadUrl,
                          description,
                          isUsingDiversion,
                          progress),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        child: Text(S.current.app_upgrade_action_update_now),
                      )),
                if (ConstConf.appVersionCode >= (minVersionCode ?? 0))
                  Button(
                      onPressed: () => _doCancel(context),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        child: Text(S.current.app_upgrade_action_next_time),
                      )),
              ],
      ),
    );
  }

  Future<void> _getUpdateInfo(
      BuildContext context,
      String targetVersion,
      ValueNotifier<String?> description,
      ValueNotifier<String> downloadUrl) async {
    try {
      final r = await Api.getAppReleaseDataByVersionName(targetVersion);
      description.value = r["body"];
      final assets = List.of(r["assets"] ?? []);
      for (var asset in assets) {
        if (asset["name"].toString().endsWith("SETUP.exe")) {
          downloadUrl.value = asset["browser_download_url"];
        }
      }
    } catch (e) {
      dPrint("UpgradeDialogUIModel.loadData Error : $e");
      if (!context.mounted) return;
      Navigator.pop(context, false);
    }
  }

  void _launchReleaseUrl() {
    launchUrlString(URLConf.devReleaseUrl);
  }

  void _doCancel(BuildContext context) {
    Navigator.pop(context, true);
  }

  String _getDiversionUrl(String description) {
    try {
      final htmlStr = markdown.markdownToHtml(description);
      final html = html_parser.parse(htmlStr);
      for (var element in html.querySelectorAll('a')) {
        String linkText = element.text;
        String linkUrl = element.attributes['href'] ?? '';
        if (linkText.trim().endsWith("_SETUP.exe")) {
          final diversionDownloadUrl = linkUrl.trim();
          dPrint("diversionDownloadUrl === $diversionDownloadUrl");
          return diversionDownloadUrl;
        }
      }
    } catch (e) {
      dPrint("_checkDiversionUrl Error:$e");
    }
    return "";
  }

  Future<void> _doUpgrade(
      BuildContext context,
      AppGlobalState appState,
      ValueNotifier<bool> isUpgrading,
      AppGlobalModel appModel,
      ValueNotifier<String> downloadUrl,
      ValueNotifier<String?> description,
      ValueNotifier<bool> isUsingDiversion,
      ValueNotifier<double> progress) async {
    if (ConstConf.isMSE) {
      launchUrlString("ms-windows-store://pdp/?productid=9NF3SWFWNKL1");
      await Future.delayed(const Duration(seconds: 3));
      if (ConstConf.appVersionCode <
          (appState.networkVersionData?.minVersionCode ?? 0)) {
        exit(0);
      }
      if (!context.mounted) return;
      _doCancel(context);
      return;
    }
    isUpgrading.value = true;
    final fileName = "${appModel.getUpgradePath()}/next_SETUP.exe";
    try {
      // check diversionDownloadUrl
      var url = downloadUrl.value;
      final diversionDownloadUrl = _getDiversionUrl(description.value!);
      final dio = Dio();
      if (diversionDownloadUrl.isNotEmpty) {
        try {
          final resp = await dio.head(diversionDownloadUrl,
              options: Options(
                  sendTimeout: const Duration(seconds: 10),
                  receiveTimeout: const Duration(seconds: 10)));
          if (resp.statusCode == 200) {
            isUsingDiversion.value = true;
            url = diversionDownloadUrl;
          } else {
            isUsingDiversion.value = false;
          }
          dPrint("diversionDownloadUrl head resp == ${resp.headers}");
        } catch (e) {
          dPrint("diversionDownloadUrl err:$e");
        }
      }
      await dio.download(url, fileName,
          onReceiveProgress: (int count, int total) {
        progress.value = (count / total) * 100;
      });
    } catch (_) {
      isUpgrading.value = false;
      progress.value = 0;
      if (!context.mounted) return;
      showToast(context, S.current.app_upgrade_info_download_failed);
      return;
    }

    try {
      final r = await (Process.run(
          SystemHelper.powershellPath, ["start", fileName, "/SILENT"]));
      if (r.stderr.toString().isNotEmpty) {
        throw r.stderr;
      }
      exit(0);
    } catch (_) {
      isUpgrading.value = false;
      progress.value = 0;
      if (!context.mounted) return;
      showToast(context, S.current.app_upgrade_info_run_failed);
      SystemHelper.openDir("\"$fileName\"");
    }
  }
}
