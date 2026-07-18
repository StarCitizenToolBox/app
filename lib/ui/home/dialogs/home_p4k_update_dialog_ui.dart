import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/eac/eac_registrar.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/rsi_launcher/launcher_store.dart';
import 'package:starcitizen_doctor/common/rust/api/p4k_upgrader_api.dart';
import 'package:starcitizen_doctor/ui/home/dialogs/home_p4k_download_source_dialog_ui.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:window_manager/window_manager.dart';

enum P4kUpdateDialogResult { updated, switchToOfficial }

Future<P4kUpdateDialogResult?> resolveP4kMirrorProviderFailure({
  required P4kMirrorUnavailable error,
  required Future<bool> Function(P4kMirrorUnavailable error) decideFallback,
}) async {
  return await decideFallback(error)
      ? P4kUpdateDialogResult.switchToOfficial
      : null;
}

class HomeP4kUpdateDialogUI extends StatefulWidget {
  const HomeP4kUpdateDialogUI({
    super.key,
    required this.source,
    required this.releaseInfo,
    required this.installPath,
    required this.applicationSupportDir,
    required this.webToken,
    required this.webCookie,
    this.libraryData = const {},
    this.onMirrorProviderError,
  });

  final P4kDownloadSource source;
  final Map releaseInfo;
  final String installPath;
  final String applicationSupportDir;
  final String webToken;
  final String webCookie;
  final Map libraryData;
  final Future<bool> Function(P4kMirrorUnavailable error)?
  onMirrorProviderError;

  @override
  State<HomeP4kUpdateDialogUI> createState() => _HomeP4kUpdateDialogUIState();
}

P4kUpgraderConfig buildP4kSessionConfig({
  required P4kDownloadSource source,
  required String manifestSource,
  required List<String> objectBases,
  required String p4kBaseUrl,
  required String p4kBaseVerificationUrl,
  required List<String> objectPathTemplates,
  required String requestCookie,
  required String rsiToken,
  required String cacheDir,
  required String gameDir,
  required bool deepVerify,
}) {
  final official = source == P4kDownloadSource.official;
  return P4kUpgraderConfig(
    source: source,
    manifestSource: manifestSource,
    mirrorBases: official ? const [] : objectBases,
    officialBases: official ? objectBases : const [],
    p4KBaseUrl: p4kBaseUrl,
    p4KBaseVerificationUrl: p4kBaseVerificationUrl,
    objectPathTemplates: objectPathTemplates,
    requestCookie: official ? requestCookie : "",
    rsiToken: official ? rsiToken : "",
    cacheDir: cacheDir,
    gameDir: gameDir,
    updateP4K: true,
    updateLooseFiles: official,
    inplaceUpdateP4K: true,
    fallbackRebuildOnInplaceVerifyFailure: deepVerify,
    replaceExistingP4K: true,
    verifyAfterAssemble: deepVerify,
    verifyCigStructure: deepVerify,
  );
}

class _P4kLogLine {
  const _P4kLogLine(this.text, {this.isError = false});

  final String text;
  final bool isError;
}

class _P4kStageInfo {
  const _P4kStageInfo(this.key, this.current, this.total);

  final String key;
  final int current;
  final int total;
}

class _HomeP4kUpdateDialogUIState extends State<HomeP4kUpdateDialogUI> {
  late final TextEditingController _manifestController;
  late final TextEditingController _baseController;
  late final TextEditingController _templateController;
  late final _ReleaseUrls _releaseUrls;
  bool get _updateLooseFiles => widget.source == P4kDownloadSource.official;
  bool _working = false;
  bool _paused = false;
  bool _cancelling = false;
  bool _lastRunFailed = false;
  int _downloadThreads = 32;
  String _status = "";
  String _downloadSpeedText = "";
  P4kUpgraderEstimateReport? _estimateReport;
  double? _overallProgressPercent;
  final List<_P4kLogLine> _logLines = [];
  Timer? _downloadSpeedTimer;
  BigInt _downloadSpeedCumulativeBytes = BigInt.zero;
  BigInt _lastDownloadSpeedSampleBytes = BigInt.zero;
  int _lastDownloadSpeedSampleMillis = 0;
  bool _hasDownloadSpeedSample = false;
  List<String> _plannedStageKeys = [];
  Map<String, int> _plannedStageNumbers = {};
  bool _currentRunDeepRepair = false;
  String? _lastProgressEventPhase;
  int _lastProgressLogMillis = 0;
  String _lastProgressLogSignature = "";

