import 'package:flutter/material.dart' show Material;
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';

import 'upgrade_dialog_ui_model.dart';

class UpgradeDialogUI extends BaseUI<UpgradeDialogUIModel> {
  @override
  Widget? buildBody(BuildContext context, UpgradeDialogUIModel model) {
    return Material(
      child: ContentDialog(
        title: const Text("发现新版本"),
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
                      ...makeMarkdownView(model.description!),
                  ],
                ),
              ),
            )),
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
