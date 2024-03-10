import 'package:extended_image/extended_image.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CacheNetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CacheNetImage(
      {super.key, required this.url, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ProgressRing(),
                  ],
                ),
              ),
            );
          case LoadState.failed:
            return const Text("Loading Image error");
          case LoadState.completed:
            return null;
        }
      },
    );
  }
}
