import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/rust/http_package.dart';

class URLConf {
  /// HOME API
  static String gitApiHome = "https://git.sctoolbox.sccsgo.com";
  static String rssApiHome = "https://rss.sctoolbox.sccsgo.com";
  static const String xkeycApiHome = "https://sctoolbox.xkeyc.com";

  static bool isUrlCheckPass = false;

  /// URLS
  static String get giteaAttachmentsUrl => "$gitApiHome/SCToolBox/Release";

  static String get gitlabLocalizationUrl =>
      "$gitApiHome/SCToolBox/LocalizationData";

  static String get apiRepoPath => "$gitApiHome/SCToolBox/api/raw/branch/main/";

  static String get gitlabApiPath => "https://$gitApiHome/api/v1/";

  static String get webTranslateHomeUrl =>
      "$gitApiHome/SCToolBox/ScWeb_Chinese_Translate/raw/branch/main/json/locales";

  static String get rssVideoUrl =>
      "$rssApiHome/bilibili/user/channel/27976358/290653";

  static String get rssTextUrl1 => "$rssApiHome/bilibili/user/article/40102960";

  static String get rssTextUrl2 =>
      "$rssApiHome/baidu/tieba/user/%E7%81%AC%E7%81%ACG%E7%81%AC%E7%81%AC&";

  static const feedbackUrl = "https://txc.qq.com/products/614843";

  static String get devReleaseUrl => "$gitApiHome/SCToolBox/Release/releases";

  static Future<bool> checkHost() async {
    // 使用 DNS 获取可用列表
    final gitApiList =
        _genFinalList(await RSHttp.dnsLookupTxt("git.dns.scbox.org"));
    dPrint("DNS gitApiList ==== $gitApiList");
    final fasterGit = await getFasterUrl(gitApiList);
    dPrint("gitApiList.Faster ==== $fasterGit");
    if (fasterGit != null) {
      gitApiHome = fasterGit;
    }
    final rssApiList =
        _genFinalList(await RSHttp.dnsLookupTxt("rss.dns.scbox.org"));
    final fasterRss = await getFasterUrl(rssApiList);
    dPrint("DNS rssApiList ==== $rssApiList");
    dPrint("rssApiList.Faster ==== $fasterRss");
    if (fasterRss != null) {
      rssApiHome = fasterRss;
    }
    isUrlCheckPass = fasterGit != null && fasterRss != null;
    return isUrlCheckPass;
  }

  static Future<String?> getFasterUrl(List<String> urls) async {
    String firstUrl = "";
    int callLen = 0;

    void onCall(RustHttpResponse? response, String url) {
      callLen++;
      if (response != null && response.statusCode == 200 && firstUrl.isEmpty) {
        firstUrl = url;
      }
    }

    for (var value in urls) {
      RSHttp.head(value).then((resp) => onCall(resp, value), onError: (err) {
        callLen++;
        dPrint("RSHttp.head error $err");
      });
    }

    while (true) {
      await Future.delayed(const Duration(milliseconds: 16));
      if (firstUrl.isNotEmpty) {
        return firstUrl;
      }
      if (callLen == urls.length && firstUrl.isEmpty) {
        return null;
      }
    }
  }

  static List<String> _genFinalList(List<String> sList) {
    List<String> list = [];
    for (var ll in sList) {
      final ssList = ll.split(",");
      for (var value in ssList) {
        list.add(value);
      }
    }
    return list;
  }
}
