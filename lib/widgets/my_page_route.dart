import 'package:fluent_ui/fluent_ui.dart';

class MyPageRoute extends FluentPageRoute {
  late final WidgetBuilder _builder;

  MyPageRoute({required super.builder}) : _builder = builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    assert(debugCheckHasFluentTheme(context));
    final result = _builder(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: EntrancePageTransition(
        animation: CurvedAnimation(
          parent: animation,
          curve: FluentTheme.of(context).animationCurve,
        ),
        child: result,
      ),
    );
  }
}
