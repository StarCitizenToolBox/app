import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/ui/nav/nav_state.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:starcitizen_doctor/widgets/widgets.dart';

class NavUI extends HookConsumerWidget {
  const NavUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Expanded(
            child: buildBody(context, ref),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: S.current.nav_third_party_service_disclaimer),
                  TextSpan(text: S.current.nav_website_navigation_data_provided_by),
                  TextSpan(
                    text: " 42kit ",
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrlString("https://42kit.citizenwiki.cn/nav");
                      },
                  ),
                  TextSpan(text: S.current.nav_provided_by),
                ]),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: .6),
                ),
              ),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context, WidgetRef ref) {
    final data = ref.watch(navProvider);
    if (data.errorInfo.isNotEmpty) {
      return Center(
        child: Text(
          data.errorInfo,
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    if (data.items == null) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProgressRing(),
          SizedBox(height: 12),
          Text(S.current.nav_fetching_data),
        ],
      ));
    }
    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: data.items!.length,
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
      itemBuilder: (BuildContext context, int index) {
        const itemHeight = 160.0;

        final item = data.items![index];
        final itemName = item.name;
        final itemImage = item.image.url;
        return GridItemAnimator(
          index: index,
          child: GestureDetector(
            onTap: () {
              launchUrlString(item.link);
            },
            child: Tilt(
              shadowConfig: const ShadowConfig(maxIntensity: .3),
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                height: itemHeight,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Center(
                        child: CacheNetImage(
                          height: itemHeight,
                          width: double.infinity,
                          url: itemImage,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .55),
                        ),
                      ),
                      ClipRect(
                        clipBehavior: Clip.hardEdge,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                          blendMode: BlendMode.srcOver,
                          child: SizedBox(
                            width: double.infinity,
                            height: itemHeight,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CacheNetImage(
                                    url: itemImage,
                                    height: 48,
                                    width: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    itemName,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Expanded(
                              child: Text(
                                item.abstract_,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white.withValues(alpha: .75)),
                              ),
                            ),
                            Row(
                              children: [
                                for (var value in item.tags)
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.withValues(alpha: .6),
                                        borderRadius: BorderRadius.circular(12)),
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                    margin: EdgeInsets.only(right: 6),
                                    child: Text(
                                      value.name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
