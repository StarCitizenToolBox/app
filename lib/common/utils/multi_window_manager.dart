import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/ui/tools/log_analyze_ui/log_analyze_ui.dart';

import 'base_utils.dart';

part 'multi_window_manager.freezed.dart';

part 'multi_window_manager.g.dart';

@freezed
abstract class MultiWindowAppState with _$MultiWindowAppState {
  const factory MultiWindowAppState({
    required String backgroundColor,
    required String menuColor,
    required String micaColor,
    required List<String> gameInstallPaths,
    String? languageCode,
    String? countryCode,
  }) = _MultiWindowAppState;

  factory MultiWindowAppState.fromJson(Map<String, dynamic> json) => _$MultiWindowAppStateFromJson(json);
}

class MultiWindowManager {
  static Future<void> launchSubWindow(String type, String title, AppGlobalState appGlobalState) async {
    final gameInstallPaths = await SCLoggerHelper.getGameInstallPath(await SCLoggerHelper.getLauncherLogList() ?? [],
        checkExists: true, withVersion: AppConf.gameChannels);
    final window = await DesktopMultiWindow.createWindow(jsonEncode({
      'window_type': type,
      'app_state': _appStateToWindowState(
        appGlobalState,
        gameInstallPaths: gameInstallPaths,
      ).toJson(),
    }));
    window.setFrame(const Rect.fromLTWH(0, 0, 900, 1200));
    window.setTitle(title);
    await window.center();
    await window.show();
    // sendAppStateBroadcast(appGlobalState);
  }

  static void sendAppStateBroadcast(AppGlobalState appGlobalState) {
    DesktopMultiWindow.invokeMethod(
      0,
      'app_state_broadcast',
      _appStateToWindowState(appGlobalState).toJson(),
    );
  }

  static MultiWindowAppState _appStateToWindowState(AppGlobalState appGlobalState, {List<String>? gameInstallPaths}) {
    return MultiWindowAppState(
      backgroundColor: colorToHexCode(appGlobalState.themeConf.backgroundColor),
      menuColor: colorToHexCode(appGlobalState.themeConf.menuColor),
      micaColor: colorToHexCode(appGlobalState.themeConf.micaColor),
      languageCode: appGlobalState.appLocale?.languageCode,
      countryCode: appGlobalState.appLocale?.countryCode,
      gameInstallPaths: gameInstallPaths ?? [],
    );
  }

  static void runSubWindowApp(List<String> args) {
    final argument = args[2].isEmpty ? const {} : jsonDecode(args[2]) as Map<String, dynamic>;
    final windowAppState = MultiWindowAppState.fromJson(argument['app_state'] ?? {});
    Widget? windowWidget;
    switch (argument["window_type"]) {
      case "log_analyze":
        windowWidget = ToolsLogAnalyzeDialogUI(appState: windowAppState);
        break;
      default:
        throw Exception('Unknown window type');
    }
    return runApp(ProviderScope(
      child: FluentApp(
        title: "StarCitizenToolBox",
        restorationScopeId: "StarCitizenToolBox",
        themeMode: ThemeMode.dark,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FluentLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: windowWidget,
        theme: FluentThemeData(
            brightness: Brightness.dark,
            fontFamily: "SourceHanSansCN-Regular",
            navigationPaneTheme: NavigationPaneThemeData(
              backgroundColor: HexColor(windowAppState.backgroundColor),
            ),
            menuColor: HexColor(windowAppState.menuColor),
            micaBackgroundColor: HexColor(windowAppState.micaColor),
            buttonTheme: ButtonThemeData(
                defaultButtonStyle: ButtonStyle(
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.white.withValues(alpha: .01)))),
            ))),
        locale: windowAppState.languageCode != null
            ? Locale(windowAppState.languageCode!, windowAppState.countryCode)
            : null,
        debugShowCheckedModeBanner: false,
      ),
    ));
  }
}
