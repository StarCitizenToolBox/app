import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';

class URLConf {
  /// HOME API
  static String gitApiHome = "https://git.sctoolbox.sccsgo.com";
  static String rssApiHome = "https://rss.sctoolbox.sccsgo.com";
  static const String xkeycApiHome = "https://sctoolbox.xkeyc.com";

  static bool isUsingFallback = false;

  /// URLS
  static String giteaAttachmentsUrl = "$gitApiHome/SCToolBox/Release";
  static String gitlabLocalizationUrl =
      "$gitApiHome/SCToolBox/LocalizationData";
  static String apiRepoPath = "$gitApiHome/SCToolBox/api/raw/branch/main/";

  static String gitlabApiPath = "https://$gitApiHome/api/v1/";

  static String webTranslateHomeUrl =
      "$gitApiHome/SCToolBox/ScWeb_Chinese_Translate/raw/branch/main/json/locales";

  static String rssVideoUrl =
      "$rssApiHome/bilibili/user/channel/27976358/290653";

  static String rssTextUrl1 = "$rssApiHome/bilibili/user/article/40102960";
  static String rssTextUrl2 =
      "$rssApiHome/baidu/tieba/user/%E7%81%AC%E7%81%ACG%E7%81%AC%E7%81%AC&";

  static const feedbackUrl = "https://txc.qq.com/products/614843";

  static const devReleaseUrl =
      "https://git.sctoolbox.sccsgo.com/SCToolBox/Release/releases";

  static const _gitApiList = [
    "https://git.sctoolbox.sccsgo.com",
    "https://sctb-git.xkeyc.com"
  ];

  static const _rssApiList = [
    "https://rss.sctoolbox.sccsgo.com",
    "https://rss.42kit.com"
  ];

  static checkHost() async {
    final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));
    bool hasAvailable = false;
    // 寻找可用的 git API
    for (var value in _gitApiList) {
      try {
        final resp = await dio.head(value);
        if (resp.statusCode == 200) {
          dPrint("[URLConf].checkHost passed $value");
          gitApiHome = value;
          hasAvailable = true;
          break;
        }
        isUsingFallback = true;
        continue;
      } catch (e) {
        dPrint("[URLConf].checkHost $value Error= $e");
        isUsingFallback = true;
        continue;
      }
    }
    // 寻找可用的 RSS API
    for (var value in _rssApiList) {
      try {
        final resp = await dio.head(value);
        if (resp.statusCode == 200) {
          rssApiHome = value;
          hasAvailable = true;
          dPrint("[URLConf].checkHost passed $value");
          break;
        }
        isUsingFallback = true;
        continue;
      } catch (e) {
        dPrint("[URLConf].checkHost $value Error= $e");
        isUsingFallback = true;
        continue;
      }
    }

    if (!hasAvailable) {
      isUsingFallback = false;
    }
  }
}