  static const _threadOptions = [4, 8, 16, 32, 64, 96];
  static const _maxLogLines = 300;
  static const _progressLogInterval = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    final urls = widget.source == P4kDownloadSource.official
        ? _extractReleaseUrls(widget.releaseInfo)
        : const _ReleaseUrls("", []);
    _releaseUrls = urls;
    _printExtractedReleaseUrls(urls);
    _manifestController = TextEditingController(text: urls.manifestUrl);
    _baseController = TextEditingController(text: urls.objectBases.join('\n'));
    final defaultTemplates = p4KUpgraderDefaultObjectPathTemplates();
    _templateController = TextEditingController(
      text:
          (urls.hashOnlyTemplates
                  ? defaultTemplates.where((value) => value == "{sha256_upper}")
                  : defaultTemplates)
              .join('\n'),
    );
    final signatureProblem = _signatureProblemText();
    if (signatureProblem != null) {
      _status = signatureProblem;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showToast(context, signatureProblem);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _runEstimate(context);
      });
    }
  }

  @override
  void dispose() {
    _stopDownloadSpeedTimer();
    p4KUpgraderClearManifestCache();
    _manifestController.dispose();
    _baseController.dispose();
    _templateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .7,
      ),
      title: DragToMoveArea(
        child: Text(S.current.p4k_update_game_downloader_updater),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * .68,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.p4k_update_install_to(widget.installPath),
              style: FluentTheme.of(context).typography.subtitle,
            ),
            Text(
              S.current.p4k_source_current(
                widget.source == P4kDownloadSource.official
                    ? S.current.p4k_source_official
                    : S.current.p4k_source_community_mirror,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(S.current.p4k_update_number_of_threads),
                const SizedBox(width: 8),
                ComboBox<int>(
                  value: _downloadThreads,
                  items: _threadOptions
                      .map(
                        (value) => ComboBoxItem(
                          value: value,
                          child: Text(value.toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _downloadThreads = value);
                    p4KUpgraderSetDownloadThreads(threads: BigInt.from(value));
                  },
                ),
                const SizedBox(width: 24),
                if (_downloadSpeedText.isNotEmpty)
                  Text(S.current.p4k_update_download_speed(_downloadSpeedText)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildStatusPanel(context)),
          ],
        ),
      ),
      actions: [
        Button(
          onPressed: _cancelling
              ? null
              : _working
              ? _stopUpdate
              : () => Navigator.pop(context),
          child: Text(
            _cancelling
                ? S.current.p4k_update_canceling
                : _working
                ? S.current.p4k_update_stop
                : S.current.action_close,
          ),
        ),
        if (_working)
          Button(
            onPressed: _cancelling ? null : () => _togglePause(context),
            child: Text(
              _paused
                  ? S.current.app_splash_free_software_notice_confirm
                  : S.current.p4k_update_pause,
            ),
          ),
        Tooltip(
          message: S
              .current
              .p4k_update_deep_repair_the_current_p4k_will_be_diagnosed_first_restored_reb,
          child: Button(
            onPressed: _working || _cancelling
                ? null
                : () => _runRepairMode(context),
            child: Text(S.current.p4k_update_deep_repair),
          ),
        ),
        FilledButton(
          onPressed: _working || _cancelling
              ? null
              : _estimateReport == null
              ? () => _runEstimate(context)
              : () => _runUpdate(context),
          child: Text(
            _estimateReport == null
                ? S.current.p4k_update_estimated_number_of_updates
                : _lastRunFailed
                ? S.current.party_room_retry
                : S.current.p4k_update_start_installation,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPanel(BuildContext context) {
    if (_working) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: FluentTheme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ProgressBar(value: _overallProgressPercent),
            ),
            const SizedBox(height: 12),
            Text(_status),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  child: _logLines.isEmpty
                      ? Text(
                          S.current.p4k_update_waiting_for_progress,
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 13,
                            height: 1.35,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _logLines
                              .map(
                                (line) => Text(
                                  line.text,
                                  style: TextStyle(
                                    color: line.isError ? Colors.red : null,
                                    fontFamily: 'Consolas',
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                  softWrap: true,
                                ),
                              )
                              .toList(),
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    final report = _estimateReport;
    if (report == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: FluentTheme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Text(
            _status.isEmpty ? _formatReleaseInfo(widget.releaseInfo) : _status,
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Text(
          S.current
              .p4k_update_manifest_entry_p4k_requires_download_entry_game_files_need_to_be(
                report.manifestEntries,
                report.p4KEntriesRequiringDownload,
                report.looseEntriesRequiringDownload,
                report.totalEntriesRequiringDownload,
                _formatBytes(report.totalDownloadBytes),
                _formatBytes(_localDataP4kPartBytes()),
                report.baseDownloadRequired
                    ? _formatBytes(report.baseDownloadBytes)
                    : S.current.p4k_update_unnecessary,
                formatP4kPayloadEstimate(
                  report.payloadDownloadBytes,
                  exact: report.payloadEstimateExact,
                ),
                _formatBytes(_estimatedTotalDownload()),
                report.entries
                    .take(20)
                    .map(
                      (entry) =>
                          '${_formatBytes(entry.compressedSize)}  ${entry.name}',
                    )
                    .join('\n'),
              ),
        ),
      ),
    );
  }

  Future<void> _runEstimate(BuildContext context) async {
    final config = _buildConfig();
    if (config == null) return;
    await _runTask(
      status: S.current.p4k_update_reading_inventory_and_estimating_updates,
      task: () async {
        final outcome = await p4KUpgraderEstimate(config: config);
        if (outcome.mirrorUnavailable case final unavailable?) {
          throw unavailable;
        }
        if (outcome.errorMessage case final message?) {
          throw Exception(message);
        }
        final report = outcome.report;
        if (report == null) throw StateError("missing estimate report");
        if (!mounted) return;
        setState(() {
          _estimateReport = report;
          _lastRunFailed = false;
        });
      },
      success: S.current.p4k_update_estimate_completed,
      context: context,
    );
  }

  Future<void> _runUpdate(BuildContext context) async {
    if (await _blockUpdateWhileLauncherIsRunning(context)) return;
    if (!mounted) return;
    final config = _buildConfig();
    if (config == null) return;
    _prepareStagePlan(deepRepair: false);
    await _runUpdateWithProgressTask(
      this.context,
      config,
      status:
          S.current.p4k_update_downloading_objects_game_files_and_patching_p4k,
      success: S.current.p4k_update_update_completed,
      deepRepair: false,
    );
  }

  Future<void> _runRepairMode(BuildContext context) async {
    if (await _blockUpdateWhileLauncherIsRunning(context)) return;
    if (!mounted) return;
    final config = _buildConfig(deepVerify: true);
    if (config == null) return;
    _prepareStagePlan(deepRepair: true);
    await _runUpdateWithProgressTask(
      this.context,
      config,
      status: S
          .current
          .p4k_update_p4k_is_being_repaired_in_depth_will_diagnose_first_and_rebuild_i,
      success: S.current.p4k_update_deep_repair_completed,
      deepRepair: true,
    );
  }

  Future<void> _runUpdateWithProgressTask(
    BuildContext context,
    P4kUpgraderConfig config, {
    required String status,
    required String success,
    required bool deepRepair,
  }) async {
    p4KUpgraderSetDownloadThreads(threads: BigInt.from(_downloadThreads));
    var streamCompletedSuccessfully = false;
    await _runTask(
      status: status,
      deepRepair: deepRepair,
      shouldCloseOnSuccess: () =>
          streamCompletedSuccessfully &&
          !_cancelling &&
          _status != S.current.p4k_update_canceled,
      task: () async {
        _paused = false;
        _cancelling = false;
        EacDistributionPatchGuard? eacPatchGuard;
        if (config.updateLooseFiles) {
          eacPatchGuard = await EacDistributionPatchGuard.prepare(
            widget.installPath,
            log: _appendEacLog,
          );
        }
        _startDownloadSpeedTimer();
        final completer = Completer<void>();
        late final StreamSubscription<P4kUpgraderProgressEvent> sub;
        sub = p4KUpgraderUpdateWithProgress(config: config).listen(
          (event) {
            if (!mounted) return;
            if (event.phase == "network_speed") {
              _recordDownloadSpeedEvent(event);
              return;
            }
            if (_cancelling && event.phase == "download_error") {
              return;
            }
            final nowMillis = DateTime.now().millisecondsSinceEpoch;
            final phaseChanged = _lastProgressEventPhase != event.phase;
            _lastProgressEventPhase = event.phase;
            _recordDownloadSpeedEvent(event);
            final shouldAppendLog = _shouldAppendProgressLog(
              event,
              nowMillis,
              phaseChanged: phaseChanged,
            );
            setState(() {
              final progressValue = _overallProgressValue(event);
              final stageText = _stageText(event);
              _overallProgressPercent = progressValue;
              if (shouldAppendLog) {
                _appendLogLine(
                  _formatProgressLog(event, stageText: stageText),
                  isError:
                      event.phase == "download_error" || event.phase == "error",
                );
              }
              if (event.phase == "done") {
                _status = S.current.p4k_update_update_completed_2(
                  event.message,
                );
              } else if (event.phase == "cancelled") {
                _status = S.current.p4k_update_canceled;
                _cancelling = false;
              } else if (event.phase == "error") {
                _status = S.current.p4k_update_failure(event.message);
              } else if (event.phase == "download_error") {
                _status = S.current.p4k_update_download_failed_retrying(
                  event.name,
                );
              } else if (event.phase == "writing") {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_writing(event.name),
                );
              } else if (event.phase == "disk_checking") {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_checking_disk_space,
                );
              } else if (event.phase == "p4k_diagnosing") {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_diagnosing_current_p4k,
                );
              } else if (event.phase == "repair_rebuilding") {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_in_depth_repair_of_p4k,
                );
              } else if (event.phase == "p4k_metadata") {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_updating_p4k_entry_metadata(event.name),
                );
              } else if (event.phase == "p4k_recovering_index") {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S
                      .current
                      .p4k_update_scanning_local_p4k_records_and_restoring_indexes,
                );
              } else if (event.phase == "loose_staging") {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_preparing_game_files(event.name),
                );
              } else if (event.phase == "loose_writing") {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_writing_game_file(event.name),
                );
              } else if (_isP4kWorkPhase(event.phase)) {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_processing_p4k,
                );
              } else if (_isVerifyPhase(event.phase)) {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_verifying(event.name),
                );
              } else {
                _status = _statusWithStageText(
                  event,
                  stageText,
                  S.current.p4k_update_downloading(event.name),
                );
              }
            });
            if (event.phase == "done") {
              streamCompletedSuccessfully = true;
              if (!completer.isCompleted) completer.complete();
            } else if (event.phase == "cancelled") {
              if (!completer.isCompleted) completer.complete();
            } else if (event.phase == "error") {
              if (!completer.isCompleted) {
                completer.completeError(
                  event.mirrorUnavailable ?? Exception(event.message),
                );
              }
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!completer.isCompleted) {
              completer.completeError(error, stackTrace);
            }
          },
          onDone: () {
            if (!completer.isCompleted) completer.complete();
          },
        );
        try {
          await completer.future;
          if (streamCompletedSuccessfully && !_cancelling) {
            await eacPatchGuard?.commit();
            eacPatchGuard = null;
            await _runPostInstallTasks();
          }
        } finally {
          await eacPatchGuard?.rollback();
          _stopDownloadSpeedTimer();
          await sub.cancel();
          if (mounted) {
            setState(() => _resetDownloadSpeedSampler());
          } else {
            _resetDownloadSpeedSampler();
          }
        }
      },
      success: success,
      context: context,
    );
  }

  Future<bool> _blockUpdateWhileLauncherIsRunning(BuildContext context) async {
    if (!await blockIfRsiLauncherRunning(context)) return false;
    if (mounted) {
      setState(
        () =>
            _status = S.current.tools_action_info_rsi_launcher_running_warning,
      );
    }
    return true;
  }

  void _stopUpdate() {
    if (_cancelling) return;
    p4KUpgraderCancel();
    if (!mounted) return;
    setState(() {
      _paused = false;
      _cancelling = true;
      _status = S.current.p4k_update_canceling_2;
      _appendLogLine(_status);
    });
  }

  Future<void> _togglePause(BuildContext context) async {
    if (_cancelling) return;
    if (_paused) {
      if (await _blockUpdateWhileLauncherIsRunning(context)) return;
      p4KUpgraderResume();
    } else {
      p4KUpgraderPause();
    }
    setState(() {
      _paused = !_paused;
      _status = _paused
          ? S.current.downloader_info_paused
          : S.current.p4k_update_continuing;
      _appendLogLine(_status);
    });
  }

  void _appendLogLine(String line, {bool isError = false}) {
    if (line.trim().isEmpty) return;
    _logLines.add(_P4kLogLine(line, isError: isError));
    if (_logLines.length > _maxLogLines) {
      _logLines.removeRange(0, _logLines.length - _maxLogLines);
    }
  }

  Future<void> _runTask({
    required String status,
    required Future<void> Function() task,
    required String success,
    required BuildContext context,
    bool? deepRepair,
    bool Function()? shouldCloseOnSuccess,
  }) async {
    setState(() {
      _working = true;
      _cancelling = false;
      _lastRunFailed = false;
      _status = status;
      _overallProgressPercent = null;
      _resetDownloadSpeedSampler();
      _lastProgressEventPhase = null;
      _lastProgressLogMillis = 0;
      _lastProgressLogSignature = "";
      if (deepRepair == null) {
        _resetStagePlan();
      } else {
        _currentRunDeepRepair = deepRepair;
        if (_plannedStageKeys.isEmpty) {
          _prepareStagePlan(deepRepair: deepRepair);
        }
      }
      _logLines
        ..clear()
        ..add(_P4kLogLine(status));
    });
    try {
      await task();
      if (!mounted) return;
      if (shouldCloseOnSuccess?.call() == true) {
        Navigator.pop(this.context, P4kUpdateDialogResult.updated);
        return;
      }
      setState(() {
        if (_status != S.current.p4k_update_canceled) _status = success;
      });
    } catch (e) {
      if (!mounted) return;
      final providerError = widget.source == P4kDownloadSource.communityMirror
          ? mapP4kMirrorOperationalError(e)
          : null;
      setState(() {
        _lastRunFailed = true;
        _status = providerError == null
            ? S.current.p4k_update_failure(e)
            : p4kProviderErrorMessage(providerError);
      });
      if (providerError != null) {
        final decideFallback = widget.onMirrorProviderError;
        if (decideFallback == null) return;
        final result = await resolveP4kMirrorProviderFailure(
          error: providerError,
          decideFallback: decideFallback,
        );
        if (result != null && mounted) {
          Navigator.pop(this.context, result);
        }
        return;
      }
      if (context.mounted) {
        showToast(context, S.current.p4k_update_p4k_updater_failed(e));
      }
    } finally {
      if (mounted) {
        setState(() {
          _working = false;
          _cancelling = false;
        });
      }
    }
  }

  P4kUpgraderConfig? _buildConfig({bool deepVerify = false}) {
    if (!_isLiveInstallPath(widget.installPath)) {
      setState(() => _status = _p4kLiveOnlyMessage);
      showToast(context, _p4kLiveOnlyMessage);
      return null;
    }
    final mirror = widget.source == P4kDownloadSource.communityMirror;
    final manifest = _manifestController.text.trim();
    final bases = _splitLines(_baseController.text);
    if (!mirror && manifest.isEmpty) {
      setState(
        () => _status = S.current.p4k_update_manifest_url_cannot_be_empty,
      );
      return null;
    }
    final signatureProblem = _signatureProblemText(
      manifest: manifest,
      bases: bases,
    );
    if (signatureProblem != null) {
      setState(() => _status = signatureProblem);
      showToast(context, signatureProblem);
      return null;
    }
    return buildP4kSessionConfig(
      source: widget.source,
      manifestSource: manifest,
      objectBases: bases,
      p4kBaseUrl: _releaseUrls.p4kBaseUrl,
      p4kBaseVerificationUrl: _releaseUrls.p4kBaseVerificationUrl,
      objectPathTemplates: _splitLines(_templateController.text),
      requestCookie: widget.webCookie,
      rsiToken: widget.webToken,
      cacheDir: _joinInstallPath('.p4k_upgrader'),
      gameDir: widget.installPath,
      deepVerify: deepVerify,
    );
  }

  void _startDownloadSpeedTimer() {
    _stopDownloadSpeedTimer();
    _resetDownloadSpeedBaseline(active: true);
    _downloadSpeedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refreshDownloadSpeedText();
    });
  }

  void _stopDownloadSpeedTimer() {
    _downloadSpeedTimer?.cancel();
    _downloadSpeedTimer = null;
  }

  void _recordDownloadSpeedEvent(P4kUpgraderProgressEvent event) {
    if (event.phase == "network_speed") {
      _recordNetworkSpeedBytes(event.downloadedBytes);
      return;
    }
  }

  void _recordNetworkSpeedBytes(BigInt downloadedBytes) {
    if (downloadedBytes < _downloadSpeedCumulativeBytes) {
      _downloadSpeedCumulativeBytes = downloadedBytes;
      _resetDownloadSpeedBaseline(active: _downloadSpeedTimer != null);
      return;
    }
    _downloadSpeedCumulativeBytes = downloadedBytes;
  }

  void _refreshDownloadSpeedText() {
    if (!mounted) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (!_hasDownloadSpeedSample) {
      setState(() {
        _lastDownloadSpeedSampleBytes = _downloadSpeedCumulativeBytes;
        _lastDownloadSpeedSampleMillis = now;
        _hasDownloadSpeedSample = true;
        _downloadSpeedText = _downloadSpeedTimer == null ? "" : "0 B/s";
      });
      return;
    }
    final elapsedMillis = now - _lastDownloadSpeedSampleMillis;
    if (elapsedMillis <= 0) return;
    final currentBytes = _downloadSpeedCumulativeBytes;
    final delta = currentBytes >= _lastDownloadSpeedSampleBytes
        ? currentBytes - _lastDownloadSpeedSampleBytes
        : BigInt.zero;
    final bytesPerSecond = delta.toDouble() / (elapsedMillis / 1000);
    setState(() {
      _downloadSpeedText = _formatByteRate(bytesPerSecond);
      _lastDownloadSpeedSampleBytes = currentBytes;
      _lastDownloadSpeedSampleMillis = now;
    });
  }

  void _resetDownloadSpeedSampler() {
    _downloadSpeedText = "";
    _downloadSpeedCumulativeBytes = BigInt.zero;
    _resetDownloadSpeedBaseline();
  }

  void _resetDownloadSpeedBaseline({bool active = false}) {
    _lastDownloadSpeedSampleBytes = _downloadSpeedCumulativeBytes;
    _lastDownloadSpeedSampleMillis = DateTime.now().millisecondsSinceEpoch;
    _hasDownloadSpeedSample = active;
  }

  BigInt _estimatedTotalDownload() {
    final report = _estimateReport;
    if (report == null) return BigInt.zero;
    final baseAndPayload =
        (report.baseDownloadRequired ? report.baseDownloadBytes : BigInt.zero) +
        report.payloadDownloadBytes;
    if (!report.baseDownloadRequired) {
      return baseAndPayload.isNegative ? BigInt.zero : baseAndPayload;
    }
    final fullP4kRemaining =
        report.totalDownloadBytes - _localDataP4kPartBytes();
    final total = _maxBigInt(
      fullP4kRemaining.isNegative ? BigInt.zero : fullP4kRemaining,
      baseAndPayload,
    );
    return total.isNegative ? BigInt.zero : total;
  }

  double? _overallProgressValue(P4kUpgraderProgressEvent? event) {
    if (event == null) return null;
    if (event.phase == 'done') {
      return 100.0;
    }
    if (_isStableProgressDownloadPhase(event.phase) &&
        event.totalBytes > BigInt.zero) {
      return (event.downloadedBytes.toDouble() /
              event.totalBytes.toDouble() *
              100.0)
          .clamp(0.0, 100.0)
          .toDouble();
    }
    final stageKey = _stageKey(event.phase, deepRepair: _currentRunDeepRepair);
    if (stageKey == "p4k_patch" || stageKey == "repair_rebuilding") {
      return null;
    }
    if (event.total > BigInt.zero) {
      return (event.current.toDouble() / event.total.toDouble() * 100.0)
          .clamp(0.0, 100.0)
          .toDouble();
    }
    return null;
  }

  String? _signatureProblemText({String? manifest, List<String>? bases}) {
    final manifestUrl = manifest ?? _manifestController.text.trim();
    final baseUrls = bases ?? _splitLines(_baseController.text);
    if (_isOfficialCdnUrl(manifestUrl) && !_hasObjectSignature(manifestUrl)) {
      return S
          .current
          .p4k_update_the_manifest_url_is_missing_the_expires_keyname_signature_signat;
    }
    final unsignedBase = baseUrls
        .where(_isOfficialCdnUrl)
        .where((url) => !_hasObjectSignature(url))
        .firstOrNull;
    if (unsignedBase != null) {
      return S
          .current
          .p4k_update_the_object_base_url_is_missing_the_expires_keyname_signature_sig;
    }
    return null;
  }

  bool _shouldAppendProgressLog(
    P4kUpgraderProgressEvent event,
    int nowMillis, {
    required bool phaseChanged,
  }) {
    final signature = '${event.phase}|${event.message}';
    final important = _isImportantProgressEvent(event);
    final messageChanged =
        event.message.trim().isNotEmpty &&
        _lastProgressLogSignature.isNotEmpty &&
        _lastProgressLogSignature != signature;
    final elapsedMillis = nowMillis - _lastProgressLogMillis;
    final shouldAppend =
        important ||
        phaseChanged ||
        _isProgressCompletion(event) ||
        messageChanged ||
        elapsedMillis >= _progressLogInterval.inMilliseconds;
    if (shouldAppend) {
      _lastProgressLogMillis = nowMillis;
      _lastProgressLogSignature = signature;
    }
    return shouldAppend;
  }

  void _prepareStagePlan({required bool deepRepair}) {
    _currentRunDeepRepair = deepRepair;
    final report = _estimateReport;
    final keys = <String>[];

    void addStage(String key) {
      if (!keys.contains(key)) keys.add(key);
    }

    addStage("disk_checking");
    if (deepRepair) {
      addStage("p4k_diagnosing");
      addStage("repair_rebuilding");
      addStage("p4k_verifying");
      if (_updateLooseFiles) {
        addStage("loose_files");
      }
      addStage("post_install");
    } else {
      if (report?.baseDownloadRequired ?? false) {
        addStage("base_downloading");
      }
      addStage("p4k_patch");
      if (_updateLooseFiles) {
        addStage("loose_files");
      }
      addStage("post_install");
    }

    _plannedStageKeys = keys;
    _rebuildStageNumbers();
  }

  void _resetStagePlan() {
    _plannedStageKeys = [];
    _plannedStageNumbers = {};
    _currentRunDeepRepair = false;
  }

  void _rebuildStageNumbers() {
    _plannedStageNumbers = {
      for (var index = 0; index < _plannedStageKeys.length; index++)
        _plannedStageKeys[index]: index + 1,
    };
  }

  _P4kStageInfo? _stageInfo(P4kUpgraderProgressEvent event) {
    if (event.phase == "done" ||
        event.phase == "error" ||
        event.phase == "cancelled" ||
        event.phase == "download_error") {
      return null;
    }
    final key = _stageKey(event.phase, deepRepair: _currentRunDeepRepair);
    if (event.phase == "loose_written" &&
        !_plannedStageNumbers.containsKey(key)) {
      return null;
    }
    if (!_plannedStageNumbers.containsKey(key)) {
      if (_plannedStageKeys.isNotEmpty) return null;
      _plannedStageKeys = [key];
      _rebuildStageNumbers();
    }
    final current = _plannedStageNumbers[key] ?? 1;
    return _P4kStageInfo(key, current, _plannedStageKeys.length);
  }

  String _stageText(P4kUpgraderProgressEvent event) {
    final info = _stageInfo(event);
    if (info == null) return '';
    return S.current.p4k_update_stage(
      info.current,
      info.total,
      _stageLabelForKey(info.key),
    );
  }

  String _stageTextForKey(String key) {
    if (!_plannedStageNumbers.containsKey(key)) {
      _plannedStageKeys.add(key);
      _rebuildStageNumbers();
    }
    final current = _plannedStageNumbers[key] ?? _plannedStageKeys.length;
    final total = _plannedStageKeys.length;
    return S.current.p4k_update_stage(current, total, _stageLabelForKey(key));
  }

  Future<void> _runPostInstallTasks() async {
    _stopDownloadSpeedTimer();
    if (mounted) {
      setState(() => _resetDownloadSpeedSampler());
    } else {
      _resetDownloadSpeedSampler();
    }
    final stageText = _stageTextForKey("post_install");
    _setPostInstallStatus(
      stageText,
      S.current.p4k_update_registering_eac_and_syncing_launcher_state,
    );
    await _installEasyAntiCheat(stageText);
    await _syncLauncherInstallState(stageText);
    _setPostInstallStatus(
      stageText,
      S.current.p4k_update_installation_status_processing_completed,
    );
  }

  Future<void> _installEasyAntiCheat(String stageText) async {
    late final EacRegistrationOutcome outcome;
    try {
      outcome = await EacRegistrar().register(
        gameDirectory: widget.installPath,
        log: _appendEacLog,
      );
    } on EACError catch (error) {
      _appendEacLog(error.toString());
      _setPostInstallStatus(
        stageText,
        S.current
            .p4k_update_easyanticheat_registration_failed_and_has_continued_as_a_non_fat(
              error,
            ),
        warning: true,
      );
      return;
    }
    if (outcome == EacRegistrationOutcome.distributionNotFound) {
      _setPostInstallStatus(
        stageText,
        S
            .current
            .p4k_update_easyanticheat_installer_not_found_registration_skipped,
        warning: true,
      );
      return;
    }
    _setPostInstallStatus(
      stageText,
      S.current.p4k_update_easyanticheat_registration_completed,
    );
  }

  void _appendEacLog(String message) {
    if (!mounted) return;
    setState(() => _appendLogLine('${_simpleLogTime()} $message'));
  }

  Future<void> _syncLauncherInstallState(String stageText) async {
    _setPostInstallStatus(
      stageText,
      S.current.p4k_update_synchronizing_launcher_installation_status,
    );
    final buildManifestUpdated = await _updateBuildManifestId(stageText);
    if (widget.releaseInfo.isEmpty) {
      _setPostInstallStatus(
        stageText,
        'RSI Launcher store sync skipped: official release metadata is missing',
        warning: true,
      );
      return;
    }
    final storeCandidates = await _existingLauncherStoreCandidates();
    if (storeCandidates.isEmpty) {
      _setPostInstallStatus(
        stageText,
        S
            .current
            .p4k_update_rsi_launcher_store_not_found_encrypted_store_sync_skipped,
        warning: true,
      );
      return;
    }
    if ((await SystemHelper.getPID('RSI Launcher')).isNotEmpty) {
      const message =
          'RSI Launcher is running; exit it completely before synchronizing '
          'launcher store.json';
      _setPostInstallStatus(stageText, message, warning: true);
      return;
    }
    try {
      final result = await RsiLauncherStoreService().syncInstalledChannel(
        storeFile: storeCandidates.first,
        gameDirectory: widget.installPath,
        releaseInfo: widget.releaseInfo,
        libraryData: widget.libraryData,
      );
      final manifestSuffix = buildManifestUpdated
          ? '; build_manifest.id updated'
          : '';
      final backupSuffix = result.backupPath == null
          ? ''
          : '; backup: ${result.backupPath}';
      _setPostInstallStatus(
        stageText,
        result.changed
            ? 'RSI Launcher store synchronized$manifestSuffix$backupSuffix'
            : 'RSI Launcher store is already up to date$manifestSuffix',
      );
    } catch (error) {
      _setPostInstallStatus(
        stageText,
        'RSI Launcher store synchronization failed: $error',
        warning: true,
      );
    }
  }

  Future<bool> _updateBuildManifestId(String stageText) async {
    final changeNumber = _extractRequestedP4ChangeNumber(widget.releaseInfo);
    if (changeNumber == null || changeNumber.isEmpty) {
      _setPostInstallStatus(
        stageText,
        S
            .current
            .p4k_update_requestedp4changenum_cannot_be_inferred_from_releaseinfo_build_m,
        warning: true,
      );
      return false;
    }
    final file = File(_joinInstallPath('build_manifest.id'));
    try {
      Map<String, dynamic> root = {};
      if (await file.exists()) {
        final decoded = json.decode(await file.readAsString());
        if (decoded is Map) {
          root = Map<String, dynamic>.from(decoded);
        }
      }
      final data = root['Data'] is Map
          ? Map<String, dynamic>.from(root['Data'] as Map)
          : <String, dynamic>{};
      final buildNumber = int.tryParse(changeNumber) ?? changeNumber;
      data['Branch'] = _installEnvironment(widget.installPath);
      data['RequestedP4ChangeNum'] = buildNumber;
      data['BuildId'] = buildNumber;
      root['Data'] = data;
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(root),
      );
      _setPostInstallStatus(
        stageText,
        S.current.p4k_update_updated_build_manifest_id_requestedp4changenum(
          changeNumber,
        ),
      );
      return true;
    } catch (e) {
      _setPostInstallStatus(
        stageText,
        S.current
            .p4k_update_update_build_manifest_id_failed_continued_as_non_fatal_warning(
              e,
            ),
        warning: true,
      );
      return false;
    }
  }

  Future<List<File>> _existingLauncherStoreCandidates() async {
    final appData = Platform.environment['APPDATA'];
    if (appData == null || appData.isEmpty) return const [];
    final file = File(
      _joinPath(appData, _joinPath('rsilauncher', 'launcher store.json')),
    );
    return await file.exists() ? [file] : const [];
  }

  void _setPostInstallStatus(
    String stageText,
    String message, {
    bool warning = false,
  }) {
    if (!mounted) return;
    setState(() {
      _overallProgressPercent = null;
      _downloadSpeedText = "";
      _status = "$stageText：$message";
      _appendLogLine(
        "${_simpleLogTime()} ${warning ? '[WARN] ' : ''}$_status",
        isError: false,
      );
    });
  }

  BigInt _localDataP4kPartBytes() {
    try {
      final file = File(_joinInstallPath('Data.p4k.part'));
      if (!file.existsSync()) return BigInt.zero;
      return BigInt.from(file.statSync().size);
    } catch (_) {
      return BigInt.zero;
    }
  }

  String _joinInstallPath(String child) {
    final separator = Platform.isWindows ? '\\' : '/';
    return widget.installPath.endsWith('\\') || widget.installPath.endsWith('/')
        ? "${widget.installPath}$child"
        : "${widget.installPath}$separator$child";
  }
}

