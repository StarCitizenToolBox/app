import 'package:flutter/material.dart' show Material;
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';

import 'upgrade_dialog_ui_model.dart';

class UpgradeDialogUI extends BaseUI<UpgradeDialogUIModel> {
  @override
  Widget? buildBody(BuildContext context, UpgradeDialogUIModel model) {
    return Material(
      child: ContentDialog(
        title: Text("发现新版本 -> ${model.targetVersion}"),
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
                    if (model.description == null) ...[
                      const Center(
                        child: Column(
                          children: [
                            ProgressRing(),
                            SizedBox(height: 16),
                            Text("正在获取新版本详情...")
                          ],
                        ),
                      )
                    ] else
                      ...makeMarkdownView(model.description!,
                          attachmentsUrl: URLConf.giteaAttachmentsUrl),
                  ],
                ),
              ),
            )),
            if (model.isUsingDiversion) ...[
              const SizedBox(height: 24),
              GestureDetector(
                onTap: model.launchReleaseUrl,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.1),
                      borderRadius: BorderRadius.circular(7)),
                  child: Text(
                    "提示：当前正在使用分流服务器进行更新，可能会出现下载速度下降，但有助于我们进行成本控制，若下载异常请点击这里跳转手动安装。",
                    style: TextStyle(
                        fontSize: 14, color: Colors.white.withOpacity(.7)),
                  ),
                ),
              ),
            ],
            if (model.isUpgrading) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(model.progress == 100
                      ? "正在安装：   "
                      : "正在下载： ${model.progress?.toStringAsFixed(2) ?? 0}%    "),
                  Expanded(
                      child: ProgressBar(
                    value: model.progress == 100 ? null : model.progress,
                  )),
                ],
              ),
            ],
          ],
        ),
        actions: model.isUpgrading
            ? null
            : [
                if (model.downloadUrl.isNotEmpty)
                  FilledButton(
                      onPressed: model.doUpgrade,
                      child: const Padding(
                        padding: EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        child: Text("立即更新"),
                      )),
                if (AppConf.appVersionCode >=
                    (AppConf.networkVersionData?.minVersionCode ?? 0))
                  Button(
                      onPressed: model.doCancel,
                      child: const Padding(
                        padding: EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        child: Text("下次吧"),
                      )),
              ],
      ),
    );
  }

  @override
  String getUITitle(BuildContext context, UpgradeDialogUIModel model) => "";
}
