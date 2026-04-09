import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/data/localization_extension_api_data.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

/// 汉化拓展选择器组件
/// 用于本地文件安装、高级汉化安装、远程汉化安装等场景
class LocalizationExtensionSelector extends StatefulWidget {
  /// 可用的拓展列表
  final List<LocalizationExtensionItemData> availableExtensions;

  /// 已选择的拓展列表（会被修改）
  final List<LocalizationExtensionItemData> selectedExtensions;

  /// 是否展开选择器
  final bool isExpanded;

  /// 展开状态变化回调
  final void Function(bool expanded)? onExpandedChanged;

  const LocalizationExtensionSelector({
    super.key,
    required this.availableExtensions,
    required this.selectedExtensions,
    this.isExpanded = false,
    this.onExpandedChanged,
  });

  @override
  State<LocalizationExtensionSelector> createState() => _LocalizationExtensionSelectorState();

  /// 为 StatefulBuilder 场景构建拓展选择器 UI
  /// 返回一个 Widget，使用外部状态管理
  static Widget buildForStatefulBuilder({
    required BuildContext context,
    required List<LocalizationExtensionItemData> availableExtensions,
    required List<LocalizationExtensionItemData> selectedExtensions,
    required bool isExtensionExpanded,
    required void Function(void Function()) setState,
    required void Function(bool) onExpandedChanged,
  }) {
    if (availableExtensions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(S.current.localization_extension_title),
            const Spacer(),
            ToggleSwitch(
              checked: isExtensionExpanded,
              onChanged: (v) {
                setState(() {
                  onExpandedChanged(v);
                  if (!v) {
                    selectedExtensions.clear();
                  }
                });
              },
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 130),
          child: isExtensionExpanded
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: availableExtensions.map((ext) {
                      final isSelected = selectedExtensions.any((e) => e.file == ext.file);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedExtensions.removeWhere((e) => e.file == ext.file);
                            } else {
                              selectedExtensions.add(ext);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.white.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected ? FluentIcons.check_mark : FluentIcons.circle_ring,
                                size: 14,
                                color: isSelected ? Colors.white : Colors.white.withValues(alpha: .6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                ext.name ?? ext.file ?? "Unknown",
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: .9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _LocalizationExtensionSelectorState extends State<LocalizationExtensionSelector> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.availableExtensions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(S.current.localization_extension_title),
            const Spacer(),
            ToggleSwitch(
              checked: _isExpanded,
              onChanged: (v) {
                setState(() {
                  _isExpanded = v;
                  if (!v) {
                    widget.selectedExtensions.clear();
                  }
                });
                widget.onExpandedChanged?.call(v);
              },
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 130),
          child: _isExpanded
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.availableExtensions.map((ext) {
                      final isSelected = widget.selectedExtensions.any((e) => e.file == ext.file);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              widget.selectedExtensions.removeWhere((e) => e.file == ext.file);
                            } else {
                              widget.selectedExtensions.add(ext);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.white.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected ? FluentIcons.check_mark : FluentIcons.circle_ring,
                                size: 14,
                                color: isSelected ? Colors.white : Colors.white.withValues(alpha: .6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                ext.name ?? ext.file ?? "Unknown",
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: .9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

/// 汉化安装选项数据类
/// 包含社区输入法、载具排序、汉化拓展等选项
class LocalizationInstallOptions {
  bool enableCommunityInputMethod;
  bool enableVehicleSorting;
  List<LocalizationExtensionItemData> selectedExtensions;
  bool isExtensionExpanded;

  LocalizationInstallOptions({
    this.enableCommunityInputMethod = true,
    this.enableVehicleSorting = false,
    List<LocalizationExtensionItemData>? selectedExtensions,
    this.isExtensionExpanded = false,
  }) : selectedExtensions = selectedExtensions ?? [];

  /// 从 Hive 缓存中恢复用户上次的选择
  static Future<LocalizationInstallOptions> loadFromCache({
    required bool hasCommunityInputMethodData,
    required bool defaultVehicleSorting,
    required List<LocalizationExtensionItemData>? availableExtensions,
    required dynamic savedExtensionFiles,
  }) async {
    final options = LocalizationInstallOptions(
      enableCommunityInputMethod: hasCommunityInputMethodData,
      enableVehicleSorting: defaultVehicleSorting,
    );

    // 恢复上次选择的拓展
    if (savedExtensionFiles != null &&
        savedExtensionFiles is List &&
        savedExtensionFiles.isNotEmpty &&
        availableExtensions != null) {
      for (final ext in availableExtensions) {
        if (savedExtensionFiles.contains(ext.file)) {
          options.selectedExtensions.add(ext);
        }
      }
      if (options.selectedExtensions.isNotEmpty) {
        options.isExtensionExpanded = true;
      }
    }

    return options;
  }
}

/// 汉化安装选项面板组件
/// 包含社区输入法开关、载具排序开关、汉化拓展选择器
class LocalizationInstallOptionsPanel extends StatefulWidget {
  /// 安装选项（会被修改）
  final LocalizationInstallOptions options;

  /// 是否有社区输入法数据
  final bool hasCommunityInputMethodData;

  /// 可用的汉化拓展列表
  final List<LocalizationExtensionItemData>? availableExtensions;

  /// 是否隐藏社区输入法选项（高级汉化模式下使用）
  final bool hideCommunityInputMethod;

  /// 额外内容（如代码预览区域）
  final Widget? extraContent;

  const LocalizationInstallOptionsPanel({
    super.key,
    required this.options,
    this.hasCommunityInputMethodData = false,
    this.availableExtensions,
    this.hideCommunityInputMethod = false,
    this.extraContent,
  });

  @override
  State<LocalizationInstallOptionsPanel> createState() => _LocalizationInstallOptionsPanelState();

  /// 为 StatefulBuilder 场景构建安装选项面板 UI
  /// 使用外部状态变量和 setState 回调
  static Widget buildForStatefulBuilder({
    required BuildContext context,
    required bool enableCommunityInputMethod,
    required bool hasCommunityInputMethodData,
    required bool isEnableVehicleSorting,
    required List<LocalizationExtensionItemData>? availableExtensions,
    required List<LocalizationExtensionItemData> selectedExtensions,
    required bool isExtensionExpanded,
    required void Function(void Function()) setState,
    required void Function(bool) onEnableCommunityInputMethodChanged,
    required void Function(bool) onEnableVehicleSortingChanged,
    required void Function(bool) onExtensionExpandedChanged,
    Widget? extraContent,
    bool hideCommunityInputMethod = false,
  }) {
    return Column(
      children: [
        if (extraContent != null) ...[
          Expanded(child: extraContent),
          const SizedBox(height: 16),
        ],
        if (!hideCommunityInputMethod) ...[
          Row(
            children: [
              Text(S.current.input_method_install_community_input_method_support),
              const Spacer(),
              ToggleSwitch(
                checked: enableCommunityInputMethod,
                onChanged: hasCommunityInputMethodData
                    ? (v) {
                        setState(() {
                          onEnableCommunityInputMethodChanged(v);
                        });
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Text(S.current.tools_vehicle_sorting_title),
            const Spacer(),
            ToggleSwitch(
              checked: isEnableVehicleSorting,
              onChanged: (v) {
                setState(() {
                  onEnableVehicleSortingChanged(v);
                });
              },
            ),
          ],
        ),
        if (availableExtensions != null && availableExtensions.isNotEmpty) ...[
          const SizedBox(height: 12),
          LocalizationExtensionSelector.buildForStatefulBuilder(
            context: context,
            availableExtensions: availableExtensions,
            selectedExtensions: selectedExtensions,
            isExtensionExpanded: isExtensionExpanded,
            setState: setState,
            onExpandedChanged: onExtensionExpandedChanged,
          ),
        ],
      ],
    );
  }
}

class _LocalizationInstallOptionsPanelState extends State<LocalizationInstallOptionsPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.extraContent != null) ...[
          Expanded(child: widget.extraContent!),
          const SizedBox(height: 16),
        ],
        if (!widget.hideCommunityInputMethod) ...[
          Row(
            children: [
              Text(S.current.input_method_install_community_input_method_support),
              const Spacer(),
              ToggleSwitch(
                checked: widget.options.enableCommunityInputMethod,
                onChanged: widget.hasCommunityInputMethodData
                    ? (v) {
                        setState(() {
                          widget.options.enableCommunityInputMethod = v;
                        });
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Text(S.current.tools_vehicle_sorting_title),
            const Spacer(),
            ToggleSwitch(
              checked: widget.options.enableVehicleSorting,
              onChanged: (v) {
                setState(() {
                  widget.options.enableVehicleSorting = v;
                });
              },
            ),
          ],
        ),
        if (widget.availableExtensions != null && widget.availableExtensions!.isNotEmpty) ...[
          const SizedBox(height: 12),
          LocalizationExtensionSelector(
            availableExtensions: widget.availableExtensions!,
            selectedExtensions: widget.options.selectedExtensions,
            isExpanded: widget.options.isExtensionExpanded,
            onExpandedChanged: (expanded) {
              widget.options.isExtensionExpanded = expanded;
            },
          ),
        ],
      ],
    );
  }
}
