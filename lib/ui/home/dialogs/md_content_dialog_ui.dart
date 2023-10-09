import 'package:flutter/material.dart' show Material;
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/md_content_dialog_ui_model.dart';

class MDContentDialogUI extends BaseUI<MDContentDialogUIModel> {
  @override
  Widget? buildBody(BuildContext context, MDContentDialogUIModel model) {
    return Material(
      child: ContentDialog(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .6,
        ),
        title: Text(getUITitle(context, model)),
        content: model.data == null
            ? makeLoading(context)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: makeMarkdownView(model.data ?? ""),
                  ),
                ),
              ),
        actions: [
          FilledButton(
              child: const Padding(
                padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                child: Text("关闭"),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  String getUITitle(BuildContext context, MDContentDialogUIModel model) =>
      model.title;
}
