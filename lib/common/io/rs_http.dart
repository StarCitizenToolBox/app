import 'dart:convert';
import 'dart:typed_data';

import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/rust/api/http_api.dart' as rust_http;
import 'package:starcitizen_doctor/common/rust/api/http_api.dart';
import 'package:starcitizen_doctor/common/rust/http_package.dart';

class RSHttp {
  static Future<void> init() async {
    await rust_http.setDefaultHeader(headers: {
      "User-Agent":
          "SCToolBox/${ConstConf.appVersion} (${ConstConf.appVersionCode})${ConstConf.isMSE ? "" : " DEV"} RSHttp"
    });
  }

  static Future<RustHttpResponse> get(
    String url, {
    Map<String, String>? headers,
    String? withIpAddress,
    bool? withCustomDns,
  }) async {
    final r = await rust_http.fetch(
      method: MyMethod.gets,
      url: url,
      headers: headers,
      withIpAddress: withIpAddress,
      withCustomDns: withCustomDns,
    );
    return r;
  }

  static Future<String> getText(
    String url, {
    Map<String, String>? headers,
    String? withIpAddress,
    bool? withCustomDns,
  }) async {
    final r = await get(url,
        headers: headers,
        withIpAddress: withIpAddress,
        withCustomDns: withCustomDns);
    if (r.data == null) return "";
    final str = utf8.decode(r.data!);
    return str;
  }

  static Future<RustHttpResponse> postData(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Uint8List? data,
    String? withIpAddress,
    bool? withCustomDns,
  }) async {
    if (contentType != null) {
      headers ??= {};
      headers["Content-Type"] = contentType;
    }
    final r = await rust_http.fetch(
      method: MyMethod.post,
      url: url,
      headers: headers,
      inputData: data,
      withIpAddress: withIpAddress,
      withCustomDns: withCustomDns,
    );
    return r;
  }

  static Future<RustHttpResponse> head(
    String url, {
    Map<String, String>? headers,
    String? withIpAddress,
    bool? withCustomDns,
  }) async {
    final r = await rust_http.fetch(
      method: MyMethod.head,
      url: url,
      headers: headers,
      withIpAddress: withIpAddress,
      withCustomDns: withCustomDns,
    );
    return r;
  }

  static Future<List<String>> dnsLookupTxt(String host) async {
    return await rust_http.dnsLookupTxt(host: host);
  }

  static Future<List<String>> dnsLookupIps(String host) async {
    return await rust_http.dnsLookupIps(host: host);
  }
}
