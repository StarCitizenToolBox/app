import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // run app
  runApp(const ProviderScope(child: App()));
}


class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appState = ref.watch(appGlobalModelProvider);
    return FluentApp.router(
      title: "SCToolBox Lite",
      restorationScopeId: "SCToolBox Lite",
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

