import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/rust/api/http_api.dart' as rust_http;

class AnalyticsApi {
  static touch(String key) async {
    // debug 不统计
    if (kDebugMode) return;
    dPrint("AnalyticsApi.touch === $key start");
    try {
      await rust_http.postJsonString(
          url: "${URLConf.xkeycApiHome}/analytics/$key",
          jsonData: json.encode({"test": "a"}));
      dPrint("AnalyticsApi.touch === $key  over");
    } catch (e) {
      dPrint("AnalyticsApi.touch === $key Error:$e");
    }
  }
}
