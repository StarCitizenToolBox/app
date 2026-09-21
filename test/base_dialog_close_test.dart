import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';

void main() {
  testWidgets('close removes its own dialog even under another page', (
    tester,
  ) async {
    late BuildContext homeContext;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) {
            homeContext = context;
            return const Text('home');
          },
          routes: [
            GoRoute(path: 'next', builder: (_, _) => const Text('next')),
          ],
        ),
      ],
    );
    await tester.pumpWidget(FluentApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    late DialogClose close;
    final result = showBaseDialog(
      homeContext,
      title: 'tip',
      content: const Text('toast'),
      actionsBuilder: (c) {
        close = c;
        return [Button(onPressed: () => c('ok'), child: const Text('ok'))];
      },
    );
    await tester.pumpAndSettle();
    expect(find.text('toast'), findsOneWidget);

    // A page is pushed over the still-open dialog.
    router.go('/next');
    await tester.pumpAndSettle();
    expect(find.text('next'), findsOneWidget);

    // Closing the dialog must not pop the page above it.
    close('done');
    await tester.pumpAndSettle();
    expect(await result, 'done');
    expect(find.text('next'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(find.text('toast'), findsNothing);
  });

  testWidgets('close pops the dialog when it is on top', (tester) async {
    late BuildContext homeContext;
    await tester.pumpWidget(
      FluentApp(
        home: Builder(
          builder: (context) {
            homeContext = context;
            return const Text('home');
          },
        ),
      ),
    );

    final result = showBaseDialog(
      homeContext,
      title: 'tip',
      content: const Text('toast'),
      actionsBuilder: (close) => [
        Button(onPressed: () => close(true), child: const Text('ok')),
      ],
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();

    expect(await result, isTrue);
    expect(find.text('toast'), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });
}
