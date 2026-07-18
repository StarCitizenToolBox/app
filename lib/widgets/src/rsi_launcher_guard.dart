import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/helper/system_helper.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

/// Shows the standard warning and returns true when a game-file operation
/// must be blocked because RSI Launcher is still running.
Future<bool> blockIfRsiLauncherRunning(BuildContext context) async {
  if (!await SystemHelper.isRsiLauncherRunning()) return false;
  if (context.mounted) {
    showToast(
      context,
      S.current.tools_action_info_rsi_launcher_running_warning,
    );
  }
  return true;
}
