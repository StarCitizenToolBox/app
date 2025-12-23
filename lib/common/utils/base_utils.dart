import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

/// String extension for cross-platform path compatibility
extension PathStringExtension on String {
  /// Converts path separators to the current platform's format.
  /// On Windows: / -> \
  /// On Linux/macOS: \ -> /
  String get platformPath {
    if (Platform.isWindows) {
      return replaceAll('/', '\\');
    }
    return replaceAll('\\', '/');
  }
}

Future showToast(BuildContext context, String msg, {BoxConstraints? constraints, String? title}) async {
  return showBaseDialog(
    context,
    title: title ?? S.current.app_common_tip,
    content: Text(msg),
    actions: [
      FilledButton(
        child: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
          child: Text(S.current.app_common_tip_i_know),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ],
    constraints: constraints,
  );
}

Future<bool> showConfirmDialogs(
  BuildContext context,
  String title,
  Widget content, {
  String confirm = "",
  String cancel = "",
  BoxConstraints? constraints,
}) async {
  if (confirm.isEmpty) confirm = S.current.app_common_tip_confirm;
  if (cancel.isEmpty) cancel = S.current.app_common_tip_cancel;

  final r = await showBaseDialog(
    context,
    title: title,
    content: content,
    actions: [
      if (confirm.isNotEmpty)
        FilledButton(
          child: Padding(padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8), child: Text(confirm)),
          onPressed: () => Navigator.pop(context, true),
        ),
      if (cancel.isNotEmpty)
        Button(
          child: Padding(padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8), child: Text(cancel)),
          onPressed: () => Navigator.pop(context, false),
        ),
    ],
    constraints: constraints,
  );
  return r == true;
}

Future<String?> showInputDialogs(
  BuildContext context, {
  required String title,
  required String content,
  BoxConstraints? constraints,
  String? initialValue,
  List<TextInputFormatter>? inputFormatters,
}) async {
  String? userInput;
  constraints ??= BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .38);
  final ok = await showConfirmDialogs(
    context,
    title,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.isNotEmpty) Text(content, style: TextStyle(color: Colors.white.withValues(alpha: .6))),
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
    constraints: constraints,
  );
  if (ok == true) return userInput;
  return null;
}

Future showBaseDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  List<Widget>? actions,
  BoxConstraints? constraints,
}) async {
  return await showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(title),
      content: content,
      constraints: constraints ?? const BoxConstraints(maxWidth: 512, maxHeight: 756.0),
      actions: actions,
    ),
  );
}

bool stringIsNotEmpty(String? s) {
  return s != null && (s.isNotEmpty);
}

Future<Uint8List?> widgetToPngImage(GlobalKey repaintBoundaryKey, {double pixelRatio = 3.0}) async {
  RenderRepaintBoundary? boundary = repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return null;

  ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return null;
  var pngBytes = byteData.buffer.asUint8List();
  return pngBytes;
}

double roundDoubleTo(double value, double precision) => (value * precision).round() / precision;

int getMinNumber(List<int> list) {
  if (list.isEmpty) return 0;
  list.sort((a, b) => a.compareTo(b));
  return list.first;
}

String colorToHexCode(Color color, {ignoreTransparency = false}) {
  final colorValue = color.toARGB32();
  final colorAlpha = ((0xff000000 & colorValue) >> 24);
  final r = ((0x00ff0000 & colorValue) >> 16).toRadixString(16).padLeft(2, '0');
  final g = ((0x0000ff00 & colorValue) >> 8).toRadixString(16).padLeft(2, '0');
  final b = ((0x000000ff & colorValue) >> 0).toRadixString(16).padLeft(2, '0');
  final a = colorAlpha.toRadixString(16).padLeft(2, '0');

  if (ignoreTransparency || colorAlpha == 255) {
    return '#$r$g$b';
  } else {
    return '#$a$r$g$b';
  }
}
