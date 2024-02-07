import 'dart:convert';
import 'dart:typed_data';

import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/common/rust/api/http_api.dart' as rust_http;
import 'package:starcitizen_doctor/common/rust/api/http_api.dart';
import 'package:starcitizen_doctor/common/rust/http_package.dart';

class RSHttp {
  static init() async {
    await rust_http.setDefaultHeader(headers: {
      "User-Agent":
          "SCToolBox/${AppConf.appVersion} (${AppConf.appVersionCode}) ${AppConf.isMSE ? "" : " DEV"} RSHttp"
    });
  }

  static Future<String> getText(String url,
      {Map<String, String>? headers}) async {
    final r = await rust_http.fetch(
        method: MyMethod.gets, url: url, headers: headers);
    if (r.data == null) return "";
    final str = utf8.decode(r.data!);
    return str;
  }

  static Future postData(String url,
      {Map<String, String>? headers,
      String? contentType,
      Uint8List? data}) async {
    if (contentType != null) {
      headers ??= {};
      headers["Content-Type"] = contentType;
    }
    final r = await rust_http.fetch(
        method: MyMethod.post, url: url, headers: headers, inputData: data);
    return r.statusCode == 200;
  }

  static Future<RustHttpResponse> head(String url,
      {Map<String, String>? headers}) async {
    final r = await rust_http.fetch(
        method: MyMethod.head, url: url, headers: headers);
    return r;
  }

  static Future<List<String>> dnsLookupTxt(String host) async {
    return await rust_http.dnsLookupTxt(host: host);
  }
}
