import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/common/utils/rsi_launcher_bundle.dart';

void main() {
  test('extracts hashes from current index and historical main bundles', () {
    expect(extractRsiLauncherBundleHash(r'app\launcher\static\js\index.deadbeef.js'), 'deadbeef');
    expect(extractRsiLauncherBundleHash('app/launcher/static/js/main.f3ea829e.js'), 'f3ea829e');
    expect(extractRsiLauncherBundleHash('app/static/js/main.abcdef12.js'), 'abcdef12');
  });

  test('rejects unrelated bundles and non-hex hashes', () {
    expect(extractRsiLauncherBundleHash('app/overlay/static/js/index.1e614767.js'), isNull);
    expect(extractRsiLauncherBundleHash('lib/main.js'), isNull);
    expect(extractRsiLauncherBundleHash('app/launcher/static/js/index.not-a-hash.js'), isNull);
  });
}
