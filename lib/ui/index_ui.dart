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
    // Remember the previously selected tab so the indicator knows which way
    // to flow, like NavigationPane's StickyNavigationIndicator did.
    final lastIndex = useRef(curIndex.value);
    final previousIndex = useRef(curIndex.value);
    if (lastIndex.value != curIndex.value) {
      previousIndex.value = lastIndex.value;
      lastIndex.value = curIndex.value;
    }

    // Initialize URL scheme handler
    useEffect(() {
      UrlSchemeHandler().initialize(context);
      return () => UrlSchemeHandler().dispose();
    }, const []);

    return NavigationView(
      titleBar: _makeTitleBar(context, curIndex),
      content: Row(
        children: [
          _makeNavigationBar(curIndex, previousIndex.value),
          Expanded(
            child: _makeContentPanel(
              context,
              KeyedSubtree(
                key: ValueKey(curIndex.value),
                child: pageMenus.values.elementAt(curIndex.value).$2,
              ),
            ),
          ),
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

  /// Restores the content surface NavigationPane used to draw before the
  /// custom navigation bar: scaffold fill, rounded top-left corner and the
  /// card stroke, instead of a divider line next to the navigation bar.
  Widget _makeContentPanel(BuildContext context, Widget child) {
    final theme = FluentTheme.of(context);
    final shape = RoundedRectangleBorder(
      side: BorderSide(color: theme.resources.cardStrokeColorDefault),
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
    );
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: ShapeDecoration(shape: shape),
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: ColoredBox(
          color: theme.scaffoldBackgroundColor,
          // Same page switch animation NavigationBody used to provide.
          child: AnimatedSwitcher(
            switchInCurve: theme.animationCurve,
            switchOutCurve: theme.animationCurve,
            duration: theme.fastAnimationDuration,
            reverseDuration: theme.fastAnimationDuration ~/ 2,
            layoutBuilder: (child, children) => SizedBox(child: child),
            transitionBuilder: (child, animation) =>
                EntrancePageTransition(animation: animation, child: child),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _makeNavigationBar(ValueNotifier<int> curIndex, int previousIndex) {
    final menus = pageMenus.entries.toList();

    return SizedBox(
      width: 78,
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
              indicator: _StickyNavIndicator(
                itemIndex: index,
                selectedIndex: curIndex.value,
                previousIndex: previousIndex,
              ),
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
    required Widget indicator,
    required VoidCallback onTap,
  }) {
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
                    Positioned.fill(child: indicator),
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

/// Port of fluent_ui's StickyNavigationIndicator for the custom navigation
/// bar: the old tab's bar shrinks towards the new tab during the first half,
/// then the new tab's bar grows out from the old tab's side.
class _StickyNavIndicator extends StatefulWidget {
  const _StickyNavIndicator({
    required this.itemIndex,
    required this.selectedIndex,
    required this.previousIndex,
  });

  final int itemIndex;
  final int selectedIndex;
  final int previousIndex;

  static const double _padding = 10;
  static const double _size = 3;

  @override
  State<_StickyNavIndicator> createState() => _StickyNavIndicatorState();
}

class _StickyNavIndicatorState extends State<_StickyNavIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _shrinkController = AnimationController(
    vsync: this,
  );
  late final AnimationController _growController = AnimationController(
    vsync: this,
    value: 1,
  );
  bool _goingDown = true;

  bool get _isSelected => widget.itemIndex == widget.selectedIndex;

  bool get _isPrevious =>
      widget.itemIndex == widget.previousIndex &&
      widget.previousIndex != widget.selectedIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration = FluentTheme.of(context).slowAnimationDuration;
    _shrinkController.duration = duration;
    _growController.duration = duration;
  }

  @override
  void didUpdateWidget(_StickyNavIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex) return;
    _goingDown = widget.previousIndex > widget.selectedIndex;
    if (_isSelected) {
      _growController.forward(from: 0);
    } else if (_isPrevious) {
      _shrinkController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shrinkController.dispose();
    _growController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final color =
        NavigationPaneTheme.of(context).highlightColor ?? theme.accentColor;
    final curve = theme.animationCurve;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge([_shrinkController, _growController]),
        builder: (context, child) {
          var top = _StickyNavIndicator._padding;
          var bottom = _StickyNavIndicator._padding;
          if (_isSelected) {
            final progress = CurvedAnimation(
              parent: _growController,
              curve: Interval(0.5, 1, curve: curve),
            ).value;
            if (progress == 0) return const SizedBox.shrink();
            if (_goingDown) {
              bottom = _StickyNavIndicator._padding * progress;
            } else {
              top = _StickyNavIndicator._padding * progress;
            }
          } else if (_isPrevious && _shrinkController.isAnimating) {
            final progress = CurvedAnimation(
              parent: _shrinkController,
              curve: Interval(0, 0.5, curve: curve),
            ).value;
            if (progress == 1) return const SizedBox.shrink();
            if (_goingDown) {
              top = _StickyNavIndicator._padding * (1 - progress);
            } else {
              bottom = _StickyNavIndicator._padding * (1 - progress);
            }
          } else {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: EdgeInsetsDirectional.only(top: top, bottom: bottom),
            child: child,
          );
        },
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: _StickyNavIndicator._size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
