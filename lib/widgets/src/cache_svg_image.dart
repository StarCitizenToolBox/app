import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:starcitizen_doctor/common/utils/file_cache_utils.dart';

class CachedSvgImage extends HookWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CachedSvgImage(this.url, {super.key, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    final cachedFile = useState<File?>(null);
    final errorInfo = useState<String?>(null);

    useEffect(
      () {
        () async {
          try {
            cachedFile.value = await FileCacheUtils.getFile(url);
          } catch (e) {
            debugPrint("Error loading SVG: $e");
            errorInfo.value = "Error loading SVG: $e";
          }
        }();
        return null;
      },
      [url],
    );

    if (errorInfo.value != null) {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            errorInfo.value!,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return cachedFile.value != null
        ? SvgPicture.file(
            cachedFile.value!,
            width: width,
            height: height,
            fit: fit ?? BoxFit.contain,
          )
        : SizedBox(
            width: width,
            height: height,
            child: Center(
              child: ProgressRing(),
            ),
          );
  }
}
