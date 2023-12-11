import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/main.dart';
import 'package:starcitizen_doctor/ui/about/about_ui.dart';
import 'package:starcitizen_doctor/ui/about/about_ui_model.dart';
import 'package:starcitizen_doctor/ui/home/home_ui.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui_model.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:window_manager/window_manager.dart';

import 'home/home_ui_model.dart';
import 'index_ui_model.dart';

class IndexUI extends BaseUI<IndexUIModel> {
  @override
  Widget? buildBody(BuildContext context, IndexUIModel model) {
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
                    const Text(
                        "SC汉化盒子  V${AppConf.appVersion} ${AppConf.isMSE ? "" : " +Dev"}")
                  ],
                ),
              ),
            );
          }(),
          actions: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [WindowButtons()],
          )),
      pane: NavigationPane(
        selected: model.curIndex,
        items: getNavigationPaneItems(model),
        size: const NavigationPaneSize(openWidth: 64),
      ),
      paneBodyBuilder: (item, child) {
        // final name =
        //     item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body_${model.curIndex}'),
          child: getPage(model),
        );
      },
    );
  }

  Widget getPage(IndexUIModel model) {
    switch (model.curIndex) {
      case 0:
        return BaseUIContainer(
            uiCreate: () => HomeUI(),
            modelCreate: () =>
                model.getChildUIModelProviders<HomeUIModel>("home"));
      case 1:
        return BaseUIContainer(
            uiCreate: () => ToolsUI(),
            modelCreate: () =>
                model.getChildUIModelProviders<ToolsUIModel>("tools"));
      case 2:
        return BaseUIContainer(
            uiCreate: () => SettingUI(),
            modelCreate: () =>
                model.getChildUIModelProviders<SettingUIModel>("settings"));
      case 3:
        return BaseUIContainer(
            uiCreate: () => AboutUI(),
            modelCreate: () =>
                model.getChildUIModelProviders<AboutUIModel>("about"));
    }
    return const SizedBox();
  }

  List<NavigationPaneItem> getNavigationPaneItems(IndexUIModel model) {
    final menus = {
      FluentIcons.home: "首页",
      FluentIcons.toolbox: "工具",
      FluentIcons.settings: "设置",
      FluentIcons.info: "关于",
    };
    return [
      for (final kv in menus.entries)
        PaneItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6, left: 4),
            child: Column(
              children: [
                Icon(kv.key, size: 18),
                const SizedBox(height: 3),
                Text(
                  kv.value,
                  style: const TextStyle(fontSize: 11),
                )
              ],
            ),
          ),
          // title: Text(kv.value),
          body: const SizedBox.shrink(),
          onTap: () {
            model.onIndexMenuTap(kv.value);
          },
        ),
    ];
  }

  @override
  String getUITitle(BuildContext context, IndexUIModel model) => "";
}
