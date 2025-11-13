import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/rust/http_package.dart';

class RSHttp {
  static late Dio _dio;
  static Map<String, String> _defaultHeaders = {};

  static Future<void> init() async {
    _defaultHeaders = {};

    _dio = Dio(
      BaseOptions(
        headers: _defaultHeaders,
        responseType: ResponseType.bytes,
        validateStatus: (status) => true, // 接受所有状态码
      ),
    );
  }

  static Future<RustHttpResponse> get(
    String url, {
    Map<String, String>? headers,
    String? withIpAddress,
    bool? withCustomDns,
  }) async {
    return await _fetch(
      method: 'GET',
      url: url,
      headers: headers,
      withIpAddress: withIpAddress,
      withCustomDns: withCustomDns,
    );
  }

  static Future<String> getText(
    String url, {
    Map<String, String>? headers,
    String? withIpAddress,
    bool? withCustomDns,
  }) async {
    final r = await get(url, headers: headers, withIpAddress: withIpAddress, withCustomDns: withCustomDns);
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
    return await _fetch(
      method: 'POST',
      url: url,
      headers: headers,
      data: data,
      withIpAddress: withIpAddress,
      withCustomDns: withCustomDns,
    );
  }

  static Future<RustHttpResponse> head(
    String url, {
    Map<String, String>? headers,
    String? withIpAddress,
    bool? withCustomDns,
  }) async {
    return await _fetch(
      method: 'HEAD',
      url: url,
      headers: headers,
      withIpAddress: withIpAddress,
      withCustomDns: withCustomDns,
    );
  }

  static Future<List<String>> dnsLookupTxt(String host) async {
    // TXT 记录查询在 Web 平台上无法实现，返回空列表
    return [];
  }

  static Future<List<String>> dnsLookupIps(String host) async {
    // Web 平台无法直接查询 DNS，返回空列表
    // 在 Web 平台上，DNS 解析由浏览器自动处理
    return [];
  }

  static Future<RustHttpResponse> _fetch({
    required String method,
    required String url,
    Map<String, String>? headers,
    Uint8List? data,
    String? withIpAddress,
    bool? withCustomDns,
  }) async {
    try {
      final mergedHeaders = {..._defaultHeaders, ...?headers};

      final response = await _dio.request(
        url,
        data: data,
        options: Options(
          method: method,
          headers: mergedHeaders,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
        ),
      );

      // 将 Dio Response 转换为 RustHttpResponse
      return RustHttpResponse(
        statusCode: response.statusCode ?? 0,
        headers: _convertHeaders(response.headers.map),
        url: response.realUri.toString(),
        contentLength: response.headers.value('content-length') != null
            ? BigInt.from(int.parse(response.headers.value('content-length')!))
            : null,
        version: MyHttpVersion.httpUnknown,
        remoteAddr: response.realUri.host,
        data: response.data is Uint8List ? response.data : null,
      );
    } catch (e) {
      // 发生错误时返回默认响应
      return RustHttpResponse(
        statusCode: 0,
        headers: {},
        url: url,
        contentLength: null,
        version: MyHttpVersion.httpUnknown,
        remoteAddr: '',
        data: null,
      );
    }
  }

  static Map<String, String> _convertHeaders(Map<String, List<String>> headers) {
    final result = <String, String>{};
    headers.forEach((key, value) {
      if (value.isNotEmpty) {
        result[key] = value.join(', ');
      }
    });
    return result;
  }
}
