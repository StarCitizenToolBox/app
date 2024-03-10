import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class ToolsUI extends HookConsumerWidget {
  const ToolsUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toolsUIModelProvider);
    final model = ref.read(toolsUIModelProvider.notifier);

    useEffect(() {
      addPostFrameCallback(() {
        model.loadToolsCard(context, skipPathScan: false);
      });
      return null;
    }, []);

    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        makeGameLauncherPathSelect(context, model, state),
                        const SizedBox(height: 12),
                        makeGamePathSelect(context, model, state),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Button(
                    onPressed: state.working
                        ? null
                        : () =>
                            model.loadToolsCard(context, skipPathScan: false),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 30, bottom: 30, left: 12, right: 12),
                      child: Icon(FluentIcons.refresh),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (state.items.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProgressRing(),
                      SizedBox(height: 12),
                      Text("正在扫描..."),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: AlignedGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: (state.isItemLoading)
                        ? state.items.length + 1
                        : state.items.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return Container(
                            width: 300,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: FluentTheme.of(context).cardColor,
                            ),
                            child: makeLoading(context));
                      }
                      final item = state.items[index];
                      return Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: FluentTheme.of(context).cardColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.2),
                                        borderRadius:
                                            BorderRadius.circular(1000)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: item.icon,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Text(
                                    item.name,
                                    style: const TextStyle(fontSize: 16),
                                  )),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                  child: Text(
                                item.infoString,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(.6)),
                              )),
                              Row(
                                children: [
                                  const Spacer(),
                                  Button(
                                    onPressed: state.working
                                        ? null
                                        : item.onTap == null
                                            ? null
                                            : () {
                                                try {
                                                  item.onTap?.call();
                                                } catch (e) {
                                                  showToast(
                                                      context, "处理失败！：$e");
                                                }
                                              },
                                    child: const Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Icon(FluentIcons.play),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
          ],
        ),
        if (state.working)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(150),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProgressRing(),
                  SizedBox(height: 12),
                  Text("正在处理..."),
                ],
              ),
            ),
          )
      ],
    );
  }

  Widget makeGamePathSelect(
      BuildContext context, ToolsUIModel model, ToolsUIState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("游戏安装位置：  "),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ComboBox<String>(
              value: state.scInstalledPath,
              items: [
                for (final path in state.scInstallPaths)
                  ComboBoxItem(
                    value: path,
                    child: Text(path),
                  )
              ],
              onChanged: (v) {
                model.loadToolsCard(context, skipPathScan: true);
                model.onChangeGamePath(v!);
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Button(
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(FluentIcons.folder_open),
            ),
            onPressed: () => model.openDir(state.scInstalledPath))
      ],
    );
  }

  Widget makeGameLauncherPathSelect(
      BuildContext context, ToolsUIModel model, ToolsUIState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("RSI启动器位置："),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ComboBox<String>(
              value: state.rsiLauncherInstalledPath,
              items: [
                for (final path in state.rsiLauncherInstallPaths)
                  ComboBoxItem(
                    value: path,
                    child: Text(path),
                  )
              ],
              onChanged: (v) {
                model.loadToolsCard(context, skipPathScan: true);
                model.onChangeLauncherPath(v!);
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Button(
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(FluentIcons.folder_open),
            ),
            onPressed: () => model.openDir(state.rsiLauncherInstalledPath))
      ],
    );
  }
}
