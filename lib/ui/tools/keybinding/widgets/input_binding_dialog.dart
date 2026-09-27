import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input_format.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'binding_chip.dart';
import 'keybinding_styles.dart';
import 'keybinding_text.dart';

/// Edits one input from the device side: what it triggers now, removing those, and binding
/// another action to it. [onReveal] jumps to an action in the main list.
Future<void> showInputBindingDialog(
  BuildContext context, {
  required ScInput input,
  required ValueChanged<ScActionDef> onReveal,
}) async {
  final model = ProviderScope.containerOf(context).read(keybindingModelProvider.notifier);
  final snapshot = model.snapshotRebinds();
  // Only "done" keeps the edits; cancel, Esc and clicking outside put the working copy back.
  final kept = await showDialog<bool>(
    context: context,
    builder: (_) => _InputBindingDialog(initial: input, onReveal: onReveal),
  );
  if (kept != true) model.restoreRebinds(snapshot);
}

class _InputBindingDialog extends ConsumerStatefulWidget {
  const _InputBindingDialog({required this.initial, required this.onReveal});

  final ScInput initial;
  final ValueChanged<ScActionDef> onReveal;

  @override
  ConsumerState<_InputBindingDialog> createState() => _InputBindingDialogState();
}

class _InputBindingDialogState extends ConsumerState<_InputBindingDialog> {
  late final List<String> _modifiers = [...widget.initial.modifiers];
  final _search = TextEditingController();

  ScInput get _input =>
      ScInput(widget.initial.device, widget.initial.instance, ScInput.sortModifiers(_modifiers), widget.initial.key);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(keybindingModelProvider);
    final model = ref.read(keybindingModelProvider.notifier);
    final input = _input;
    final device = input.device;
    final current = [
      for (final a in model.allActions())
        if (model.slotOf(a, device).input == input) a,
    ];
    final candidates = [
      for (final a in model.allActions())
        if (a.devices.contains(device) && !current.contains(a)) a,
    ];
    final modifierChoices = device == ScDeviceType.gamepad ? scGamepadModifiers : scKeyboardModifiers;
    final muted = TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6));

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 620, maxHeight: 640),
      title: Row(
        children: [
          Text(S.current.keybinding_input_dialog_title),
          const SizedBox(width: 12),
          BindingChip(text: model.formatInput(input), style: BindingChipStyle.custom, fontSize: 15),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!input.isAxis) ...[
              Text(S.current.keybinding_input_dialog_modifiers, style: muted),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final m in modifierChoices)
                    ToggleButton(
                      style: kbToggleStyle(context),
                      checked: _modifiers.contains(m),
                      onChanged: (v) => setState(() => v ? _modifiers.add(m) : _modifiers.remove(m)),
                      child: Text(scFormatModifier(device, m)),
                    ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            Text(S.current.keybinding_input_dialog_current(current.length), style: muted),
            const SizedBox(height: 6),
            if (current.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(S.current.keybinding_input_dialog_none, style: muted),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(right: 12),
                  children: [
                    for (final a in current)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Card(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          borderRadius: BorderRadius.circular(6),
                          child: Row(
                            children: [
                              if (model.conflictsOf(a, device).isNotEmpty) ...[
                                Icon(FluentIcons.warning, size: 12, color: kbConflictColor),
                                const SizedBox(width: 6),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(model.actionLabel(a), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    Text(
                                      '${model.groupLabelOf(a)} · ${activationModeShortLabel(model.slotOf(a, device).activationMode, a)}',
                                      style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .5)),
                                    ),
                                  ],
                                ),
                              ),
                              HyperlinkButton(
                                onPressed: () {
                                  // Leaving to look at the action keeps what was edited here.
                                  closeDialog(context, true);
                                  widget.onReveal(a);
                                },
                                child: Text(S.current.keybinding_view),
                              ),
                              const SizedBox(width: 4),
                              Button(
                                style: kbGhostButtonStyle(context),
                                onPressed: () => model.clearBinding(a, device),
                                child: Text(S.current.keybinding_input_dialog_unbind),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            Text(S.current.keybinding_input_dialog_add, style: muted),
            const SizedBox(height: 6),
            AutoSuggestBox<ScActionDef>(
              controller: _search,
              placeholder: S.current.keybinding_input_dialog_search,
              items: [
                for (final a in candidates)
                  AutoSuggestBoxItem<ScActionDef>(
                    value: a,
                    label: '${model.actionLabel(a)}  ·  ${model.groupLabelOf(a)}  ·  ${a.name}',
                    // Suggestion rows have a fixed height: keep each on one line.
                    child: Text(
                      '${model.actionLabel(a)}  ·  ${model.groupLabelOf(a)}  ·  ${a.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onSelected: (item) {
                final a = item.value;
                if (a == null) return;
                model.bind(a, input);
                // Clear after the suggestion overlay has closed.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _search.clear();
                });
              },
            ),
            const SizedBox(height: 6),
            Text(S.current.keybinding_input_dialog_add_hint(deviceLabel(device)), style: muted),
          ],
        ),
      ),
      actions: [
        Button(onPressed: () => closeDialog(context, false), child: Text(S.current.app_common_tip_cancel)),
        FilledButton(onPressed: () => closeDialog(context, true), child: Text(S.current.keybinding_done)),
      ],
    );
  }
}
