import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/ui/home/microsoft_store_feature_guard.dart';

void main() {
  test('store build continues without showing the restriction', () async {
    var promptCalls = 0;
    var installCalls = 0;
    final allowed = await guardMicrosoftStoreOnlyFeature(
      isMicrosoftStoreVersion: true,
      showRestriction: () async {
        promptCalls++;
        return false;
      },
      installMicrosoftStoreVersion: () async => installCalls++,
    );

    expect(allowed, isTrue);
    expect([promptCalls, installCalls], [0, 0]);
  });

  test('development build stops after showing the restriction', () async {
    var promptCalls = 0;
    var installCalls = 0;
    final allowed = await guardMicrosoftStoreOnlyFeature(
      isMicrosoftStoreVersion: false,
      showRestriction: () async {
        promptCalls++;
        return false;
      },
      installMicrosoftStoreVersion: () async => installCalls++,
    );

    expect(allowed, isFalse);
    expect([promptCalls, installCalls], [1, 0]);
  });

  test('install action does not continue into the protected feature', () async {
    var installCalls = 0;
    final allowed = await guardMicrosoftStoreOnlyFeature(
      isMicrosoftStoreVersion: false,
      showRestriction: () async => true,
      installMicrosoftStoreVersion: () async => installCalls++,
    );

    expect(allowed, isFalse);
    expect(installCalls, 1);
  });
}
