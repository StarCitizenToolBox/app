import 'dart:convert';

import '../common/conf/url_conf.dart';
import '../common/io/rs_http.dart';
import '../common/utils/log.dart';
import '../data/citizen_news_data.dart';
import 'api.dart';

class NewsApi {
  static Future<CitizenNewsData?> getLatest() async {
    try {
      final data = await RSHttp.getText(
        "${URLConf.newsApiHome}/api/latest",
        withCustomDns: await Api.isUseInternalDNS(),
      );
      final map = json.decode(data);
      return CitizenNewsData.fromJson(map);
    } catch (e) {
      dPrint("getLatestNews error: $e");
    }
    return null;
  }
}
