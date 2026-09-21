import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/app.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

/// Asks for confirmation, repairs the database (see
/// [AppGlobalModel.repairDatabase]) and reports the result.
Future<void> repairDatabaseInteractive(BuildContext context) async {
  final ok = await showConfirmDialogs(
    context,
    S.current.settings_item_repair_database,
    Text(S.current.app_db_repair_confirm),
  );
  if (!ok || !context.mounted) return;
  try {
    await ProviderScope.containerOf(
      context,
      listen: false,
    ).read(appGlobalModelProvider.notifier).repairDatabase();
    if (!context.mounted) return;
    await showToast(context, S.current.app_db_repair_done);
  } catch (e) {
    if (!context.mounted) return;
    await showToast(context, S.current.app_db_repair_failed(e));
  }
}

/// Logs a failed operation and tells the user, offering to repair the
/// database: a failing database used to make actions silently do nothing.
///
/// [message] is shown instead of the raw [error] when given.
Future<void> showErrorWithDatabaseRepair(
  BuildContext context,
  Object error,
  StackTrace stack, {
  String? message,
}) async {
  dPrint("[OperationFailed] $error\n$stack");
  if (!context.mounted) return;
  final repair = await showConfirmDialogs(
    context,
    S.current.app_common_operation_failed,
    Text(S.current.app_db_repair_hint(message ?? error)),
    confirm: S.current.settings_item_repair_database,
    cancel: S.current.app_common_tip_i_know,
  );
  if (repair && context.mounted) {
    await repairDatabaseInteractive(context);
  }
}
