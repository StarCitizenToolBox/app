import 'dart:convert';
import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';

import '../../../../common/rust/api/win32_api.dart';
import '../../../../widgets/widgets.dart';

class TextTempWidget extends HookConsumerWidget {
  final Uint8List bytes;

  const TextTempWidget(this.bytes, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textData = useState<String?>(null);

    useEffect(() {
      // 处理 BOM
      var data = bytes;
      if (data.length > 3 && data[0] == 0xEF && data[1] == 0xBB && data[2] == 0xBF) {
        data = data.sublist(3);
      }
      final text = utf8.decode(data, allowMalformed: true);
      textData.value = text;
      return null;
    }, const []);

    if (textData.value == null) return makeLoading(context);

    return CodeEditor(controller: CodeLineEditingController.fromText('${textData.value}'), readOnly: true);
  }
}

class ImageTempWidget extends HookConsumerWidget {
  final Uint8List bytes;

  const ImageTempWidget(this.bytes, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCopying = useState(false);
    final flyoutController = useMemoized(() => FlyoutController());

    Future<void> copyToClipboard() async {
      if (isCopying.value) return;
      isCopying.value = true;
      try {
        await setClipboardImage(imageData: bytes);
        if (context.mounted) {
          displayInfoBar(context, builder: (_, close) => InfoBar(
            title: Text(S.current.tools_unp4k_action_copy_image_success),
            severity: InfoBarSeverity.success,
            onClose: close,
          ));
        }
      } catch (e) {
        if (context.mounted) {
          displayInfoBar(context, builder: (_, close) => InfoBar(
            title: Text(S.current.tools_unp4k_action_copy_image_failed(e.toString())),
            severity: InfoBarSeverity.error,
            onClose: close,
          ));
        }
      } finally {
        if (context.mounted) {
          isCopying.value = false;
        }
      }
    }

    void showContextMenu(Offset position) {
      flyoutController.showFlyout(
        position: position,
        barrierColor: Colors.transparent,
        builder: (flyoutContext) {
          return MenuFlyout(
            items: [
              MenuFlyoutItem(
                leading: isCopying.value
                    ? const SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2))
                    : const Icon(FluentIcons.copy, size: 16),
                text: Text(S.current.tools_unp4k_action_copy_image),
                onPressed: isCopying.value
                    ? null
                    : () async {
                        Navigator.of(flyoutContext).pop();
                        await copyToClipboard();
                      },
              ),
            ],
          );
        },
      );
    }

    return GestureDetector(
      onSecondaryTapUp: (details) => showContextMenu(details.globalPosition),
      child: FlyoutTarget(
        controller: flyoutController,
        child: InteractiveViewer(
          minScale: 0.1,
          maxScale: 8,
          child: Center(
            child: Image.memory(
              bytes,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(S.current.tools_unp4k_msg_unknown_file_type(error.toString()), textAlign: TextAlign.center);
              },
            ),
          ),
        ),
      ),
    );
  }
}
