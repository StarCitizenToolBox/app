import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:window_manager/window_manager.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:ui' as ui;

export 'src/cache_image.dart';
export 'src/countdown_time_text.dart';
export '../common/utils/base_utils.dart';

Widget makeLoading(
  BuildContext context, {
  double? width,
}) {
  width ??= 30;
  return Center(
    child: SizedBox(
      width: width,
      height: width,
      child: const ProgressRing(),
    ),
  );
}

Widget makeDefaultPage(BuildContext context,
    {Widget? titleRow,
    List<Widget>? actions,
    Widget? content,
    bool automaticallyImplyLeading = true,
    String title = ""}) {
  return NavigationView(
    appBar: NavigationAppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: DragToMoveArea(
          child: titleRow ??
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(title),
                      ],
                    ),
                  )
                ],
              ),
        ),
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [...?actions, const WindowButtons()],
        )),
    content: content,
  );
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);
    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

List<Widget> makeMarkdownView(String description, {String? attachmentsUrl}) {
  return MarkdownGenerator().buildWidgets(description,
      config: MarkdownConfig(configs: [
        LinkConfig(onTap: (url) {
          if (url.startsWith("/") && attachmentsUrl != null) {
            url = "$attachmentsUrl/$url";
          }
          launchUrlString(url);
        }),
        ImgConfig(builder: (String url, Map<String, String> attributes) {
          if (url.startsWith("/") && attachmentsUrl != null) {
            url = "$attachmentsUrl/$url";
          }
          return ExtendedImage.network(
            url,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ProgressRing(),
                          SizedBox(
                            height: 12,
                          ),
                          Text("加载图片...")
                        ],
                      ),
                    ),
                  );
                case LoadState.completed:
                  return ExtendedRawImage(
                    image: state.extendedImageInfo?.image,
                  );
                case LoadState.failed:
                  return Text("Loading Image error $url");
              }
            },
          );
        })
      ]));
}

ColorFilter makeSvgColor(Color color) {
  return ui.ColorFilter.mode(color, ui.BlendMode.srcIn);
}

CustomTransitionPage<T> myPageBuilder<T>(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
      child: child,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return Semantics(
          scopesRoute: true,
          explicitChildNodes: true,
          child: EntrancePageTransition(
            animation: CurvedAnimation(
              parent: animation,
              curve: FluentTheme.of(context).animationCurve,
            ),
            child: child,
          ),
        );
      });
}

class LoadingWidget<T> extends HookConsumerWidget {
  final T? data;
  final Future<T?> Function()? onLoadData;
  final Widget Function(BuildContext context, T data) childBuilder;

  const LoadingWidget(
      {super.key, this.data, required this.childBuilder, this.onLoadData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = useState<T?>(null);
    final errorMsg = useState("");
    useEffect(() {
      if (data == null && onLoadData != null) {
        _loadData(dataState, errorMsg);
        return null;
      }
      return null;
    }, const []);

    if (errorMsg.value.isNotEmpty) {
      return Button(
        onPressed: () {
          _loadData(dataState, errorMsg);
        },
        child: Center(
          child: Text(errorMsg.value),
        ),
      );
    }
    if (dataState.value == null && data == null) return makeLoading(context);
    return childBuilder(context, (data ?? dataState.value) as T);
  }

  void _loadData(
      ValueNotifier<T?> dataState, ValueNotifier<String> errorMsg) async {
    errorMsg.value = "";
    try {
      final r = await onLoadData!();
      dataState.value = r;
    } catch (e) {
      errorMsg.value = e.toString();
    }
  }
}
