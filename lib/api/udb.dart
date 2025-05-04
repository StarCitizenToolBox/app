import 'dart:convert';

import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/data/nav_api_data.dart';

class UDBNavApi {
  static Future<NavApiData> getNavItems({int pageNo = 1}) async {
    final r = await RSHttp.getText(
        "https://payload.citizenwiki.cn/api/community-navs?sort=is_sponsored&depth=2&page=$pageNo&limit=1000");
    if (r.isEmpty) throw "Network Error";
    final result = NavApiData.fromJson(jsonDecode(r));
    return result;
  }
}
