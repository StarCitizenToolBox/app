import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

/// Anonymous usage statistics.
///
/// Events are tied only to [installId], a random UUID generated locally on
/// first launch. Never put personal data (paths, user names, raw error
/// messages...) into `label` or `reason`; use [AnalyticsApi.classifyError] for
/// failure reasons.
class AnalyticsApi {
  /// Random install id (Hive `app_conf` -> `install_id`), set during app init.
  static String installId = "";

  static const statusTriggered = "";
  static const statusSuccess = "success";
  static const statusFailure = "failure";
  static const statusCancel = "cancel";

  static const _maxLabelLength = 64;
  static const _maxReasonLength = 48;

  /// Feature triggered / entered.
  static Future<void> touch(String key, {String? label}) {
    return _sendEvent(key, status: statusTriggered, label: label);
  }

  static Future<void> success(String key, {String? label}) {
    return _sendEvent(key, status: statusSuccess, label: label);
  }

  /// [reason] must be a coarse error class, see [classifyError].
  static Future<void> failure(String key, {String? label, String? reason}) {
    return _sendEvent(key, status: statusFailure, label: label, reason: reason);
  }

  static Future<void> cancel(String key, {String? label}) {
    return _sendEvent(key, status: statusCancel, label: label);
  }

  /// Maps an error to a coarse, non-personal class:
  /// `network`, `timeout`, `permission`, `not_found`, `io` or `unknown`.
  static String classifyError(Object? error) {
    if (error == null) return "unknown";
    if (error is TimeoutException) return "timeout";
    if (error is SocketException ||
        error is HttpException ||
        error is TlsException) {
      return "network";
    }
    if (error is FileSystemException) {
      final code = error.osError?.errorCode;
      if (error is PathAccessException || code == 5 || code == 13) {
        return "permission";
      }
      if (error is PathNotFoundException || code == 2 || code == 3) {
        return "not_found";
      }
      return "io";
    }
    // Errors from the Rust side arrive as plain messages; the message is only
    // inspected locally and never sent.
    final msg = error.toString().toLowerCase();
    if (msg.contains("timed out") || msg.contains("timeout")) return "timeout";
    if (msg.contains("permission denied") ||
        msg.contains("access is denied") ||
        msg.contains("拒绝访问")) {
      return "permission";
    }
    if (msg.contains("error sending request") ||
        msg.contains("connection") ||
        msg.contains("dns") ||
        msg.contains("network")) {
      return "network";
    }
    if (msg.contains("not found") ||
        msg.contains("cannot find") ||
        msg.contains("找不到")) {
      return "not_found";
    }
    if (msg.contains("os error") || msg.contains("i/o")) return "io";
    return "unknown";
  }

  static Future<void> _sendEvent(
    String key, {
    required String status,
    String? label,
    String? reason,
  }) async {
    final tag = status.isEmpty ? key : "$key:$status";
    if (kDebugMode || kProfileMode) {
      dPrint("AnalyticsApi.event === $tag skip");
      return;
    }
    dPrint("AnalyticsApi.event === $tag start");
    try {
      final body = <String, dynamic>{
        "id": installId,
        "key": key,
        "status": status,
        if (label != null && label.isNotEmpty)
          "label": _truncate(label, _maxLabelLength),
        if (reason != null && reason.isNotEmpty)
          "reason": _truncate(reason, _maxReasonLength),
        "ver": ConstConf.appVersion,
      };
      final r = await RSHttp.postData(
          "${URLConf.analyticsApiHome}/analytics/v2/event",
          contentType: "application/json",
          data: utf8.encode(json.encode(body)));
      dPrint("AnalyticsApi.event === $tag over statusCode == ${r.statusCode}");
      if (r.statusCode == 404 && status == statusTriggered) {
        // v2 not deployed, fall back to the legacy counter.
        final legacy = await RSHttp.postData(
            "${URLConf.analyticsApiHome}/analytics/$key",
            data: null);
        dPrint(
            "AnalyticsApi.event === $tag legacy statusCode == ${legacy.statusCode}");
      }
    } catch (e) {
      dPrint("AnalyticsApi.event === $tag Error:$e");
    }
  }

  static String _truncate(String value, int maxLength) =>
      value.length <= maxLength ? value : value.substring(0, maxLength);

  static Future<Map<String, dynamic>> getAnalyticsData() async {
    final r = await RSHttp.get("${URLConf.analyticsApiHome}/analytics");
    if (r.data == null) return {};
    final jsonData = json.decode(utf8.decode(r.data!));
    dPrint("AnalyticsApi.getAnalyticsData");
    return jsonData;
  }
}
