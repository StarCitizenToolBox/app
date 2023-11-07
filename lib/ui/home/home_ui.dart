import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/base/ui.dart';
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
                  const SizedBox(height: 12),
                ],
                if (!model.isChecking &&
                    model.checkResult != null &&
                    model.checkResult!.isNotEmpty)
                  ...makeResult(context, model)
                else
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
    final width = MediaQuery.of(context).size.width * .21;
    return [
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 64, bottom: 64),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Image.asset(
                  "assets/sc_logo.png",
                  height: 256,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 24,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            FluentTheme.of(context).cardColor.withOpacity(.03),
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
                                webURL: "https://uexcorp.space",
                                info: "采矿、精炼、贸易计算器、价格、船信息",
                                useLocalization: true,
                                width: width,
                                touchKey: "webLocalization_uex"),
                            const SizedBox(height: 12),
                            makeWebViewButton(model,
                                icon: Row(
                                  children: [
                                    ExtendedImage.network(
                                      "https://www.erkul.games/assets/icons/icon-512x512.png",
                                      height: 20,
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                                name: "DPS计算器汉化",
                                webTitle: "DPS计算器汉化",
                                webURL:
                                    "https://www.erkul.games/live/calculator",
                                info: "在线改船，查询伤害数值和配件购买地点",
                                useLocalization: true,
                                width: width,
                                touchKey: "webLocalization_dps"),
                            const SizedBox(height: 12),
                            const Text("外部浏览器拓展："),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Button(
                                  child: const FaIcon(FontAwesomeIcons.chrome,
                                      size: 18),
                                  onPressed: () {
                                    launchUrlString(
                                        "https://chrome.google.com/webstore/detail/gocnjckojmledijgmadmacoikibcggja?authuser=0&hl=zh-CN");
                                  },
                                ),
                                const SizedBox(width: 12),
                                Button(
                                  child: const FaIcon(FontAwesomeIcons.edge,
                                      size: 18),
                                  onPressed: () {
                                    launchUrlString(
                                        "https://microsoftedge.microsoft.com/addons/detail/lipbbcckldklpdcpfagicipecaacikgi");
                                  },
                                ),
                                const SizedBox(width: 12),
                                Button(
                                  child: const FaIcon(
                                      FontAwesomeIcons.firefoxBrowser,
                                      size: 18),
                                  onPressed: () {
                                    launchUrlString(
                                        "https://addons.mozilla.org/zh-CN/firefox/"
                                        "addon/%E6%98%9F%E9%99%85%E5%85%AC%E6%B0%91%E7%9B%92%E5%AD%90%E6%B5%8F%E8%A7%88%E5%99%A8%E6%8B%93%E5%B1%95/");
                                  },
                                ),
                                const SizedBox(width: 12),
                                Button(
                                  child: const FaIcon(FontAwesomeIcons.github,
                                      size: 18),
                                  onPressed: () {
                                    launchUrlString(
                                        "https://github.com/xkeyC/StarCitizenBoxBrowserEx");
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Tilt(
                      borderRadius: BorderRadius.circular(12),
                      shadowConfig: const ShadowConfig(disable: true),
                      child: GestureDetector(
                        onTap: () => model.onTapFestival(),
                        child: Container(
                            width: width + 24,
                            decoration: BoxDecoration(
                                color: FluentTheme.of(context).cardColor),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 6, bottom: 6),
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
                                        itemCount: model
                                            .countdownFestivalListData!.length,
                                        autoplay: true,
                                        autoplayDelay: 5000,
                                        itemBuilder: (context, index) {
                                          final item =
                                              model.countdownFestivalListData![
                                                  index];
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              if (item.icon != null &&
                                                  item.icon != "") ...[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000),
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
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  CountdownTimeText(
                                                    targetTime: DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            item.time ?? 0),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                            )),
                      ),
                    ),
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
            ),
          ),
          Positioned(
              left: 24,
              bottom: 0,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  makeADCard(context, model,
                      bgURl:
                          "https://i2.hdslb.com/bfs/face/7582c8d46fc03004f4f8032c667c0ea4dbbb1088.jpg",
                      title: "Anicat",
                      subtitle: "高质量星际公民资讯UP主",
                      jumpUrl: "https://space.bilibili.com/27976358/video"),
                  const SizedBox(height: 12),
                  makeADCard(context, model,
                      bgURl:
                          "https://citizenwiki.cn/images/f/f2/890Jump_beach.jpg.webp",
                      title: "星际公民中文百科",
                      subtitle: "探索宇宙的好伙伴",
                      jumpUrl: "https://citizenwiki.cn"),
                  const SizedBox(height: 12),
                  Tilt(
                    shadowConfig: const ShadowConfig(maxIntensity: .2),
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () {
                        model.goWebView("RSI 服务器状态",
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
                            const Row(
                              children: [
                                Text("星际公民服务器状态："),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (model.scServerStatus == null)
                              makeLoading(context, width: 20)
                            else
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (final item in model.scServerStatus ?? [])
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 14,
                                          child: Center(
                                            child: Icon(
                                              FontAwesomeIcons.solidCircle,
                                              color: model
                                                      .isRSIServerStatusOK(item)
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          "${model.statusCnName[item["name"]] ?? item["name"]}",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    )
                                ],
                              )
                          ]),
                        ),
                        // child: IconButton(
                        //   icon: ,
                        //   onPressed: () {
                        //     launchUrlString(
                        //         "https://status.robertsspaceindustries.com/");
                        //   },
                        // ),
                      ),
                    ),
                  ),
                ],
              ))
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
                        padding: const EdgeInsets.all(8.0),
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
                  padding: EdgeInsets.all(8.0),
                  child: Icon(FluentIcons.folder_open),
                ),
                onPressed: () => model.openDir(model.scInstalledPath)),
            const SizedBox(width: 12),
            Button(
              onPressed: model.isChecking ? null : model.reScanPath,
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
      const SizedBox(height: 32),
      makeIndexActionLists(context, model),
      const SizedBox(height: 32),
    ];
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
              onPressed: item.key == "auto_check" && model.isChecking
                  ? null
                  : () => model.onMenuTap(item.key),
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
                        const SizedBox(width: 12),
                        if (item.key == "auto_check" && model.isChecking)
                          const ProgressRing()
                        else
                          const Icon(
                            FluentIcons.chevron_right,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  List<Widget> makeResult(BuildContext context, HomeUIModel model) {
    return [
      const SizedBox(height: 24),
      const Text(
        "检测结果",
        style: TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 6),
      Text(model.lastScreenInfo, maxLines: 1),
      const SizedBox(height: 24),
      ListView.builder(
        itemCount: model.checkResult!.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final item = model.checkResult![index];
          return makeResultItem(item, model);
        },
      ),
      Text(
        "注意：本工具检测结果仅供参考，若您不理解以上操作，请提供截图给有经验的玩家！",
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
      const SizedBox(height: 64),
      FilledButton(
        onPressed: model.resetCheck,
        child: const Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Text('返回'),
        ),
      ),
      const SizedBox(height: 38),
    ];
  }

  @override
  String getUITitle(BuildContext context, HomeUIModel model) => "HOME";

  Widget makeResultItem(MapEntry<String, String> item, HomeUIModel model) {
    final errorNames = {
      "unSupport_system":
          MapEntry("不支持的操作系统，游戏可能无法运行", "请升级您的系统 (${item.value})"),
      "no_live_path": MapEntry("安装目录缺少LIVE文件夹，可能导致安装失败",
          "点击修复为您创建 LIVE 文件夹，完成后重试安装。(${item.value})"),
      "nvme_PhysicalBytes": MapEntry("新型 NVME 设备，与 RSI 启动器暂不兼容，可能导致安装失败",
          "为注册表项添加 ForcedPhysicalSectorSizeInBytes 值 模拟旧设备。硬盘分区(${item.value})"),
      "eac_file_miss": const MapEntry("EasyAntiCheat 文件丢失",
          "未在 LIVE 文件夹找到 EasyAntiCheat 文件 或 文件不完整，请使用 RSI 启动器校验文件"),
      "eac_not_install": const MapEntry("EasyAntiCheat 未安装",
          "EasyAntiCheat 未安装，请点击修复为您一键安装。（在 EAC 完成首次启动前，本条目持续存在）"),
      "cn_user_name":
          const MapEntry("中文用户名！", "中文用户名可能会导致游戏启动/安装错误！ 点击修复按钮查看修改教程！"),
      "cn_install_path": MapEntry("中文安装路径！",
          "中文安装路径！这可能会导致游戏 启动/安装 错误！（${item.value}），请在RSI启动器更换安装路径。"),
      "low_ram": MapEntry(
          "物理内存过低", "您至少需要 16GB 的物理内存（Memory）才可运行此游戏。（当前大小：${item.value}）"),
    };
    return ListTile(
      title: Text(errorNames[item.key]?.key ?? item.key),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text("修复建议： ${errorNames[item.key]?.value ?? "暂无解决方法，请截图反馈"}"),
      ),
      trailing: Button(
        onPressed: (errorNames[item.key]?.value == null || model.isFixing)
            ? null
            : () async {
                await model.doFix(item);
                model.isFixing = false;
                model.notifyListeners();
              },
        child: const Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Text("修复"),
        ),
      ),
    );
  }

  Widget makeADCard(
    BuildContext context,
    HomeUIModel model, {
    required String bgURl,
    required String title,
    required String subtitle,
    required String jumpUrl,
  }) {
    final width = MediaQuery.of(context).size.width * .21;
    return Tilt(
      shadowConfig: const ShadowConfig(maxIntensity: .3),
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          launchUrlString(jumpUrl);
        },
        child: ClipRRect(
          child: Container(
            width: width,
            height: 128,
            decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(.3),
                  child: ExtendedImage.network(
                    bgURl,
                    fit: BoxFit.cover,
                    width: width,
                  ),
                ),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.7),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

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
                          fontSize: 12, color: Colors.white.withOpacity(.6)),
                    ),
                  )
              ],
            ),
          ),
        ),
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
