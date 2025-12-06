import 'dart:async';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:starcitizen_doctor/api/analytics.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/conf/conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/provider/download_manager.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class SplashUI extends HookConsumerWidget {
  const SplashUI({super.key});

  static const _alertInfoVersion = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepState = useState(0);
    final step = stepState.value;
    final clickCount = useState(0);
    final diagnosticMode = useState(false);
    final diagnosticLogs = useState<List<String>>([]);
    final lastClickTime = useState<DateTime?>(null);

    useEffect(() {
      final appModel = ref.read(appGlobalModelProvider.notifier);
      _initApp(context, appModel, stepState, ref, diagnosticLogs);
      return null;
    }, []);

    return makeDefaultPage(
      context,
      content: Center(
        child: diagnosticMode.value
            ? _buildDiagnosticView(diagnosticLogs, step, context)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      final now = DateTime.now();
                      final lastClick = lastClickTime.value;

                      // 重置计数器如果距离上次点击超过2秒
                      if (lastClick != null && now.difference(lastClick).inSeconds > 2) {
                        clickCount.value = 0;
                      }

                      lastClickTime.value = now;
                      clickCount.value++;

                      if (clickCount.value >= 10) {
                        diagnosticMode.value = true;
                        clickCount.value = 0;
                      }
                    },
                    child: Image.asset("assets/app_logo.png", width: 192, height: 192),
                  ),
                  const SizedBox(height: 32),
                  const ProgressRing(),
                  const SizedBox(height: 32),
                  if (step == 0) Text(S.current.app_splash_checking_availability),
                  if (step == 1) Text(S.current.app_splash_checking_for_updates),
                  if (step == 2) Text(S.current.app_splash_almost_done),
                ],
              ),
      ),
      automaticallyImplyLeading: false,
      titleRow: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          children: [
            Image.asset("assets/app_logo_mini.png", width: 20, height: 20, fit: BoxFit.cover),
            const SizedBox(width: 12),
            Text(S.current.app_index_version_info(ConstConf.appVersion, ConstConf.isMSE ? "" : " Dev")),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticView(ValueNotifier<List<String>> diagnosticLogs, int currentStep, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('诊断模式 - Step $currentStep', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Button(onPressed: () => _loadDPrintLog(diagnosticLogs), child: Text(S.current.splash_read_full_log)),
                  const SizedBox(width: 8),
                  Button(onPressed: () => _resetHiveDatabase(context), child: Text(S.current.splash_reset_database)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(S.current.splash_init_task_status, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: diagnosticLogs,
              builder: (context, logs, child) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: logs.isEmpty
                      ? Center(child: Text(S.current.splash_waiting_log))
                      : ListView.builder(
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            Color textColor = Colors.white;
                            if (log.contains('✓')) {
                              textColor = Colors.green;
                            } else if (log.contains('✗') ||
                                log.contains(S.current.splash_timeout) ||
                                log.contains(S.current.splash_error)) {
                              textColor = Colors.red;
                            } else if (log.contains('⚠')) {
                              textColor = Colors.orange;
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                log,
                                style: TextStyle(fontFamily: 'Consolas', fontSize: 12, color: textColor),
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _initApp(
    BuildContext context,
    AppGlobalModel appModel,
    ValueNotifier<int> stepState,
    WidgetRef ref,
    ValueNotifier<List<String>> diagnosticLogs,
  ) async {
    void addLog(String message) {
      final logMessage = '[${DateTime.now().toString().substring(11, 23)}] $message';
      diagnosticLogs.value = [...diagnosticLogs.value, logMessage];
      dPrint("[诊断] $message");
    }

    addLog('[${DateTime.now().toIso8601String()}] 开始初始化...');

    // Step 0: initApp with timeout
    addLog(S.current.splash_exec_app_init);
    try {
      await appModel.initApp().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          addLog(S.current.splash_app_init_timeout);
          throw TimeoutException('initApp timeout');
        },
      );
      addLog(S.current.splash_app_init_done);
    } catch (e) {
      addLog('✗ appModel.initApp() 错误: $e');
      rethrow;
    }

    // Open app_conf box with timeout
    addLog(S.current.splash_open_hive_box);
    late Box appConf;
    try {
      appConf = await Hive.openBox("app_conf").timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          addLog(S.current.splash_hive_timeout);
          throw TimeoutException('openBox timeout');
        },
      );
      addLog(S.current.splash_hive_done);
    } catch (e) {
      addLog('✗ Hive.openBox("app_conf") 错误: $e');
      rethrow;
    }

    // Check alert info version
    addLog(S.current.splash_check_version);
    final v = appConf.get("splash_alert_info_version", defaultValue: 0);
    addLog('✓ splash_alert_info_version = $v');

    // Analytics touch
    addLog(S.current.splash_exec_analytics);
    try {
      final touchFuture = AnalyticsApi.touch("launch");
      await touchFuture.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          addLog(S.current.splash_analytics_timeout);
        },
      );
      addLog(S.current.splash_analytics_done);
    } catch (e) {
      addLog('⚠ AnalyticsApi.touch("launch") 错误: $e - 继续执行');
    }

    // Show alert if needed
    if (v < _alertInfoVersion) {
      addLog(S.current.splash_show_agreement);
      if (!context.mounted) {
        addLog(S.current.splash_context_unmounted_dialog);
        return;
      }
      await _showAlert(context, appConf);
      addLog(S.current.splash_agreement_handled);
    }

    // Check host
    addLog(S.current.splash_exec_check_host);
    try {
      final checkHostFuture = URLConf.checkHost();
      await checkHostFuture.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          addLog(S.current.splash_check_host_timeout);
          return false;
        },
      );
      addLog(S.current.splash_check_host_done);
    } catch (e) {
      addLog('⚠ URLConf.checkHost() 错误: $e - 继续执行');
      dPrint("checkHost Error:$e");
    }

    addLog(S.current.splash_step0_done);
    stepState.value = 1;
    if (!context.mounted) {
      addLog(S.current.splash_context_unmounted);
      return;
    }

    // Step 1: Check update
    addLog(S.current.splash_exec_check_update);
    dPrint("_initApp checkUpdate");
    try {
      await appModel
          .checkUpdate(context)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              addLog(S.current.splash_check_update_timeout);
              return false;
            },
          );
      addLog(S.current.splash_check_update_done);
    } catch (e) {
      addLog('⚠ appModel.checkUpdate() 错误: $e - 继续执行');
    }

    addLog(S.current.splash_step1_done);
    stepState.value = 2;

    // Step 2: Initialize download manager
    addLog(S.current.splash_init_aria2c);
    dPrint("_initApp downloadManagerProvider");
    try {
      ref.read(downloadManagerProvider);
      addLog(S.current.splash_aria2c_done);
    } catch (e) {
      addLog('⚠ downloadManagerProvider 初始化错误: $e');
    }

    if (!context.mounted) {
      addLog(S.current.splash_context_unmounted_nav);
      return;
    }

    addLog(S.current.splash_all_done);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) {
      addLog(S.current.splash_context_unmounted_jump);
      return;
    }
    context.pushReplacement("/index");
  }

  Future<void> _showAlert(BuildContext context, Box<dynamic> appConf) async {
    final userOk = await showConfirmDialogs(
      context,
      S.current.app_splash_dialog_u_a_p_p,
      MarkdownWidget(data: S.current.app_splash_dialog_u_a_p_p_content),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .5),
    );
    if (userOk) {
      await appConf.put("splash_alert_info_version", _alertInfoVersion);
    } else {
      exit(0);
    }
  }

  void _loadDPrintLog(ValueNotifier<List<String>> diagnosticLogs) async {
    try {
      final logFile = getDPrintFile();
      if (logFile == null || !await logFile.exists()) {
        diagnosticLogs.value = [...diagnosticLogs.value, '[${DateTime.now().toString().substring(11, 23)}] ⚠ 日志文件不存在'];
        return;
      }

      diagnosticLogs.value = [
        ...diagnosticLogs.value,
        '[${DateTime.now().toString().substring(11, 23)}] --- 开始读取完整日志文件 ---',
      ];

      final logContent = await logFile.readAsString();
      final logLines = logContent.split('\n');

      // 读取最后100行日志
      final startIndex = logLines.length > 1000 ? logLines.length - 1000 : 0;
      final newLogs = <String>[...diagnosticLogs.value];
      for (int i = startIndex; i < logLines.length; i++) {
        if (logLines[i].trim().isNotEmpty) {
          newLogs.add(logLines[i]);
        }
      }
      newLogs.add('[${DateTime.now().toString().substring(11, 23)}] --- 日志读取完成 (显示最后1000行) ---');
      diagnosticLogs.value = newLogs;
    } catch (e) {
      diagnosticLogs.value = [...diagnosticLogs.value, '[${DateTime.now().toString().substring(11, 23)}] ✗ 读取日志失败: $e'];
    }
  }

  void _resetHiveDatabase(BuildContext context) async {
    try {
      dPrint(S.current.splash_user_reset_db);

      // 关闭所有 Hive box
      try {
        await Hive.close();
        dPrint(S.current.splash_hive_boxes_closed);
      } catch (e) {
        dPrint('[诊断] 关闭 Hive boxes 失败: $e');
      }

      // 获取数据库目录
      final appSupportDir = (await getApplicationSupportDirectory()).absolute.path;
      final dbDir = Directory('$appSupportDir/db');

      if (await dbDir.exists()) {
        dPrint('[诊断] 正在删除数据库目录: ${dbDir.path}');
        await dbDir.delete(recursive: true);
        dPrint(S.current.splash_db_deleted);
      } else {
        dPrint('[诊断] 数据库目录不存在: ${dbDir.path}');
      }

      // 显示提示并退出
      dPrint(S.current.splash_db_reset_done);

      if (context.mounted) {
        await showToast(context, S.current.splash_db_reset_msg);
      }

      // 等待一小段时间确保日志写入
      await Future.delayed(const Duration(milliseconds: 500));

      exit(0);
    } catch (e) {
      dPrint(S.current.splash_reset_db_failed(e.toString()));
    }
  }
}
