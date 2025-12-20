import 'dart:async';
import 'dart:js_interop';
import 'package:extended_image/extended_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:web/web.dart' as web;

import 'yearly_report_ui.dart';

// JS interop extensions for File System Access API
@JS('showDirectoryPicker')
external JSPromise<JSObject> _showDirectoryPicker();

extension type FileSystemDirectoryHandleJS(JSObject _) implements JSObject {
  external JSPromise<JSObject> getDirectoryHandle(JSString name);
  external JSPromise<JSObject> getFileHandle(JSString name);
  external JSObject values();
}

extension type FileSystemFileHandleJS(JSObject _) implements JSObject {
  external JSPromise<web.File> getFile();
  external JSString get kind;
  external JSString get name;
}

extension type AsyncIteratorJS(JSObject _) implements JSObject {
  external JSPromise<IteratorResultJS> next();
}

extension type IteratorResultJS(JSObject _) implements JSObject {
  external JSBoolean get done;
  external JSObject? get value;
}

/// 检查当前日期是否在年度报告展示期间（12月20日 - 次年1月20日）
bool isYearlyReportPeriod() {
  final now = DateTime.now();
  // 12月20日及之后
  if (now.month == 12 && now.day >= 20) return true;
  // 1月1日至1月20日
  if (now.month == 1 && now.day <= 20) return true;
  return false;
}

/// 获取年度报告的年份（1月时使用上一年）
int getReportYear() {
  final now = DateTime.now();
  // 如果是 1 月，年份减 1
  if (now.month == 1) {
    return now.year - 1;
  }
  return now.year;
}

/// Web 平台年度报告入口页面（用于通过 URL 直接访问）
class YearlyReportEntryUIRoute extends HookConsumerWidget {
  const YearlyReportEntryUIRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalState = ref.watch(appGlobalModelProvider);

