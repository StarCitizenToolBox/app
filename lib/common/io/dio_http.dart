import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';

/// HTTP Response class that matches the Rust HTTP response interface
class HttpResponse {
  final int statusCode;
  final Map<String, String> headers;
  final String url;
  final BigInt? contentLength;
  final Uint8List? data;

  const HttpResponse({
    required this.statusCode,
    required this.headers,
    required this.url,
    this.contentLength,
    this.data,
  });
}

/// Dio-based HTTP client that replaces the Rust-based RSHttp
class DioHttp {
  static final Dio _dio = Dio();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    
    _dio.options.headers = {
      "User-Agent":
          "SCToolBox/${ConstConf.appVersion} (${ConstConf.appVersionCode})${ConstConf.isMSE ? "" : " DEV"} DioHttp"
    };
    
    _initialized = true;
  }

  static Future<HttpResponse> get(String url,
      {Map<String, String>? headers, String? withIpAddress}) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
        ),
      );
      return _convertResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> getText(String url,
      {Map<String, String>? headers, String? withIpAddress}) async {
    final r = await get(url, headers: headers, withIpAddress: withIpAddress);
    if (r.data == null) return "";
    final str = utf8.decode(r.data!);
    return str;
  }

  static Future<HttpResponse> postData(String url,
      {Map<String, String>? headers,
      String? contentType,
      Uint8List? data,
      String? withIpAddress}) async {
    if (contentType != null) {
      headers ??= {};
      headers["Content-Type"] = contentType;
    }
    
    try {
      final response = await _dio.post<List<int>>(
        url,
        data: data,
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
        ),
      );
      return _convertResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<HttpResponse> head(String url,
      {Map<String, String>? headers, String? withIpAddress}) async {
    try {
      final response = await _dio.head(
        url,
        options: Options(
          headers: headers,
        ),
      );
      return _convertResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static HttpResponse _convertResponse(Response<dynamic> response) {
    final headersMap = <String, String>{};
    response.headers.forEach((name, values) {
      if (values.isNotEmpty) {
        headersMap[name] = values.join(', ');
      }
    });

    Uint8List? data;
    if (response.data != null) {
      if (response.data is List<int>) {
        data = Uint8List.fromList(response.data as List<int>);
      } else if (response.data is String) {
        data = Uint8List.fromList(utf8.encode(response.data as String));
      }
    }

    BigInt? contentLength;
    final contentLengthHeader = response.headers.value('content-length');
    if (contentLengthHeader != null) {
      contentLength = BigInt.tryParse(contentLengthHeader);
    }

    return HttpResponse(
      statusCode: response.statusCode ?? 0,
      headers: headersMap,
      url: response.realUri.toString(),
      contentLength: contentLength,
      data: data,
    );
  }
}
