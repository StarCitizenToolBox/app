import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/ui/index_ui_model.dart';
import 'package:window_manager/window_manager.dart';

import 'global_ui_model.dart';
import 'ui/index_ui.dart';

void main(List<String> args) async {
  if (runWebViewTitleBarWidget(args,
      backgroundColor: const Color.fromRGBO(19, 36, 49, 1),
      builder: _defaultWebviewTitleBar)) {
    return;
  }
  await AppConf.init(args);
  runApp(ProviderScope(
    child: BaseUIContainer(
      uiCreate: () => AppUI(),
      modelCreate: () => globalUIModelProvider,
    ),
  ));
}

class AppUI extends BaseUI {
  @override
  Widget? buildBody(BuildContext context, BaseUIModel model) {
    return FluentApp(
      title: "StarCitizen Doctor",
      restorationScopeId: "Doctor",
      themeMode: ThemeMode.dark,
      // theme: FluentThemeData(brightness: Brightness.light),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        fontFamily: "SourceHanSansCN-Regular",
        navigationPaneTheme: NavigationPaneThemeData(
          backgroundColor:
              HexColor(globalUIModel.colorBackground).withOpacity(.75),
        ),
        menuColor: HexColor(globalUIModel.colorMenu).withOpacity(.95),
        micaBackgroundColor: HexColor(globalUIModel.colorMica),
      ),
      debugShowCheckedModeBanner: false,
      home: BaseUIContainer(
          uiCreate: () => IndexUI(), modelCreate: () => IndexUIModel()),
    );
  }

  @override
  String getUITitle(BuildContext context, BaseUIModel model) => "";
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

Widget _defaultWebviewTitleBar(BuildContext context) {
  final state = TitleBarWebViewState.of(context);
  final controller = TitleBarWebViewController.of(context);
  return FluentTheme(
      data: FluentThemeData.dark(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: !state.canGoBack ? null : controller.back,
            icon: const Icon(FluentIcons.chevron_left),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: !state.canGoForward ? null : controller.forward,
            icon: const Icon(FluentIcons.chevron_right),
          ),
          const SizedBox(width: 12),
          if (state.isLoading)
            IconButton(
              onPressed: controller.stop,
              icon: const Icon(FluentIcons.chrome_close),
            )
          else
            IconButton(
              onPressed: controller.reload,
              icon: const Icon(FluentIcons.refresh),
            ),
          const SizedBox(width: 12),
          (state.isLoading)
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: ProgressRing(),
                )
              : const SizedBox(width: 24),
          const SizedBox(width: 12),
          SelectableText(state.url ?? ""),
          const Spacer()
        ],
      ));
}
