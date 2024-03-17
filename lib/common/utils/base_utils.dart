import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

Future showToast(BuildContext context, String msg,
    {BoxConstraints? constraints, String? title}) async {
  return showBaseDialog(context,
      title: title ?? S.current.app_common_tip,
      content: Text(msg),
      actions: [
        FilledButton(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
            child: Text(S.current.app_common_tip_i_know),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      constraints: constraints);
}

Future<bool> showConfirmDialogs(
    BuildContext context, String title, Widget content,
    {String confirm = "",
    String cancel = "",
    BoxConstraints? constraints}) async {
  if (confirm.isEmpty) confirm = S.current.app_common_tip_confirm;
  if (cancel.isEmpty) confirm = S.current.app_common_tip_cancel;

  final r = await showBaseDialog(context,
      title: title,
      content: content,
      actions: [
        if (confirm.isNotEmpty)
          FilledButton(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              child: Text(confirm),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        if (cancel.isNotEmpty)
          Button(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              child: Text(cancel),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
      ],
      constraints: constraints);
  return r == true;
}

Future<String?> showInputDialogs(BuildContext context,
    {required String title,
    required String content,
    BoxConstraints? constraints,
    String? initialValue,
    List<TextInputFormatter>? inputFormatters}) async {
  String? userInput;
  constraints ??=
      BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .38);
  final ok = await showConfirmDialogs(
      context,
      title,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.isNotEmpty)
            Text(
              content,
              style: TextStyle(color: Colors.white.withOpacity(.6)),
            ),
          const SizedBox(height: 8),
          TextFormBox(
            initialValue: initialValue,
            onChanged: (str) {
              userInput = str;
            },
            inputFormatters: inputFormatters,
          ),
        ],
      ),
      constraints: constraints);
  if (ok == true) return userInput;
  return null;
}

Future showBaseDialog(BuildContext context,
    {required String title,
    required Widget content,
    List<Widget>? actions,
    BoxConstraints? constraints}) async {
  return await showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(title),
      content: content,
      constraints: constraints ??
          const BoxConstraints(
            maxWidth: 512,
            maxHeight: 756.0,
          ),
      actions: actions,
    ),
  );
}

bool stringIsNotEmpty(String? s) {
  return s != null && (s.isNotEmpty);
}

Future<Uint8List?> widgetToPngImage(GlobalKey repaintBoundaryKey,
    {double pixelRatio = 3.0}) async {
  RenderRepaintBoundary? boundary = repaintBoundaryKey.currentContext
      ?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return null;

  ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return null;
  var pngBytes = byteData.buffer.asUint8List();
  return pngBytes;
}

double roundDoubleTo(double value, double precision) =>
    (value * precision).round() / precision;
