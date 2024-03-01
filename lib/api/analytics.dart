import 'package:flutter/foundation.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class AnalyticsApi {
  static touch(String key) async {
    // debug 不统计
    if (kDebugMode) return;
    dPrint("AnalyticsApi.touch === $key start");
    try {
      final r = await RSHttp.postData(
          "${URLConf.analyticsApiHome}/analytics/$key",
          data: null);
      dPrint("AnalyticsApi.touch === $key  over statusCode == ${r.statusCode}");
    } catch (e) {
      dPrint("AnalyticsApi.touch === $key Error:$e");
    }
  }
}
