import 'dart:convert';
import 'dart:typed_data';

import 'package:starcitizen_doctor/common/io/dio_http.dart';

// Type alias to maintain compatibility
typedef RustHttpResponse = HttpResponse;

class RSHttp {
  static init() async {
    await DioHttp.init();
  }

  static Future<HttpResponse> get(String url,
      {Map<String, String>? headers, String? withIpAddress}) async {
    return await DioHttp.get(url, headers: headers, withIpAddress: withIpAddress);
  }

  static Future<String> getText(String url,
      {Map<String, String>? headers, String? withIpAddress}) async {
    return await DioHttp.getText(url, headers: headers, withIpAddress: withIpAddress);
  }

  static Future<HttpResponse> postData(String url,
      {Map<String, String>? headers,
      String? contentType,
      Uint8List? data,
      String? withIpAddress}) async {
    return await DioHttp.postData(url, headers: headers, contentType: contentType, data: data, withIpAddress: withIpAddress);
  }

  static Future<HttpResponse> head(String url,
      {Map<String, String>? headers, String? withIpAddress}) async {
    return await DioHttp.head(url, headers: headers, withIpAddress: withIpAddress);
  }
}
