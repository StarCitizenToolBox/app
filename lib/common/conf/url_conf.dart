import 'package:starcitizen_doctor/api/api.dart';
import 'package:starcitizen_doctor/common/io/doh_client.dart';
import 'package:starcitizen_doctor/common/rust/api/http_api.dart' as rust_http;
import 'package:starcitizen_doctor/common/utils/log.dart';

class URLConf {
  /// HOME API
  static String gitApiHome = "https://git.scbox.xkeyc.cn";
  static String newsApiHome = "https://scbox.citizenwiki.cn";
  static const String analyticsApiHome = "https://scbox.org";

  /// PartyRoom Server
  static const String partyRoomServerAddress = "localhost";
  static const int partyRoomServerPort = 50051;
  // static const String partyRoomServerAddress = "ecdn.partyroom.grpc.scbox.xkeyc.cn";
  // static const int partyRoomServerPort = 443;

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
      "https://payload.citizenwiki.cn/api/community-navs?sort=is_sponsored&depth=2&page=1&limit=1000";

  static String get devReleaseUrl => "$gitApiHome/SCToolBox/Release/releases";

  /// RSI Avatar Base URL
  static const String rsiAvatarBaseUrl = "https://robertsspaceindustries.com";

  static Future<bool> checkHost() async {
    // 使用 DNS 获取可用列表
    final gitApiList = _genFinalList(await dnsLookupTxt("git.dns.scbox.org"));
    dPrint("DNS gitApiList ==== $gitApiList");
    final fasterGit = await rust_http.getFasterUrl(
      urls: gitApiList,
      pathSuffix: "/SCToolBox/Api/raw/branch/main/sc_doctor/version.json",
    );
    dPrint("gitApiList.Faster ==== $fasterGit");
    if (fasterGit != null) {
      gitApiHome = fasterGit;
    }
    final newsApiList = _genFinalList(await dnsLookupTxt("news.dns.scbox.org"));
    final fasterNews = await rust_http.getFasterUrl(urls: newsApiList, pathSuffix: "/api/latest");
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
      return rust_http.dnsLookupTxt(host: host);
    }
    dPrint("[URLConf] use DOH LookupTxt $host");
    return (await DohClient.resolveTXT(host)) ?? [];
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
