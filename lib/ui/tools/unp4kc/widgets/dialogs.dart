import 'dart:io';
import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starcitizen_doctor/common/helper/log_helper.dart';
import 'package:starcitizen_doctor/common/rust/api/unp4k_api.dart' as unp4k_api;
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';

import '../../../../widgets/widgets.dart';
import '../../../../common/helper/system_helper.dart';
import 'models.dart';

class ExtractProgressDialog extends HookWidget {
  final AppUnp4kP4kItemData item;
  final String outputDir;
  final Unp4kCModel model;

  const ExtractProgressDialog({
    super.key,
    required this.item,
    required this.outputDir,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isCancelled = useState(false);
    final currentFile = useState("");
    final currentIndex = useState(0);
    final totalFiles = useState(0);
    final isCompleted = useState(false);
    final errorMessage = useState<String?>(null);
    final extractedCount = useState(0);

    useEffect(() {
      totalFiles.value = model.getFileCountInDirectory(item);

      _startExtraction(
        isCancelled,
        currentFile,
        currentIndex,
        totalFiles,
        isCompleted,
        errorMessage,
        extractedCount,
      );
      return null;
    }, const []);

    final progress = totalFiles.value > 0
        ? currentIndex.value / totalFiles.value
        : 0.0;

    return ContentDialog(
      title: Text(S.current.tools_unp4k_extract_dialog_title),
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 300),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCompleted.value && errorMessage.value == null) ...[
            ProgressBar(value: progress * 100),
            const SizedBox(height: 12),
            Text(
              S.current.tools_unp4k_extract_progress(
                currentIndex.value,
                totalFiles.value,
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              S.current.tools_unp4k_extract_current_file(
                currentFile.value.length > 60
                    ? "...${currentFile.value.substring(currentFile.value.length - 60)}"
                    : currentFile.value,
              ),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: .7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (errorMessage.value != null) ...[
            const Icon(
              FluentIcons.error_badge,
              size: 48,
              color: Color(0xFFE81123),
            ),
            const SizedBox(height: 12),
            Text(errorMessage.value!, style: const TextStyle(fontSize: 14)),
          ] else ...[
            const Icon(
              FluentIcons.completed_solid,
              size: 48,
              color: Color(0xFF107C10),
            ),
            const SizedBox(height: 12),
            Text(
              S.current.tools_unp4k_extract_completed(extractedCount.value),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ],
      ),
      actions: [
        if (!isCompleted.value && errorMessage.value == null)
          Button(
            onPressed: () {
              isCancelled.value = true;
            },
            child: Text(S.current.home_action_cancel),
          )
        else
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.current.action_close),
          ),
      ],
    );
  }

  Future<void> _startExtraction(
    ValueNotifier<bool> isCancelled,
    ValueNotifier<String> currentFile,
    ValueNotifier<int> currentIndex,
    ValueNotifier<int> totalFiles,
    ValueNotifier<bool> isCompleted,
    ValueNotifier<String?> errorMessage,
    ValueNotifier<int> extractedCount,
  ) async {
    final result = await model.extractToDirectoryWithProgress(
      item,
      outputDir,
      onProgress: (current, total, file) {
        currentIndex.value = current;
        totalFiles.value = total;
        currentFile.value = file;
      },
      isCancelled: () => isCancelled.value,
    );

    final (success, count, error) = result;
    extractedCount.value = count;

    if (!success && error != null) {
      errorMessage.value = error;
    } else {
      isCompleted.value = true;
    }
  }
}

class BatchExportOptionsDialog extends HookWidget {
  final bool hasConvertible;

  const BatchExportOptionsDialog({super.key, required this.hasConvertible});

  @override
  Widget build(BuildContext context) {
    final convert = useState(hasConvertible);
    final includePath = useState(true);
    return ContentDialog(
      title: const Text("批量导出选项"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasConvertible)
            ToggleSwitch(
              checked: convert.value,
              onChanged: (v) => convert.value = v,
              content: const Text(
                "可转换格式自动转换导出（WEM->WAV, DDS->PNG, CGA/CGF->GLB）",
              ),
            )
          else
            const Text("当前选择中没有可转换格式，将按原文件导出。"),
          const SizedBox(height: 8),
          ToggleSwitch(
            checked: includePath.value,
            onChanged: (v) => includePath.value = v,
            content: const Text("保留目录结构导出"),
          ),
          const SizedBox(height: 4),
          Text(
            includePath.value ? "导出时包含原始路径。" : "直接按文件名导出；单文件时将直接选择保存文件。",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: .7),
            ),
          ),
        ],
      ),
      actions: [
        Button(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.home_action_cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              BatchExportOptions(
                convertWhenPossible: hasConvertible ? convert.value : false,
                includePath: includePath.value,
              ),
            );
          },
          child: const Text("开始导出"),
        ),
      ],
    );
  }
}

