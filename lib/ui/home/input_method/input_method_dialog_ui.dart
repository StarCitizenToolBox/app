import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/ui/home/input_method/input_method_dialog_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class InputMethodDialogUI extends HookConsumerWidget {
  const InputMethodDialogUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inputMethodDialogUIModelProvider);
    final model = ref.read(inputMethodDialogUIModelProvider.notifier);
    final srcTextCtrl = useTextEditingController();
    final destTextCtrl = useTextEditingController();

    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .8,
      ),
      title: makeTitle(context, state, model, destTextCtrl),
      content: state.keyMaps == null
          ? makeLoading(context)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12),
                InfoBar(
                  title: Text("使用说明"),
                  content: Text(
                      "在上方文本框中输入文字，并将下方转码后的文本复制到游戏的文本框中，即可在聊天频道中发送游戏不支持输入的文字。"),
                ),
                SizedBox(height: 24),
                TextFormBox(
                  placeholder: "请输入文本...",
                  controller: srcTextCtrl,
                  maxLines: 5,
                  placeholderStyle:
                      TextStyle(color: Colors.white.withOpacity(.6)),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  onChanged: (str) {
                    final text = model.onTextChange("src", str);
                    if (text != null) {
                      destTextCtrl.text = text;
                    }
                  },
                ),
                SizedBox(height: 16),
                Center(
                  child: Icon(FluentIcons.down),
                ),
                SizedBox(height: 16),
                TextFormBox(
                  placeholder: "这里是转码后的文本...",
                  controller: destTextCtrl,
                  maxLines: 5,
                  placeholderStyle:
                      TextStyle(color: Colors.white.withOpacity(.6)),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  enabled: true,
                  onChanged: (str) {
                    // final text = model.onTextChange("dest", str);
                    // if (text != null) {
                    //   srcTextCtrl.text = text;
                    // }
                  },
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                        "*本功能建议仅在非公共频道中使用。若用户选择在公共频道中使用本功能，由此产生的任何后果（包括但不限于被其他玩家举报刷屏等），均由用户自行承担。\n*若该功能被滥用，我们将关闭该功能。",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(.6),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }

  Widget makeTitle(BuildContext context, InputMethodDialogUIState state,
      InputMethodDialogUIModel model, TextEditingController destTextCtrl) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(
              FluentIcons.back,
              size: 22,
            ),
            onPressed: () {
              context.pop();
            }),
        const SizedBox(width: 12),
        Text("社区输入法"),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "自动复制",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(width: 12),
            ToggleSwitch(
                checked: state.enableAutoCopy,
                onChanged: model.onSwitchAutoCopy),
          ],
        ),
        SizedBox(width: 24),
        FilledButton(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(FluentIcons.copy),
          ),
          onPressed: () {
            if (destTextCtrl.text.isNotEmpty) {
              Clipboard.setData(ClipboardData(text: destTextCtrl.text));
            }
          },
        )
      ],
    );
  }
}
