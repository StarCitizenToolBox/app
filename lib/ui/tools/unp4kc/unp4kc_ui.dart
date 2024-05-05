import 'dart:io';

import 'package:file_sizes/file_sizes.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class UnP4kcUI extends HookConsumerWidget {
  const UnP4kcUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    final model = ref.read(unp4kCModelProvider.notifier);
    final files = model.getFiles();
    final paths = state.curPath.trim().split("\\");
    return makeDefaultPage(context,
        title: "P4K 查看器 -> ${model.getGamePath()}",
        useBodyContainer: false,
        content: state.files == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: makeLoading(context)),
                  if (state.endMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${state.endMessage}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color:
                            FluentTheme.of(context).cardColor.withOpacity(.06)),
                    height: 36,
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: SuperListView.builder(
                      itemCount: paths.length - 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        var path = paths[index];
                        if (path.isEmpty) {
                          path = "\\";
                        }
                        final fullPath =
                            "${paths.sublist(0, index + 1).join("\\")}\\";
                        return Row(
                          children: [
                            IconButton(
                              icon: Text(path),
                              onPressed: () {
                                model.changeDir(fullPath, fullPath: true);
                              },
                            ),
                            const Icon(
                              FluentIcons.chevron_right,
                              size: 12,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .3,
                        decoration: BoxDecoration(
                          color: FluentTheme.of(context)
                              .cardColor
                              .withOpacity(.01),
                        ),
                        child: SuperListView.builder(
                          padding: const EdgeInsets.only(
                              top: 6, bottom: 6, left: 3, right: 12),
                          itemBuilder: (BuildContext context, int index) {
                            final item = files![index];
                            final fileName = item.name
                                    ?.replaceAll(state.curPath.trim(), "") ??
                                "?";
                            return Container(
                              margin: const EdgeInsets.only(top: 4, bottom: 4),
                              decoration: BoxDecoration(
                                color: FluentTheme.of(context)
                                    .cardColor
                                    .withOpacity(.05),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (item.isDirectory ?? false) {
                                    model.changeDir(fileName);
                                  } else {
                                    model.openFile(item.name ?? "");
                                  }
                                },
                                icon: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 4),
                                  child: Row(
                                    children: [
                                      if (item.isDirectory ?? false)
                                        const Icon(
                                          FluentIcons.folder_fill,
                                          color:
                                              Color.fromRGBO(255, 224, 138, 1),
                                        )
                                      else if (fileName.endsWith(".xml"))
                                        const Icon(
                                          FluentIcons.file_code,
                                        )
                                      else
                                        const Icon(
                                          FluentIcons.open_file,
                                        ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    fileName,
                                                    style: const TextStyle(
                                                        fontSize: 13),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (!(item.isDirectory ??
                                                true)) ...[
                                              const SizedBox(height: 1),
                                              Row(
                                                children: [
                                                  Text(
                                                    FileSize.getSize(item.size),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white
                                                            .withOpacity(.6)),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    "${item.dateTime}",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white
                                                            .withOpacity(.6)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Icon(
                                        FluentIcons.chevron_right,
                                        size: 14,
                                        color: Colors.white.withOpacity(.6),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: files?.length ?? 0,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: state.tempOpenFile == null
                            ? const Center(
                                child: Text("单击文件以预览"),
                              )
                            : state.tempOpenFile?.key == "loading"
                                ? makeLoading(context)
                                : Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        if (state.tempOpenFile?.key == "text")
                                          Expanded(
                                              child: _TextTempWidget(
                                                  state.tempOpenFile?.value ??
                                                      ""))
                                        else
                                          Expanded(
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      "未知文件类型\n${state.tempOpenFile?.value}"),
                                                  const SizedBox(height: 32),
                                                  FilledButton(
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        child: Text("打开文件夹"),
                                                      ),
                                                      onPressed: () {
                                                        SystemHelper.openDir(
                                                            state.tempOpenFile
                                                                    ?.value ??
                                                                "");
                                                      })
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                      ))
                    ],
                  )),
                  if (state.endMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${state.endMessage}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ));
  }
}

class _TextTempWidget extends HookConsumerWidget {
  final String filePath;

  const _TextTempWidget(this.filePath);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textData = useState<String?>(null);

    useEffect(() {
      File(filePath).readAsString().then((value) {
        textData.value = value;
      }).catchError((err) {
        textData.value = "Error: $err";
      });
      return null;
    }, const []);

    if (textData.value == null) return makeLoading(context);

    return CodeEditor(
      controller: CodeLineEditingController.fromText('${textData.value}'),
      readOnly: true,
    );
  }
}
