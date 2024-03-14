import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Material;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class HomeMdContentDialogUI extends HookConsumerWidget {
  final String title;
  final String url;

  const HomeMdContentDialogUI(
      {super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: ContentDialog(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .6,
        ),
        title: Text(title),
        content: LoadingWidget(
          onLoadData: _getContent,
          childBuilder: (BuildContext context, String data) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: makeMarkdownView(data),
                ),
              ),
            );
          },
        ),
        actions: [
          FilledButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                child: Text(S.current.action_close),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  Future<String> _getContent() async {
    final r = await RSHttp.getText(url);
    return r;
  }
}