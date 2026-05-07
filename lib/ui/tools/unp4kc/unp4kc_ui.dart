import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';
import 'package:starcitizen_doctor/ui/tools/unp4kc/widgets/widgets.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class UnP4kcUI extends HookConsumerWidget {
  const UnP4kcUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    final model = ref.read(unp4kCModelProvider.notifier);
    final files = model.getFiles();
    final displayPath = _displayPath(state, model);
    final paths = displayPath.trim().split("\\");
    final pathController = useTextEditingController(text: displayPath);
    final isPathEditing = useState(false);
    final pathFocusNode = useFocusNode();

    useEffect(() {
      if (!isPathEditing.value && pathController.text != displayPath) {
        pathController.text = displayPath;
      }
      return null;
    }, [displayPath, isPathEditing.value]);

    useEffect(() {
      void listener() {
        if (!pathFocusNode.hasFocus && isPathEditing.value) {
          isPathEditing.value = false;
        }
      }

      pathFocusNode.addListener(listener);
      return () => pathFocusNode.removeListener(listener);
    }, [pathFocusNode, isPathEditing.value]);

    useEffect(() {
      AnalyticsApi.touch("unp4k_launch");
      return null;
    }, const []);

    return makeDefaultPage(
      context,
      automaticallyImplyLeading: false,
      title: S.current.tools_unp4k_title(model.getGamePath()),
      titleRow: Row(
        children: [
          IconButton(
            icon: const Icon(FluentIcons.home, size: 14),
            onPressed: () async {
              final shouldLeave = await _confirmExitToHome(context);
              if (shouldLeave && context.mounted) {
                await model.clearTempWemCache();
                if (!context.mounted) return;
                audioWaveformCache.clear();
                context.pop();
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              S.current.tools_unp4k_title(model.getGamePath()),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      useBodyContainer: false,
      content: makeBody(
        context,
        state,
        model,
        files,
        paths,
        pathController,
        isPathEditing,
        pathFocusNode,
      ),
    );
  }

  Widget makeBody(
    BuildContext context,
    Unp4kcState state,
    Unp4kCModel model,
    List<AppUnp4kP4kItemData>? files,
    List<String> paths,
    TextEditingController pathController,
    ValueNotifier<bool> isPathEditing,
    FocusNode pathFocusNode,
  ) {
    if (state.errorMessage.isNotEmpty) {
      return UnP4kErrorWidget(errorMessage: state.errorMessage);
    }
    return state.files == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 420,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.loadingTotal > 0) ...[
                          ProgressBar(
                            value:
                                (state.loadingCurrent / state.loadingTotal) *
                                100,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${state.loadingCurrent}/${state.loadingTotal} (${((state.loadingCurrent / state.loadingTotal) * 100).toStringAsFixed(1)}%)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: .75),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          makeLoading(context),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
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
        : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FluentTheme.of(
                        context,
                      ).cardColor.withValues(alpha: .06),
                    ),
                    height: 36,
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      children: [
                        if (state.searchMatchedFiles != null) ...[
                          IconButton(
                            icon: const Icon(FluentIcons.back, size: 14),
                            onPressed: () {
                              model.clearSearch();
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "[${S.current.tools_unp4k_searching.replaceAll('...', '')}]",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: .7),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        IconButton(
                          icon: const Icon(FluentIcons.back, size: 14),
                          onPressed: model.canGoBackPath()
                              ? () {
                                  model.goBackPath();
                                }
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(FluentIcons.forward, size: 14),
                          onPressed: model.canGoForwardPath()
                              ? () {
                                  model.goForwardPath();
                                }
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child:
                              isPathEditing.value &&
                                  state.viewMode == Unp4kViewMode.fileBrowser
                              ? TextBox(
                                  controller: pathController,
                                  focusNode: pathFocusNode,
                                  placeholder: r"\data\...",
                                  autofocus: true,
                                  onSubmitted: (value) {
                                    final normalized = _normalizeInputPath(
                                      value,
                                    );
                                    if (state.searchMatchedFiles != null) {
                                      model.clearSearch(targetPath: normalized);
                                      isPathEditing.value = false;
                                    } else {
                                      final ok = model.changeDirValidated(
                                        normalized,
                                        fullPath: true,
                                      );
                                      if (ok) {
                                        isPathEditing.value = false;
                                      }
                                    }
                                  },
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          if (state.viewMode ==
                                              Unp4kViewMode.fileBrowser) {
                                            isPathEditing.value = true;
                                          }
                                        },
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
                                                  onPressed:
                                                      state.viewMode ==
                                                          Unp4kViewMode
                                                              .fileBrowser
                                                      ? () {
                                                          if (state
                                                                  .searchMatchedFiles !=
                                                              null) {
                                                            model.clearSearch(
                                                              targetPath:
                                                                  fullPath,
                                                            );
                                                          } else {
                                                            model
                                                                .changeDirValidated(
                                                                  fullPath,
                                                                  fullPath:
                                                                      true,
                                                                );
                                                          }
                                                        }
                                                      : null,
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
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  FilterToolbar(state: state, model: model),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _P4KViewRail(state: state, model: model),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .28,
                          child: FileListPanel(
                            state: state,
                            model: model,
                            files: files,
                          ),
                        ),
                        Expanded(
                          child: state.tempOpenFile == null
                              ? Center(
                                  child: Text(S.current.tools_unp4k_view_file),
                                )
                              : state.tempOpenFile?.type == "loading"
                              ? makeLoading(context)
                              : Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      if (state.tempOpenFile?.type == "text")
                                        Expanded(
                                          child: TextTempWidget(
                                            state.tempOpenFile!.bytes!,
                                          ),
                                        )
                                      else if (state.tempOpenFile?.type ==
                                          "image")
                                        Expanded(
                                          child: ImageTempWidget(
                                            state.tempOpenFile!.bytes!,
                                          ),
                                        )
                                      else if (state.tempOpenFile?.type ==
                                          "audio")
                                        Expanded(
                                          child: AudioTempWidget(
                                            state.tempOpenFile!.bytes!,
                                            state.tempOpenFile!.filePath ?? "",
                                            onPrevious: _getPrevAudioFile(
                                              state,
                                              files,
                                              model,
                                            ),
                                            onNext: _getNextAudioFile(
                                              state,
                                              files,
                                              model,
                                            ),
                                          ),
                                        )
                                      else if (state.tempOpenFile?.type ==
                                          "model")
                                        Expanded(
                                          child: ModelTempWidget.fromP4k(
                                            key: ValueKey(
                                              state.tempOpenFile!.filePath ??
                                                  "",
                                            ),
                                            p4kPath:
                                                "${model.getGamePath()}\\Data.p4k",
                                            modelPath:
                                                state.tempOpenFile!.filePath ??
                                                "",
                                          ),
                                        )
                                      else
                                        Expanded(
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  S.current
                                                      .tools_unp4k_msg_unknown_file_type(
                                                        state
                                                                .tempOpenFile
                                                                ?.filePath ??
                                                            "",
                                                      ),
                                                ),
                                                const SizedBox(height: 16),
                                                if (state.tempOpenFile?.bytes !=
                                                    null) ...[
                                                  FilledButton(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: Text(
                                                        S.current.action_export,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      final fileName =
                                                          state
                                                              .tempOpenFile
                                                              ?.filePath
                                                              ?.split("\\")
                                                              .last ??
                                                          "file";
                                                      final savePath =
                                                          await FilePicker.saveFile(
                                                            dialogTitle: S
                                                                .current
                                                                .action_export,
                                                            fileName: fileName,
                                                          );
                                                      if (savePath != null &&
                                                          state
                                                                  .tempOpenFile
                                                                  ?.bytes !=
                                                              null) {
                                                        await File(
                                                          savePath,
                                                        ).writeAsBytes(
                                                          state
                                                              .tempOpenFile!
                                                              .bytes!,
                                                          flush: true,
                                                        );
                                                        SystemHelper.openDir(
                                                          savePath,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  if (state.endMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${state.endMessage}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              if (state.isSearching)
                Container(
                  color: Colors.black.withValues(alpha: .7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ProgressRing(),
                        const SizedBox(height: 16),
                        Text(
                          S.current.tools_unp4k_searching,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
  }

  String _normalizeInputPath(String value) {
    var path = value.trim().replaceAll("/", "\\");
    if (path.isEmpty) return "\\";
    if (!path.startsWith("\\")) {
      path = "\\$path";
    }
    if (!path.endsWith("\\")) {
      path = "$path\\";
    }
    return path;
  }

  String _displayPath(Unp4kcState state, Unp4kCModel model) {
    if (state.searchMatchedFiles != null && state.searchPath != null) {
      return state.searchPath!;
    }
    switch (state.viewMode) {
      case Unp4kViewMode.fileBrowser:
        return state.curPath;
      case Unp4kViewMode.modelBrowser:
        final category = state.modelCategory;
        return category == null
            ? r"\3D浏览器\"
            : "\\3D浏览器\\${model.modelCategoryLabel(category)}\\";
      case Unp4kViewMode.musicBrowser:
        return r"\音乐浏览器\";
    }
  }

  Future<bool> _confirmExitToHome(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return ContentDialog(
          title: const Text("返回首页"),
          content: const Text("退出后需要重新加载 P4K，确认返回首页吗？"),
          actions: [
            Button(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(S.current.home_action_cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text("确认返回"),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  VoidCallback? _getPrevAudioFile(
    Unp4kcState state,
    List<AppUnp4kP4kItemData>? files,
    Unp4kCModel model,
  ) {
    final audioFiles = _getAudioFiles(files);
    if (audioFiles.isEmpty) return null;

    final currentIndex = audioFiles.indexWhere(
      (f) => f.name == state.currentPreviewPath,
    );
    if (currentIndex <= 0) return null;

    return () => model.openFile(audioFiles[currentIndex - 1].name ?? "");
  }

  VoidCallback? _getNextAudioFile(
    Unp4kcState state,
    List<AppUnp4kP4kItemData>? files,
    Unp4kCModel model,
  ) {
    final audioFiles = _getAudioFiles(files);
    if (audioFiles.isEmpty) return null;

    final currentIndex = audioFiles.indexWhere(
      (f) => f.name == state.currentPreviewPath,
    );
    if (currentIndex < 0 || currentIndex >= audioFiles.length - 1) return null;

    return () => model.openFile(audioFiles[currentIndex + 1].name ?? "");
  }

  List<AppUnp4kP4kItemData> _getAudioFiles(List<AppUnp4kP4kItemData>? files) {
    if (files == null) return [];
    return files.where((f) {
      final name = f.name?.toLowerCase() ?? "";
      return !(f.isDirectory ?? false) && name.endsWith(".wem");
    }).toList();
  }
}

class _P4KViewRail extends StatelessWidget {
  final Unp4kcState state;
  final Unp4kCModel model;

  const _P4KViewRail({required this.state, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor.withValues(alpha: .035),
        border: Border(
          right: BorderSide(
            color: FluentTheme.of(
              context,
            ).resources.cardStrokeColorDefault.withValues(alpha: .35),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _P4KViewRailItem(
            icon: FluentIcons.fabric_folder,
            label: "文件浏览器",
            selected: state.viewMode == Unp4kViewMode.fileBrowser,
            onPressed: () => model.setViewMode(Unp4kViewMode.fileBrowser),
          ),
          const SizedBox(height: 6),
          _P4KViewRailItem(
            icon: FluentIcons.cube_shape,
            label: "3D 浏览器",
            selected: state.viewMode == Unp4kViewMode.modelBrowser,
            onPressed: () => model.setViewMode(Unp4kViewMode.modelBrowser),
          ),
          const SizedBox(height: 6),
          _P4KViewRailItem(
            icon: FluentIcons.music_in_collection,
            label: "音乐浏览器",
            selected: state.viewMode == Unp4kViewMode.musicBrowser,
            onPressed: () => model.setViewMode(Unp4kViewMode.musicBrowser),
          ),
        ],
      ),
    );
  }
}

class _P4KViewRailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _P4KViewRailItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        final hovered = states.isHovered;
        return Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected
                ? FluentTheme.of(context).accentColor.withValues(alpha: .22)
                : hovered
                ? FluentTheme.of(context).cardColor.withValues(alpha: .08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: .76),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: .86),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
