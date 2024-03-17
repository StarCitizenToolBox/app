import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

class AnalyticsApi {
  static touch(String key) async {
    if (kDebugMode || kProfileMode) return;
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

  static Future<Map<String, dynamic>> getAnalyticsData() async {
    final r = await RSHttp.get("${URLConf.analyticsApiHome}/analytics");
    if (r.data == null) return {};
    final jsonData = json.decode(utf8.decode(r.data!));
    dPrint("AnalyticsApi.getAnalyticsData");
    return jsonData;
  }
}
