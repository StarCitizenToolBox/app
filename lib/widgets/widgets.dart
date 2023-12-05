import 'package:extended_image/extended_image.dart';
import 'dart:ui' as ui;

import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../base/ui.dart';

Widget makeLoading(
  BuildContext context, {
  double? width,
}) {
  width ??= 30;
  return Center(
    child: SizedBox(
      width: width,
      height: width,
      // child: Lottie.asset("images/lottie/loading.zip", width: width),
      child: const ProgressRing(),
    ),
  );
}

Widget makeSafeAre(BuildContext context, {bool withKeyboard = true}) {
  return SafeArea(
      child: Column(
    children: [
      const SizedBox(height: 4),
      if (withKeyboard)
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        ),
    ],
  ));
}

makeSvgColor(Color color) {
  return ui.ColorFilter.mode(color, ui.BlendMode.srcIn);
}

bool isPadUI(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return size.width >= size.height;
}

fastPadding(
    {required double? all,
    required Widget child,
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0}) {
  return Padding(
      padding: all != null
          ? EdgeInsets.all(all)
          : EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      child: child);
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

class NoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
