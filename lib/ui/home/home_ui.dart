import 'package:card_swiper/card_swiper.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'dialogs/home_countdown_dialog_ui.dart';
import 'dialogs/home_md_content_dialog_ui.dart';
import 'home_ui_model.dart';
import 'localization/localization_dialog_ui.dart';
import 'localization/localization_ui_model.dart';

class HomeUI extends HookConsumerWidget {
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeUIModelProvider);
    final model = ref.watch(homeUIModelProvider.notifier);
    ref.watch(localizationUIModelProvider);
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (homeState.appPlacardData != null) ...[
                  InfoBar(
                    title: Text("${homeState.appPlacardData?.title}"),
                    content: Text("${homeState.appPlacardData?.content}"),
                    severity: InfoBarSeverity.info,
                    action: homeState.appPlacardData?.link == null
                        ? null
                        : Button(
                            child: Text(S.current.doctor_action_view_details),
                            onPressed: () => _showPlacard(context, homeState),
                          ),
                    onClose: homeState.appPlacardData?.alwaysShow == true
                        ? null
                        : () => model.closePlacard(),
                  ),
                  const SizedBox(height: 6),
                ],
                ...makeIndex(context, model, homeState, ref)
              ],
            ),
          ),
        ),
        if (homeState.isFixing)
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
                  Text(homeState.isFixingString.isNotEmpty
                      ? homeState.isFixingString
                      : S.current.doctor_info_processing),
                ],
              ),
            ),
          )
      ],
    );
  }

  List<Widget> makeIndex(BuildContext context, HomeUIModel model,
      HomeUIModelState homeState, WidgetRef ref) {
    double width = 280;
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
                    makeGameStatusCard(context, model, 340, homeState)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 24,
            child: makeLeftColumn(context, model, width, homeState),
          ),
          Positioned(
            right: 24,
            top: 0,
            child: makeNewsCard(context, model, homeState),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.current.home_install_location),
            const SizedBox(width: 6),
            Expanded(
              child: ComboBox<String>(
                value: homeState.scInstalledPath,
                isExpanded: true,
                items: [
                  ComboBoxItem(
                    value: "not_install",
                    child: Text(S.current.home_not_installed_or_failed),
                  ),
                  for (final path in homeState.scInstallPaths)
                    ComboBoxItem(
                      value: path,
                      child: Row(
                        children: [Text(path)],
                      ),
                    )
                ],
                onChanged: model.onChangeInstallPath,
              ),
            ),
            const SizedBox(width: 12),
            Button(
                onPressed: homeState.webLocalizationVersionsData == null
                    ? null
                    : () => model.launchRSI(context),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    homeState.isCurGameRunning
                        ? FluentIcons.stop_solid
                        : FluentIcons.play,
                    color: homeState.isCurGameRunning
                        ? Colors.red.withOpacity(.8)
                        : null,
                  ),
                )),
            const SizedBox(width: 12),
            Button(
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(FluentIcons.folder_open),
              ),
              onPressed: () => SystemHelper.openDir(homeState.scInstalledPath),
            ),
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
      Text(homeState.lastScreenInfo, maxLines: 1),
      makeIndexActionLists(context, model, homeState, ref),
    ];
  }

  Widget makeLeftColumn(BuildContext context, HomeUIModel model, double width,
      HomeUIModelState homeState) {
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
                    makeWebViewButton(context, model,
                        icon: SvgPicture.asset(
                          "assets/rsi.svg",
                          colorFilter: makeSvgColor(Colors.white),
                          height: 18,
                        ),
                        name: S.current.home_action_star_citizen_website_localization,
                        webTitle: S.current.home_action_star_citizen_website_localization,
                        webURL: "https://robertsspaceindustries.com",
                        info: S.current.home_action_info_roberts_space_industries_origin,
                        useLocalization: true,
                        width: width,
                        touchKey: "webLocalization_rsi"),
                    const SizedBox(height: 12),
                    makeWebViewButton(context, model,
                        icon: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/uex.svg",
                              height: 18,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                        name: S.current.home_action_uex_localization,
                        webTitle: S.current.home_action_uex_localization,
                        webURL: "https://uexcorp.space/",
                        info: S.current.home_action_info_mining_refining_trade_calculator,
                        useLocalization: true,
                        width: width,
                        touchKey: "webLocalization_uex"),
                    const SizedBox(height: 12),
                    makeWebViewButton(context, model,
                        icon: Row(
                          children: [
                            Image.asset(
                              "assets/dps.png",
                              height: 20,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                        name: S.current.home_action_dps_calculator_localization,
                        webTitle: S.current.home_action_dps_calculator_localization,
                        webURL: "https://www.erkul.games/live/calculator",
                        info: S.current.home_action_info_ship_upgrade_damage_value_query,
                        useLocalization: true,
                        width: width,
                        touchKey: "webLocalization_dps"),
                    const SizedBox(height: 12),
                    Text(S.current.home_action_external_browser_extension),
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
            makeActivityBanner(context, model, width, homeState),
          ],
        ),
        if (homeState.webLocalizationVersionsData == null)
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

  Widget makeNewsCard(
      BuildContext context, HomeUIModel model, HomeUIModelState homeState) {
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
                      child: homeState.rssVideoItems == null
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.1)),
                              child: makeLoading(context),
                            )
                          : Swiper(
                              itemCount: homeState.rssVideoItems?.length ?? 0,
                              itemBuilder: (context, index) {
                                final item = homeState.rssVideoItems![index];
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
                if (homeState.rssTextItems == null)
                  makeLoading(context)
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final item = homeState.rssTextItems![index];
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
                                      model.handleTitle(item.title),
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
                    itemCount: homeState.rssTextItems?.length,
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

  Widget makeIndexActionLists(BuildContext context, HomeUIModel model,
      HomeUIModelState homeState, WidgetRef ref) {
    final items = [
      _HomeItemData("game_doctor", "一键诊断", S.current.home_action_info_one_click_diagnosis_star_citizen,
          FluentIcons.auto_deploy_settings),
      _HomeItemData(
          "localization", "汉化管理", S.current.home_action_info_quick_install_localization_resources, FluentIcons.locale_language),
      _HomeItemData("performance", "性能优化", S.current.home_action_info_engine_config_optimization,
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
              onPressed: () => _onMenuTap(context, item.key, homeState, ref),
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
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              item.icon,
                              size: 24,
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
                            homeState.localizationUpdateInfo != null)
                          Container(
                            padding: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 8, right: 8),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                                homeState.localizationUpdateInfo?.key ?? " "),
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

  Widget makeWebViewButton(BuildContext context, HomeUIModel model,
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
          model.goWebView(context, webTitle, webURL, useLocalization: true);
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

  Widget makeGameStatusCard(BuildContext context, HomeUIModel model,
      double width, HomeUIModelState homeState) {
    final statusCnName = {
      "Platform": S.current.home_action_rsi_status_platform,
      "Persistent Universe": S.current.home_action_rsi_status_persistent_universe,
      "Electronic Access": S.current.home_action_rsi_status_electronic_access,
      "Arena Commander": S.current.home_action_rsi_status_arena_commander
    };

    return Tilt(
      shadowConfig: const ShadowConfig(maxIntensity: .2),
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          model.goWebView(context, S.current.home_action_rsi_status_rsi_server_status,
              "https://status.robertsspaceindustries.com/",
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
              if (homeState.scServerStatus == null)
                makeLoading(context, width: 20)
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.current.home_action_rsi_status_status),
                    for (final item in homeState.scServerStatus ?? [])
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
                            "${statusCnName[item["name"]] ?? item["name"]}",
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

  Widget makeActivityBanner(BuildContext context, HomeUIModel model,
      double width, HomeUIModelState homeState) {
    return Tilt(
      borderRadius: BorderRadius.circular(12),
      shadowConfig: const ShadowConfig(disable: true),
      child: GestureDetector(
        onTap: () => _onTapFestival(context),
        child: Container(
            width: width + 24,
            decoration: BoxDecoration(color: FluentTheme.of(context).cardColor),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: (homeState.countdownFestivalListData == null)
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
                        itemCount: homeState.countdownFestivalListData!.length,
                        autoplay: true,
                        autoplayDelay: 5000,
                        itemBuilder: (context, index) {
                          final item =
                              homeState.countdownFestivalListData![index];
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

  _showPlacard(BuildContext context, HomeUIModelState homeState) {
    switch (homeState.appPlacardData?.linkType) {
      case "external":
        launchUrlString(homeState.appPlacardData?.link);
        return;
      case "doc":
        showDialog(
            context: context,
            builder: (context) {
              return HomeMdContentDialogUI(
                title: homeState.appPlacardData?.title ?? S.current.home_announcement_details,
                url: homeState.appPlacardData?.link,
              );
            });
        return;
    }
  }

  _onTapFestival(BuildContext context) {
    showDialog(
        context: context, builder: (context) => const HomeCountdownDialogUI());
  }

  _onMenuTap(BuildContext context, String key, HomeUIModelState homeState,
      WidgetRef ref) async {
    String gameInstallReqInfo =
        "该功能需要一个有效的安装位置\n\n如果您的游戏未下载完成，请等待下载完毕后使用此功能。\n\n如果您的游戏已下载完毕但未识别，请启动一次游戏后重新打开盒子 或 在设置选项中手动设置安装位置。";
    switch (key) {
      case "localization":
        if (homeState.scInstalledPath == "not_install") {
          showToast(context, gameInstallReqInfo);
          break;
        }
        final model = ref.watch(homeUIModelProvider.notifier);
        model.checkLocalizationUpdate();
        await showDialog(
            context: context,
            dismissWithEsc: false,
            builder: (BuildContext context) => const LocalizationDialogUI());
        model.checkLocalizationUpdate(skipReload: true);
        break;
      default:
        context.push("/index/$key");
    }
  }
}

class _HomeItemData {
  String key;

  _HomeItemData(this.key, this.name, this.infoString, this.icon);

  String name;
  String infoString;
  IconData icon;
}