import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/common/conf.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';

class AnalyticsApi {
  static final Dio _dio = Dio();

  static touch(String key) async {
    dPrint("AnalyticsApi.touch === $key start");
    try {
      await _dio.post("${AppConf.xkeycApiUrl}/analytics/$key");
      dPrint("AnalyticsApi.touch === $key  over");
    } catch (e) {
      dPrint("AnalyticsApi.touch === $key Error:$e");
    }
  }
}
