import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/widgets/cache_image.dart';
import 'package:starcitizen_doctor/widgets/countdown_time_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'home_ui_model.dart';

class HomeUI extends BaseUI<HomeUIModel> {
  @override
  Widget? buildBody(BuildContext context, HomeUIModel model) {
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (model.appPlacardData != null) ...[
                  InfoBar(
                    title: Text("${model.appPlacardData?.title}"),
                    content: Text("${model.appPlacardData?.content}"),
                    severity: InfoBarSeverity.info,
                    action: model.appPlacardData?.link == null
                        ? null
                        : Button(
                            child: const Text('查看详情'),
                            onPressed: () => model.showPlacard(),
                          ),
                    onClose: model.appPlacardData?.alwaysShow == true
                        ? null
                        : () => model.closePlacard(),
                  ),
                  const SizedBox(height: 6),
                ],
                ...makeIndex(context, model)
              ],
            ),
          ),
        ),
        if (model.isFixing)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(150),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProgressRing(),
                  const SizedBox(height: 12),
                  Text(model.isFixingString.isNotEmpty
                      ? model.isFixingString
                      : "正在处理..."),
                ],
              ),
            ),
          )
      ],
    );
  }

  List<Widget> makeIndex(BuildContext context, HomeUIModel model) {
    const double width = 280;
    return [
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 64, bottom: 0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Image.asset(
                        "assets/sc_logo.png",
                        fit: BoxFit.fitHeight,
                        height: 260,
                      ),
                    ),
                    makeGameStatusCard(context, model, 340)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 24,
            child: makeLeftColumn(context, model, width),
          ),
          Positioned(
            right: 24,
            top: 0,
            child: makeNewsCard(context, model),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("安装位置："),
            const SizedBox(width: 6),
            Expanded(
              child: ComboBox<String>(
                value: model.scInstalledPath,
                items: [
                  const ComboBoxItem(
                    value: "not_install",
                    child: Text("未安装 或 安装失败"),
                  ),
                  for (final path in model.scInstallPaths)
                    ComboBoxItem(
                      value: path,
                      child: Text(path),
                    )
                ],
                onChanged: (v) {
                  model.scInstalledPath = v!;
                  model.notifyListeners();
                },
              ),
            ),
            const SizedBox(width: 12),
            AnimatedSize(
              duration: const Duration(milliseconds: 130),
              child: model.isRsiLauncherStarting
                  ? const ProgressRing()
                  : Button(
                      onPressed: model.appWebLocalizationVersionsData == null
                          ? null
                          : () => model.launchRSI(),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          model.isCurGameRunning
                              ? FluentIcons.stop_solid
                              : FluentIcons.play,
                          color: model.isCurGameRunning
                              ? Colors.red.withOpacity(.8)
                              : null,
                        ),
                      )),
            ),
            const SizedBox(width: 12),
            Button(
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(FluentIcons.folder_open),
                ),
                onPressed: () => model.openDir(model.scInstalledPath)),
            const SizedBox(width: 12),
            Button(
              onPressed: model.reScanPath,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(FluentIcons.refresh),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(model.lastScreenInfo, maxLines: 1),
      makeIndexActionLists(context, model),
    ];
  }

  Widget makeLeftColumn(BuildContext context, HomeUIModel model, double width) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: FluentTheme.of(context).cardColor.withOpacity(.03),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    makeWebViewButton(model,
                        icon: SvgPicture.asset(
                          "assets/rsi.svg",
                          colorFilter: makeSvgColor(Colors.white),
                          height: 18,
                        ),
                        name: "星际公民官网汉化",
                        webTitle: "星际公民官网汉化",
                        webURL: "https://robertsspaceindustries.com",
                        info: "罗伯茨航天工业公司，万物的起源",
                        useLocalization: true,
                        width: width,
                        touchKey: "webLocalization_rsi"),
                    const SizedBox(height: 12),
                    makeWebViewButton(model,
                        icon: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/uex.svg",
                              height: 18,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                        name: "UEX 汉化",
                        webTitle: "UEX 汉化",
                        webURL: "https://uexcorp.space/",
                        info: "采矿、精炼、贸易计算器、价格、船信息",
                        useLocalization: true,
                        width: width,
                        touchKey: "webLocalization_uex"),
                    const SizedBox(height: 12),
                    makeWebViewButton(model,
                        icon: Row(
                          children: [
                            Image.asset(
                              "assets/dps.png",
                              height: 20,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                        name: "DPS计算器汉化",
                        webTitle: "DPS计算器汉化",
                        webURL: "https://www.erkul.games/live/calculator",
                        info: "在线改船，查询伤害数值和配件购买地点",
                        useLocalization: true,
                        width: width,
                        touchKey: "webLocalization_dps"),
                    const SizedBox(height: 12),
                    const Text("外部浏览器拓展："),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Button(
                          child:
                              const FaIcon(FontAwesomeIcons.chrome, size: 18),
                          onPressed: () {
                            launchUrlString(
                                "https://chrome.google.com/webstore/detail/gocnjckojmledijgmadmacoikibcggja?authuser=0&hl=zh-CN");
                          },
                        ),
                        const SizedBox(width: 12),
                        Button(
                          child: const FaIcon(FontAwesomeIcons.edge, size: 18),
                          onPressed: () {
                            launchUrlString(
                                "https://microsoftedge.microsoft.com/addons/detail/lipbbcckldklpdcpfagicipecaacikgi");
                          },
                        ),
                        const SizedBox(width: 12),
                        Button(
                          child: const FaIcon(FontAwesomeIcons.firefoxBrowser,
                              size: 18),
                          onPressed: () {
                            launchUrlString(
                                "https://addons.mozilla.org/zh-CN/firefox/"
                                "addon/%E6%98%9F%E9%99%85%E5%85%AC%E6%B0%91%E7%9B%92%E5%AD%90%E6%B5%8F%E8%A7%88%E5%99%A8%E6%8B%93%E5%B1%95/");
                          },
                        ),
                        const SizedBox(width: 12),
                        Button(
                          child:
                              const FaIcon(FontAwesomeIcons.github, size: 18),
                          onPressed: () {
                            launchUrlString(
                                "https://github.com/StarCitizenToolBox/StarCitizenBoxBrowserEx");
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            makeActivityBanner(context, model, width),
          ],
        ),
        if (model.appWebLocalizationVersionsData == null)
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.3),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(
              child: ProgressRing(),
            ),
          ))
      ],
    );
  }

  Widget makeNewsCard(BuildContext context, HomeUIModel model) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Container(
          width: 316,
          height: 386,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.1),
              borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: 190,
                    width: 316,
                    child: Tilt(
                      shadowConfig: const ShadowConfig(maxIntensity: .3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: model.rssVideoItems == null
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.1)),
                              child: makeLoading(context),
                            )
                          : Swiper(
                              itemCount: model.rssVideoItems?.length ?? 0,
                              itemBuilder: (context, index) {
                                final item = model.rssVideoItems![index];
                                return GestureDetector(
                                  onTap: () {
                                    if (item.link != null) {
                                      launchUrlString(item.link!);
                                    }
                                  },
                                  child: CacheNetImage(
                                    url: model.getRssImage(item),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              autoplay: true,
                            ),
                    )),
                const SizedBox(height: 1),
                if (model.rssTextItems == null)
                  makeLoading(context)
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final item = model.rssTextItems![index];
                      return Tilt(
                          shadowConfig: const ShadowConfig(maxIntensity: .3),
                          borderRadius: BorderRadius.circular(12),
                          child: GestureDetector(
                            onTap: () {
                              if (item.link != null) {
                                launchUrlString(item.link!);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 4, bottom: 4),
                              child: Row(
                                children: [
                                  getRssIcon(item.link ?? ""),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      "${model.handleTitle(item.title)}",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12.2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    FluentIcons.chevron_right,
                                    size: 12,
                                    color: Colors.white.withOpacity(.4),
                                  )
                                ],
                              ),
                            ),
                          ));
                    },
                    itemCount: model.rssTextItems?.length,
                  ),
                const SizedBox(height: 12),
              ],
            ),
          )),
    );
  }

  Widget getRssIcon(String url) {
    if (url.startsWith("https://tieba.baidu.com")) {
      return SvgPicture.asset("assets/tieba.svg", width: 14, height: 14);
    }

    if (url.startsWith("https://www.bilibili.com")) {
      return const FaIcon(
        FontAwesomeIcons.bilibili,
        size: 14,
        color: Color.fromRGBO(0, 161, 214, 1),
      );
    }

    return const FaIcon(FontAwesomeIcons.rss, size: 14);
  }

  Widget makeIndexActionLists(BuildContext context, HomeUIModel model) {
    final items = [
      _HomeItemData("auto_check", "一键诊断", "一键诊断星际公民常见问题",
          FluentIcons.auto_deploy_settings),
      _HomeItemData(
          "localization", "汉化管理", "快捷安装汉化资源", FluentIcons.locale_language),
      _HomeItemData("performance", "性能优化", "调整引擎配置文件，优化游戏性能",
          FluentIcons.process_meta_task),
    ];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AlignedGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemCount: items.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = items.elementAt(index);
            return HoverButton(
              onPressed: () => model.onMenuTap(item.key),
              builder: (BuildContext context, Set<ButtonStates> states) {
                return Container(
                  width: 300,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: states.isHovering
                        ? FluentTheme.of(context).cardColor.withOpacity(.1)
                        : FluentTheme.of(context).cardColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.2),
                              borderRadius: BorderRadius.circular(1000)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              item.icon,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(item.infoString),
                          ],
                        )),
                        if (item.key == "localization" &&
                            model.localizationUpdateInfo != null)
                          Container(
                            padding: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 8, right: 8),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12)),
                            child:
                                Text(model.localizationUpdateInfo?.key ?? " "),
                          ),
                        const SizedBox(width: 12),
                        const Icon(
                          FluentIcons.chevron_right,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  @override
  String getUITitle(BuildContext context, HomeUIModel model) => "HOME";

  Widget makeWebViewButton(HomeUIModel model,
      {required Widget icon,
      required String name,
      required String webTitle,
      required String webURL,
      required bool useLocalization,
      required double width,
      String? info,
      String? touchKey}) {
    return Tilt(
      shadowConfig: const ShadowConfig(maxIntensity: .3),
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          if (touchKey != null) {
            AnalyticsApi.touch(touchKey);
          }
          model.goWebView(webTitle, webURL, useLocalization: true);
        },
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          icon,
                          Text(
                            name,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (info != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            info,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(.6)),
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  FluentIcons.chevron_right,
                  size: 14,
                  color: Colors.white.withOpacity(.6),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeGameStatusCard(
      BuildContext context, HomeUIModel model, double width) {
    return Tilt(
      shadowConfig: const ShadowConfig(maxIntensity: .2),
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          model.goWebView(
              "RSI 服务器状态", "https://status.robertsspaceindustries.com/",
              useLocalization: true);
        },
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              if (model.scServerStatus == null)
                makeLoading(context, width: 20)
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("状态："),
                    for (final item in model.scServerStatus ?? [])
                      Row(
                        children: [
                          SizedBox(
                            height: 14,
                            child: Center(
                              child: Icon(
                                FontAwesomeIcons.solidCircle,
                                color: model.isRSIServerStatusOK(item)
                                    ? Colors.green
                                    : Colors.red,
                                size: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${model.statusCnName[item["name"]] ?? item["name"]}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    Icon(
                      FluentIcons.chevron_right,
                      size: 12,
                      color: Colors.white.withOpacity(.4),
                    )
                  ],
                )
            ]),
          ),
        ),
      ),
    );
  }

  Widget makeActivityBanner(
      BuildContext context, HomeUIModel model, double width) {
    return Tilt(
      borderRadius: BorderRadius.circular(12),
      shadowConfig: const ShadowConfig(disable: true),
      child: GestureDetector(
        onTap: () => model.onTapFestival(),
        child: Container(
            width: width + 24,
            decoration: BoxDecoration(color: FluentTheme.of(context).cardColor),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: (model.countdownFestivalListData == null)
                  ? SizedBox(
                      width: width,
                      height: 62,
                      child: const Center(
                        child: ProgressRing(),
                      ),
                    )
                  : SizedBox(
                      width: width,
                      height: 62,
                      child: Swiper(
                        itemCount: model.countdownFestivalListData!.length,
                        autoplay: true,
                        autoplayDelay: 5000,
                        itemBuilder: (context, index) {
                          final item = model.countdownFestivalListData![index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (item.icon != null && item.icon != "") ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: Image.asset(
                                    "assets/countdown/${item.icon}",
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                              Column(
                                children: [
                                  Text(
                                    item.name ?? "",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 3),
                                  CountdownTimeText(
                                    targetTime:
                                        DateTime.fromMillisecondsSinceEpoch(
                                            item.time ?? 0),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                FluentIcons.chevron_right,
                                size: 14,
                                color: Colors.white.withOpacity(.6),
                              )
                            ],
                          );
                        },
                      ),
                    ),
            )),
      ),
    );
  }
}

class _HomeItemData {
  String key;

  _HomeItemData(this.key, this.name, this.infoString, this.icon);

  String name;
  String infoString;
  IconData icon;
}
