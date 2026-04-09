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

class WaveMark {
  final double ratio;
  final int second;

  const WaveMark(this.ratio, this.second);
}
