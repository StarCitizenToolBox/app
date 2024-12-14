import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/ui/home/input_method/input_method_dialog_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/input_method/server.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'server_qr_dialog_ui.dart';

class InputMethodDialogUI extends HookConsumerWidget {
  const InputMethodDialogUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inputMethodDialogUIModelProvider);
    final model = ref.read(inputMethodDialogUIModelProvider.notifier);
    final serverState = ref.watch(inputMethodServerProvider);
    final serverModel = ref.read(inputMethodServerProvider.notifier);
    final srcTextCtrl = useTextEditingController();
    final destTextCtrl = useTextEditingController();

    useEffect(() {
      model.setUpController(srcTextCtrl, destTextCtrl);
      return null;
    }, const []);

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
                  title: Text(S.current.input_method_usage_instructions),
                  content: Text(S.current.input_method_input_text_instructions),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            S.current.input_method_online_version_prompt,
                            style: TextStyle(
                              color: Color(0xff4ca0e0),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        onTap: () {
                          launchUrlString("https://ime.citizenwiki.cn/");
                        }),
                  ],
                ),
                SizedBox(height: 12),
                TextFormBox(
                  placeholder: S.current.input_method_input_placeholder,
                  controller: srcTextCtrl,
                  maxLines: 5,
                  placeholderStyle:
                      TextStyle(color: Colors.white.withValues(alpha: .6)),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  onChanged: (str) async {
                    final text = model.onTextChange("src", str);
                    destTextCtrl.text = text ?? "";
                    if (text != null) {
                      model.checkAutoTranslate();
                    }
                  },
                ),
                SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isAutoTranslateWorking)
                        SizedBox(width: 24, height: 24, child: ProgressRing())
                      else
                        SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(FluentIcons.down))
                    ],
                  ),
                ),
                SizedBox(height: 16),
                TextFormBox(
                  placeholder: S.current.input_method_encoded_text_placeholder,
                  controller: destTextCtrl,
                  maxLines: 5,
                  placeholderStyle:
                      TextStyle(color: Colors.white.withValues(alpha: .6)),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  enabled: true,
                  onChanged: (str) {
                    // final text = model.onTextChange("dest", str);
                    // if (text != null) {
                    //   srcTextCtrl.text = text;
                    // }
                  },
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(S.current.input_method_auto_translate),
                        SizedBox(width: 6),
                        ToggleSwitch(
                          checked: state.isEnableAutoTranslate,
                          onChanged: (b) =>
                              _onSwitchAutoTranslate(context, model, b),
                        ),
                      ],
                    ),
                    SizedBox(width: 24),
                    Row(
                      children: [
                        Text(S.current.input_method_remote_input_service),
                        SizedBox(width: 6),
                        if (serverState.isServerStartup)
                          Button(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    ServerQrDialogUI(),
                              );
                            },
                            child: Text(
                              serverState.serverAddressText ?? "...",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        SizedBox(width: 14),
                        ToggleSwitch(
                            checked: serverState.isServerStartup,
                            onChanged: (b) =>
                                _onSwitchServer(context, b, serverModel)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                        S.current.input_method_disclaimer,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: .6),
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
        Text(S.current.input_method_experimental_input_method),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              S.current.input_method_auto_copy,
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

  Future<void> _onSwitchServer(
      BuildContext context, bool value, InputMethodServer serverModel) async {
    if (value) {
      final userOK = await showConfirmDialogs(
          context,
          S.current.input_method_confirm_enable_remote_input,
          Text(S.current.input_method_enable_remote_input_instructions));
      if (userOK) {
        // ignore: use_build_context_synchronously
        await serverModel.startServer().unwrap(context: context);
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (BuildContext context) => ServerQrDialogUI(),
        );
      }
    } else {
      await serverModel.stopServer().unwrap(context: context);
    }
  }

  _onSwitchAutoTranslate(
      BuildContext context, InputMethodDialogUIModel model, bool b) async {
    if (b) {
      final ok = await showConfirmDialogs(
          context,
          S.current.input_method_auto_translate_dialog_title,
          Text(S.current.input_method_auto_translate_dialog_title_content));
      if (ok != true) return;
    }
    model.toggleAutoTranslate(b);
  }
}
