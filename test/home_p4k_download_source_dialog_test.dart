import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/common/rust/api/p4k_upgrader_api.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/home_p4k_download_source_dialog_ui.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/home_p4k_update_dialog_ui.dart';

void main() {
  Widget app() => FluentApp(
    localizationsDelegates: const [S.delegate],
    supportedLocales: S.delegate.supportedLocales,
    home: const HomeP4kDownloadSourceDialogUI(),
  );

  testWidgets('requires an explicit source selection', (tester) async {
    await tester.pumpWidget(app());
    expect(find.byKey(p4kOfficialSourceOptionKey), findsOneWidget);
    expect(find.byKey(p4kCommunityMirrorSourceOptionKey), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.byKey(p4kSourceContinueKey),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('shows accessible mirror verification warning', (tester) async {
    await tester.pumpWidget(
      FluentApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: const HomeP4kDownloadSourceDialogUI(),
      ),
    );
    await tester.pumpAndSettle();
    final limitation = find.byKey(p4kCommunityMirrorLimitationKey);
    expect(limitation, findsOneWidget);
    expect(
      tester.widget<Text>(limitation).data,
      '无需登录，可能更新不及时，下载完毕后请使用官方源或启动器再次校验',
    );
    expect(find.text('中文百科镜像（免登录）'), findsOneWidget);
    expect(tester.getSemantics(limitation).label, contains('再次校验'));
  });

  testWidgets('returns official and mirror typed values', (tester) async {
    P4kDownloadSource? result;
    await tester.pumpWidget(
      FluentApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Button(
            onPressed: () async {
              result = await showP4kDownloadSourceDialog(context);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(p4kOfficialSourceOptionKey));
    await tester.pump();
    await tester.tap(find.byKey(p4kSourceContinueKey));
    await tester.pumpAndSettle();
    expect(result, P4kDownloadSource.official);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(p4kCommunityMirrorSourceOptionKey));
    await tester.pump();
    await tester.tap(find.byKey(p4kSourceContinueKey));
    await tester.pumpAndSettle();
    expect(result, P4kDownloadSource.communityMirror);
  });

  testWidgets('cancel returns null', (tester) async {
    P4kDownloadSource? result = P4kDownloadSource.official;
    await tester.pumpWidget(
      FluentApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Button(
            onPressed: () async {
              result = await showP4kDownloadSourceDialog(context);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(p4kSourceCancelKey));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('escape dismisses without selecting a source', (tester) async {
    P4kDownloadSource? result = P4kDownloadSource.official;
    await tester.pumpWidget(
      FluentApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Button(
            onPressed: () async {
              result = await showP4kDownloadSourceDialog(context);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('barrier dismisses without selecting a source', (tester) async {
    P4kDownloadSource? result = P4kDownloadSource.official;
    await tester.pumpWidget(
      FluentApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) => Button(
            onPressed: () async {
              result = await showP4kDownloadSourceDialog(context);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('all typed mirror reasons select localized summaries', (
    tester,
  ) async {
    final expectations = <Locale, List<String>>{
      const Locale('zh', 'CN'): ['不符合', '尚未收录', '基础包不完整', '版本不匹配'],
      const Locale('zh', 'TW'): ['不符合', '尚未收錄', '基礎套件不完整', '版本不相符'],
      const Locale('en'): [
        'not eligible',
        'not been mirrored',
        'base package is incomplete',
        'does not match',
      ],
      const Locale('ja'): ['対象外', 'まだミラー', 'ベースパッケージが不完全', '一致しません'],
      const Locale('ru'): [
        'не подходит',
        'ещё не размещён',
        'базовый пакет неполон',
        'не соответствует',
      ],
    };
    const reasons = P4kMirrorUnavailableReason.values;
    for (final localeEntry in expectations.entries) {
      await tester.pumpWidget(
        FluentApp(
          locale: localeEntry.key,
          localizationsDelegates: const [S.delegate],
          supportedLocales: S.delegate.supportedLocales,
          home: const HomeP4kDownloadSourceDialogUI(),
        ),
      );
      await tester.pumpAndSettle();
      for (var index = 0; index < reasons.length; index++) {
        final text = p4kProviderErrorMessage(
          P4kMirrorUnavailable(
            reason: reasons[index],
            objectSha256: 'abc123',
            compressedSize: BigInt.from(42),
            message: 'UNLOCALIZED_UPSTREAM_DIAGNOSTIC',
          ),
        );
        expect(
          text,
          contains(localeEntry.value[index]),
          reason: '${localeEntry.key} ${reasons[index]}',
        );
        expect(text, contains('abc123'));
        expect(text, contains('42'));
        expect(text, isNot(contains('UNLOCALIZED_UPSTREAM_DIAGNOSTIC')));
      }
    }

    final typed = const P4kMirrorUnavailable(
      reason: P4kMirrorUnavailableReason.releaseMismatch,
      message: 'release mismatch',
    );
    expect(mapP4kMirrorOperationalError(typed), same(typed));
    expect(mapP4kMirrorOperationalError(Exception('generic')), isNull);
  });

  testWidgets('inexact payload is labeled as a conservative estimate', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    expect(
      formatP4kPayloadEstimate(BigInt.from(1024), exact: false),
      contains('1.00 KiB'),
    );
    expect(
      formatP4kPayloadEstimate(BigInt.from(1024), exact: false),
      isNot(formatP4kPayloadEstimate(BigInt.from(1024), exact: true)),
    );
  });
}