String formatP4kPayloadEstimate(BigInt bytes, {required bool exact}) {
  final formatted = _formatBytes(bytes);
  return exact
      ? formatted
      : S.current.p4k_update_payload_conservative_estimate(formatted);
}

class _ReleaseUrls {
  const _ReleaseUrls(
    this.manifestUrl,
    this.objectBases, {
    this.p4kBaseUrl = "",
    this.p4kBaseVerificationUrl = "",
    this.hashOnlyTemplates = false,
  });

  final String manifestUrl;
  final List<String> objectBases;
  final String p4kBaseUrl;
  final String p4kBaseVerificationUrl;
  final bool hashOnlyTemplates;
}

class _UrlHit {
  const _UrlHit(this.keyPath, this.url);

  final String keyPath;
  final String url;
}

class _ScalarHit {
  const _ScalarHit(this.keyPath, this.value);

  final String keyPath;
  final String value;
}

_ReleaseUrls _extractReleaseUrls(Map releaseInfo) {
  final fixed = _extractReleaseUrlsFromKnownFields(releaseInfo);
  if (fixed.manifestUrl.isNotEmpty || fixed.objectBases.isNotEmpty) {
    return fixed;
  }

  final hits = <_UrlHit>[];
  final scalars = <_ScalarHit>[];
  void visit(dynamic value, String keyPath) {
    if (value is Map) {
      for (final entry in value.entries) {
        visit(
          entry.value,
          keyPath.isEmpty ? entry.key.toString() : "$keyPath.${entry.key}",
        );
      }
    } else if (value is Iterable) {
      var index = 0;
      for (final item in value) {
        visit(item, "$keyPath[$index]");
        index++;
      }
    } else if (value is String) {
      final text = value.trim();
      if (text.isNotEmpty) {
        scalars.add(_ScalarHit(keyPath, text));
      }
      if (text.startsWith("https://") || text.startsWith("http://")) {
        hits.add(_UrlHit(keyPath, text));
      }
    } else if (value is num || value is bool) {
      scalars.add(_ScalarHit(keyPath, value.toString()));
    }
  }

  visit(releaseInfo, "");
  final manifestHit =
      hits.where((hit) {
        final key = hit.keyPath.toLowerCase();
        final url = hit.url.toLowerCase();
        return key.contains("manifest") || url.contains("manifest");
      }).firstOrNull ??
      const _UrlHit("", "");
  final manifest = _appendObjectSignature(
    manifestHit.url,
    _extractSignatureQueryForHit(manifestHit, scalars),
  );

  final bases = <String>[];
  final seen = <String>{};
  var p4kBase = "";
  var p4kBaseVerification = "";
  for (final hit in hits) {
    if (hit.url == manifest) continue;
    final key = hit.keyPath.toLowerCase();
    final url = hit.url.toLowerCase();
    final looksLikeP4kBaseVerification =
        key.contains("p4kbaseverification") ||
        key.contains("p4k_base_verification") ||
        url.endsWith(".p4k.vf") ||
        url.contains(".p4k.vf?");
    final looksLikeP4kBase =
        key.contains("p4kbase") ||
        key.contains("p4k_base") ||
        url.endsWith(".p4k") ||
        url.contains(".p4k?") ||
        looksLikeP4kBaseVerification;
    if (looksLikeP4kBaseVerification) {
      p4kBaseVerification = _appendObjectSignature(
        hit.url,
        _extractSignatureQueryForHit(hit, scalars),
      );
      continue;
    }
    if (looksLikeP4kBase) {
      p4kBase = _appendObjectSignature(
        hit.url,
        _extractSignatureQueryForHit(hit, scalars),
      );
      continue;
    }
    final looksLikeBase =
        key.contains("base") ||
        key.contains("object") ||
        key.contains("file") ||
        key.contains("archive") ||
        key.contains("p4k") ||
        key.contains("download") ||
        url.contains("/bin64") ||
        url.contains("/objects") ||
        url.contains("p4k");
    final looksLikeWrongFile =
        url.contains("manifest") ||
        url.endsWith(".json") ||
        url.endsWith(".exe") ||
        url.endsWith(".zip");
    if (looksLikeBase && !looksLikeWrongFile && !looksLikeP4kBase) {
      final signedUrl = _appendObjectSignature(
        hit.url,
        _extractSignatureQueryForHit(hit, scalars),
      );
      if (seen.add(signedUrl)) {
        bases.add(signedUrl);
      }
    }
  }
  return _ReleaseUrls(
    manifest,
    bases,
    p4kBaseUrl: p4kBase,
    p4kBaseVerificationUrl: p4kBaseVerification,
    hashOnlyTemplates: bases.any(_isOfficialCdnUrl),
  );
}