class AdvancedExportProgressDialog extends HookWidget {
  final List<String> filesToExport;
  final String? outputDir;
  final String? singleOutputPath;
  final BatchExportOptions options;
  final Unp4kCModel model;

  const AdvancedExportProgressDialog({
    super.key,
    required this.filesToExport,
    required this.outputDir,
    required this.singleOutputPath,
    required this.options,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isCancelled = useState(false);
    final currentFile = useState("");
    final currentIndex = useState(0);
    final totalFiles = useState(filesToExport.length);
    final isCompleted = useState(false);
    final errorMessage = useState<String?>(null);
    final exportedCount = useState(0);

    useEffect(() {
      _startExport(
        isCancelled,
        currentFile,
        currentIndex,
        totalFiles,
        isCompleted,
        errorMessage,
        exportedCount,
      );
      return null;
    }, const []);

    final progress = totalFiles.value > 0
        ? currentIndex.value / totalFiles.value
        : 0.0;

    return ContentDialog(
      title: const Text("批量导出"),
      constraints: const BoxConstraints(maxWidth: 520, maxHeight: 320),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCompleted.value && errorMessage.value == null) ...[
            ProgressBar(value: progress * 100),
            const SizedBox(height: 12),
            Text("进度: ${currentIndex.value}/${totalFiles.value}"),
            const SizedBox(height: 8),
            Text(
              currentFile.value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: .7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (errorMessage.value != null) ...[
            const Icon(
              FluentIcons.error_badge,
              size: 48,
              color: Color(0xFFE81123),
            ),
            const SizedBox(height: 8),
            Text(errorMessage.value!),
          ] else ...[
            const Icon(
              FluentIcons.completed_solid,
              size: 48,
              color: Color(0xFF107C10),
            ),
            const SizedBox(height: 8),
            Text("导出完成，共 ${exportedCount.value} 个文件"),
          ],
        ],
      ),
      actions: [
        if (!isCompleted.value && errorMessage.value == null)
          Button(
            onPressed: () => isCancelled.value = true,
            child: Text(S.current.home_action_cancel),
          )
        else ...[
          if ((outputDir ?? "").isNotEmpty)
            Button(
              onPressed: () {
                Navigator.of(context).pop();
                SystemHelper.openDir(outputDir!);
              },
              child: Text(S.current.action_open_folder),
            ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.current.action_close),
          ),
        ],
      ],
    );
  }

  Future<void> _startExport(
    ValueNotifier<bool> isCancelled,
    ValueNotifier<String> currentFile,
    ValueNotifier<int> currentIndex,
    ValueNotifier<int> totalFiles,
    ValueNotifier<bool> isCompleted,
    ValueNotifier<String?> errorMessage,
    ValueNotifier<int> exportedCount,
  ) async {
    try {
      final usedNames = <String, int>{};
      final jobs = <ExportJob>[];
      for (final src in filesToExport) {
        final outPath = await _buildOutputPath(src, usedNames);
        jobs.add(ExportJob(sourcePath: src, outputPath: outPath));
      }

      totalFiles.value = jobs.length;
      final workerCount = _computeWorkerCount(jobs.length);
      var nextJobIndex = 0;
      Object? firstError;
      StackTrace? firstStack;

      Future<void> workerLoop() async {
        while (true) {
          if (isCancelled.value || firstError != null) return;
          if (nextJobIndex >= jobs.length) return;

          final job = jobs[nextJobIndex];
          nextJobIndex += 1;
          currentFile.value = job.sourcePath;

          try {
            await _exportOne(job.sourcePath, job.outputPath);
            exportedCount.value = exportedCount.value + 1;
            currentIndex.value = exportedCount.value;
          } catch (e, st) {
            firstError ??= e;
            firstStack ??= st;
            return;
          }
        }
      }

      await Future.wait(List.generate(workerCount, (_) => workerLoop()));

      if (isCancelled.value) {
        errorMessage.value = S.current.tools_unp4k_extract_cancelled;
        return;
      }
      if (firstError != null) {
        errorMessage.value = firstStack == null
            ? firstError.toString()
            : "$firstError\n$firstStack";
        return;
      }

      isCompleted.value = true;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  int _computeWorkerCount(int totalJobs) {
    if (totalJobs <= 1) return 1;
    final cpuBased = (Platform.numberOfProcessors / 2).ceil();
    final preferred = cpuBased.clamp(2, 6);
    return totalJobs < preferred ? totalJobs : preferred;
  }

  Future<void> _exportOne(String sourcePath, String outputPath) async {
    final lower = sourcePath.toLowerCase();
    final normalized = _normalizeP4kPath(sourcePath);
    final outFile = File(outputPath);
    await outFile.parent.create(recursive: true);

    if (options.convertWhenPossible && lower.endsWith(".wem")) {
      final cached = await _tryLoadCachedWav(normalized);
      if (cached != null) {
        await outFile.writeAsBytes(cached, flush: true);
        return;
      }
      final wemBytes = await unp4k_api.p4KExtractToMemory(filePath: normalized);
      final tempDir = Directory(
        "${Directory.systemTemp.path}\\SCToolbox_unp4kc_export",
      );
      await tempDir.create(recursive: true);
      final safeName = normalized.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final tempWem = File(
        "${tempDir.path}\\${DateTime.now().microsecondsSinceEpoch}_$safeName.wem",
      );
      await tempWem.writeAsBytes(wemBytes, flush: true);
      try {
        await unp4k_api.p4KDecodeWemToWav(
          inputPath: tempWem.path,
          outputPath: outputPath,
        );
      } finally {
        if (await tempWem.exists()) {
          await tempWem.delete();
        }
      }
      return;
    }

    if (options.convertWhenPossible &&
        (lower.endsWith(".dds") || RegExp(r"\.dds\.\d+$").hasMatch(lower)) &&
        !RegExp(r"_ddna\.dds(\.\d+)?$").hasMatch(lower)) {
      final png = (await unp4k_api.p4KExtractDdsAsPng(filePath: normalized)).$1;
      await outFile.writeAsBytes(png, flush: true);
      return;
    }

    if (options.convertWhenPossible &&
        _isModelConvertible(lower)) {
      final (success, glbPath, error) = await model.convertModelToGlb(
        sourcePath,
        outFile.parent.path,
      );
      if (!success || glbPath == null || glbPath.isEmpty) {
        throw Exception(error ?? "GLB conversion failed");
      }
      final produced = File(glbPath);
      if (!await produced.exists()) {
        throw Exception("GLB output missing: $glbPath");
      }
      final samePath =
          produced.absolute.path.toLowerCase() ==
          outFile.absolute.path.toLowerCase();
      if (!samePath) {
        if (await outFile.exists()) {
          await outFile.delete();
        }
        await produced.copy(outFile.path);
      }
      return;
    }

    final data = await unp4k_api.p4KExtractToMemory(filePath: normalized);
    await outFile.writeAsBytes(data, flush: true);
  }

  Future<Uint8List?> _tryLoadCachedWav(String normalizedNoLeading) async {
    final tempDir = await getTemporaryDirectory();
    final tempRoot =
        "${tempDir.absolute.path}\\SCToolbox_unp4kc\\${SCLoggerHelper.getGameChannelID(model.getGamePath())}\\";
    final cachedPath = "$tempRoot$normalizedNoLeading.preview.v2.wav";
    final file = File(cachedPath);
    if (!await file.exists()) return null;
    final stat = await file.stat();
    if (stat.size <= 44) return null;
    return file.readAsBytes();
  }

  Future<String> _buildOutputPath(
    String sourcePath,
    Map<String, int> usedNames,
  ) async {
    if (singleOutputPath != null) return singleOutputPath!;
    final dir = outputDir!;
    final relative = _buildRelativeOutputPath(sourcePath);
    final safeRelative = options.includePath
        ? relative
        : relative.split("\\").last;
    var candidate = "$dir\\$safeRelative";
    if (options.includePath) {
      return candidate;
    }
    final lower = candidate.toLowerCase();
    final n = usedNames[lower] ?? 0;
    if (n == 0) {
      usedNames[lower] = 1;
      return candidate;
    }
    final dot = candidate.lastIndexOf(".");
    final withIndex = dot > 0
        ? "${candidate.substring(0, dot)}_${n + 1}${candidate.substring(dot)}"
        : "${candidate}_${n + 1}";
    usedNames[lower] = n + 1;
    return withIndex;
  }

  String _buildRelativeOutputPath(String sourcePath) {
    final normalized = sourcePath.startsWith("\\")
        ? sourcePath.substring(1)
        : sourcePath;
    if (!options.convertWhenPossible) return normalized;
    final lower = normalized.toLowerCase();
    if (lower.endsWith(".wem")) {
      return "${normalized.substring(0, normalized.length - 4)}.wav";
    }
    final ddsChain = lower.indexOf(".dds.");
    if (ddsChain != -1) {
      return "${normalized.substring(0, ddsChain)}.png";
    }
    if (lower.endsWith(".dds") && !RegExp(r"_ddna\.dds$").hasMatch(lower)) {
      return "${normalized.substring(0, normalized.length - 4)}.png";
    }
    for (final ext in [".skin", ".cgf", ".cga", ".cdf", ".chr"]) {
      if (lower.endsWith(ext)) {
        return "${normalized.substring(0, normalized.length - ext.length)}.glb";
      }
    }
    return normalized;
  }

  bool _isModelConvertible(String lowerPath) {
    return lowerPath.endsWith(".cgf") ||
        lowerPath.endsWith(".cga") ||
        lowerPath.endsWith(".skin") ||
        lowerPath.endsWith(".cdf") ||
        lowerPath.endsWith(".chr");
  }

  String _normalizeP4kPath(String filePath) {
    var p = filePath;
    if (p.startsWith("\\")) {
      p = p.substring(1);
    }
    return p;
  }
}

class ConvertProgressDialog extends HookWidget {
  final String filePath;
  final String outputDir;
  final Unp4kCModel model;

  const ConvertProgressDialog({
    super.key,
    required this.filePath,
    required this.outputDir,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = useState(true);
    final errorMessage = useState<String?>(null);
    final resultPath = useState<String?>(null);

    useEffect(() {
      _startConversion(isRunning, errorMessage, resultPath);
      return null;
    }, const []);

    return ContentDialog(
      title: Text(S.current.tools_unp4k_action_convert_glb),
      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 260),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRunning.value) ...[
              const ProgressRing(),
              const SizedBox(height: 12),
              Text(
                S.current.tools_unp4k_convert_in_progress,
                style: const TextStyle(fontSize: 14),
              ),
            ] else if (errorMessage.value != null) ...[
              const Icon(
                FluentIcons.error_badge,
                size: 48,
                color: Color(0xFFE81123),
              ),
              const SizedBox(height: 16),
              Text(
                S.current.tools_unp4k_convert_failed(errorMessage.value!),
                style: const TextStyle(fontSize: 14),
              ),
            ] else ...[
              const Icon(
                FluentIcons.completed_solid,
                size: 48,
                color: Color(0xFF107C10),
              ),
              const SizedBox(height: 16),
              Text(
                S.current.tools_unp4k_convert_success,
                style: const TextStyle(fontSize: 14),
              ),
              if ((resultPath.value ?? outputDir).isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  resultPath.value ?? outputDir,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: .65),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        if (!isRunning.value && errorMessage.value == null)
          Button(
            onPressed: () {
              SystemHelper.openDir(outputDir);
            },
            child: Text(S.current.action_open_folder),
          ),
        FilledButton(
          onPressed: isRunning.value ? null : () => Navigator.of(context).pop(),
          child: Text(S.current.action_close),
        ),
      ],
    );
  }

  Future<void> _startConversion(
    ValueNotifier<bool> isRunning,
    ValueNotifier<String?> errorMessage,
    ValueNotifier<String?> resultPath,
  ) async {
    final result = await model.convertModelToGlb(filePath, outputDir);
    final (success, glbPath, error) = result;
    resultPath.value = glbPath;
    if (!success) {
      errorMessage.value = error ?? "Unknown error";
    }
    isRunning.value = false;
  }
}
