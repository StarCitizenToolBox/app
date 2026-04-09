import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/provider/unp4kc.dart';

import '../../../../widgets/widgets.dart';

class FilterToolbar extends HookConsumerWidget {
  final Unp4kcState state;
  final Unp4kCModel model;

  const FilterToolbar({super.key, required this.state, required this.model});

  static String _getSizeUnitLabel(Unp4kSizeUnit unit) {
    switch (unit) {
      case Unp4kSizeUnit.k:
        return "K";
      case Unp4kSizeUnit.kb:
        return "KB";
      case Unp4kSizeUnit.mb:
        return "MB";
      case Unp4kSizeUnit.gb:
        return "GB";
    }
  }

  static String _formatDate(DateTime? d) {
    if (d == null) return "?";
    return "${d.year}.${d.month}.${d.day}";
  }

  static String getSizeFilterLabel(Unp4kcState s) {
    if (s.sizeFilterMode == Unp4kFilterMode.none) return "大小";
    final unit = _getSizeUnitLabel(s.sizeFilterUnit);
    if (s.sizeFilterMode == Unp4kFilterMode.range) {
      if (s.sizeFilterRangeStart == null || s.sizeFilterRangeEnd == null) {
        return "大小";
      }
      final start = s.sizeFilterRangeStart!.toStringAsFixed(0);
      final end = s.sizeFilterRangeEnd!.toStringAsFixed(0);
      return "$start-$end $unit";
    }
    if (s.sizeFilterSingleValue == null) return "大小";
    final val = s.sizeFilterSingleValue!.toStringAsFixed(0);
    switch (s.sizeFilterMode) {
      case Unp4kFilterMode.before:
        return "< $val $unit";
      case Unp4kFilterMode.after:
        return "> $val $unit";
      default:
        return "大小";
    }
  }

