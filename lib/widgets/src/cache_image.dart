import 'package:extended_image/extended_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

import 'cache_svg_image.dart';

class CacheNetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CacheNetImage({super.key, required this.url, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    if (url.endsWith(".svg")) {
      return CachedSvgImage(url, width: width, height: height, fit: fit ?? BoxFit.contain);
    }
    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      fit: fit,
      headers: {
        "User-Agent":
            "SCToolBox/${ConstConf.appVersion} (${ConstConf.appVersionCode})${ConstConf.isMSE ? "" : " DEV"} RSHttp",
      },
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return SizedBox(
              width: width,
              height: height,
              child: Center(child: ProgressRing()),
            );
          case LoadState.failed:
            dPrint("Failed to load image from $url: ${state.lastException} ${state.lastStack}");
            return const Text("Loading Image error");
          case LoadState.completed:
            return null;
        }
      },
    );
  }
}
