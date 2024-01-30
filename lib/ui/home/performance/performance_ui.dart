import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/data/game_performance_data.dart';

import 'performance_ui_model.dart';

class PerformanceUI extends BaseUI<PerformanceUIModel> {
  @override
  Widget? buildBody(BuildContext context, PerformanceUIModel model) {
    var content = makeLoading(context);

    if (model.performanceMap != null) {
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
                      if (model.showGraphicsPerformanceTip)
                        InfoBar(
                          title: const Text("图形优化提示"),
                          content: const Text(
                            "该功能对优化显卡瓶颈有很大帮助，但对 CPU 瓶颈可能起反效果，如果您显卡性能强劲，可以尝试使用更好的画质来获得更高的显卡利用率。",
                          ),
                          onClose: () => model.closeTip(),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "当前状态：${model.enabled ? "已应用" : "未应用"}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 32),
                          const Text(
                            "预设：",
                            style: TextStyle(fontSize: 18),
                          ),
                          for (final item in const {
                            "low": "低",
                            "medium": "中",
                            "high": "高",
                            "ultra": "超级"
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
                          const Text("（预设只修改图形设置）"),
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
                              child: const Text(
                                " 恢复默认 ",
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () => model.clean()),
                          const SizedBox(width: 24),
                          Button(
                              child: const Text(
                                "应用",
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () => model.applyProfile(false)),
                          const SizedBox(width: 6),
                          Button(
                              child: const Text(
                                "应用并清理着色器（推荐）",
                                style: TextStyle(fontSize: 16),
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
                  itemCount: model.performanceMap!.length,
                  itemBuilder: (context, index) {
                    return makeItemGroup(
                        model.performanceMap!.entries.elementAt(index));
                  },
                )),
              ],
            ),
          ),
          if (model.workingString.isNotEmpty)
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
                    Text(model.workingString),
                  ],
                ),
              ),
            )
        ],
      );
    }

    return makeDefaultPage(context, model, content: content);
  }

  Widget makeItemGroup(MapEntry<String?, List<GamePerformanceData>> group) {
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
              for (final item in group.value) makeItem(item)
            ],
          ),
        ),
      ),
    );
  }

  Widget makeItem(GamePerformanceData item) {
    final model = ref.watch(provider);
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
                          setState(() {});
                        },
                        onTapOutside: (e) {
                          setState(() {});
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
                          setState(() {});
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
                    setState(() {});
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

  @override
  String getUITitle(BuildContext context, PerformanceUIModel model) =>
      "性能优化         ${model.scPath}";
}
