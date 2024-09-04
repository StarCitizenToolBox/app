import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:ui' as ui;

export 'src/cache_image.dart';
export 'src/countdown_time_text.dart';
export '../common/utils/async.dart';
export '../common/utils/base_utils.dart';
export 'package:starcitizen_doctor/generated/l10n.dart';

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
    String title = "",
    bool useBodyContainer = false}) {
  return NavigationView(
    appBar: NavigationAppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: Column(
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
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [...?actions],
        )),
    content: useBodyContainer
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
            ),
            child: content,
          )
        : content,
  );
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
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const ProgressRing(),
                          const SizedBox(height: 12),
                          Text(S.current.app_common_loading_images)
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
      transitionDuration: const Duration(milliseconds: 150),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: const Offset(0.0, 0.0),
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      });
}

class LoadingWidget<T> extends HookConsumerWidget {
  final T? data;
  final Future<T?> Function()? onLoadData;
  final Widget Function(BuildContext context, T data) childBuilder;
  final Duration? autoRefreshDuration;

  const LoadingWidget(
      {super.key,
      this.data,
      required this.childBuilder,
      this.onLoadData,
      this.autoRefreshDuration});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = useState<T?>(null);
    final errorMsg = useState("");
    useEffect(() {
      if (data == null && onLoadData != null) {
        _loadData(dataState, errorMsg);
      }
      if (autoRefreshDuration != null) {
        final timer = Timer.periodic(autoRefreshDuration!, (timer) {
          if (onLoadData != null) {
            _loadData(dataState, errorMsg);
          }
        });
        return timer.cancel;
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

addPostFrameCallback(Function() callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}
