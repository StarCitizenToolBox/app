import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/ui/tools/log_analyze_ui/log_analyze_ui.dart';
import 'package:window_manager/window_manager.dart';

import 'base_utils.dart';

part 'multi_window_manager.freezed.dart';

part 'multi_window_manager.g.dart';

/// Window type definitions for multi-window support
class WindowTypes {
  /// Main application window
  static const String main = 'main';

  /// Log analyzer window
  static const String logAnalyze = 'log_analyze';
}

@freezed
abstract class MultiWindowAppState with _$MultiWindowAppState {
  const factory MultiWindowAppState({
    required String backgroundColor,
    required String menuColor,
    required String micaColor,
    required List<String> gameInstallPaths,
    String? languageCode,
    String? countryCode,
    @Default(10) windowsVersion,
  }) = _MultiWindowAppState;

  factory MultiWindowAppState.fromJson(Map<String, dynamic> json) => _$MultiWindowAppStateFromJson(json);
}

class MultiWindowManager {
  /// Parse window type from arguments string
  static String parseWindowType(String arguments) {
    if (arguments.isEmpty) {
      return WindowTypes.main;
    }
    try {
      final Map<String, dynamic> argument = jsonDecode(arguments);
      return argument['window_type'] ?? WindowTypes.main;
    } catch (e) {
      return WindowTypes.main;
    }
  }

  /// Launch a sub-window with specified type and title
  static Future<void> launchSubWindow(String type, String title, AppGlobalState appGlobalState) async {
    final gameInstallPaths = await SCLoggerHelper.getGameInstallPath(
      await SCLoggerHelper.getLauncherLogList() ?? [],
      checkExists: true,
      withVersion: AppConf.gameChannels,
    );

    final controller = await WindowController.create(
      WindowConfiguration(
        hiddenAtLaunch: true,
        arguments: jsonEncode({
          'window_type': type,
          'app_state': _appStateToWindowState(appGlobalState, gameInstallPaths: gameInstallPaths).toJson(),
        }),
      ),
    );
    await Future.delayed(Duration(milliseconds: 500)).then((_) async {
      await controller.setFrame(const Rect.fromLTWH(0, 0, 800, 1200));
      await controller.setTitle(title);
      await controller.center();
      await controller.show();
    });
  }

  static MultiWindowAppState _appStateToWindowState(AppGlobalState appGlobalState, {List<String>? gameInstallPaths}) {
    return MultiWindowAppState(
      backgroundColor: colorToHexCode(appGlobalState.themeConf.backgroundColor),
      menuColor: colorToHexCode(appGlobalState.themeConf.menuColor),
      micaColor: colorToHexCode(appGlobalState.themeConf.micaColor),
      languageCode: appGlobalState.appLocale?.languageCode,
      countryCode: appGlobalState.appLocale?.countryCode,
      gameInstallPaths: gameInstallPaths ?? [],
      windowsVersion: appGlobalState.windowsVersion,
    );
  }

  /// Run sub-window app with parsed arguments
  static Future<void> runSubWindowApp(String arguments, String windowType) async {
    final Map<String, dynamic> argument = arguments.isEmpty ? const {} : jsonDecode(arguments);
    final windowAppState = MultiWindowAppState.fromJson(argument['app_state'] ?? {});
    Widget? windowWidget;

    switch (windowType) {
      case WindowTypes.logAnalyze:
        windowWidget = ToolsLogAnalyzeDialogUI(appState: windowAppState);
        break;
      default:
        throw Exception('Unknown window type: $windowType');
    }

    await Window.initialize();

    if (windowAppState.windowsVersion >= 10) {
      await Window.setEffect(effect: WindowEffect.acrylic);
    }

    final backgroundColor = HexColor(windowAppState.backgroundColor).withValues(alpha: .1);

    return runApp(
      ProviderScope(
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
            navigationPaneTheme: NavigationPaneThemeData(backgroundColor: backgroundColor),
            menuColor: HexColor(windowAppState.menuColor),
            micaBackgroundColor: HexColor(windowAppState.micaColor),
            scaffoldBackgroundColor: backgroundColor,
            buttonTheme: ButtonThemeData(
              defaultButtonStyle: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.white.withValues(alpha: .01)),
                  ),
                ),
              ),
            ),
          ),
          locale: windowAppState.languageCode != null
              ? Locale(windowAppState.languageCode!, windowAppState.countryCode)
              : null,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

/// Extension methods for WindowController to add custom functionality
extension WindowControllerExtension on WindowController {
  /// Initialize custom window method handlers
  Future<void> doCustomInitialize() async {
    windowManager.ensureInitialized();
    return await setWindowMethodHandler((call) async {
      switch (call.method) {
        case 'window_center':
          return await windowManager.center();
        case 'window_close':
          return await windowManager.close();
        case 'window_show':
          return await windowManager.show();
        case 'window_hide':
          return await windowManager.hide();
        case 'window_focus':
          return await windowManager.focus();
        case 'window_set_frame':
          final args = call.arguments as Map;
          return await windowManager.setBounds(
            Rect.fromLTWH(
              args['left'] as double,
              args['top'] as double,
              args['width'] as double,
              args['height'] as double,
            ),
          );
        case 'window_set_title':
          return await windowManager.setTitle(call.arguments as String);
        default:
          throw MissingPluginException('Not implemented: ${call.method}');
      }
    });
  }

  /// Center the window
  Future<void> center() {
    return invokeMethod('window_center');
  }

  /// Close the window
  void close() async {
    await invokeMethod('window_close');
  }

  /// Show the window
  Future<void> show() {
    return invokeMethod('window_show');
  }

  /// Hide the window
  Future<void> hide() {
    return invokeMethod('window_hide');
  }

  /// Focus the window
  Future<void> focus() {
    return invokeMethod('window_focus');
  }

  /// Set window frame (position and size)
  Future<void> setFrame(Rect frame) {
    return invokeMethod('window_set_frame', {
      'left': frame.left,
      'top': frame.top,
      'width': frame.width,
      'height': frame.height,
    });
  }

  /// Set window title
  Future<void> setTitle(String title) {
    return invokeMethod('window_set_title', title);
  }
}
