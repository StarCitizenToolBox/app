import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';

import '../../../../widgets/widgets.dart';
import 'dialogs.dart';

class FileListItem extends HookWidget {
  final AppUnp4kP4kItemData item;
  final Unp4kcState state;
  final Unp4kCModel model;

  const FileListItem({
    super.key,
    required this.item,
    required this.state,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final flyoutController = useMemoized(() => FlyoutController());
    final fullPath = item.name ?? "?";
    final isFlatResultMode = state.searchMatchedFiles != null;
    final normalized = fullPath.replaceAll("/", "\\");
    final lowerPath = normalized.toLowerCase();
    final lastSep = normalized.lastIndexOf("\\");
    final baseName = lastSep >= 0
        ? normalized.substring(lastSep + 1)
        : normalized;
    final parentPath = lastSep > 0 ? normalized.substring(0, lastSep) : "\\";
    final fileName = isFlatResultMode
        ? baseName
        : (item.name?.replaceAll(state.curPath.trim(), "") ?? "?");
    final itemPath = item.name ?? "";
    final isSelected = state.selectedItems.contains(itemPath);
    final isPreviewing = state.currentPreviewPath == itemPath;

    return FlyoutTarget(
      controller: flyoutController,
      child: GestureDetector(
        onSecondaryTapUp: (details) =>
            _showContextMenu(context, flyoutController),
        child: Container(
          margin: const EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? FluentTheme.of(context).accentColor.withValues(alpha: .2)
                : isPreviewing
                ? FluentTheme.of(context).accentColor.withValues(alpha: .12)
                : FluentTheme.of(context).cardColor.withValues(alpha: .05),
          ),
          child: IconButton(
            onPressed: () {
              if (state.isMultiSelectMode) {
                model.toggleSelectItem(itemPath);
              } else if (item.isDirectory ?? false) {
                final dirName =
                    item.name?.replaceAll(state.curPath.trim(), "") ?? "";
                model.changeDir(dirName);
              } else {
                model.openFile(item.name ?? "", context: context);
              }
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Row(
                children: [
                  if (state.isMultiSelectMode) ...[
                    Checkbox(
                      checked: isSelected,
                      onChanged: (value) {
                        model.toggleSelectItem(itemPath);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (item.isDirectory ?? false)
                    const Icon(
                      FluentIcons.folder_fill,
                      color: Color.fromRGBO(255, 224, 138, 1),
                    )
                  else if (_isConvertibleModel(lowerPath))
                    const Icon(FluentIcons.cube_shape)
                  else if (_isConvertibleAudio(lowerPath))
                    const Icon(FluentIcons.volume3)
                  else if (_isConvertibleDds(lowerPath))
                    const Icon(FluentIcons.picture)
                  else if (fileName.endsWith(".xml"))
                    const Icon(FluentIcons.file_code)
                  else
                    const Icon(FluentIcons.open_file),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                fileName,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        if (isFlatResultMode) ...[
                          const SizedBox(height: 1),
                          Text(
                            parentPath,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: .55),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (!(item.isDirectory ?? true)) ...[
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              Text(
                                FileSize.getSize(item.size),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: .6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.dateModified != null
                                    ? DateTime.fromMillisecondsSinceEpoch(
                                        item.dateModified!,
                                      ).toString().substring(0, 19)
                                    : "",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: .6),
                                ),
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
                    color: Colors.white.withValues(alpha: .6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isConvertibleModel(String lowerPath) {
    return lowerPath.endsWith(".cgf") || lowerPath.endsWith(".cga");
  }

  bool _isConvertibleAudio(String lowerPath) {
    return lowerPath.endsWith(".wem");
  }

  bool _isConvertibleDds(String lowerPath) {
    return (lowerPath.endsWith(".dds") ||
            RegExp(r"\.dds\.\d+$").hasMatch(lowerPath)) &&
        !RegExp(r"_ddna\.dds(\.\d+)?$").hasMatch(lowerPath);
  }

  void _showContextMenu(BuildContext context, FlyoutController controller) {
    final outerContext = context;
    controller.showFlyout(
      autoModeConfiguration: FlyoutAutoConfiguration(
        preferredMode: FlyoutPlacementMode.bottomCenter,
      ),
      barrierColor: Colors.transparent,
      builder: (flyoutContext) {
        return MenuFlyout(
          items: [
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.save_as, size: 16),
              text: Text(S.current.tools_unp4k_action_save_as),
              onPressed: () async {
                Navigator.of(flyoutContext).pop();
                await _saveAs(outerContext);
              },
            ),
            if (_isWemFile(item.name ?? ""))
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.volume3, size: 16),
                text: const Text("导出 WAV"),
                onPressed: () async {
                  Navigator.of(flyoutContext).pop();
                  await _exportWav(outerContext);
                },
              ),
            if (_canConvertToGlb(item.name ?? ""))
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.export, size: 16),
                text: Text(S.current.tools_unp4k_action_convert_glb),
                onPressed: () async {
                  Navigator.of(flyoutContext).pop();
                  await _convertToGlb(outerContext);
                },
              ),
            if (_canConvertDdsToPng(item.name ?? ""))
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.picture, size: 16),
                text: const Text("DDS 转 PNG"),
                onPressed: () async {
                  Navigator.of(flyoutContext).pop();
                  await _convertDdsToPng(outerContext);
                },
              ),
            if (state.searchMatchedFiles != null)
              MenuFlyoutItem(
                leading: const Icon(
                  FluentIcons.open_folder_horizontal,
                  size: 16,
                ),
                text: const Text("跳转到文件位置"),
                onPressed: () {
                  Navigator.of(flyoutContext).pop();
                  model.jumpToFileLocation(item.name ?? "");
                },
              ),
            if (!state.isMultiSelectMode)
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.checkbox_composite, size: 16),
                text: Text(S.current.tools_unp4k_action_multi_select),
                onPressed: () {
                  Navigator.of(flyoutContext).pop();
                  model.enterMultiSelectMode();
                  model.toggleSelectItem(item.name ?? "");
                },
              ),
          ],
        );
      },
    );
  }

  bool _canConvertToGlb(String fullPath) {
    if ((item.isDirectory ?? false)) return false;
    final lower = fullPath.toLowerCase();
    return lower.endsWith('.cgf') || lower.endsWith('.cga');
  }

  bool _canConvertDdsToPng(String fullPath) {
    if ((item.isDirectory ?? false)) return false;
    final lower = fullPath.toLowerCase();
    return lower.endsWith('.dds') || RegExp(r"\.dds\.\d+$").hasMatch(lower);
  }

  bool _isWemFile(String fullPath) {
    if (item.isDirectory ?? false) return false;
    return fullPath.toLowerCase().endsWith('.wem');
  }

  Future<void> _saveAs(BuildContext context) async {
    final outputDir = await FilePicker.getDirectoryPath(
      dialogTitle: S.current.tools_unp4k_action_save_as,
    );
    if (outputDir != null && context.mounted) {
      await _showExtractProgressDialog(context, outputDir);
    }
  }

  Future<void> _showExtractProgressDialog(
    BuildContext context,
    String outputDir,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ExtractProgressDialog(
          item: item,
          outputDir: outputDir,
          model: model,
        );
      },
    );
  }

  Future<void> _convertToGlb(BuildContext context) async {
    final outputDir = await FilePicker.getDirectoryPath(
      dialogTitle: S.current.tools_unp4k_action_convert_glb,
    );
    if (outputDir != null && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return ConvertProgressDialog(
            filePath: item.name ?? '',
            outputDir: outputDir,
            model: model,
          );
        },
      );
    }
  }

  Future<void> _exportWav(BuildContext context) async {
    try {
      var p4kPath = item.name ?? "";
      if (p4kPath.isEmpty) return;
      var sourceName = p4kPath.split("\\").last;
      if (sourceName.isEmpty) sourceName = "audio.wem";
      final wavName = sourceName.toLowerCase().endsWith(".wem")
          ? "${sourceName.substring(0, sourceName.length - 4)}.wav"
          : "$sourceName.wav";

      final outputPath = await FilePicker.saveFile(
        dialogTitle: "导出 WAV",
        fileName: wavName,
        type: FileType.custom,
        allowedExtensions: const ["wav"],
      );
      if (outputPath == null) return;

      if (p4kPath.startsWith("\\")) {
        p4kPath = p4kPath.substring(1);
      }
      final tempDir = await getTemporaryDirectory();
      final tempRoot =
          "${tempDir.absolute.path}\\SCToolbox_unp4kc\\${SCLoggerHelper.getGameChannelID(model.getGamePath())}\\";
      final extractedWemPath = "$tempRoot$p4kPath";
      final cachedWavPath = "$extractedWemPath.preview.v2.wav";

      final outFile = File(outputPath);
      await outFile.parent.create(recursive: true);

      final cachedWavFile = File(cachedWavPath);
      if (await cachedWavFile.exists()) {
        final stat = await cachedWavFile.stat();
        if (stat.size > 44) {
          await cachedWavFile.copy(outputPath);
          if (!context.mounted) return;
          await displayInfoBar(
            context,
            builder: (ctx, close) {
              return InfoBar(
                title: const Text("WAV 导出成功"),
                content: Text("${outFile.path}\n(来自缓存)"),
                severity: InfoBarSeverity.success,
                onClose: close,
              );
            },
          );
          return;
        }
      }

      final wemBytes = await unp4k_api.p4KExtractToMemory(filePath: p4kPath);
      final exportTempDir = Directory(
        "${Directory.systemTemp.path}\\SCToolbox_unp4kc_export",
      );
      await exportTempDir.create(recursive: true);
      final tempWemPath =
          "${exportTempDir.path}\\${DateTime.now().microsecondsSinceEpoch}_${sourceName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')}";
      final tempWemFile = File(tempWemPath);
      await tempWemFile.writeAsBytes(wemBytes, flush: true);
      try {
        await unp4k_api.p4KDecodeWemToWav(
          inputPath: tempWemPath,
          outputPath: outputPath,
        );
      } finally {
        if (await tempWemFile.exists()) {
          await tempWemFile.delete();
        }
      }

      if (!context.mounted) return;
      await displayInfoBar(
        context,
        builder: (ctx, close) {
          return InfoBar(
            title: const Text("WAV 导出成功"),
            content: Text(outFile.path),
            severity: InfoBarSeverity.success,
            onClose: close,
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      await displayInfoBar(
        context,
        builder: (ctx, close) {
          return InfoBar(
            title: const Text("WAV 导出失败"),
            content: Text(e.toString()),
            severity: InfoBarSeverity.error,
            onClose: close,
          );
        },
      );
    }
  }

  Future<void> _convertDdsToPng(BuildContext context) async {
    final outputDir = await FilePicker.getDirectoryPath(
      dialogTitle: "DDS 转 PNG",
    );
    if (outputDir == null || !context.mounted) return;

    final (success, outputPath, error) = await model.convertDdsToPng(
      item.name ?? '',
      outputDir,
    );

    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (dialogContext) => ContentDialog(
        title: Text(success ? "转换成功" : "转换失败"),
        content: Text(
          success ? (outputPath ?? outputDir) : (error ?? "Unknown"),
        ),
        actions: [
          if (success)
            Button(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                SystemHelper.openDir(outputDir);
              },
              child: Text(S.current.action_open_folder),
            ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(S.current.action_close),
          ),
        ],
      ),
    );
  }
}