    // 使用类似 index_ui.dart 的背景图片布局
    return Container(
      color: const Color(0xFF0a0a12), // 深色背景色作为底色
      child: Stack(
        children: [
          // 背景图片
          AnimatedSwitcher(
            duration: const Duration(seconds: 3),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: ExtendedImage.asset(
              key: ValueKey(globalState.backgroundImageAssetsPath),
              width: double.infinity,
              height: double.infinity,
              globalState.backgroundImageAssetsPath,
              fit: BoxFit.cover,
              cacheWidth: null,
              cacheHeight: null,
              loadStateChanged: (state) {
                if (state.extendedImageLoadState == LoadState.completed) {
                  return state.completedWidget;
                }
                return Container(width: double.infinity, height: double.infinity, color: const Color(0xFF0a0a12));
              },
            ),
          ),
          // 半透明遮罩，增加可读性
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withValues(alpha: .6), Colors.black.withValues(alpha: .75)],
              ),
            ),
          ),
          // 内容区域
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440, maxHeight: 920),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: BlurOvalWidget(child: const YearlyReportEntryUI()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Web 平台年度报告入口页面
class YearlyReportEntryUI extends HookConsumerWidget {
  const YearlyReportEntryUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appGlobalState = ref.watch(appGlobalModelProvider);
    final appGlobalModel = ref.read(appGlobalModelProvider.notifier);

    // 自动计算年份
    final reportYear = getReportYear();
    final isLoading = useState(false);
    final loadingMessage = useState("");
    final loadingProgress = useState(0.0);
    final logContents = useState<List<String>?>(null);
    final errorMessage = useState<String?>(null);

    // 如果已加载日志内容，显示报告
    if (logContents.value != null) {
      return YearlyReportUI(logContents: logContents.value!, year: reportYear);
    }

    // 构建内容
    Widget contentWidget;
    if (isLoading.value) {
      contentWidget = _buildLoadingState(context, loadingMessage.value, loadingProgress.value);
    } else {
      contentWidget = _buildSelectionState(
        context,
        reportYear,
        isLoading,
        loadingMessage,
        loadingProgress,
        logContents,
        errorMessage,
        appGlobalState,
        appGlobalModel,
      );
    }

    return contentWidget;
  }

  Widget _buildLoadingState(BuildContext context, String message, double progress) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ProgressRing(),
          const SizedBox(height: 24),
          Text(
            message.isEmpty ? S.current.yearly_report_web_reading_files : message,
            style: const TextStyle(fontSize: 16),
          ),
          if (progress > 0) ...[
            const SizedBox(height: 16),
            SizedBox(width: 300, child: ProgressBar(value: progress * 100)),
            const SizedBox(height: 8),
            Text(
              "${(progress * 100).toStringAsFixed(1)}%",
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .7)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectionState(
    BuildContext context,
    int reportYear,
    ValueNotifier<bool> isLoading,
    ValueNotifier<String> loadingMessage,
    ValueNotifier<double> loadingProgress,
    ValueNotifier<List<String>?> logContents,
    ValueNotifier<String?> errorMessage,
    AppGlobalState appGlobalState,
    AppGlobalModel appGlobalModel,
  ) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.chartLine, size: 64, color: FluentTheme.of(context).accentColor),
            const SizedBox(height: 32),
            Text(
              S.current.yearly_report_title(reportYear.toString()),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              S.current.yearly_report_web_select_folder_desc,
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: .7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // 语言选择器
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FontAwesomeIcons.language, size: 16),
                const SizedBox(width: 12),
                Text("Language", style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 12),
                SizedBox(
                  height: 36,
                  child: ComboBox(
                    value: appGlobalState.appLocale ?? const Locale("auto"),
                    items: [
                      for (final mkv in AppGlobalModel.appLocaleSupport.entries)
                        ComboBoxItem(value: mkv.key, child: Text(mkv.value)),
                    ],
                    onChanged: appGlobalModel.changeLocale,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (errorMessage.value != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(errorMessage.value!, style: TextStyle(color: Colors.red)),
              ),
            ],
            FilledButton(
              onPressed: () => _selectFolderAndGenerateReport(
                context,
                reportYear,
                isLoading,
                loadingMessage,
                loadingProgress,
                logContents,
                errorMessage,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(FluentIcons.folder_open, size: 20),
                    const SizedBox(width: 12),
                    Text(S.current.yearly_report_web_select_folder, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFolderAndGenerateReport(
    BuildContext context,
    int year,
    ValueNotifier<bool> isLoading,
    ValueNotifier<String> loadingMessage,
    ValueNotifier<double> loadingProgress,
    ValueNotifier<List<String>?> logContents,
    ValueNotifier<String?> errorMessage,
  ) async {
    if (!kIsWeb) return;

    // 检查浏览器是否支持 showDirectoryPicker
    if (!_isDirectoryPickerSupported()) {
      errorMessage.value = S.current.yearly_report_web_browser_not_supported;
      return;
    }

    try {
      isLoading.value = true;
      loadingMessage.value = S.current.yearly_report_web_reading_files;
      loadingProgress.value = 0;
      errorMessage.value = null;

      final contents = await _readLogFilesFromDirectory(loadingMessage, loadingProgress);

      if (contents.isEmpty) {
        errorMessage.value = S.current.yearly_report_web_no_logs_found;
        isLoading.value = false;
        return;
      }

      logContents.value = contents;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  bool _isDirectoryPickerSupported() {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<String>> _readLogFilesFromDirectory(
    ValueNotifier<String> loadingMessage,
    ValueNotifier<double> loadingProgress,
  ) async {
    final logContents = <String>[];

    try {
      final dirHandle = await _showDirectoryPickerWrapper();
      if (dirHandle == null) return [];

      final dirHandleJS = FileSystemDirectoryHandleJS(dirHandle);

      // 尝试获取 LIVE 目录
      FileSystemDirectoryHandleJS? liveHandle;
      try {
        final livePromise = dirHandleJS.getDirectoryHandle('LIVE'.toJS);
        final liveResult = await livePromise.toDart;
        liveHandle = FileSystemDirectoryHandleJS(liveResult);
      } catch (_) {
        liveHandle = dirHandleJS;
      }

      // 先收集所有需要读取的文件
      final filesToRead = <FileSystemFileHandleJS>[];

      // 读取 Game.log
      try {
        final gameLogPromise = liveHandle.getFileHandle('Game.log'.toJS);
        final gameLogResult = await gameLogPromise.toDart;
        filesToRead.add(FileSystemFileHandleJS(gameLogResult));
      } catch (_) {}

      // 收集 logbackups 目录中的文件
      try {
        final logbackupsPromise = liveHandle.getDirectoryHandle('logbackups'.toJS);
        final logbackupsResult = await logbackupsPromise.toDart;
        final logbackupsHandle = FileSystemDirectoryHandleJS(logbackupsResult);
        await _collectLogbackupsFiles(logbackupsHandle, filesToRead);
      } catch (_) {}

      // 依次读取文件，更新进度
      for (var i = 0; i < filesToRead.length; i++) {
        final fileHandle = filesToRead[i];
        final fileName = fileHandle.name.toDart;
        loadingMessage.value = "${S.current.yearly_report_web_reading_files} ($fileName)";
        loadingProgress.value = i / filesToRead.length;

        try {
          await Future.delayed(Duration.zero);

          final content = await _readFileContent(fileHandle);
          if (content.isNotEmpty) {
            logContents.add(content);
          }
        } catch (_) {}
      }

      loadingProgress.value = 1.0;
    } catch (e) {
      rethrow;
    }

    return logContents;
  }

  Future<void> _collectLogbackupsFiles(
    FileSystemDirectoryHandleJS dirHandle,
    List<FileSystemFileHandleJS> filesToRead,
  ) async {
    try {
      final valuesIterator = AsyncIteratorJS(dirHandle.values());

      while (true) {
        final nextPromise = valuesIterator.next();
        final result = await nextPromise.toDart;

        if (result.done.toDart) break;

        final entry = result.value;
        if (entry == null) continue;

        final handleJS = FileSystemFileHandleJS(entry);
        final name = handleJS.name.toDart;
        final kind = handleJS.kind.toDart;

        if (kind == 'file' && name.endsWith('.log')) {
          filesToRead.add(handleJS);
        }
      }
    } catch (e) {}
  }

  Future<JSObject?> _showDirectoryPickerWrapper() async {
    try {
      final promise = _showDirectoryPicker();
      final result = await promise.toDart;
      return result;
    } catch (e) {
      if (e.toString().contains('AbortError')) {
        return null;
      }
      rethrow;
    }
  }

  Future<String> _readFileContent(FileSystemFileHandleJS fileHandle) async {
    final filePromise = fileHandle.getFile();
    final file = await filePromise.toDart;
    final textPromise = file.text();
    final text = await textPromise.toDart;
    return text.toDart;
  }
}
