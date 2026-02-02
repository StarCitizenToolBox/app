import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

/// 着色器缓存清理对话框
class ShaderCacheCleanDialog extends StatefulWidget {
  final Future<void> Function(String mode) onClean;

  const ShaderCacheCleanDialog({super.key, required this.onClean});

  @override
  State<ShaderCacheCleanDialog> createState() => _ShaderCacheCleanDialogState();
}

class _ShaderCacheCleanDialogState extends State<ShaderCacheCleanDialog> {
  bool _isCleaning = false;
  String? _selectedMode;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          const Icon(FontAwesomeIcons.shapes, size: 20),
          const SizedBox(width: 12),
          Text(S.current.tools_shader_clean_dialog_title),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 500),
      content: _isCleaning
          ? SizedBox(
              height: 120,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ProgressRing(),
                    const SizedBox(height: 16),
                    Text(S.current.tools_action_info_cleaning),
                  ],
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                // 保留最新模式
                _CleanModeOption(
                  icon: FluentIcons.save,
                  title: S.current.tools_shader_clean_keep_latest,
                  description: S.current.tools_shader_clean_keep_latest_desc,
                  isSelected: _selectedMode == "keep_latest",
                  isRecommended: true,
                  onTap: () {
                    setState(() {
                      _selectedMode = "keep_latest";
                    });
                  },
                ),
                const SizedBox(height: 12),
                // 全部清理模式
                _CleanModeOption(
                  icon: FluentIcons.delete,
                  title: S.current.tools_shader_clean_all,
                  description: S.current.tools_shader_clean_all_desc,
                  isSelected: _selectedMode == "clean_all",
                  onTap: () {
                    setState(() {
                      _selectedMode = "clean_all";
                    });
                  },
                ),
              ],
            ),
      actions: [
        if (!_isCleaning) ...[
          Button(onPressed: () => Navigator.of(context).pop(), child: Text(S.current.app_common_tip_cancel)),
          FilledButton(
            onPressed: _selectedMode == null
                ? null
                : () async {
                    setState(() {
                      _isCleaning = true;
                    });
                    try {
                      await widget.onClean(_selectedMode!);
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isCleaning = false;
                        });
                      }
                    }
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(S.current.tools_action_start_cleaning),
            ),
          ),
        ],
      ],
    );
  }
}

/// 清理模式选项组件
class _CleanModeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final bool isRecommended;
  final VoidCallback onTap;

  const _CleanModeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    this.isRecommended = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? FluentTheme.of(context).accentColor.withValues(alpha: .15)
              : FluentTheme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? FluentTheme.of(context).accentColor : Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? FluentTheme.of(context).accentColor : Colors.white.withValues(alpha: .7),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? FluentTheme.of(context).accentColor : Colors.white,
                              ),
                            ),
                          ),
                          if (isRecommended)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                S.current.app_common_recommended,
                                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .6), height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
