import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/data/game_performance_data.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'performance_ui_model.dart';

class HomePerformanceUI extends HookConsumerWidget {
  const HomePerformanceUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePerformanceUIModelProvider);
    final model = ref.read(homePerformanceUIModelProvider.notifier);

    var content = makeLoading(context);

    if (state.performanceMap != null) {
      content = Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: [
                      if (state.showGraphicsPerformanceTip)
                        InfoBar(
                          title: Text(
                              S.current.performance_info_graphic_optimization_hint),
                          content: Text(
                            S.current.performance_info_graphic_optimization_warning,
                          ),
                          onClose: () => model.closeTip(),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "当前状态：${state.enabled ? "已应用" : "未应用"}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 32),
                          Text(
                            S.current.performance_action_preset,
                            style: const TextStyle(fontSize: 18),
                          ),
                          for (final item in {
                            "low": S.current.performance_action_low,
                            "medium": S.current.performance_action_medium,
                            "high": S.current.performance_action_high,
                            "ultra": S.current.performance_action_super
                          }.entries)
                            Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: Button(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 2, left: 4, right: 4),
                                    child: Text(item.value),
                                  ),
                                  onPressed: () =>
                                      model.onChangePreProfile(item.key)),
                            ),
                          Text(
                              S.current.performance_action_info_preset_only_changes_graphics),
                          const Spacer(),
                          Button(
                            onPressed: () => model.refresh(),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(FluentIcons.refresh),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Button(
                              child: Text(
                                S.current.performance_action_reset_to_default,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () => model.clean(context)),
                          const SizedBox(width: 24),
                          Button(
                              child: Text(
                                S.current.performance_action_apply,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () => model.applyProfile(false)),
                          const SizedBox(width: 6),
                          Button(
                              child: Text(
                                S.current.performance_action_apply_and_clear_shaders,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () => model.applyProfile(true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Expanded(
                    child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  itemCount: state.performanceMap!.length,
                  itemBuilder: (context, index) {
                    return makeItemGroup(context,
                        state.performanceMap!.entries.elementAt(index), model);
                  },
                )),
              ],
            ),
          ),
          if (state.workingString.isNotEmpty)
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
                    Text(state.workingString),
                  ],
                ),
              ),
            )
        ],
      );
    }

    return makeDefaultPage(context,
        title: "性能优化 -> ${model.scPath}",
        useBodyContainer: true,
        content: content);
  }

  Widget makeItemGroup(
      BuildContext context,
      MapEntry<String?, List<GamePerformanceData>> group,
      HomePerformanceUIModel model) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: FluentTheme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${group.key}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 6),
              Container(
                  color: FluentTheme.of(context).cardColor.withOpacity(.2),
                  height: 1),
              const SizedBox(height: 6),
              for (final item in group.value) makeItem(context, item, model)
            ],
          ),
        ),
      ),
    );
  }

  Widget makeItem(BuildContext context, GamePerformanceData item,
      HomePerformanceUIModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${item.name}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          if (item.type == "int")
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 72,
                      child: TextFormBox(
                        key: UniqueKey(),
                        initialValue: "${item.value}",
                        onFieldSubmitted: (str) {
                          dPrint(str);
                          if (str.isEmpty) return;
                          final v = int.tryParse(str);
                          if (v != null &&
                              v < (item.max ?? 0) &&
                              v >= (item.min ?? 0)) {
                            item.value = v;
                          }
                          model.updateState();
                        },
                        onTapOutside: (e) {
                          model.updateState();
                        },
                      ),
                    ),
                    const SizedBox(width: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Slider(
                        value: item.value?.toDouble() ?? 0,
                        min: item.min?.toDouble() ?? 0,
                        max: item.max?.toDouble() ?? 0,
                        onChanged: (double value) {
                          item.value = value.toInt();
                          model.updateState();
                        },
                      ),
                    )
                  ],
                )
              ],
            )
          else if (item.type == "bool")
            Column(
              children: [
                ToggleSwitch(
                  checked: item.value == 1,
                  onChanged: (bool value) {
                    item.value = value ? 1 : 0;
                    model.updateState();
                  },
                )
              ],
            )
          else if (item.type == "customize")
            TextFormBox(
              maxLines: 10,
              placeholder:
                  "您可以在这里输入未收录进盒子的自定义参数。配置示例:\n\nr_displayinfo=0\nr_VSync=0",
              controller: model.customizeCtrl,
            ),
          if (item.info != null && item.info!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              "${item.info}",
              style:
                  TextStyle(fontSize: 14, color: Colors.white.withOpacity(.6)),
            ),
          ],
          const SizedBox(height: 12),
          if (item.type != "customize")
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${item.key}    最小值: ${item.min} / 最大值: ${item.max}",
                  style: TextStyle(color: Colors.white.withOpacity(.6)),
                )
              ],
            ),
          const SizedBox(height: 6),
          Container(
              color: FluentTheme.of(context).cardColor.withOpacity(.1),
              height: 1),
        ],
      ),
    );
  }
}
