// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.4.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

enum MyHttpVersion {
  http09,
  http10,
  http11,
  http2,
  http3,
  httpUnknown,
  ;
}

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
