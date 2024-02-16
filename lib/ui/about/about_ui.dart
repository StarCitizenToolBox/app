import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'about_ui_model.dart';

class AboutUI extends BaseUI<AboutUIModel> {
  bool isTipTextCn = false;

  @override
  Widget? buildBody(BuildContext context, AboutUIModel model) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          const SizedBox(height: 64),
          Image.asset("assets/app_logo.png", width: 128, height: 128),
          const SizedBox(height: 6),
          const Text(
              "SC汉化盒子  V${AppConf.appVersion} ${AppConf.isMSE ? "" : " +Dev"}",
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          Button(
              onPressed: model.checkUpdate,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Text("检查更新"),
              )),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                "不仅仅是汉化！\n\nSC汉化盒子是你探索宇宙的好帮手，我们致力于为各位公民解决游戏中的常见问题，并为社区汉化、性能调优、常用网站汉化 等操作提供便利。",
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(.9)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Row(
                  children: [
                    const Icon(FontAwesomeIcons.link),
                    const SizedBox(width: 8),
                    Text(
                      "在线反馈",
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(.6)),
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
                      "QQ群: 940696487",
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(.6)),
                    ),
                  ],
                ),
                onPressed: () {
                  launchUrlString(
                      "https://qm.qq.com/cgi-bin/qm/qr?k=TdyR3QU-x77OeD0NQ5w--F0uiNxPq-Tn&jump_from=webapi&authKey=m8s5GhF/7bRCvm5vI4aNl7RQEx5KOViwkzzIl54K+u9w2hzFpr9N/3avG4W/HaVS");
                },
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: Row(
                  children: [
                    const Icon(FontAwesomeIcons.envelope),
                    const SizedBox(width: 8),
                    Text(
                      "邮箱: scbox@xkeyc.com",
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(.6)),
                    ),
                  ],
                ),
                onPressed: () {
                  launchUrlString("mailto:scbox@xkeyc.com");
                },
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: Row(
                  children: [
                    const Icon(FontAwesomeIcons.github),
                    const SizedBox(width: 8),
                    Text(
                      "开源",
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(.6)),
                    ),
                  ],
                ),
                onPressed: () {
                  launchUrlString("https://github.com/StarCitizenToolBox/app");
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * .35,
                decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor.withOpacity(.03),
                    borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      isTipTextCn ? tipTextCN : tipTextEN,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(.9)),
                    ),
                  ),
                  onPressed: () {
                    isTipTextCn = !isTipTextCn;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  static const tipTextEN =
      "This is an unofficial Star Citizen fan-made tools, not affiliated with the Cloud Imperium group of companies. All content on this Software not authored by its host or users are property of their respective owners. \nStar Citizen®, Roberts Space Industries® and Cloud Imperium® are registered trademarks of Cloud Imperium Rights LLC.";

  static const tipTextCN =
      "这是一个非官方的星际公民工具，不隶属于 Cloud Imperium 公司集团。 本软件中非由其主机或用户创作的所有内容均为其各自所有者的财产。 \nStar Citizen®、Roberts Space Industries® 和 Cloud Imperium® 是 Cloud Imperium Rights LLC 的注册商标。";

  @override
  String getUITitle(BuildContext context, AboutUIModel model) => "";
}
