import 'dart:io';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';

void main(List<String> args) async {
  // webview window
  if (runWebViewTitleBarWidget(args,
      backgroundColor: const Color.fromRGBO(19, 36, 49, 1),
      builder: _defaultWebviewTitleBar)) {
    return;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await _initWindow();
  // run app
  runApp(const ProviderScope(child: App()));
}

_initWindow() async {
  await windowManager.ensureInitialized();
  await windowManager.setTitleBarStyle(
    TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  await windowManager.setSize(const Size(1280, 810));
  await windowManager.setMinimumSize(const Size(1280, 810));
  await windowManager.center(animate: true);
}

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appState = ref.watch(appGlobalModelProvider);
    return FluentApp.router(
      title: "StarCitizenToolBox",
      restorationScopeId: "StarCitizenToolBox",
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FluentLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) {
        return MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox(),
        );
      },
      theme: FluentThemeData(
          brightness: Brightness.dark,
          fontFamily: "SourceHanSansCN-Regular",
          navigationPaneTheme: NavigationPaneThemeData(
            backgroundColor: appState.themeConf.backgroundColor,
          ),
          menuColor: appState.themeConf.menuColor,
          micaBackgroundColor: appState.themeConf.micaColor,
          buttonTheme: ButtonThemeData(
              defaultButtonStyle: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.white.withOpacity(.01)))),
          ))),
      locale: appState.appLocale,
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
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
          if (Platform.isMacOS) const SizedBox(width: 96),
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
