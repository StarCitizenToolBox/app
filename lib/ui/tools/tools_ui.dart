import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:starcitizen_doctor/base/ui.dart';

import 'tools_ui_model.dart';

class ToolsUI extends BaseUI<ToolsUIModel> {
  @override
  Widget? buildBody(BuildContext context, ToolsUIModel model) {
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
                        makeGameLauncherPathSelect(context, model),
                        const SizedBox(height: 12),
                        makeGamePathSelect(context, model),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Button(
                    onPressed: model.working ? null : model.loadData,
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 32, bottom: 32, left: 12, right: 12),
                      child: Icon(FluentIcons.refresh),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (model.items.isEmpty)
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
                    itemCount: (model.isItemLoading)
                        ? model.items.length + 1
                        : model.items.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == model.items.length) {
                        return Container(
                            width: 300,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: FluentTheme.of(context).cardColor,
                            ),
                            child: makeLoading(context));
                      }
                      final item = model.items[index];
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
                                    onPressed: model.working
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
        if (model.working)
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

  Widget makeGamePathSelect(BuildContext context, ToolsUIModel model) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("游戏安装位置：  "),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ComboBox<String>(
              value: model.scInstalledPath,
              items: [
                for (final path in model.scInstallPaths)
                  ComboBoxItem(
                    value: path,
                    child: Text(path),
                  )
              ],
              onChanged: (v) {
                model.loadData(skipPathScan: true);
                model.scInstalledPath = v!;
                model.notifyListeners();
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Button(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(FluentIcons.folder_open),
            ),
            onPressed: () => model.openDir(model.scInstalledPath))
      ],
    );
  }

  Widget makeGameLauncherPathSelect(BuildContext context, ToolsUIModel model) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("RSI启动器位置："),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ComboBox<String>(
              value: model.rsiLauncherInstalledPath,
              items: [
                for (final path in model.rsiLauncherInstallPaths)
                  ComboBoxItem(
                    value: path,
                    child: Text(path),
                  )
              ],
              onChanged: (v) {
                model.loadData(skipPathScan: true);
                model.rsiLauncherInstalledPath = v!;
                model.notifyListeners();
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Button(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(FluentIcons.folder_open),
            ),
            onPressed: () => model.openDir(model.rsiLauncherInstalledPath))
      ],
    );
  }

  @override
  String getUITitle(BuildContext context, ToolsUIModel model) => "ToolsUI";
}