_ReleaseUrls _extractReleaseUrlsFromKnownFields(Map releaseInfo) {
  final manifest = _signedReleaseUrl(releaseInfo["manifest"]);
  final bases = <String>[];
  final objects = _signedReleaseUrl(releaseInfo["objects"]);
  if (objects.isNotEmpty) bases.add(objects);
  final p4kBase = _signedReleaseUrl(releaseInfo["p4kBase"]);
  final p4kBaseVerification = _signedReleaseUrl(
    releaseInfo["p4kBaseVerificationFile"],
  );
  return _ReleaseUrls(
    manifest,
    bases,
    p4kBaseUrl: p4kBase,
    p4kBaseVerificationUrl: p4kBaseVerification,
    hashOnlyTemplates: true,
  );
}

String _signedReleaseUrl(dynamic value) {
  if (value is! Map) return "";
  final rawUrl = value["url"]?.toString() ?? "";
  if (rawUrl.isEmpty) return "";
  final signatures = value["signatures"]?.toString() ?? "";
  if (signatures.isEmpty) return rawUrl;
  final separator = rawUrl.contains("?") ? "&" : "?";
  return "$rawUrl$separator$signatures";
}

void _printExtractedReleaseUrls(_ReleaseUrls urls) {
  // Keep URL shape in stdout for debugging without exposing signed CDN query params.
  // ignore: avoid_print
  print("[P4K Upgrader] manifest_url=${_redactSignedUrl(urls.manifestUrl)}");
  for (final base in urls.objectBases) {
    // ignore: avoid_print
    print("[P4K Upgrader] object_base=${_redactSignedUrl(base)}");
  }
  if (urls.p4kBaseUrl.isNotEmpty) {
    // ignore: avoid_print
    print("[P4K Upgrader] p4k_base=${_redactSignedUrl(urls.p4kBaseUrl)}");
  }
  if (urls.p4kBaseVerificationUrl.isNotEmpty) {
    // ignore: avoid_print
    print(
      "[P4K Upgrader] p4k_base_verification=${_redactSignedUrl(urls.p4kBaseVerificationUrl)}",
    );
  }
}

