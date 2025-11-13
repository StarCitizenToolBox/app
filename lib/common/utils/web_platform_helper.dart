import 'package:flutter/foundation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';

/// Helper class for web platform detection and user guidance
class WebPlatformHelper {
  /// Check if running on web platform
  static bool get isWeb => kIsWeb;

  /// Show a dialog for features that are not available on web
  /// Guides users to download the full desktop version
  static Future<void> showWebUnsupportedDialog(
    BuildContext context, {
    required String featureName,
    String? additionalInfo,
  }) async {
    if (!isWeb) return;

    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(S.current.web_feature_unavailable_title ?? '功能不可用'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.current.web_feature_unavailable_message(featureName) ??
                '抱歉，"$featureName" 功能在网页版中不可用。'),
            const SizedBox(height: 12),
            if (additionalInfo != null) ...[
              Text(additionalInfo),
              const SizedBox(height: 12),
            ],
            Text(S.current.web_download_full_version_prompt ??
                '请下载完整版以使用所有功能。'),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.current.button_cancel ?? '取消'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _openDownloadPage();
            },
            child: Text(S.current.button_download ?? '下载完整版'),
          ),
        ],
      ),
    );
  }

  /// Open the download page for the full version
  static Future<void> _openDownloadPage() async {
    const downloadUrl = 'https://github.com/StarCitizenToolBox/app/releases';
    try {
      final uri = Uri.parse(downloadUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      dPrint('Error opening download page: $e');
    }
  }

  /// Check if a feature is supported on web and show dialog if not
  /// Returns true if the feature is supported (or if not on web)
  static Future<bool> checkFeatureSupport(
    BuildContext context,
    String featureName, {
    String? additionalInfo,
  }) async {
    if (!isWeb) return true;

    await showWebUnsupportedDialog(
      context,
      featureName: featureName,
      additionalInfo: additionalInfo,
    );
    return false;
  }
}
