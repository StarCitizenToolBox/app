// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.8.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<void> sendNotify(
        {String? summary, String? body, String? appName, String? appId}) =>
    RustLib.instance.api.crateApiWin32ApiSendNotify(
        summary: summary, body: body, appName: appName, appId: appId);

Future<bool> setForegroundWindow({required String windowName}) =>
    RustLib.instance.api
        .crateApiWin32ApiSetForegroundWindow(windowName: windowName);
