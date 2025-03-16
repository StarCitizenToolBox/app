import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ToolsLogAnalyzeDialogUI extends HookConsumerWidget {
  const ToolsLogAnalyzeDialogUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text("Log 分析器"),
      ),
      content: Column(
        children: [],
      ),
    );
  }
}
