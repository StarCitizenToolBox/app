import 'dart:convert';
import 'dart:typed_data';

import 'package:starcitizen_doctor/common/rust/api/http_api.dart' as rust_http;
import 'package:starcitizen_doctor/common/rust/api/http_api.dart';

class RSHttp {
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
}
