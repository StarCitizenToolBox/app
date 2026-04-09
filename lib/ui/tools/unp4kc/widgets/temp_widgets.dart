import 'dart:convert';
import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';

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

class ImageTempWidget extends HookWidget {
  final Uint8List bytes;

  const ImageTempWidget(this.bytes, {super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
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
    );
  }
}
