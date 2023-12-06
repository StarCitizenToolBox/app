import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/data/sc_localization_data.dart';

import 'localization_ui_model.dart';

class LocalizationUI extends BaseUI<LocalizationUIModel> {
  @override
  Widget? buildBody(BuildContext context, LocalizationUIModel model) {
    final curInstallInfo = model.apiLocalizationData?[model.patchStatus?.value];
    return ContentDialog(
      title: makeTitle(context, model),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .7,
          minHeight: MediaQuery.of(context).size.height * .9),
      content: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 130),
                child: model.patchStatus?.key == true &&
                        model.patchStatus?.value == "游戏内置"
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InfoBar(
                          title: const Text("警告"),
                          content: const Text(
                              "您正在使用游戏内置文本，官方文本目前为机器翻译（截至3.21.0），建议您在下方安装社区汉化。"),
                          severity: InfoBarSeverity.info,
                          style: InfoBarThemeData(decoration: (severity) {
                            return const BoxDecoration(
                                color: Color.fromRGBO(155, 7, 7, 1.0));
                          }, iconColor: (severity) {
                            return Colors.white;
                          }),
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                      ),
              ),
              makeListContainer("汉化状态", [
                if (model.patchStatus == null)
                  makeLoading(context)
                else ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Center(
                        child: Text(
                            "启用（${LocalizationUIModel.languageSupport[model.selectedLanguage]}）："),
                      ),
                      const Spacer(),
                      ToggleSwitch(
                        checked: model.patchStatus?.key == true,
                        onChanged: model.updateLangCfg,
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text("已安装版本：${model.patchStatus?.value}"),
                      const Spacer(),
                      if (model.patchStatus?.value != "游戏内置")
                        Button(
                            onPressed: model.doDelIniFile(),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  Icon(FluentIcons.delete),
                                  SizedBox(width: 6),
                                  Text("删除"),
                                ],
                              ),
                            )),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 130),
                    child: (curInstallInfo != null &&
                            curInstallInfo.note != null &&
                            curInstallInfo.note!.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: FluentTheme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "备注：",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${curInstallInfo.note}",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.8)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                          ),
                  ),
                ],
              ]),
              makeListContainer("社区汉化", [
                if (model.apiLocalizationData == null)
                  makeLoading(context)
                else if (model.apiLocalizationData!.isEmpty)
                  Center(
                    child: Text(
                      "该语言/版本 暂无可用汉化，敬请期待！",
                      style: TextStyle(
                          fontSize: 13, color: Colors.white.withOpacity(.8)),
                    ),
                  )
                else
                  for (final item in model.apiLocalizationData!.entries)
                    makeRemoteList(context, model, item),
              ]),
              const SizedBox(height: 12),
              IconButton(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(model.enableCustomize
                          ? FluentIcons.chevron_up
                          : FluentIcons.chevron_down),
                      const SizedBox(width: 12),
                      const Text("高级功能"),
                    ],
                  ),
                  onPressed: () {
                    model.enableCustomize = !model.enableCustomize;
                    model.notifyListeners();
                  }),
              AnimatedSize(
                duration: const Duration(milliseconds: 130),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    model.enableCustomize
                        ? makeListContainer("自定义文本", [
                            if (model.customizeList == null)
                              makeLoading(context)
                            else if (model.customizeList!.isEmpty)
                              Center(
                                child: Text(
                                  "暂无自定义文本",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(.8)),
                                ),
                              )
                            else ...[
                              for (final file in model.customizeList!)
                                Row(
                                  children: [
                                    Text(
                                      model.getCustomizeFileName(file),
                                    ),
                                    const Spacer(),
                                    if (model.workingVersion == file)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 12),
                                        child: ProgressRing(),
                                      )
                                    else
                                      Button(
                                          onPressed: model.doLocalInstall(file),
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 4,
                                                bottom: 4),
                                            child: Text("安装"),
                                          ))
                                  ],
                                )
                            ],
                          ], actions: [
                            Button(
                                onPressed: () => model.openDir(),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      Icon(FluentIcons.folder_open),
                                      SizedBox(width: 6),
                                      Text("打开文件夹"),
                                    ],
                                  ),
                                )),
                          ])
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeRemoteList(BuildContext context, LocalizationUIModel model,
      MapEntry<String, ScLocalizationData> item) {
    final isWorking = model.workingVersion.isNotEmpty;
    final isMineWorking = model.workingVersion == item.key;
    final isInstalled = model.patchStatus?.value == item.key;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.value.info}",
                    style: const TextStyle(fontSize: 19),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "版本号：${item.value.versionName}",
                    style: TextStyle(color: Colors.white.withOpacity(.6)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "通道：${item.value.gameChannel}",
                    style: TextStyle(color: Colors.white.withOpacity(.6)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "更新时间：${item.value.updateAt}",
                    style: TextStyle(color: Colors.white.withOpacity(.6)),
                  ),
                ],
              ),
              const Spacer(),
              if (isMineWorking)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ProgressRing(),
                )
              else
                Button(
                    onPressed: ((item.value.enable == true &&
                            !isWorking &&
                            !isInstalled)
                        ? model.doRemoteInstall(item.value)
                        : null),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(isInstalled
                                ? FluentIcons.check_mark
                                : (item.value.enable ?? false)
                                    ? FluentIcons.download
                                    : FluentIcons.disable_updates),
                          ),
                          Text(isInstalled
                              ? "已安装"
                              : ((item.value.enable ?? false) ? "安装" : "不可用")),
                        ],
                      ),
                    )),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            color: Colors.white.withOpacity(.05),
            height: 1,
          ),
        ],
      ),
    );
  }

  Widget makeListContainer(String title, List<Widget> children,
      {List<Widget> actions = const []}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 130),
        child: Container(
          decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor,
              borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const Spacer(),
                    if (actions.isNotEmpty) ...actions,
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  color: Colors.white.withOpacity(.1),
                  height: 1,
                ),
                const SizedBox(height: 12),
                ...children
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeTitle(BuildContext context, LocalizationUIModel model) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(
              FluentIcons.back,
              size: 22,
            ),
            onPressed: model.onBack()),
        const SizedBox(width: 12),
        Text(getUITitle(context, model)),
        const SizedBox(width: 24),
        Text(
          model.scInstallPath,
          style: const TextStyle(fontSize: 13),
        ),
        const Spacer(),
        SizedBox(
          height: 36,
          child: Row(
            children: [
              const Text(
                "语言：   ",
                style: TextStyle(fontSize: 16),
              ),
              ComboBox<String>(
                value: model.selectedLanguage,
                items: [
                  for (final lang
                      in LocalizationUIModel.languageSupport.entries)
                    ComboBoxItem(
                      value: lang.key,
                      child: Text(lang.value),
                    )
                ],
                onChanged: model.workingVersion.isNotEmpty
                    ? null
                    : (v) {
                        if (v == null) return;
                        model.selectLang(v);
                      },
              )
            ],
          ),
        ),
        const SizedBox(width: 12),
        Button(
            onPressed: model.doRefresh(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(FluentIcons.refresh),
            )),
      ],
    );
  }

  @override
  String getUITitle(BuildContext context, LocalizationUIModel model) => "汉化管理";
}
