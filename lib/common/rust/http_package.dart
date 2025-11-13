// HTTP 响应数据类
// 原先由 flutter_rust_bridge 生成，现改为纯 Dart 实现

import 'dart:typed_data';

enum MyHttpVersion { http09, http10, http11, http2, http3, httpUnknown }

class RustHttpResponse {
  final int statusCode;
  final Map<String, String> headers;
  final String url;
  final BigInt? contentLength;
  final MyHttpVersion version;
  final String remoteAddr;
  final Uint8List? data;

  const RustHttpResponse({
    required this.statusCode,
    required this.headers,
    required this.url,
    this.contentLength,
    required this.version,
    required this.remoteAddr,
    this.data,
  });

  @override
  int get hashCode =>
      statusCode.hashCode ^
      headers.hashCode ^
      url.hashCode ^
      contentLength.hashCode ^
      version.hashCode ^
      remoteAddr.hashCode ^
      data.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RustHttpResponse &&
          runtimeType == other.runtimeType &&
          statusCode == other.statusCode &&
          headers == other.headers &&
          url == other.url &&
          contentLength == other.contentLength &&
          version == other.version &&
          remoteAddr == other.remoteAddr &&
          data == other.data;
}
