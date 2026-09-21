import 'dart:io';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';
import 'provider/dynamic_background.dart';
import 'widgets/src/dialog_move_area.dart';
import 'widgets/src/nebula_background.dart';
import 'common/utils/multi_window_manager.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Get the current window controller
  final windowController = await WindowController.fromCurrentEngine();

  // Parse window arguments to determine which window to show
  final windowType = MultiWindowManager.parseWindowType(windowController.arguments);

  // Initialize window-specific handlers for sub-windows
  if (windowType != WindowTypes.main) {
    await windowController.doCustomInitialize();
  }

  // Run different apps based on the window type
  switch (windowType) {
    case WindowTypes.main:
      await _initWindow();
      runApp(const ProviderScope(child: App()));
    default:
      MultiWindowManager.runSubWindowApp(windowController.arguments, windowType);
  }
}

Future<void> _initWindow() async {
  await windowManager.setTitleBarStyle(TitleBarStyle.hidden, windowButtonVisibility: false);
  await windowManager.setSize(const Size(1280, 810));
  await windowManager.setMinimumSize(const Size(1280, 810));
  await windowManager.center(animate: true);
}

class App extends HookConsumerWidget with WindowListener {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appState = ref.watch(appGlobalModelProvider);
    final dynamicBackground = ref.watch(dynamicBackgroundProvider);

    useEffect(() {
      windowManager.addListener(this);
      windowManager.setPreventClose(true);
      return () async {
        windowManager.removeListener(this);
      };
    }, const []);

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
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: Stack(
            fit: StackFit.expand,
            children: [
              NebulaBackground(animated: dynamicBackground),
              child ?? const SizedBox(),
              const DialogMoveArea(),
            ],
          ),
        );
      },
      theme: FluentThemeData(
        brightness: Brightness.dark,
        // 强调色 #54ADF7；暗色主题下 Fluent 取 lighter 档作为默认画刷
        accentColor: AccentColor.swatch(const {
          "darkest": Color(0xff1f6aa8),
          "darker": Color(0xff2f87d0),
          "dark": Color(0xff3f9ce8),
          "normal": Color(0xff54adf7),
          "light": Color(0xff54adf7),
          "lighter": Color(0xff54adf7),
          "lightest": Color(0xff8cc8fa),
        }),
        visualDensity: const VisualDensity(vertical: 1),
        fontFamily: "SourceHanSansCN-Regular",
        navigationPaneTheme: NavigationPaneThemeData(backgroundColor: appState.themeConf.backgroundColor),
        menuColor: appState.themeConf.menuColor,
        micaBackgroundColor: appState.themeConf.micaColor,
        // Dialogs show the nebula too, under a denser tint than the window.
        dialogTheme: ContentDialogThemeData(
          decoration: NebulaDecoration(
            tint: const Color(0xd90b1118),
            borderRadius: BorderRadius.circular(12),
            border: BorderSide(color: Colors.white.withValues(alpha: .05)),
            boxShadow: kElevationToShadow[6] ?? const [],
          ),
          actionsDecoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .2),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
        ),
        buttonTheme: ButtonThemeData(
          // fluent_ui 4.16 fills disabled IconButtons with the button colour,
          // which turns toolbars into grey blocks; keep them transparent.
          iconButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              const res = ResourceDictionary.dark();
              if (states.isDisabled) return res.subtleFillColorTransparent;
              if (states.isPressed) return res.subtleFillColorTertiary;
              if (states.isHovered) return res.subtleFillColorSecondary;
              return res.subtleFillColorTransparent;
            }),
          ),
          defaultButtonStyle: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.white.withValues(alpha: .04)),
              ),
            ),
          ),
        ),
      ),
      locale: appState.appLocale,
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }

  @override
  Future<void> onWindowClose() async {
    debugPrint("onWindowClose");
    if (await windowManager.isPreventClose()) {
      final mainWindow = await WindowController.fromCurrentEngine();
      final windows = await WindowController.getAll();
      for (final controller in windows) {
        if (controller.windowId != mainWindow.windowId) {
          try {
            controller.close();
          } catch (e) {
            debugPrint("Error closing window ${controller.windowId}: $e");
          }
        }
      }
      await windowManager.setPreventClose(false);
      await windowManager.close();
      exit(0);
    }
    super.onWindowClose();
  }
}
