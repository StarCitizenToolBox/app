import 'dart:convert';

import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/data/nav_api_data.dart';

class UDBNavApi {
  static Future<NavApiData> getNavItems({int pageNo = 1}) async {
    final r = await RSHttp.getText(URLConf.nav42KitUrl);
    if (r.isEmpty) throw "Network Error";
    final result = NavApiData.fromJson(jsonDecode(r));
    return result;
  }
}
