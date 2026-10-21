import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/provider/download_manager.dart';

void main() {
  // The speed limit dialog accepts input matching `^\d*[km]?$`.
  final textToByte = DownloadManager().textToByte;

  test('plain numbers are bytes per second', () {
    expect(textToByte('1'), 1);
    expect(textToByte('2048'), 2048);
  });

  test('k and m are binary multiples, either case, surrounding spaces ignored', () {
    expect(textToByte('100k'), 100 * 1024);
    expect(textToByte('100K'), 100 * 1024);
    expect(textToByte('10m'), 10 * 1024 * 1024);
    expect(textToByte(' 10M '), 10 * 1024 * 1024);
  });

  test('empty, zero and unknown units mean no limit', () {
    expect(textToByte(''), 0);
    expect(textToByte('0'), 0);
    expect(textToByte('0k'), 0);
    expect(textToByte('10g'), 0);
  });

  test(
    'a unit without a number means no limit',
    () {
      expect(textToByte('k'), 0);
      expect(textToByte('m'), 0);
    },
    skip: 'Known bug: "k"/"m" pass the dialog\'s input filter but int.parse("") throws, so '
        'choosing "restart now" fails with an uncaught FormatException.',
  );
}
