import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/io/doh_client.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/rust/http_package.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class URLConf {
  /// HOME API
  static String gitApiHome = "https://ecdn.git.scbox.xkeyc.cn";
  static String newsApiHome = "https://ecdn.news.scbox.xkeyc.cn";
  static const String analyticsApiHome = "https://web-proxy.scbox.xkeyc.cn/analytics/analytics";

  static bool isUrlCheckPass = false;

  /// URLS
  static String get giteaAttachmentsUrl => "$gitApiHome/SCToolBox/Release";

  static String get gitlabLocalizationUrl => "$gitApiHome/SCToolBox/LocalizationData";

  static String get gitApiRSILauncherEnhanceUrl => "$gitApiHome/SCToolBox/RSILauncherEnhance";

  static String get apiRepoPath => "$gitApiHome/SCToolBox/api/raw/branch/main";

  static String get gitlabApiPath => "$gitApiHome/api/v1/";

  static String get webTranslateHomeUrl => "$gitApiHome/SCToolBox/ScWeb_Chinese_Translate/raw/branch/main/json/locales";

  static const feedbackUrl = "https://support.citizenwiki.cn/all";
  static const feedbackFAQUrl = "https://support.citizenwiki.cn/t/sc-toolbox";
  static String nav42KitUrl =
      "https://ecdn.42nav.xkeyc.cn/api/community-navs?sort=is_sponsored&depth=2&page=1&limit=1000";

  static String get devReleaseUrl => "$gitApiHome/SCToolBox/Release/releases";

  static Future<bool> checkHost() async {
    // 使用 DNS 获取可用列表
    final gitApiList = _genFinalList(await dnsLookupTxt("git.dns.scbox.org"));
    dPrint("DNS gitApiList ==== $gitApiList");
    final fasterGit = await getFasterUrl(gitApiList, "git");
    dPrint("gitApiList.Faster ==== $fasterGit");
    if (fasterGit != null) {
      gitApiHome = fasterGit;
    }
    final newsApiList = _genFinalList(await dnsLookupTxt("news.dns.scbox.org"));
    final fasterNews = await getFasterUrl(newsApiList, "news");
    dPrint("DNS newsApiList ==== $newsApiList");
    dPrint("newsApiList.Faster ==== $fasterNews");
    if (fasterNews != null) {
      newsApiHome = fasterNews;
    }
    isUrlCheckPass = fasterGit != null && fasterNews != null;
    return isUrlCheckPass;
  }

  static Future<List<String>> dnsLookupTxt(String host) async {
    if (await Api.isUseInternalDNS()) {
      dPrint("[URLConf] use internal DNS LookupTxt $host");
      return RSHttp.dnsLookupTxt(host);
    }
    dPrint("[URLConf] use DOH LookupTxt $host");
    return (await DohClient.resolveTXT(host)) ?? [];
  }

  static Future<String?> getFasterUrl(List<String> urls, String mode) async {
    String firstUrl = "";
    int callLen = 0;

    void onCall(RustHttpResponse? response, String url) {
      callLen++;
      if (response != null && response.statusCode == 200 && firstUrl.isEmpty) {
        firstUrl = url;
      }
    }

    for (var url in urls) {
      var reqUrl = url;
      switch (mode) {
        case "git":
          reqUrl = "$url/SCToolBox/Api/raw/branch/main/sc_doctor/version.json";
          break;
        case "news":
          reqUrl = "$url/api/latest";
          break;
      }
      RSHttp.head(reqUrl).then(
        (resp) => onCall(resp, url),
        onError: (err) {
          callLen++;
          dPrint("RSHttp.head error $err");
        },
      );
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
