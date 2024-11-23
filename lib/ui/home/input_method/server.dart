import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/ui/home/input_method/server_qr_dialog_ui.dart';
import 'package:starcitizen_doctor/ui/home/localization/localization_ui_model.dart';

import 'input_method_dialog_ui_model.dart';

part 'server.g.dart';

part 'server.freezed.dart';

@freezed
class InputMethodServerState with _$InputMethodServerState {
  const factory InputMethodServerState({
    @Default(false) bool isServerStartup,
    String? serverAddressText,
  }) = _InputMethodServerState;
}

@riverpod
class InputMethodServer extends _$InputMethodServer {
  @override
  InputMethodServerState build() {
    state = InputMethodServerState(isServerStartup: false);
    ref.onDispose(() {
      stopServer();
    });
    return state;
  }

  LocalizationUIState get _localizationUIState =>
      ref.read(localizationUIModelProvider);

  InputMethodDialogUIModel get _inputMethodDialogUIModel =>
      ref.read(inputMethodDialogUIModelProvider.notifier);

  HttpServer? _httpServer;

  Future<void> stopServer() async {
    if (_httpServer != null) {
      await _httpServer!.close(force: true);
      _httpServer = null;
      state = state.copyWith(
        isServerStartup: false,
      );
      dPrint("[InputMethodServer] stopServer");
    }
  }

  Future<void> startServer() async {
    dPrint("[InputMethodServer] startServer");
    var handler =
        const Pipeline().addMiddleware(logRequests()).addHandler(_onHandler);

    var server = await shelf_io.serve(
        handler, "0.0.0.0", ConstConf.inputMethodServerPort);

    // Enable content compression
    server.autoCompress = true;

    dPrint('Serving at http://${server.address.host}:${server.port}');

    server.autoCompress = true;
    _httpServer = server;
    final address = await _findAddress();
    state = state.copyWith(
      isServerStartup: true,
      serverAddressText: address,
    );
  }

  Future<String> _findAddress() async {
    final list = <String>[];
    final List<NetworkInterface> address = await NetworkInterface.list();
    bool has192168 = false;
    for (var value in address) {
      for (var addr in value.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          list.add("http://${addr.address}:${ConstConf.inputMethodServerPort}");
          if (addr.address.startsWith('192.168.')) {
            has192168 = true;
          }
        }
      }
    }
    if (has192168) {
      list.removeWhere((element) => !element.contains('192.168.'));
    }
    if (list.isEmpty) {
      list.add(S.current.input_method_address_fetch_failed);
    }
    return list.join(", ");
  }

  Future<Response> _onHandler(Request request) async {
    final path = request.url.path;
    dPrint("[InputMethodServer] path: $path");
    Uint8List? contentByte;
    String mimeType;
    try {
      if (path.startsWith('api')) {
        return _onHandlerApi(request);
      }
      if (path == '/' || path == '') {
        contentByte =
            (await rootBundle.load('assets/web/input_method/index.html'))
                .buffer
                .asUint8List();
        mimeType = 'text/html; charset=utf-8';
      } else {
        var dotOffset = path.lastIndexOf('.');
        if (path.substring(dotOffset) == '.png' ||
            path.substring(dotOffset) == '.ttf' ||
            path.substring(dotOffset) == '.otf') {
          contentByte = (await rootBundle.load('assets/web/input_method/$path'))
              .buffer
              .asUint8List();
        } else {
          contentByte = (await rootBundle.load('assets/web/input_method/$path'))
              .buffer
              .asUint8List();
        }

        mimeType = dotOffset == -1
            ? 'text/plain; charset=utf-8'
            : {
                  '.html': 'text/html; charset=utf-8',
                  '.css': 'text/css; charset=utf-8',
                  '.js': 'text/javascript; charset=utf-8',
                  '.csv': 'text/csv; charset=utf-8',
                  '.txt': 'text/plain; charset=utf-8',
                  '.ico': 'image/x-icon',
                  '.jpg': 'image/jpg',
                  '.jpeg': 'image/jpeg',
                  '.png': 'image/png',
                  '.gif': 'image/gif',
                  '.svg': 'image/svg+xml',
                  '.json': 'application/json',
                  '.xml': 'application/xml',
                  '.ttf': 'font/ttf',
                  '.otf': 'font/otf'
                }[path.substring(dotOffset)] ??
                "application/octet-stream";
      }
      return Response.ok(
        contentByte,
        headers: {
          'Content-Type': mimeType,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      return Response.internalServerError();
    }
  }

  Future<Response> _onHandlerApi(Request request) async {
    final path = request.url.path;
    if (path == "api") {
      if (ref.exists(serverQrStateProvider)) {
        // ignore: avoid_manual_providers_as_generated_provider_dependency
        ref.read(serverQrStateProvider.notifier).popDialog();
      }
      return Response.ok(json.encode({
        "status": "ok",
        "appVersion": ConstConf.appVersion,
        "appVersionCode": ConstConf.appVersionCode,
        "appVersionDate": ConstConf.appVersionDate,
        "isMSE": ConstConf.isMSE,
        "installedCommunityInputMethodSupportVersion":
            _localizationUIState.installedCommunityInputMethodSupportVersion,
      }));
    } else if (path.startsWith("api/send") && request.method == "POST") {
      final body = await request.readAsString();
      final data = json.decode(body);
      final text = data["text"] ?? "";
      if (text.isEmpty) {
        return Response.badRequest(
            body: json.encode({
          "result": "error",
          "message": S.current.input_method_text_cannot_be_empty,
        }));
      }
      final autoCopy = data["autoCopy"] ?? false;
      final autoInput = data["autoInput"] ?? false;
      try {
        await _inputMethodDialogUIModel.onSendText(
          text,
          autoCopy: autoCopy,
          autoInput: autoInput,
        );
        return Response.ok(json.encode({
          "result": "ok",
          "message": S.current.input_method_send_success,
        }));
      } catch (e) {
        return Response.internalServerError(
            body: json.encode({
          "result": "error",
          "message": e.toString(),
        }));
      }
    } else {
      return Response.notFound("Not Found");
    }
  }
}