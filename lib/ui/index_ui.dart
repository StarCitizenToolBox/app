import 'package:extended_image/extended_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/widgets/src/blur_oval_widget.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'about/about_ui.dart';
import 'home/home_ui.dart';

class IndexUI extends HookConsumerWidget {
  const IndexUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // pre init child
    ref.watch(homeUIModelProvider.select((value) => null));
    // ref.watch(settingsUIModelProvider.select((value) => null));
    final globalState = ref.watch(appGlobalModelProvider);

    final curIndex = useState(0);
    return Stack(
      children: [
        ExtendedImage.asset(
          width: double.infinity,
          height: double.infinity,
          globalState.backgroundImageAssetsPath,
          fit: BoxFit.cover,
        ),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BlurOvalWidget(
              child: Container(
                constraints:
                    const BoxConstraints(maxWidth: 1440, maxHeight: 920),
                child: NavigationView(
                  appBar: NavigationAppBar(
                    automaticallyImplyLeading: false,
                    title: () {
                      return Align(
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
                                ConstConf.appVersion,
                                ConstConf.isMSE ? "" : " Dev")),
                          ],
                        ),
                      );
                    }(),
                  ),
                  pane: NavigationPane(
                    key: Key("NavigationPane_${S.current.app_language_code}"),
                    selected: curIndex.value,
                    items: getNavigationPaneItems(curIndex),
                    size: NavigationPaneSize(
                        openWidth: S.current.app_language_code.startsWith("zh")
                            ? 64
                            : 74),
                  ),
                  paneBodyBuilder: (item, child) {
                    return item!.body;
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Map<IconData, (String, Widget)> get pageMenus => {
        FluentIcons.home: (
          S.current.app_index_menu_home,
          const HomeUI(),
        ),
        FluentIcons.toolbox: (
          S.current.app_index_menu_tools,
          const SizedBox(),
        ),
        FluentIcons.settings: (
          S.current.app_index_menu_settings,
          const SizedBox()
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
}
