import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/provider/aria2c.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:window_manager/window_manager.dart';

import 'about/about_ui.dart';
import 'home/home_ui.dart';
import 'settings/settings_ui.dart';
import 'tools/tools_ui.dart';

class IndexUI extends HookConsumerWidget {
  const IndexUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // pre init child
    ref.watch(homeUIModelProvider.select((value) => null));
    ref.watch(settingsUIModelProvider.select((value) => null));
    ref.watch(appGlobalModelProvider);

    final curIndex = useState(0);
    return NavigationView(
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          title: () {
            return DragToMoveArea(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/app_logo_mini.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 12),
                    Text(S.current.app_index_version_info(
                        ConstConf.appVersion, ConstConf.isMSE ? "" : " Dev")),
                  ],
                ),
              ),
            );
          }(),
          actions: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        FluentIcons.installation,
                        size: 22,
                        color: Colors.white.withValues(alpha: .6),
                      ),
                    ),
                    _makeAria2TaskNumWidget()
                  ],
                ),
                onPressed: () => _goDownloader(context),
                // onPressed: model.goDownloader
              ),
              const SizedBox(width: 24),
              const WindowButtons()
            ],
          )),
      pane: NavigationPane(
        key: Key("NavigationPane_${S.current.app_language_code}"),
        selected: curIndex.value,
        items: getNavigationPaneItems(curIndex),
        size: NavigationPaneSize(
            openWidth: S.current.app_language_code.startsWith("zh") ? 64 : 74),
      ),
      paneBodyBuilder: (item, child) {
        return item!.body;
      },
    );
  }

  Map<IconData, (String, Widget)> get pageMenus => {
        FluentIcons.home: (
          S.current.app_index_menu_home,
          const HomeUI(),
        ),
        FluentIcons.toolbox: (
          S.current.app_index_menu_tools,
          const ToolsUI(),
        ),
        FluentIcons.settings: (
          S.current.app_index_menu_settings,
          const SettingsUI()
        ),
        FluentIcons.info: (
          S.current.app_index_menu_about,
          const AboutUI(),
        ),
      };

  List<NavigationPaneItem> getNavigationPaneItems(
      ValueNotifier<int> curIndexState) {
    // width = 64
    return [
      for (final kv in pageMenus.entries)
        PaneItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: SizedBox(
              width: S.current.app_language_code.startsWith("zh") ? 32 : 42,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(kv.key, size: 18),
                  const SizedBox(height: 3),
                  Text(
                    kv.value.$1,
                    style: const TextStyle(fontSize: 11),
                  )
                ],
              ),
            ),
          ),
          // title: Text(kv.value),
          body: kv.value.$2,
          onTap: () => _onTapIndexMenu(kv.value.$1, curIndexState),
        ),
    ];
  }

  void _onTapIndexMenu(String value, ValueNotifier<int> curIndexState) {
    final pageIndex =
        pageMenus.values.toList().indexWhere((element) => element.$1 == value);
    curIndexState.value = pageIndex;
  }

  Widget _makeAria2TaskNumWidget() {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final aria2cState = ref.watch(aria2cModelProvider);
        if (!aria2cState.hasDownloadTask) {
          return const SizedBox();
        }
        return Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(
                  left: 6, right: 6, bottom: 1.5, top: 1.5),
              child: Text(
                "${aria2cState.aria2TotalTaskNum}",
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
            ));
      },
    );
  }

  _goDownloader(BuildContext context) {
    context.push('/index/downloader');
  }
}