String _redactSignedUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasQuery) return url;
  return uri.replace(query: "<redacted>").toString();
}

String _extractSignatureQueryForHit(_UrlHit hit, List<_ScalarHit> scalars) {
  final ownQuery = _extractSignatureQueryFromValue(hit.url);
  if (ownQuery != null) return ownQuery;

  final relatedScalars = _relatedScalars(hit.keyPath, scalars);
  final nearbyQuery = _extractObjectSignatureQuery(relatedScalars, const []);
  if (nearbyQuery.isNotEmpty) return nearbyQuery;

  return "";
}

List<_ScalarHit> _relatedScalars(String keyPath, List<_ScalarHit> scalars) {
  if (keyPath.isEmpty) return const [];
  final parent = _parentKeyPath(keyPath).toLowerCase();
  if (parent.isEmpty) return const [];
  return scalars.where((hit) {
    final key = hit.keyPath.toLowerCase();
    return key == parent ||
        key.startsWith("$parent.") ||
        key.startsWith("$parent[");
  }).toList();
}

String _parentKeyPath(String keyPath) {
  final dot = keyPath.lastIndexOf('.');
  final bracket = keyPath.lastIndexOf('[');
  final idx = dot > bracket ? dot : bracket;
  if (idx <= 0) return "";
  return keyPath.substring(0, idx);
}

