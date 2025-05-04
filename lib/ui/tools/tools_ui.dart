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
                    onPressed: state.working ? null : () => model.loadToolsCard(context, skipPathScan: false),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30, left: 12, right: 12),
                      child: Icon(FluentIcons.refresh),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (state.items.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ProgressRing(),
                      const SizedBox(height: 12),
                      Text(S.current.tools_info_scanning),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: MasonryGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: (state.isItemLoading) ? state.items.length + 1 : state.items.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return GridItemAnimator(
                          index: index,
                          child: Container(
                              width: 300,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: FluentTheme.of(context).cardColor,
                              ),
                              child: makeLoading(context)),
                        );
                      }
                      final item = state.items[index];
                      return GridItemAnimator(
                        index: index,
                        child: Container(
                          width: 300,
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
                                          color: Colors.white.withValues(alpha: .2),
                                          borderRadius: BorderRadius.circular(1000)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: item.icon,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(
                                      item.name,
                                      style: const TextStyle(fontSize: 16),
                                    )),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  item.infoString,
                                  style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .6)),
                                ),
                                const SizedBox(height: 12),
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
                                                    showToast(context, S.current.tools_info_processing_failed(e));
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
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProgressRing(),
                  const SizedBox(height: 12),
                  Text(S.current.doctor_info_processing),
                ],
              ),
            ),
          )
      ],
    );
  }

  Widget makeGamePathSelect(BuildContext context, ToolsUIModel model, ToolsUIState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.current.tools_info_game_install_location),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ComboBox<String>(
              isExpanded: true,
              value: state.scInstalledPath,
              items: [
                for (final path in state.scInstallPaths)
                  ComboBoxItem(
                    value: path,
                    child: Text(path),
                  )
              ],
              onChanged: (v) {
                model.onChangeGamePath(v!);
                model.loadToolsCard(context, skipPathScan: true);
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
            onPressed: () {
              if (state.scInstalledPath.trim().isEmpty) {
                showToast(context, S.current.tools_action_info_star_citizen_not_found);
                return;
              }
              model.openDir(state.scInstalledPath);
            })
      ],
    );
  }

  Widget makeGameLauncherPathSelect(BuildContext context, ToolsUIModel model, ToolsUIState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.current.tools_info_rsi_launcher_location),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ComboBox<String>(
              isExpanded: true,
              value: state.rsiLauncherInstalledPath,
              items: [
                for (final path in state.rsiLauncherInstallPaths)
                  ComboBoxItem(
                    value: path,
                    child: Text(path),
                  )
              ],
              onChanged: (v) {
                model.onChangeLauncherPath(v!);
                model.loadToolsCard(context, skipPathScan: true);
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
            onPressed: () {
              if (state.scInstalledPath.trim().isEmpty) {
                showToast(context, S.current.tools_rsi_launcher_enhance_msg_error_launcher_notfound);
                return;
              }
              model.openDir(state.rsiLauncherInstalledPath);
            })
      ],
    );
  }
}
