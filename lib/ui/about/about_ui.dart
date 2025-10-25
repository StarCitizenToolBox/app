import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/widgets/src/flow_number_text.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUI extends HookConsumerWidget {
  const AboutUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTipTextCn = useState(false);
    final pageCtrl = usePageController();

    return PageView(
      scrollDirection: Axis.vertical,
      controller: pageCtrl,
      children: [_makeAbout(context, ref, isTipTextCn, pageCtrl), _makeDonate(context, ref, pageCtrl)],
    );
  }

  Widget _makeAbout(BuildContext context, WidgetRef ref, ValueNotifier<bool> isTipTextCn, PageController pageCtrl) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const SizedBox(height: 32),
              Image.asset("assets/app_logo.png", width: 128, height: 128),
              const SizedBox(height: 6),
              Text(
                S.current.app_index_version_info(ConstConf.appVersion, ConstConf.isMSE ? "" : " Dev"),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Button(
                onPressed: () => _onCheckUpdate(context, ref),
                child: Padding(padding: const EdgeInsets.all(4), child: Text(S.current.about_check_update)),
              ),
              const SizedBox(height: 32),
              Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: FluentTheme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        S.current.about_app_description,
                        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .9)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              makeAnalyticsWidget(context),
              const SizedBox(height: 24),
              makeLinksRow(),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .35,
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).cardColor.withValues(alpha: .06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            isTipTextCn.value ? tipTextCN : tipTextEN,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .9)),
                          ),
                        ),
                        onPressed: () {
                          isTipTextCn.value = !isTipTextCn.value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Positioned(bottom: 12, left: 0, right: 0, child: Center(child: makeNavButton(pageCtrl, 1))),
      ],
    );
  }

  Widget _makeDonate(BuildContext context, WidgetRef ref, PageController pageCtrl) {
    final donationTypeNotifier = useState('alipay');
    final bubbleMessages = [S.current.support_dev_thanks_message, S.current.support_dev_referral_code_message];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          makeNavButton(pageCtrl, 0),
          const SizedBox(height: 12),

          Text(S.current.support_dev_title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),

          // 聊天头像和气泡消息
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CacheNetImage(
                  url:
                      "https://git.scbox.xkeyc.cn/avatars/56a93334e892ba48f4fab453b8205624d661e4f7748cdb52bed47e5dc0c85de5?size=512",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < bubbleMessages.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SelectionArea(child: ChatBubble(message: bubbleMessages[i])),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 捐赠方式选择
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _donationMethodButton(
                context: context,
                title: 'AliPay',
                icon: FontAwesomeIcons.alipay,
                isSelected: donationTypeNotifier.value == 'alipay',
                color: const Color(0xFF1677FF),
                onTap: () => donationTypeNotifier.value = 'alipay',
              ),
              _donationMethodButton(
                context: context,
                title: 'WeChat',
                icon: FontAwesomeIcons.weixin,
                isSelected: donationTypeNotifier.value == 'wechat',
                color: const Color(0xFF07C160),
                onTap: () => donationTypeNotifier.value = 'wechat',
              ),
              _donationMethodButton(
                context: context,
                title: 'QQ',
                icon: FontAwesomeIcons.qq,
                isSelected: donationTypeNotifier.value == 'qq',
                color: const Color(0xFF12B7F5),
                onTap: () => donationTypeNotifier.value = 'qq',
              ),
              _donationMethodButton(
                context: context,
                title: 'FPS',
                icon: FontAwesomeIcons.dollarSign,
                iconWidget: Image.asset("assets/ic_hk_fps.png", width: 24, height: 24),
                isSelected: donationTypeNotifier.value == 'fps',
                color: const Color(0xFFFF6B6B),
                onTap: () => donationTypeNotifier.value = 'fps',
              ),
              _donationMethodButton(
                context: context,
                title: 'aUEC',
                icon: FontAwesomeIcons.gamepad,
                isSelected: donationTypeNotifier.value == 'uec',
                color: const Color(0xFFFFD700),
                onTap: () => donationTypeNotifier.value = 'uec',
              ),
              _donationMethodButton(
                context: context,
                title: 'GitHub',
                icon: FontAwesomeIcons.github,
                isSelected: donationTypeNotifier.value == 'github',
                color: Colors.white,
                onTap: () => donationTypeNotifier.value = 'github',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 二维码显示区域
          Container(
            constraints: BoxConstraints(minHeight: 300),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _buildDonationQRCode(donationTypeNotifier.value, context),
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _donationMethodButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
    Widget? iconWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Button(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => isSelected
                ? ButtonThemeData.buttonColor(context, states).withAlpha((255.0 * 0.08).round())
                : ButtonThemeData.buttonColor(context, states).withAlpha((255.0 * 0.005).round()),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget ?? Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationQRCode(String type, BuildContext context) {
    // 处理 GitHub 特殊情况
    if (type == 'github') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        key: ValueKey('github'),
        children: [
          SizedBox(height: 28),
          const Icon(FontAwesomeIcons.github, size: 64),
          const SizedBox(height: 32),
          Text(S.current.support_dev_github_star_message),
          const SizedBox(height: 32),
          Button(
            onPressed: () {
              launchUrlString("https://github.com/StarCitizenToolBox/app");
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FontAwesomeIcons.github),
                  const SizedBox(width: 12),
                  Text(S.current.support_dev_github_star_button),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // 香港 FPS 转数快特殊处理
    if (type == 'fps') {
      return Column(
        key: ValueKey('fps'),
        children: [
          Image.asset("assets/ic_hk_fps.png", width: 128, height: 128),
          const SizedBox(height: 16),
          Text(
            S.current.support_dev_hk_fps_transfer_title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor.withAlpha((255 * .1).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("FPS ID: 122289838", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                Button(
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: "122289838"));
                    showToast(context, S.current.support_dev_hk_fps_transfer_id_copied);
                  },
                  child: Text(S.current.support_dev_copy_button),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(S.current.support_dev_in_game_currency_message, textAlign: TextAlign.start),
        ],
      );
    }

    // UEC 游戏内捐赠也特殊处理
    if (type == 'uec') {
      return Column(
        key: ValueKey('uec'),
        children: [
          Image.asset("assets/sc_logo.png", width: 128, height: 128),
          const SizedBox(height: 16),
          Text(
            S.current.support_dev_in_game_currency_title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor.withAlpha((255 * .1).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.current.support_dev_in_game_id, style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                Button(
                  onPressed: () {
                    // ${S.current.support_dev_copy_button}游戏ID到剪贴板
                    Clipboard.setData(ClipboardData(text: "xkeyC"));
                    showToast(context, S.current.support_dev_in_game_id_copied);
                  },
                  child: Text(S.current.support_dev_copy_button),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(S.current.support_dev_in_game_currency_message, textAlign: TextAlign.start),
        ],
      );
    }

    // 其他支付方式显示二维码
    String qrData;
    String title;

    switch (type) {
      case 'alipay':
        qrData = DonationQrCodeData.alipay;
        title = S.current.support_dev_alipay;
        break;
      case 'wechat':
        qrData = DonationQrCodeData.wechat;
        title = S.current.support_dev_wechat;
        break;

      case 'qq':
        qrData = DonationQrCodeData.qq;
        title = "QQ";
        break;
      default:
        qrData = "";
        title = "";
        break;
    }

    return Column(
      key: ValueKey(type),
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: QrImageView(data: qrData),
        ),
        const SizedBox(height: 16),
        Text(S.current.support_dev_donation_disclaimer, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget makeNavButton(PageController pageCtrl, int pageIndex) {
    return IconButton(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(pageIndex == 0 ? FluentIcons.chevron_up : FluentIcons.chevron_down, size: 12),
          SizedBox(width: 8),
          Text(pageIndex == 0 ? S.current.support_dev_back_button : S.current.support_dev_scroll_hint),
        ],
      ),
      onPressed: () =>
          pageCtrl.animateToPage(pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.ease),
    );
  }

  Widget makeLinksRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.question),
              const SizedBox(width: 8),
              Text(
                S.current.about_action_btn_faq,
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString(URLConf.feedbackFAQUrl);
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.link),
              const SizedBox(width: 8),
              Text(
                S.current.about_online_feedback,
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString(URLConf.feedbackUrl);
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.qq),
              const SizedBox(width: 8),
              Text(
                S.current.about_action_qq_group,
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString(
              "https://qm.qq.com/cgi-bin/qm/qr?k=TdyR3QU-x77OeD0NQ5w--F0uiNxPq-Tn&jump_from=webapi&authKey=m8s5GhF/7bRCvm5vI4aNl7RQEx5KOViwkzzIl54K+u9w2hzFpr9N/3avG4W/HaVS",
            );
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.envelope),
              const SizedBox(width: 8),
              Text(
                S.current.about_action_email,
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString("mailto:xkeyc@qq.com");
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Row(
            children: [
              const Icon(FontAwesomeIcons.github),
              const SizedBox(width: 8),
              Text(
                S.current.about_action_open_source,
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6)),
              ),
            ],
          ),
          onPressed: () {
            launchUrlString("https://github.com/StarCitizenToolBox/app");
          },
        ),
      ],
    );
  }

  static const tipTextEN =
      "This is an unofficial Star Citizen fan-made tools, not affiliated with the Cloud Imperium group of companies. All content on this Software not authored by its host or users are property of their respective owners. \nStar Citizen®, Roberts Space Industries® and Cloud Imperium® are registered trademarks of Cloud Imperium Rights LLC.";

  static String get tipTextCN => S.current.about_disclaimer;

  Widget makeAnalyticsWidget(BuildContext context) {
    var buildIndex = 0;
    return LoadingWidget(
      onLoadData: AnalyticsApi.getAnalyticsData,
      autoRefreshDuration: const Duration(seconds: 60),
      childBuilder: (BuildContext context, Map<String, dynamic> data) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (data["total"] is List)
              for (var item in data["total"])
                if (item is Map)
                  if ([
                    "launch",
                    "gameLaunch",
                    "firstLaunch",
                    "install_localization",
                    "performance_apply",
                    "p4k_download",
                  ].contains(item["Type"]))
                    GridItemAnimator(
                      index: buildIndex++,
                      child: makeAnalyticsItem(
                        context: context,
                        name: item["Type"] as String,
                        value: item["Count"] as int,
                      ),
                    ),
          ],
        );
      },
    );
  }

  Widget makeAnalyticsItem({required BuildContext context, required String name, required int value}) {
    final names = {
      "launch": S.current.about_analytics_launch,
      "gameLaunch": S.current.about_analytics_launch_game,
      "firstLaunch": S.current.about_analytics_total_users,
      "install_localization": S.current.about_analytics_install_translation,
      "performance_apply": S.current.about_analytics_performance_optimization,
      "p4k_download": S.current.about_analytics_p4k_redirection,
    };
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(names[name] ?? name, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .6))),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FlowNumberText(targetValue: value, style: const TextStyle(fontSize: 20)),
              Text(
                " ${name == "firstLaunch" ? S.current.about_analytics_units_user : S.current.about_analytics_units_times}",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onCheckUpdate(BuildContext context, WidgetRef ref) async {
    if (ConstConf.isMSE) {
      launchUrlString("ms-windows-store://pdp/?productid=9NF3SWFWNKL1");
      return;
    } else {
      final hasUpdate = await ref.read(appGlobalModelProvider.notifier).checkUpdate(context);
      if (!hasUpdate) {
        if (!context.mounted) return;
        showToast(context, S.current.about_info_latest_version);
      }
    }
  }
}

class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).accentColor.withAlpha((255.0 * .2).round()),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Text(message, style: TextStyle(fontSize: 14)),
    );
  }
}

class DonationQrCodeData {
  static const alipay = "https://qr.alipay.com/tsx16308c4uai0ticmz4j96";
  static const wechat = "wxp://f2f0J40rTCX7Vt79yooWNbiqH3U6UmwGJkqjcAYnrv9OZVzKyS5_W6trp8mo3KP-CTQ5";
  static const qq =
      "https://i.qianbao.qq.com/wallet/sqrcode.htm?m=tenpay&f=wallet&a=1&u=3334969096&n=xkeyC&ac=CAEQiK6etgwY8ZuKvgYyGOa1geWKqOaRiuS9jee7j-iQpeaUtuasvjgBQiAzY2Y4NWY3MDI1MWUxYWEwMGYyN2Q0OTM4Y2U2ODFlMw%3D%3D_xxx_sign";
}