String _extractObjectSignatureQuery(
  List<_ScalarHit> scalars,
  List<_UrlHit> urls,
) {
  for (final hit in urls) {
    final query = _extractSignatureQueryFromValue(hit.url);
    if (query != null) return query;
  }
  for (final hit in scalars) {
    final query = _extractSignatureQueryFromValue(hit.value);
    if (query != null) return query;
  }
  final params = <String, String>{};
  for (final hit in scalars) {
    final key = hit.keyPath.split('.').last.toLowerCase();
    final value = hit.value.trim();
    if (value.isEmpty ||
        value.startsWith('http://') ||
        value.startsWith('https://')) {
      continue;
    }
    if (key == 'expires' || key.endsWith('expires')) {
      params.putIfAbsent('Expires', () => value);
    } else if (key == 'keyname' ||
        key == 'key_name' ||
        key == 'key-pair-id' ||
        key == 'keypairid') {
      params.putIfAbsent(
        key.contains('pair') ? 'Key-Pair-Id' : 'KeyName',
        () => value,
      );
    } else if (key == 'signature' || key.endsWith('signature')) {
      params.putIfAbsent('Signature', () => value);
    } else if (key == 'policy' || key.endsWith('policy')) {
      params.putIfAbsent('Policy', () => value);
    }
  }
  return params.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
}

