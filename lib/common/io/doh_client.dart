import 'dart:convert';

import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/data/doh_client_response_data.dart';

class DohClient {
  static Future<DohClientResponseData?> resolve(
      String domain, String type) async {
    try {
      final r = await RSHttp.getText(
          "${ConstConf.dohAddress}?name=$domain&type=$type");
      final data = DohClientResponseData.fromJson(json.decode(r));
      return data;
    } catch (e) {
      dPrint("DohClient.resolve error: $e");
      return null;
    }
  }

  static Future<List<String>?> resolveIP(String domain, String type) async {
    final data = await resolve(domain, type);
    if (data == null) return [];
    return data.answer?.map((e) => _removeDataPadding(e.data)).toList();
  }

  static Future<List<String>?> resolveTXT(String domain) async {
    final data = await resolve(domain, "TXT");
    if (data == null) return [];
    return data.answer?.map((e) => _removeDataPadding(e.data)).toList();
  }

  static String _removeDataPadding(String? data) {
    // data demo: {"data":"\"https://git.scbox.xkeyc.cn,https://gitapi.scbox.org\""}
    if (data == null) return "";
    data = data.trim();
    if (data.startsWith("\"")) {
      data = data.substring(1);
    }
    if (data.endsWith("\"")) {
      data = data.substring(0, data.length - 1);
    }
    return data;
  }
}
