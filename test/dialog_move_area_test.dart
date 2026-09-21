import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import 'package:starcitizen_doctor/widgets/src/dialog_move_area.dart';

void main() {
  final dialogOnTop = DialogRouteObserver.instance.dialogOnTop;

  Future<void> openDialog(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (_) => ContentDialog(content: Text(text)),
    );
  }

  testWidgets(
    'a page pushed over an open dialog hides the strip until the dialog is '
    'back on top',
    (tester) async {
      late BuildContext homeContext;
      late BuildContext dialogContext;
      final router = GoRouter(
        observers: [DialogRouteObserver.instance],
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
      expect(dialogOnTop.value, isFalse);

      // The input-method dialog...
      showDialog<void>(
        context: homeContext,
        builder: (context) {
          dialogContext = context;
          return const ContentDialog(content: Text('input method'));
        },
      );
      await tester.pumpAndSettle();
      expect(dialogOnTop.value, isTrue);

      // ...navigates to the downloader without closing itself...
      dialogContext.go('/next');
      await tester.pumpAndSettle();
      expect(find.text('next'), findsOneWidget);
      expect(dialogOnTop.value, isFalse);

      // ...which then shows a toast from the dialog's context.
      openDialog(dialogContext, 'downloading');
      await tester.pumpAndSettle();
      expect(dialogOnTop.value, isTrue);

      Navigator.of(dialogContext, rootNavigator: true).pop();
      await tester.pumpAndSettle();
      expect(find.text('downloading'), findsNothing);
      expect(dialogOnTop.value, isFalse);

      // Going back reveals the input-method dialog again.
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('input method'), findsOneWidget);
      expect(dialogOnTop.value, isTrue);

      Navigator.of(dialogContext, rootNavigator: true).pop();
      await tester.pumpAndSettle();
      expect(dialogOnTop.value, isFalse);
    },
  );

  testWidgets('the strip is only mounted while a dialog is on top', (
    tester,
  ) async {
    late BuildContext homeContext;
    await tester.pumpWidget(
      FluentApp(
        navigatorObservers: [DialogRouteObserver.instance],
        builder: (context, child) =>
            Stack(children: [child!, const DialogMoveArea()]),
        home: Builder(
          builder: (context) {
            homeContext = context;
            return const Text('home');
          },
        ),
      ),
    );
    expect(find.byType(DragToMoveArea), findsNothing);

    openDialog(homeContext, 'toast');
    await tester.pumpAndSettle();
    expect(find.byType(DragToMoveArea), findsOneWidget);

    Navigator.of(homeContext).pop();
    await tester.pumpAndSettle();
    // Kept briefly so unmounting does not land in the exit animation.
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(DragToMoveArea), findsNothing);
  });
}