String? _extractSignatureQueryFromValue(String value) {
  final text = value.trim();
  if (!_hasObjectSignature(text)) return null;
  final queryStart = text.indexOf('?');
  if (queryStart >= 0 && queryStart < text.length - 1) {
    return text.substring(queryStart + 1);
  }
  final expiresStart = text.indexOf('Expires=');
  if (expiresStart >= 0) {
    return _trimLeadingQueryPrefix(text.substring(expiresStart));
  }
  final policyStart = text.indexOf('Policy=');
  if (policyStart >= 0) {
    return _trimLeadingQueryPrefix(text.substring(policyStart));
  }
  return null;
}

String _trimLeadingQueryPrefix(String value) {
  var result = value.trim();
  while (result.startsWith('?') || result.startsWith('&')) {
    result = result.substring(1).trimLeft();
  }
  return result;
}

String _appendObjectSignature(String url, String query) {
  if (query.isEmpty || _hasObjectSignature(url)) return url;
  return '$url${url.contains('?') ? '&' : '?'}$query';
}

bool _hasObjectSignature(String url) {
  final lower = url.toLowerCase();
  return lower.contains('signature=') &&
      (lower.contains('expires=') ||
          lower.contains('keyname=') ||
          lower.contains('policy=') ||
          lower.contains('key-pair-id='));
}

bool _isOfficialCdnUrl(String url) {
  final host = Uri.tryParse(url)?.host.toLowerCase();
  return host == 'prod.mcdn.robertsspaceindustries.com';
}

