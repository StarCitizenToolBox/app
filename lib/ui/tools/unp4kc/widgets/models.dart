import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';

class BatchExportOptions {
  final bool convertWhenPossible;
  final bool includePath;

  const BatchExportOptions({
    required this.convertWhenPossible,
    required this.includePath,
  });
}

class ExportJob {
  final String sourcePath;
  final String outputPath;

  const ExportJob({required this.sourcePath, required this.outputPath});
}

class ExportFailure {
  final String sourcePath;
  final String error;

  const ExportFailure({required this.sourcePath, required this.error});
}

class WaveMark {
  final double ratio;
  final int second;

  const WaveMark(this.ratio, this.second);
}

List<String> collectFilesForExport(
  Iterable<String> selectedItems,
  Map<String, AppUnp4kP4kItemData>? allFiles,
) {
  if (allFiles == null) return const [];

  final result = <String>{};
  for (final selected in selectedItems) {
    final item = allFiles[selected];
    if (item != null && !(item.isDirectory ?? false)) {
      result.add(selected);
      continue;
    }

    final prefix = selected.endsWith("\\") ? selected : "$selected\\";
    for (final entry in allFiles.entries) {
      if (entry.key.startsWith(prefix) && !(entry.value.isDirectory ?? false)) {
        result.add(entry.key);
      }
    }
  }

  final list = result.toList()..sort();
  return list;
}

bool canConvertExportPath(String path) {
  final lower = path.toLowerCase();
  return lower.endsWith(".wem") ||
      lower.endsWith(".dds") ||
      RegExp(r"\.dds\.\d+$").hasMatch(lower) ||
      lower.endsWith(".cgf") ||
      lower.endsWith(".cga") ||
      lower.endsWith(".skin") ||
      lower.endsWith(".cdf") ||
      lower.endsWith(".chr");
}

String defaultExportName(String p4kPath, bool convert) {
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
  for (final ext in [".skin", ".cgf", ".cga", ".cdf", ".chr"]) {
    if (lower.endsWith(ext)) {
      return "${raw.substring(0, raw.length - ext.length)}.glb";
    }
  }
  return raw;
}
