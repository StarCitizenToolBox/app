import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:starcitizen_doctor/base/ui.dart';

import 'webview_localization_capture_ui_model.dart';

class WebviewLocalizationCaptureUI
    extends BaseUI<WebviewLocalizationCaptureUIModel> {
  @override
  Widget? buildBody(
      BuildContext context, WebviewLocalizationCaptureUIModel model) {
    return makeDefaultPage(context, model,
        content: model.data.isEmpty
            ? const Center(
                child: Text("等待数据"),
              )
            : Column(
                children: [
                  Expanded(
                      child: MarkdownWidget(
                    data: model.renderString,
                    config: MarkdownConfig(configs: [
                      const PreConfig(
                          decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, .4),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      )),
                    ]),
                  ))
                ],
              ),
        actions: [
          IconButton(
              icon: const Icon(FluentIcons.refresh), onPressed: model.doClean)
        ]);
  }

  @override
  String getUITitle(
          BuildContext context, WebviewLocalizationCaptureUIModel model) =>
      "Webview 翻译捕获工具";
}
