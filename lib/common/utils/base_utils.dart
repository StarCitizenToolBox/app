import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

void dPrint(src) {
  if (kDebugMode) {
    print(src);
  }
}

Future showToast(BuildContext context, String msg,
    {BoxConstraints? constraints}) async {
  return showBaseDialog(context,
      title: "提示",
      content: Text(msg),
      actions: [
        FilledButton(
          child: const Padding(
            padding: EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
            child: Text('我知道了'),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      constraints: constraints);
}

Future<bool> showConfirmDialogs(
    BuildContext context, String title, Widget content,
    {String confirm = "确认",
    String cancel = "取消",
    BoxConstraints? constraints}) async {
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
      constraints: constraints ?? kDefaultContentDialogConstraints,
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
