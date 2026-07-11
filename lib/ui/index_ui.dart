import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/provider/download_manager.dart';
import 'package:starcitizen_doctor/ui/home/home_ui_model.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:window_manager/window_manager.dart';
import 'about/about_ui.dart';
import 'home/home_ui.dart';
import 'nav/nav_ui.dart';
import 'party_room/party_room_ui_model.dart';
import 'settings/settings_ui.dart';
import 'tools/tools_ui.dart';
import 'index_ui_widgets/user_avatar_widget.dart';
import 'package:starcitizen_doctor/common/utils/url_scheme_handler.dart';

class IndexUI extends HookConsumerWidget {
  const IndexUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appGlobalModelProvider);
    // pre init child

    ref.watch(homeUIModelProvider.select((value) => null));
    ref.watch(settingsUIModelProvider.select((value) => null));
    ref.watch(partyRoomUIModelProvider.select((value) => null));

    final curIndex = useState(0);

    // Initialize URL scheme handler
    useEffect(() {
      UrlSchemeHandler().initialize(context);
      return () => UrlSchemeHandler().dispose();
    }, const []);

    return NavigationView(
      titleBar: _makeTitleBar(context, curIndex),
      content: Row(
        children: [
          _makeNavigationBar(curIndex),
          Expanded(child: pageMenus.values.elementAt(curIndex.value).$2),
        ],
      ),
    );
  }

  Widget _makeTitleBar(BuildContext context, ValueNotifier<int> curIndex) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: kTitleBarContentLeftPadding),
          Expanded(
            child: DragToMoveArea(
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
                    Text(
                      S.current.app_index_version_info(
                        ConstConf.appVersion,
                        ConstConf.isMSE ? "" : " Dev",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          UserAvatarWidget(
            onTapNavigateToPartyRoom: () => _navigateToPartyRoom(curIndex),
          ),
          const SizedBox(width: 12),
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
                _makeDownloadTaskNumWidget(),
              ],
            ),
            onPressed: () => _goDownloader(context),
          ),
          const SizedBox(width: 24),
          const WindowButtons(),
        ],
      ),
    );
  }

  Widget _makeNavigationBar(ValueNotifier<int> curIndex) {
    final menus = pageMenus.entries.toList();

    return Container(
      width: 78,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: .04)),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: menus.length,
          separatorBuilder: (_, _) => const SizedBox(height: 2),
          itemBuilder: (context, index) {
            final menu = menus[index];
            final selected = curIndex.value == index;
            return _makeNavigationItem(
              context,
              icon: menu.key,
              title: menu.value.$1,
              selected: selected,
              onTap: () => curIndex.value = index,
            );
          },
        ),
      ),
    );
  }

  Widget _makeNavigationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final accentColor = FluentTheme.of(context).accentColor;
    final theme = FluentTheme.of(context);
    final navTheme = NavigationPaneTheme.of(context);

    return HoverButton(
      onPressed: onTap,
      builder: (context, states) {
        final tileStates = selected
            ? {
                if (states.contains(WidgetState.hovered))
                  WidgetState.pressed
                else
                  WidgetState.hovered,
              }
            : states;
        final tileColor =
            (navTheme.tileColor ?? kDefaultPaneItemColor(context, false))
                .resolve(tileStates);
        final textStyle =
            (selected
                    ? navTheme.selectedTextStyle
                    : navTheme.unselectedTextStyle)
                ?.resolve(states);
        final iconColor =
            textStyle?.color ??
            (selected
                    ? navTheme.selectedIconColor
                    : navTheme.unselectedIconColor)
                ?.resolve(states);

        return Semantics(
          label: title,
          selected: selected,
          child: AnimatedContainer(
            duration: theme.fastAnimationDuration,
            curve: theme.animationCurve,
            height: 56,
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconTheme.merge(
              data: IconThemeData(color: iconColor),
              child: FocusBorder(
                focused: states.contains(WidgetState.focused),
                renderOutside: false,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedPositionedDirectional(
                      duration: theme.fastAnimationDuration,
                      curve: theme.animationCurve,
                      start: selected ? 0 : -3,
                      top: selected ? 10 : 23,
                      bottom: selected ? 10 : 23,
                      child: AnimatedContainer(
                        duration: theme.fastAnimationDuration,
                        curve: theme.animationCurve,
                        width: 3,
                        decoration: BoxDecoration(
                          color: selected
                              ? (navTheme.highlightColor ?? accentColor)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 22),
                        const SizedBox(height: 3),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              title,
                              maxLines: 1,
                              style: (textStyle ?? const TextStyle()).copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Map<IconData, (String, Widget)> get pageMenus => {
    FluentIcons.home: (S.current.app_index_menu_home, const HomeUI()),
    FluentIcons.game: (S.current.app_index_menu_lobby, const PartyRoomUI()),
    FluentIcons.toolbox: (S.current.app_index_menu_tools, const ToolsUI()),
    FluentIcons.power_apps: ((S.current.nav_title), const NavUI()),
    FluentIcons.settings: (
      S.current.app_index_menu_settings,
      const SettingsUI(),
    ),
    FluentIcons.info: (S.current.app_index_menu_about, const AboutUI()),
  };

  Widget _makeDownloadTaskNumWidget() {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final downloadState = ref.watch(downloadManagerProvider);
        if (!downloadState.hasDownloadTask) {
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
              left: 6,
              right: 6,
              bottom: 1.5,
              top: 1.5,
            ),
            child: Text(
              "${downloadState.totalTaskNum}",
              style: const TextStyle(fontSize: 8, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _goDownloader(BuildContext context) {
    context.push('/index/downloader');
  }

  void _navigateToPartyRoom(ValueNotifier<int> curIndexState) {
    // 查找 PartyRoomUI 在菜单中的索引
    final partyRoomIndex = pageMenus.values.toList().indexWhere(
      (element) => element.$2 is PartyRoomUI,
    );
    if (partyRoomIndex >= 0) {
      curIndexState.value = partyRoomIndex;
    }
  }
}
