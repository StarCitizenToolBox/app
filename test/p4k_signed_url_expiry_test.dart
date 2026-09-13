import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/home_p4k_update_dialog_ui.dart';

void main() {
  final now = DateTime.utc(2026, 8, 21, 6, 37);

  String signedUrl(DateTime expires) =>
      'https://sc-prod-public-objects.mcdn.robertsspaceindustries.com/objects'
      '?Expires=${expires.millisecondsSinceEpoch ~/ 1000}'
      '&KeyName=k&Signature=s';

  test('reads Expires from signed RSI CDN urls', () {
    final expires = now.add(const Duration(minutes: 90));
    expect(p4kSignedUrlExpiry(signedUrl(expires)), expires);
    expect(
      p4kSignedUrlExpiry('https://prod.mcdn.robertsspaceindustries.com/m.json'),
      isNull,
    );
  });

  test('flags urls expiring inside the margin', () {
    final soon = signedUrl(now.add(const Duration(minutes: 5)));
    final later = signedUrl(now.add(const Duration(minutes: 90)));
    const margin = Duration(minutes: 10);
    expect(p4kSignedUrlsExpireWithin([later], margin, now: now), isFalse);
    expect(p4kSignedUrlsExpireWithin([later, soon], margin, now: now), isTrue);
    expect(
      p4kSignedUrlsExpireWithin(
        [signedUrl(now.subtract(const Duration(minutes: 1)))],
        Duration.zero,
        now: now,
      ),
      isTrue,
    );
  });

  test('unsigned or empty urls never need a refresh', () {
    expect(
      p4kSignedUrlsExpireWithin(
        ['', 'https://example.invalid/a'],
        const Duration(hours: 1),
        now: now,
      ),
      isFalse,
    );
  });
}
