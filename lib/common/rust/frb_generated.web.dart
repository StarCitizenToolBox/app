// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.3.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

// Static analysis wrongly picks the IO variant, thus ignore this
// ignore_for_file: argument_type_not_assignable

import 'api/http_api.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'http_package.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  Map<String, String> dco_decode_Map_String_String(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  BigInt dco_decode_box_autoadd_u_64(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  List<(String, String)> dco_decode_list_record_string_string(dynamic raw);

  @protected
  MyMethod dco_decode_my_method(dynamic raw);

  @protected
  Map<String, String>? dco_decode_opt_Map_String_String(dynamic raw);

  @protected
  BigInt? dco_decode_opt_box_autoadd_u_64(dynamic raw);

  @protected
  Uint8List? dco_decode_opt_list_prim_u_8_strict(dynamic raw);

  @protected
  (String, String) dco_decode_record_string_string(dynamic raw);

  @protected
  RustHttpResponse dco_decode_rust_http_response(dynamic raw);

  @protected
  int dco_decode_u_16(dynamic raw);

  @protected
  BigInt dco_decode_u_64(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  Map<String, String> sse_decode_Map_String_String(
      SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_box_autoadd_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<(String, String)> sse_decode_list_record_string_string(
      SseDeserializer deserializer);

  @protected
  MyMethod sse_decode_my_method(SseDeserializer deserializer);

  @protected
  Map<String, String>? sse_decode_opt_Map_String_String(
      SseDeserializer deserializer);

  @protected
  BigInt? sse_decode_opt_box_autoadd_u_64(SseDeserializer deserializer);

  @protected
  Uint8List? sse_decode_opt_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  (String, String) sse_decode_record_string_string(
      SseDeserializer deserializer);

  @protected
  RustHttpResponse sse_decode_rust_http_response(SseDeserializer deserializer);

  @protected
  int sse_decode_u_16(SseDeserializer deserializer);

  @protected
  BigInt sse_decode_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  String cst_encode_AnyhowException(AnyhowException raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    throw UnimplementedError();
  }

  @protected
  JSAny cst_encode_Map_String_String(Map<String, String> raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return cst_encode_list_record_string_string(
        raw.entries.map((e) => (e.key, e.value)).toList());
  }

  @protected
  String cst_encode_String(String raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return raw;
  }

  @protected
  JSAny cst_encode_box_autoadd_u_64(BigInt raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return cst_encode_u_64(raw);
  }

  @protected
  JSAny cst_encode_list_prim_u_8_strict(Uint8List raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return raw.jsify()!;
  }

  @protected
  JSAny cst_encode_list_record_string_string(List<(String, String)> raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return raw.map(cst_encode_record_string_string).toList().jsify()!;
  }

  @protected
  JSAny? cst_encode_opt_Map_String_String(Map<String, String>? raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return raw == null ? null : cst_encode_Map_String_String(raw);
  }

  @protected
  JSAny? cst_encode_opt_box_autoadd_u_64(BigInt? raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return raw == null ? null : cst_encode_box_autoadd_u_64(raw);
  }

  @protected
  JSAny? cst_encode_opt_list_prim_u_8_strict(Uint8List? raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return raw == null ? null : cst_encode_list_prim_u_8_strict(raw);
  }

  @protected
  JSAny cst_encode_record_string_string((String, String) raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return [cst_encode_String(raw.$1), cst_encode_String(raw.$2)].jsify()!;
  }

  @protected
  JSAny cst_encode_rust_http_response(RustHttpResponse raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return [
      cst_encode_u_16(raw.statusCode),
      cst_encode_Map_String_String(raw.headers),
      cst_encode_String(raw.url),
      cst_encode_opt_box_autoadd_u_64(raw.contentLength),
      cst_encode_opt_list_prim_u_8_strict(raw.data)
    ].jsify()!;
  }

  @protected
  JSAny cst_encode_u_64(BigInt raw) {
    // Codec=Cst (C-struct based), see doc to use other codecs
    return castNativeBigInt(raw);
  }

  @protected
  int cst_encode_i_32(int raw);

  @protected
  int cst_encode_my_method(MyMethod raw);

  @protected
  int cst_encode_u_16(int raw);

  @protected
  int cst_encode_u_8(int raw);

  @protected
  void cst_encode_unit(void raw);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void sse_encode_Map_String_String(
      Map<String, String> self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_64(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_string_string(
      List<(String, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_my_method(MyMethod self, SseSerializer serializer);

  @protected
  void sse_encode_opt_Map_String_String(
      Map<String, String>? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_64(BigInt? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_prim_u_8_strict(
      Uint8List? self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_string(
      (String, String) self, SseSerializer serializer);

  @protected
  void sse_encode_rust_http_response(
      RustHttpResponse self, SseSerializer serializer);

  @protected
  void sse_encode_u_16(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_64(BigInt self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void wire__crate__api__http_api__fetch(NativePortType port_, int method,
          String url, JSAny? headers, JSAny? input_data) =>
      wasmModule.wire__crate__api__http_api__fetch(
          port_, method, url, headers, input_data);

  void wire__crate__api__http_api__set_default_header(
          NativePortType port_, JSAny headers) =>
      wasmModule.wire__crate__api__http_api__set_default_header(port_, headers);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
extension type RustLibWasmModule._(JSObject _) implements JSObject {
  external void wire__crate__api__http_api__fetch(NativePortType port_,
      int method, String url, JSAny? headers, JSAny? input_data);

  external void wire__crate__api__http_api__set_default_header(
      NativePortType port_, JSAny headers);
}
