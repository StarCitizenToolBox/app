import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:window_manager/window_manager.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/widget/all.dart';
import 'package:extended_image/extended_image.dart';

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