List<String> _splitLines(String value) {
  return value
      .split(RegExp(r'\r?\n'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

String _formatReleaseInfo(Map releaseInfo) {
  final version =
      releaseInfo["versionLabel"] ??
      releaseInfo["version"] ??
      S.current.p4k_update_unknown_version;
  final executable =
      releaseInfo["executable"] ?? S.current.p4k_update_unknown_startup_file;
  return S.current
      .p4k_update_release_version_startup_file_releaseinfo_has_been_read_you_can_f(
        version,
        executable,
      );
}

String _formatBytes(BigInt value) {
  final bytes = value.toDouble();
  const units = ["B", "KiB", "MiB", "GiB", "TiB"];
  var size = bytes;
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  return "${size.toStringAsFixed(unit == 0 ? 0 : 2)} ${units[unit]}";
}

String _formatByteRate(double bytesPerSecond) {
  const units = ["B/s", "KiB/s", "MiB/s", "GiB/s", "TiB/s"];
  var size = bytesPerSecond;
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  return "${size.toStringAsFixed(unit == 0 ? 0 : 2)} ${units[unit]}";
}

bool _isStableProgressDownloadPhase(String phase) {
  return phase == "base_downloading" ||
      phase == "base_verification_downloading" ||
      phase == "loose_downloading";
}

bool _isVerifyPhase(String phase) {
  return phase == "base_verifying" ||
      phase == "p4k_verifying" ||
      phase == "manifest_verifying" ||
      phase == "loose_verifying" ||
      phase == "p4k_diagnosing";
}

bool _isP4kWorkPhase(String phase) {
  return phase == "p4k_planning" ||
      phase == "p4k_recovering_index" ||
      phase == "p4k_journaling" ||
      phase == "p4k_metadata" ||
      phase == "p4k_writing" ||
      phase == "p4k_finalizing" ||
      phase == "disk_checking" ||
      phase == "repair_rebuilding";
}

bool _isImportantProgressEvent(P4kUpgraderProgressEvent event) {
  return event.phase == "done" ||
      event.phase == "cancelled" ||
      event.phase == "error" ||
      event.phase == "download_error";
}

bool _isProgressCompletion(P4kUpgraderProgressEvent event) {
  if (event.phase == "network_speed") return false;
  if (event.totalBytes > BigInt.zero && event.total <= BigInt.one) {
    return event.downloadedBytes >= event.totalBytes;
  }
  return event.total > BigInt.zero && event.current >= event.total;
}

String _phaseText(String phase) {
  return switch (phase) {
    "downloading" => S.current.p4k_update_download,
    "downloaded" => S.current.downloader_info_download_completed,
    "base_downloading" => S.current.p4k_update_download_basics_p4k,
    "base_verifying" => S.current.p4k_update_check_basics_p4k,
    "base_verification_downloading" =>
      S.current.p4k_update_download_basic_verification_file,
    "disk_checking" => S.current.p4k_update_check_disk_space,
    "p4k_diagnosing" => S.current.p4k_update_diagnose_current_p4k,
    "repair_rebuilding" => S.current.p4k_update_deep_repair_p4k,
    "p4k_verifying" => S.current.p4k_update_check_p4k,
    "manifest_verifying" => S.current.p4k_update_verify_p4k_content,
    "loose_downloading" => S.current.p4k_update_download_game_files,
    "loose_verifying" => S.current.p4k_update_verify_game_files,
    "loose_staging" => S.current.p4k_update_prepare_game_files,
    "loose_writing" => S.current.p4k_update_write_game_files,
    "loose_written" => S.current.p4k_update_game_file_writing_completed,
    "post_install" => S.current.p4k_update_completed_installation_status,
    "writing" => S.current.p4k_update_write,
    "p4k_planning" => S.current.p4k_update_preparing_for_p4k_patching,
    "p4k_recovering_index" => S.current.p4k_update_restore_p4k_index,
    "p4k_journaling" => S.current.p4k_update_create_a_p4k_rollback_record,
    "p4k_metadata" => S.current.p4k_update_update_p4k_entry_metadata,
    "p4k_writing" => S.current.p4k_update_write_to_p4k,
    "p4k_finalizing" => S.current.p4k_update_complete_p4k_write,
    "download_error" => S.current.downloader_info_download_failed,
    "done" => S.current.p4k_update_finish,
    "cancelled" => S.current.p4k_update_canceled,
    "error" => S.current.party_room_error,
    _ => phase,
  };
}

String _formatProgressLog(
  P4kUpgraderProgressEvent event, {
  String stageText = "",
}) {
  final now = DateTime.now();
  final time =
      '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}';
  final bytes = event.totalBytes == BigInt.zero
      ? ''
      : ' ${_formatBytes(event.downloadedBytes)}/${_formatBytes(event.totalBytes)}';
  final active = event.activeDownloads == BigInt.zero
      ? ''
      : ' active=${event.activeDownloads}';
  final message = event.message.isEmpty
      ? ''
      : ' ${_formatProgressMessage(event)}';
  final stage = stageText.isEmpty ? '' : ' $stageText';
  final queue = event.total == BigInt.zero
      ? ''
      : ' [${event.current}/${event.total}]';
  final name = event.name.isEmpty ? '' : ' ${event.name}';
  return '[$time] ${_phaseText(event.phase)}$stage$queue$active$bytes$name$message';
}

String _formatProgressMessage(P4kUpgraderProgressEvent event) {
  if (event.phase == "loose_written") {
    return S.current.p4k_update_game_file_writing_completed;
  }
  if (event.phase == "loose_staging") {
    return S.current.p4k_update_preparing_game_files_2;
  }
  if (event.phase == "loose_verifying") {
    return S.current.p4k_update_verifying_game_files;
  }
  if (event.phase == "p4k_metadata") {
    return S.current.p4k_update_updating_p4k_entry_metadata_2;
  }
  if (event.phase == "p4k_recovering_index") return event.message;
  return event.message;
}

String _stageKey(String phase, {bool deepRepair = false}) {
  return switch (phase) {
    "base_verification_downloading" => "base_downloading",
    "base_verifying" => "base_downloading",
    "downloading" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "downloaded" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "writing" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "p4k_planning" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "p4k_recovering_index" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "p4k_journaling" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "p4k_downloading" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "p4k_metadata" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "p4k_writing" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "p4k_finalizing" => deepRepair ? "repair_rebuilding" : "p4k_patch",
    "p4k_verifying" => deepRepair ? "p4k_verifying" : "p4k_patch",
    "manifest_verifying" => deepRepair ? "p4k_verifying" : "p4k_patch",
    "loose_downloading" => "loose_files",
    "loose_staging" => "loose_files",
    "loose_writing" => "loose_files",
    "loose_verifying" => "loose_files",
    "loose_written" => "loose_files",
    "post_install" => "post_install",
    _ => phase,
  };
}

String _stageLabelForKey(String key) {
  return switch (key) {
    "disk_checking" => S.current.p4k_update_check_disk_space_and_task_budget,
    "base_downloading" => S.current.p4k_update_download_verify_basics_p4k,
    "p4k_patch" => S.current.p4k_update_patching_data_p4k,
    "p4k_diagnosing" => S.current.p4k_update_diagnose_current_p4k,
    "repair_rebuilding" => S.current.p4k_update_deep_repair_rebuild_p4k,
    "p4k_verifying" => S.current.p4k_update_verify_repair_results,
    "loose_files" => S.current.p4k_update_download_write_game_files,
    "post_install" => S.current.p4k_update_register_eac_and_sync_launcher_state,
    _ => _phaseText(key),
  };
}

bool _isLiveInstallPath(String path) {
  return _installEnvironment(path) == 'LIVE';
}

String _installEnvironment(String path) {
  final normalized = path.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '');
  if (normalized.isEmpty) return '';
  return normalized.split('/').last.toUpperCase();
}

String get _p4kLiveOnlyMessage => S
    .current
    .p4k_update_p4k_download_update_does_not_currently_support_ptu_the_target_pa;

String _joinPath(String parent, String child) {
  final separator = Platform.isWindows ? '\\' : '/';
  return parent.endsWith('\\') || parent.endsWith('/')
      ? "$parent$child"
      : "$parent$separator$child";
}

BigInt _maxBigInt(BigInt a, BigInt b) {
  return a > b ? a : b;
}

String? _extractRequestedP4ChangeNumber(Map releaseInfo) {
  final direct =
      releaseInfo['RequestedP4ChangeNum'] ??
      releaseInfo['requestedP4ChangeNum'] ??
      releaseInfo['p4ChangeNum'] ??
      releaseInfo['buildId'];
  final directNumber = _lastNumberString(direct?.toString() ?? '');
  if (directNumber != null) return directNumber;
  final version = (releaseInfo['versionLabel'] ?? releaseInfo['version'])
      ?.toString();
  return _lastNumberString(version ?? '');
}

String? _lastNumberString(String value) {
  final matches = RegExp(r'(\d{5,})').allMatches(value).toList();
  if (matches.isEmpty) return null;
  return matches.last.group(1);
}

String _simpleLogTime() {
  final now = DateTime.now();
  return '[${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}]';
}

String _statusWithStageText(
  P4kUpgraderProgressEvent event,
  String stageText,
  String fallback,
) {
  final stage = stageText.trim();
  final rawMessage = event.message.isEmpty ? fallback : event.message;
  final message = rawMessage.trim().replaceFirst(RegExp(r'^[：:，,\s]+'), '');
  if (stage.isEmpty) return message;
  return message.isEmpty ? stage : "$stage：$message";
}
