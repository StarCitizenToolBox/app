import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starcitizen_doctor/main.dart';
import 'package:starcitizen_doctor/widgets/my_page_route.dart';
import 'package:window_manager/window_manager.dart';
import '../common/utils/log.dart' as log_utils;

import 'dart:ui' as ui;

import 'ui_model.dart';

export '../common/utils/base_utils.dart';
export '../widgets/widgets.dart';
export 'package:fluent_ui/fluent_ui.dart';

class BaseUIContainer extends ConsumerStatefulWidget {
  final ConsumerState<BaseUIContainer> Function() uiCreate;
  final dynamic Function() modelCreate;

  const BaseUIContainer(
      {super.key, required this.uiCreate, required this.modelCreate});

  @override
  // ignore: no_logic_in_create_state
  ConsumerState<BaseUIContainer> createState() => uiCreate();

  Future push(BuildContext context) {
    return Navigator.push(context, makeRoute(context));
  }

// Future pushShowModalBottomSheet(BuildContext context) {
//   return showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (BuildContext context) {
//       return this;
//     },
//   );
// }

  /// 获取路由
  FluentPageRoute makeRoute(BuildContext context) {
    return MyPageRoute(
      builder: (BuildContext context) {
        return this;
      },
    );
  }

// Future pushAndRemoveUntil(BuildContext context) {
//   return Navigator.pushAndRemoveUntil(context,
//       MaterialPageRoute(builder: (BuildContext context) {
//     return this;
//   }), (_) => false);
// }
}

abstract class BaseUI<T extends BaseUIModel>
    extends ConsumerState<BaseUIContainer> {
  BaseUIModel? _needDisposeModel;
  late final ChangeNotifierProvider<T> provider = bindUIModel();

  // final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  // RefreshController? refreshController;

  @override
  Widget build(BuildContext context) {
    // get model
    final model = ref.watch(provider);
    return buildBody(context, model)!;
  }

  String getUITitle(BuildContext context, T model);

  Widget? buildBody(
    BuildContext context,
    T model,
  );

  Widget? getBottomNavigationBar(BuildContext context, T model) => null;

  Color? getBackgroundColor(BuildContext context, T model) => null;

  Widget? getFloatingActionButton(BuildContext context, T model) => null;

  bool getDrawerEnableOpenDragGesture(BuildContext context, T model) => true;

  Widget? getDrawer(BuildContext context, T model) => null;

  Widget makeDefaultPage(BuildContext context, T model,
      {Widget? titleRow,
      List<Widget>? actions,
      Widget? content,
      bool automaticallyImplyLeading = true}) {
    return NavigationView(
      pane: NavigationPane(
        size: const NavigationPaneSize(openWidth: 0),
      ),
      appBar: NavigationAppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: DragToMoveArea(
            child: titleRow ??
                Column(children: [Expanded(
                  child: Row(
                    children: [
                      Text(getUITitle(context, model)),
                    ],
                  ),
                )],),
          ),
          actions: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [...?actions, const WindowButtons()],
          )),
      paneBodyBuilder: (
        PaneItem? item,
        Widget? body,
      ) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: content ?? makeLoading(context),
        );
      },
    );
  }

  @mustCallSuper
  @override
  void initState() {
    dPrint("[base] <$runtimeType> UI Init");
    super.initState();
  }

  @mustCallSuper
  @override
  void dispose() {
    dPrint("[base] <$runtimeType> UI Disposed");
    _needDisposeModel?.dispose();
    _needDisposeModel = null;
    super.dispose();
  }

  /// 关闭键盘
  dismissKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }


  // void updateStatusBarIconColor(BuildContext context) {
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarBrightness: Theme.of(context).brightness,
  //     statusBarIconBrightness: getAndroidIconBrightness(context),
  //   ));
  // }

  ChangeNotifierProvider<T> bindUIModel() {
    final createdModel = widget.modelCreate();
    if (createdModel is T) {
      _needDisposeModel = createdModel;
      return ChangeNotifierProvider<T>((ref) {
        return createdModel..context = context;
      });
    }
    return createdModel;
  }

// Widget pullToRefreshBody(
//     {required BaseUIModel model, required Widget child}) {
//   refreshController ??= RefreshController();
//   return AppSmartRefresher(
//     enablePullUp: false,
//     controller: refreshController,
//     onRefresh: () async {
//       await model.reloadData();
//       refreshController?.refreshCompleted();
//     },
//     child: child,
//   );
// }

  makeSvgColor(Color color, {BlendMode blendMode = BlendMode.color}) {
    return ui.ColorFilter.mode(color, blendMode);
  }

  dPrint(src) {
    log_utils.dPrint("<$runtimeType> $src");
  }
}
