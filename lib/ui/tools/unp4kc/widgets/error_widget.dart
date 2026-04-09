import 'package:fluent_ui/fluent_ui.dart';

class UnP4kErrorWidget extends StatelessWidget {
  final String errorMessage;

  const UnP4kErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(errorMessage)],
        ),
      ),
    );
  }
}
