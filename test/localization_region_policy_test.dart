import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accelerator guidance is exclusive to zh_CN', () {
    final zhCn = _readArb('intl_zh_CN.arb');
    final acceleratorKeys = zhCn.entries
        .where(
          (entry) =>
              !entry.key.startsWith('@') &&
              entry.value is String &&
              (entry.value as String).contains('加速器'),
        )
        .map((entry) => entry.key)
        .toList();

    expect(acceleratorKeys, isNotEmpty);

    final forbidden = RegExp(
      r'加速器|X黑盒|x[- ]?black box|accelerat(?:or|ion)|routing mode|'
      r'アクセラレーター|加速モード|ルーティングモード|'
      r'ускорител|режим маршрутизации',
      caseSensitive: false,
    );

    for (final locale in [
      'intl_zh_TW.arb',
      'intl_en.arb',
      'intl_ja.arb',
      'intl_ru.arb',
    ]) {
      final arb = _readArb(locale);
      for (final key in acceleratorKeys) {
        expect(
          arb[key],
          isA<String>().having(
            (value) => forbidden.hasMatch(value),
            'contains accelerator guidance',
            isFalse,
          ),
          reason: '$locale must keep $key locale-neutral',
        );
      }
    }
  });
}

Map<String, dynamic> _readArb(String name) {
  final file = File('lib/l10n/$name');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}
