import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../../widgets/widgets.dart';
import 'dialogs.dart';
import 'file_list_item.dart';
import 'models.dart';

class FileListPanel extends HookConsumerWidget {
  final Unp4kcState state;
  final Unp4kCModel model;
  final List<AppUnp4kP4kItemData>? files;

  const FileListPanel({
    super.key,
    required this.state,
    required this.model,
    required this.files,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor.withValues(alpha: .01),
      ),
      child: Column(
        children: [
          if (state.isMultiSelectMode)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: FluentTheme.of(
                  context,
                ).accentColor.withValues(alpha: .1),
                border: Border(
                  bottom: BorderSide(
                    color: FluentTheme.of(
                      context,
                    ).accentColor.withValues(alpha: .3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    S.current.tools_unp4k_action_export_selected(
                      state.selectedItems.length,
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Button(
                    child: Text(S.current.tools_unp4k_action_select_all),
                    onPressed: () => model.selectAll(files),
                  ),
                  const SizedBox(width: 4),
                  Button(
                    child: Text(S.current.tools_unp4k_action_deselect_all),
                    onPressed: () => model.deselectAll(files),
                  ),
                  const SizedBox(width: 4),
                  FilledButton(
                    onPressed: state.selectedItems.isNotEmpty
                        ? () => _exportSelected(context)
                        : null,
                    child: Text(S.current.tools_unp4k_action_save_as),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(FluentIcons.cancel, size: 14),
                    onPressed: () => model.exitMultiSelectMode(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: files == null || files!.isEmpty
                ? Center(
                    child: Text(
                      state.searchMatchedFiles != null
                          ? S.current.tools_unp4k_search_no_result
                          : '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .6),
                      ),
                    ),
                  )
                : SuperListView.builder(
                    padding: const EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                      left: 3,
                      right: 12,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final item = files![index];
                      return FileListItem(
                        item: item,
                        state: state,
                        model: model,
                      );
                    },
                    itemCount: files?.length ?? 0,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSelected(BuildContext context) async {
    final filesToExport = _collectSelectedFilesForExport();
    if (filesToExport.isEmpty) return;
    final hasConvertible = filesToExport.any(_canConvertPath);

    final options = await showDialog<BatchExportOptions>(
      context: context,
      builder: (dialogContext) {
        return BatchExportOptionsDialog(hasConvertible: hasConvertible);
      },
    );
    if (options == null || !context.mounted) return;

    String? outputDir;
    String? singleOutputPath;

    if (!options.includePath && filesToExport.length == 1) {
      final defaultName = _defaultExportName(
        filesToExport.first,
        options.convertWhenPossible,
      );
      singleOutputPath = await FilePicker.saveFile(
        dialogTitle: options.convertWhenPossible ? "选择转换导出文件" : "选择导出文件",
        fileName: defaultName,
      );
      if (singleOutputPath == null) return;
    } else {
      outputDir = await FilePicker.getDirectoryPath(
        dialogTitle: options.convertWhenPossible
            ? "选择转换导出位置"
            : S.current.tools_unp4k_action_save_as,
      );
      if (outputDir == null) return;
    }

    if (!context.mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AdvancedExportProgressDialog(
          filesToExport: filesToExport,
          outputDir: outputDir,
          singleOutputPath: singleOutputPath,
          options: options,
          model: model,
        );
      },
    );
    model.exitMultiSelectMode();
  }

  List<String> _collectSelectedFilesForExport() {
    final allFiles = state.files;
    if (allFiles == null) return const [];
    final result = <String>{};
    for (final selected in state.selectedItems) {
      final item = allFiles[selected];
      if (item != null && !(item.isDirectory ?? false)) {
        result.add(selected);
        continue;
      }
      final prefix = selected.endsWith("\\") ? selected : "$selected\\";
      for (final entry in allFiles.entries) {
        if (entry.key.startsWith(prefix) &&
            !(entry.value.isDirectory ?? false)) {
          result.add(entry.key);
        }
      }
    }
    final list = result.toList()..sort();
    return list;
  }

  bool _canConvertPath(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith(".wem") ||
        lower.endsWith(".dds") ||
        RegExp(r"\.dds\.\d+$").hasMatch(lower) ||
        lower.endsWith(".cgf") ||
        lower.endsWith(".cga");
  }

  String _defaultExportName(String p4kPath, bool convert) {
    final raw = p4kPath.split("\\").last;
    if (!convert) return raw;
    final lower = raw.toLowerCase();
    if (lower.endsWith(".wem")) {
      return "${raw.substring(0, raw.length - 4)}.wav";
    }
    final ddsChain = lower.indexOf(".dds.");
    if (ddsChain != -1) {
      return "${raw.substring(0, ddsChain)}.png";
    }
    if (lower.endsWith(".dds")) {
      return "${raw.substring(0, raw.length - 4)}.png";
    }
    if (lower.endsWith(".cgf") || lower.endsWith(".cga")) {
      return "${raw.substring(0, raw.length - 4)}.glb";
    }
    return raw;
  }
}
