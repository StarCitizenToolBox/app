import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/data/game_performance_data.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'performance_ui_model.dart';

class HomePerformanceUI extends HookConsumerWidget {
  const HomePerformanceUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePerformanceUIModelProvider);
    final model = ref.read(homePerformanceUIModelProvider.notifier);

    var content = makeLoading(context);

    if (state.performanceMap != null) {
      content = Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: [
                      if (state.showGraphicsPerformanceTip)
                        InfoBar(
                          title: Text(S.current
                              .performance_info_graphic_optimization_hint),
                          content: Text(
                            S.current
                                .performance_info_graphic_optimization_warning,
                          ),
                          onClose: () => model.closeTip(),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            S.current.performance_info_current_status(
                                state.enabled
                                    ? S.current.performance_info_applied
                                    : S.current.performance_info_not_applied),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 32),
                          Text(
                            S.current.performance_action_preset,
                            style: const TextStyle(fontSize: 18),
                          ),
                          for (final item in {
                            "low": S.current.performance_action_low,
                            "medium": S.current.performance_action_medium,
                            "high": S.current.performance_action_high,
                            "ultra": S.current.performance_action_super
                          }.entries)
                            Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: Button(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 2, left: 4, right: 4),
                                    child: Text(item.value),
                                  ),
                                  onPressed: () =>
                                      model.onChangePreProfile(item.key)),
                            ),
                          Text(S.current
                              .performance_action_info_preset_only_changes_graphics),
                          const Spacer(),
                          Button(
                            onPressed: () => model.refresh(),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(FluentIcons.refresh),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Button(
                              child: Text(
                                S.current.performance_action_reset_to_default,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () => model.clean(context)),
                          const SizedBox(width: 24),
                          Button(
                              child: Text(
                                S.current.performance_action_apply,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () => model.applyProfile(false)),
                          const SizedBox(width: 6),
                          Button(
                              child: Text(
                                S.current
                                    .performance_action_apply_and_clear_shaders,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () => model.applyProfile(true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Expanded(
                    child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  itemCount: state.performanceMap!.length,
                  itemBuilder: (context, index) {
                    final group =
                        state.performanceMap!.entries.elementAt(index);
                    return _PerformanceGroup(
                      key: ValueKey(group.key),
                      title: group.key,
                      items: group.value,
                      customizeCtrl: model.customizeCtrl,
                    );
                  },
                )),
              ],
            ),
          ),
          if (state.workingString.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ProgressRing(),
                    const SizedBox(height: 12),
                    Text(state.workingString),
                  ],
                ),
              ),
            )
        ],
      );
    }

    return makeDefaultPage(context,
        title:
            S.current.performance_title_performance_optimization(model.scPath),
        useBodyContainer: true,
        content: content);
  }
}

/// One card of settings. A [RepaintBoundary] keeps edits inside one card from
/// repainting the others.
class _PerformanceGroup extends StatelessWidget {
  const _PerformanceGroup({
    super.key,
    required this.title,
    required this.items,
    required this.customizeCtrl,
  });

  final String title;
  final List<GamePerformanceData> items;
  final TextEditingController customizeCtrl;

  @override
  Widget build(BuildContext context) {
    final cardColor = FluentTheme.of(context).cardColor;
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: cardColor,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 6),
              Container(color: cardColor.withValues(alpha: .2), height: 1),
              const SizedBox(height: 6),
              for (final item in items)
                _PerformanceItem(
                  key: ValueKey(item.key),
                  item: item,
                  customizeCtrl: customizeCtrl,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single setting. It edits [GamePerformanceData.value] in place and
/// rebuilds only itself, so dragging a slider no longer rebuilds the page.
/// Page-wide changes (presets, refresh) still rebuild it with fresh values.
class _PerformanceItem extends StatefulWidget {
  const _PerformanceItem({
    super.key,
    required this.item,
    required this.customizeCtrl,
  });

  final GamePerformanceData item;
  final TextEditingController customizeCtrl;

  @override
  State<_PerformanceItem> createState() => _PerformanceItemState();
}

class _PerformanceItemState extends State<_PerformanceItem> {
  late final _valueCtrl = TextEditingController(text: _valueText);
  final _valueFocus = FocusNode();

  GamePerformanceData get item => widget.item;

  String get _valueText => "${item.value ?? 0}";

  @override
  void initState() {
    super.initState();
    _valueFocus.addListener(() {
      if (!_valueFocus.hasFocus) _submit(_valueCtrl.text);
    });
  }

  @override
  void didUpdateWidget(_PerformanceItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncText();
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    _valueFocus.dispose();
    super.dispose();
  }

  void _syncText() {
    if (!_valueFocus.hasFocus && _valueCtrl.text != _valueText) {
      _valueCtrl.text = _valueText;
    }
  }

  void _setValue(int value) {
    if (item.value == value) return;
    setState(() => item.value = value);
    _syncText();
  }

  void _submit(String text) {
    final v = int.tryParse(text.trim());
    if (v != null && v >= (item.min ?? 0) && v <= (item.max ?? 0)) {
      _setValue(v);
    }
    // Invalid or out-of-range input falls back to the current value.
    _valueCtrl.text = _valueText;
  }

  @override
  Widget build(BuildContext context) {
    final secondaryText = TextStyle(color: Colors.white.withValues(alpha: .6));
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${item.name}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          if (item.type == "int")
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: TextBox(
                    controller: _valueCtrl,
                    focusNode: _valueFocus,
                    onSubmitted: _submit,
                    onTapOutside: (_) => _valueFocus.unfocus(),
                  ),
                ),
                const SizedBox(width: 32),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Slider(
                      value: (item.value ?? 0).toDouble(),
                      min: (item.min ?? 0).toDouble(),
                      max: (item.max ?? 0).toDouble(),
                      onChanged: (value) => _setValue(value.round()),
                    ),
                  ),
                ),
              ],
            )
          else if (item.type == "bool")
            ToggleSwitch(
              checked: item.value == 1,
              onChanged: (value) => _setValue(value ? 1 : 0),
            )
          else if (item.type == "customize")
            TextFormBox(
              maxLines: 10,
              placeholder: S.current.performance_action_custom_parameters_input,
              controller: widget.customizeCtrl,
            ),
          if (item.info != null && item.info!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              "${item.info}",
              style: secondaryText.copyWith(fontSize: 14),
            ),
          ],
          const SizedBox(height: 12),
          if (item.type != "customize")
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                S.current.performance_info_min_max_values(
                  item.key ?? "",
                  item.min ?? "",
                  item.max ?? "",
                ),
                style: secondaryText,
              ),
            ),
          const SizedBox(height: 6),
          Container(
            color: FluentTheme.of(context).cardColor.withValues(alpha: .1),
            height: 1,
          ),
        ],
      ),
    );
  }
}
