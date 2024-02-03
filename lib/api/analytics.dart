import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';

class AnalyticsApi {
  static final Dio _dio = Dio();

  static touch(String key) async {
    // debug 不统计
    if (kDebugMode) return;
    dPrint("AnalyticsApi.touch === $key start");
    try {
      await _dio.post("${URLConf.xkeycApiHome}/analytics/$key");
      dPrint("AnalyticsApi.touch === $key  over");
    } catch (e) {
      dPrint("AnalyticsApi.touch === $key Error:$e");
    }
  }
}
