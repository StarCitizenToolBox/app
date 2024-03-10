import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/provider/aria2c.dart';
import 'package:starcitizen_doctor/ui/home/home_ui.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:window_manager/window_manager.dart';

class IndexUI extends HookConsumerWidget {
  const IndexUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // pre init child
    ref.watch(homeUIModelProvider.select((value) => null));

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
                    const Text(
                        "SC汉化盒子  V${ConstConf.appVersion} ${ConstConf.isMSE ? "" : " Dev"}")
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
                        color: Colors.white.withOpacity(.6),
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
        selected: curIndex.value,
        items: getNavigationPaneItems(curIndex),
        size: const NavigationPaneSize(openWidth: 64),
      ),
      paneBodyBuilder: (item, child) {
        return FocusTraversalGroup(
          key: ValueKey('body_$curIndex'),
          child: getPage(curIndex.value),
        );
      },
    );
  }

  Map<IconData, String> get pageMenus => {
        FluentIcons.home: "首页",
        FluentIcons.game: "大厅",
        FluentIcons.toolbox: "工具",
        FluentIcons.settings: "设置",
        FluentIcons.info: "关于",
      };

  List<NavigationPaneItem> getNavigationPaneItems(
      ValueNotifier<int> curIndexState) {
    return [
      for (final kv in pageMenus.entries)
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
          onTap: () => _onTapIndexMenu(kv.value, curIndexState),
        ),
    ];
  }

  Widget getPage(int value) {
    switch (value) {
      case 0:
        return const HomeUI();
      case 1:
        return const PartyRoomUI();
      case 2:
        return const ToolsUI();
      default:
        return Center(
          child: Text("UnimplPage $value"),
        );
    }
  }

  void _onTapIndexMenu(String value, ValueNotifier<int> curIndexState) {
    final pageIndex =
        pageMenus.values.toList().indexWhere((element) => element == value);
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