  static String getDateFilterLabel(Unp4kcState s) {
    if (s.dateFilterMode == Unp4kFilterMode.none) return "日期";
    if (s.dateFilterMode == Unp4kFilterMode.range) {
      if (s.dateFilterRangeStart == null || s.dateFilterRangeEnd == null) {
        return "日期";
      }
      final start = _formatDate(s.dateFilterRangeStart);
      final end = _formatDate(s.dateFilterRangeEnd);
      return "$start - $end";
    }
    if (s.dateFilterSingleDate == null) return "日期";
    final formatted = _formatDate(s.dateFilterSingleDate);
    switch (s.dateFilterMode) {
      case Unp4kFilterMode.before:
        return "< $formatted";
      case Unp4kFilterMode.after:
        return "> $formatted";
      default:
        return "日期";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(text: state.searchQuery);
    final sizeSingleController = useTextEditingController(
      text: state.sizeFilterSingleValue?.toString() ?? "",
    );
    final sizeRangeStartController = useTextEditingController(
      text: state.sizeFilterRangeStart?.toString() ?? "",
    );
    final sizeRangeEndController = useTextEditingController(
      text: state.sizeFilterRangeEnd?.toString() ?? "",
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final v = state.sizeFilterSingleValue?.toString() ?? "";
        if (sizeSingleController.text != v) {
          sizeSingleController.text = v;
        }
      });
      return null;
    }, [state.sizeFilterSingleValue]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final s = state.sizeFilterRangeStart?.toString() ?? "";
        final e = state.sizeFilterRangeEnd?.toString() ?? "";
        if (sizeRangeStartController.text != s) {
          sizeRangeStartController.text = s;
        }
        if (sizeRangeEndController.text != e) {
          sizeRangeEndController.text = e;
        }
      });
      return null;
    }, [state.sizeFilterRangeStart, state.sizeFilterRangeEnd]);

    bool hasActiveSizeFilter() {
      if (state.sizeFilterMode == Unp4kFilterMode.none) return false;
      if (state.sizeFilterMode == Unp4kFilterMode.range) {
        return state.sizeFilterRangeStart != null &&
            state.sizeFilterRangeEnd != null;
      }
      return state.sizeFilterSingleValue != null;
    }

    bool hasActiveDateFilter() {
      if (state.dateFilterMode == Unp4kFilterMode.none) return false;
      if (state.dateFilterMode == Unp4kFilterMode.range) {
        return state.dateFilterRangeStart != null &&
            state.dateFilterRangeEnd != null;
      }
      return state.dateFilterSingleDate != null;
    }

    bool hasActiveSuffixFilter() => state.suffixFilter.isNotEmpty;

    bool hasAnyFilter() =>
        hasActiveSizeFilter() || hasActiveDateFilter() || hasActiveSuffixFilter();

    final searchPlaceholder = state.isGlobalSearchScope
        ? "搜索全部文件（支持正则）..."
        : "搜索当前目录（支持正则）...";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor.withValues(alpha: .06),
      ),
      child: Row(
        children: [
          ComboBox<Unp4kSortType>(
            value: state.sortType,
            items: [
              ComboBoxItem(
                value: Unp4kSortType.defaultSort,
                child: Text(S.current.tools_unp4k_sort_default),
              ),
              ComboBoxItem(
                value: Unp4kSortType.sizeAsc,
                child: Text(S.current.tools_unp4k_sort_size_asc),
              ),
              ComboBoxItem(
                value: Unp4kSortType.sizeDesc,
                child: Text(S.current.tools_unp4k_sort_size_desc),
              ),
              ComboBoxItem(
                value: Unp4kSortType.dateAsc,
                child: Text(S.current.tools_unp4k_sort_date_asc),
              ),
              ComboBoxItem(
                value: Unp4kSortType.dateDesc,
                child: Text(S.current.tools_unp4k_sort_date_desc),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                model.setSortType(value);
              }
            },
          ),
          const SizedBox(width: 8),
          _SearchScopeButton(searchController: searchController, model: model),
          const SizedBox(width: 4),
          Expanded(
            child: TextBox(
              controller: searchController,
              placeholder: searchPlaceholder,
              suffix:
                  searchController.text.isNotEmpty ||
                      state.searchMatchedFiles != null
                  ? IconButton(
                      icon: const Icon(FluentIcons.clear, size: 12),
                      onPressed: () {
                        searchController.clear();
                        model.clearSearch();
                      },
                    )
                  : null,
              onSubmitted: (value) {
                model.search(value);
              },
            ),
          ),
          const SizedBox(width: 4),
          _SuffixQuickSelect(model: model),
          const SizedBox(width: 8),
          _FilterPopupButton(
            label: getSizeFilterLabel(state),
            icon: FluentIcons.size_legacy,
            isActive: hasActiveSizeFilter(),
            builder: (context) => _SizeFilterPopup(
              model: model,
              singleController: sizeSingleController,
              rangeStartController: sizeRangeStartController,
              rangeEndController: sizeRangeEndController,
            ),
          ),
          const SizedBox(width: 4),
          _FilterPopupButton(
            label: getDateFilterLabel(state),
            icon: FluentIcons.calendar,
            isActive: hasActiveDateFilter(),
            builder: (context) => _DateFilterPopup(model: model),
          ),
          if (hasAnyFilter()) ...[
            const SizedBox(width: 8),
            Button(
              onPressed: () {
                model.clearSizeFilter();
                model.clearDateFilter();
                model.clearSuffixFilter();
              },
              child: const Text("清除"),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchScopeButton extends HookConsumerWidget {
  final TextEditingController searchController;
  final Unp4kCModel model;

  const _SearchScopeButton({
    required this.searchController,
    required this.model,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    final flyoutController = useMemoized(() => FlyoutController());
    final hover = useState(false);

    useEffect(() {
      return () => flyoutController.dispose();
    }, []);

    return FlyoutTarget(
      controller: flyoutController,
      child: MouseRegion(
        onEnter: (_) => hover.value = true,
        onExit: (_) => hover.value = false,
        child: GestureDetector(
          onTap: () {
            flyoutController.showFlyout(
              autoModeConfiguration: FlyoutAutoConfiguration(
                preferredMode: FlyoutPlacementMode.bottomLeft,
              ),
              barrierColor: Colors.transparent,
              builder: (context) => _SearchOptionsPanel(
                searchController: searchController,
                model: model,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hover.value
                  ? FluentTheme.of(context).accentColor.withValues(alpha: .08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  state.isGlobalSearchScope
                      ? FluentIcons.search
                      : FluentIcons.folder_search,
                  size: 12,
                  color: hover.value
                      ? FluentTheme.of(context).accentColor
                      : Colors.white.withValues(alpha: .7),
                ),
                const SizedBox(width: 4),
                Icon(
                  FluentIcons.chevron_down,
                  size: 8,
                  color: hover.value
                      ? FluentTheme.of(context).accentColor
                      : Colors.white.withValues(alpha: .5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchOptionsPanel extends HookConsumerWidget {
  final TextEditingController searchController;
  final Unp4kCModel model;

  const _SearchOptionsPanel({
    required this.searchController,
    required this.model,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);

    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).menuColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FluentTheme.of(context).resources.cardStrokeColorDefault,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RadioButton(
            checked: !state.isGlobalSearchScope,
            onChanged: (v) {
              if (v == true) {
                model.setSearchScope(false);
                Navigator.of(context).pop();
              }
            },
            content: const Text("当前目录"),
          ),
          const SizedBox(height: 4),
          RadioButton(
            checked: state.isGlobalSearchScope,
            onChanged: (v) {
              if (v == true) {
                model.setSearchScope(true);
                Navigator.of(context).pop();
              }
            },
            content: const Text("全局搜索"),
          ),
        ],
      ),
    );
  }
}

class _SuffixQuickSelect extends HookConsumerWidget {
  final Unp4kCModel model;

  const _SuffixQuickSelect({
    required this.model,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    final flyoutController = useMemoized(() => FlyoutController());
    final hover = useState(false);
    final hasSuffixFilter = state.suffixFilter.isNotEmpty;

    useEffect(() {
      return () => flyoutController.dispose();
    }, []);

    return FlyoutTarget(
      controller: flyoutController,
      child: MouseRegion(
        onEnter: (_) => hover.value = true,
        onExit: (_) => hover.value = false,
        child: GestureDetector(
          onTap: () {
            flyoutController.showFlyout(
              autoModeConfiguration: FlyoutAutoConfiguration(
                preferredMode: FlyoutPlacementMode.bottomLeft,
              ),
              barrierColor: Colors.transparent,
              builder: (context) => _SuffixQuickSelectPanel(model: model),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: hasSuffixFilter
                  ? Colors.white.withValues(alpha: .15)
                  : hover.value
                      ? FluentTheme.of(context).accentColor.withValues(alpha: .08)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "后缀",
                  style: TextStyle(
                    fontSize: 12,
                    color: hasSuffixFilter
                        ? Colors.white
                        : hover.value
                            ? FluentTheme.of(context).accentColor
                            : Colors.white.withValues(alpha: .9),
                  ),
                ),
                if (hasSuffixFilter) ...[
                  const SizedBox(width: 4),
                  Text(
                    "(${state.suffixFilter.length})",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: .7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuffixQuickSelectPanel extends HookConsumerWidget {
  final Unp4kCModel model;

  static const _previewFormats = [
    ".txt",
    ".xml",
    ".json",
    ".cfg",
    ".ini",
    ".mtl",
    ".dds",
    ".png",
    ".wem",
    ".dcb",
    ".cgf",
    ".cga",
  ];

  static const _commonFormats = [".soc", ".cry", ".cdf", ".chr", ".skin"];

  const _SuffixQuickSelectPanel({
    required this.model,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    final selectedSuffixes = state.suffixFilter;
    final inputController = useTextEditingController();

    // 计算自定义后缀（不在预设列表中的）
    final allPresetSuffixes = {..._previewFormats, ..._commonFormats};
    final customSuffixes = selectedSuffixes.where((s) => !allPresetSuffixes.contains(s)).toList();

    Widget buildSuffixButton(String suffix) {
      final isSelected = selectedSuffixes.contains(suffix);
      return Button(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          ),
          backgroundColor: WidgetStateProperty.all(
            isSelected
                ? FluentTheme.of(context).accentColor.withValues(alpha: .3)
                : null,
          ),
        ),
        onPressed: () {
          model.toggleSuffixFilter(suffix);
        },
        child: Text(
          suffix,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? Colors.white : null,
          ),
        ),
      );
    }

    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).menuColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FluentTheme.of(context).resources.cardStrokeColorDefault,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "后缀筛选",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: .7),
                ),
              ),
              if (selectedSuffixes.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    model.clearSuffixFilter();
                    inputController.clear();
                  },
                  child: Text(
                    "清除",
                    style: TextStyle(
                      fontSize: 11,
                      color: FluentTheme.of(context).accentColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextBox(
            controller: inputController,
            placeholder: "用空格分割，不包含.",
            onSubmitted: (value) {
              final suffixes = value
                  .trim()
                  .split(RegExp(r'\s+'))
                  .where((s) => s.isNotEmpty)
                  .map((s) => s.startsWith('.') ? s : '.$s')
                  .toSet();
              if (suffixes.isNotEmpty) {
                model.setSuffixFilter({...selectedSuffixes, ...suffixes});
                inputController.clear();
              }
            },
          ),
          if (customSuffixes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "自定义",
              style: TextStyle(
               fontSize: 10,
                color: Colors.white.withValues(alpha: .5),
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: customSuffixes.map(buildSuffixButton).toList(),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            "支持预览",
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: .5),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _previewFormats.map(buildSuffixButton).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            "常见格式",
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: .5),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _commonFormats.map(buildSuffixButton).toList(),
          ),
        ],
      ),
    );
  }
}

class _FilterPopupButton extends HookWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Widget Function(BuildContext context) builder;

  const _FilterPopupButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final hover = useState(false);
    final flyoutController = useMemoized(() => FlyoutController());

    useEffect(() {
      return () => flyoutController.dispose();
    }, []);

    return FlyoutTarget(
      controller: flyoutController,
      child: MouseRegion(
        onEnter: (_) => hover.value = true,
        onExit: (_) => hover.value = false,
        child: GestureDetector(
          onTap: () {
            flyoutController.showFlyout(
              autoModeConfiguration: FlyoutAutoConfiguration(
                preferredMode: FlyoutPlacementMode.bottomLeft,
              ),
              barrierColor: Colors.transparent,
              builder: builder,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withValues(alpha: .15)
                  : hover.value
                  ? FluentTheme.of(context).accentColor.withValues(alpha: .08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 12,
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: .8),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: .9),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  FluentIcons.chevron_down,
                  size: 10,
                  color: isActive
                      ? Colors.white.withValues(alpha: .8)
                      : Colors.white.withValues(alpha: .6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SizeFilterPopup extends HookConsumerWidget {
  final Unp4kCModel model;
  final TextEditingController singleController;
  final TextEditingController rangeStartController;
  final TextEditingController rangeEndController;

  const _SizeFilterPopup({
    required this.model,
    required this.singleController,
    required this.rangeStartController,
    required this.rangeEndController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).menuColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FluentTheme.of(context).resources.cardStrokeColorDefault,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ComboBox<Unp4kFilterMode>(
                value: state.sizeFilterMode,
                items: const [
                  ComboBoxItem(value: Unp4kFilterMode.none, child: Text("不限")),
                  ComboBoxItem(
                    value: Unp4kFilterMode.before,
                    child: Text("小于"),
                  ),
                  ComboBoxItem(value: Unp4kFilterMode.after, child: Text("大于")),
                  ComboBoxItem(value: Unp4kFilterMode.range, child: Text("范围")),
                ],
                onChanged: (v) {
                  if (v != null) model.setSizeFilterMode(v);
                },
              ),
              const SizedBox(width: 8),
              ComboBox<Unp4kSizeUnit>(
                value: state.sizeFilterUnit,
                items: const [
                  ComboBoxItem(value: Unp4kSizeUnit.k, child: Text("K")),
                  ComboBoxItem(value: Unp4kSizeUnit.kb, child: Text("KB")),
                  ComboBoxItem(value: Unp4kSizeUnit.mb, child: Text("MB")),
                  ComboBoxItem(value: Unp4kSizeUnit.gb, child: Text("GB")),
                ],
                onChanged: (v) {
                  if (v != null) model.setSizeFilterUnit(v);
                },
              ),
            ],
          ),
          if (state.sizeFilterMode == Unp4kFilterMode.range) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextBox(
                    controller: rangeStartController,
                    placeholder: "起始",
                    onSubmitted: (_) {
                      model.setSizeFilterRange(
                        _tryParseDouble(rangeStartController.text),
                        _tryParseDouble(rangeEndController.text),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("-"),
                ),
                Expanded(
                  child: TextBox(
                    controller: rangeEndController,
                    placeholder: "结束",
                    onSubmitted: (_) {
                      model.setSizeFilterRange(
                        _tryParseDouble(rangeStartController.text),
                        _tryParseDouble(rangeEndController.text),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ] else if (state.sizeFilterMode != Unp4kFilterMode.none) ...[
            const SizedBox(height: 8),
            TextBox(
              controller: singleController,
              placeholder: "大小值",
              onSubmitted: (_) {
                model.setSizeFilterSingleValue(
                  _tryParseDouble(singleController.text),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ],
      ),
    );
  }

  double? _tryParseDouble(String text) {
    final v = double.tryParse(text.trim());
    if (v == null || v < 0) return null;
    return v;
  }
}

class _DateFilterPopup extends HookConsumerWidget {
  final Unp4kCModel model;

  const _DateFilterPopup({required this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unp4kCModelProvider);
    return Container(
      width: 320,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).menuColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FluentTheme.of(context).resources.cardStrokeColorDefault,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComboBox<Unp4kFilterMode>(
            value: state.dateFilterMode,
            items: const [
              ComboBoxItem(value: Unp4kFilterMode.none, child: Text("不限")),
              ComboBoxItem(value: Unp4kFilterMode.before, child: Text("某日之前")),
              ComboBoxItem(value: Unp4kFilterMode.after, child: Text("某日之后")),
              ComboBoxItem(value: Unp4kFilterMode.range, child: Text("时间范围")),
            ],
            onChanged: (v) {
              if (v != null) model.setDateFilterMode(v);
            },
          ),
          if (state.dateFilterMode == Unp4kFilterMode.range) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DatePicker(
                    selected: state.dateFilterRangeStart,
                    showDay: true,
                    showMonth: true,
                    showYear: true,
                    onChanged: (d) {
                      model.setDateFilterRange(
                        DateTime(d.year, d.month, d.day),
                        state.dateFilterRangeEnd,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("-"),
                ),
                Expanded(
                  child: DatePicker(
                    selected: state.dateFilterRangeEnd,
                    showDay: true,
                    showMonth: true,
                    showYear: true,
                    onChanged: (d) {
                      model.setDateFilterRange(
                        state.dateFilterRangeStart,
                        DateTime(d.year, d.month, d.day),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ] else if (state.dateFilterMode != Unp4kFilterMode.none) ...[
            const SizedBox(height: 8),
            DatePicker(
              selected: state.dateFilterSingleDate,
              showDay: true,
              showMonth: true,
              showYear: true,
              onChanged: (d) {
                model.setDateFilterSingleDate(DateTime(d.year, d.month, d.day));
                Navigator.of(context).pop();
              },
            ),
          ],
        ],
      ),
    );
  }
}
