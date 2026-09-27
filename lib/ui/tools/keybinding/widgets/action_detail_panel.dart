import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'binding_chip.dart';
import 'capture_dialog.dart';
import 'keybinding_styles.dart';
import 'keybinding_text.dart';

class ActionDetailPanel extends StatelessWidget {
  const ActionDetailPanel({super.key, required this.state, required this.model});

  final KeybindingState state;
  final KeybindingModel model;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final action = model.selectedAction;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: .035),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.resources.cardStrokeColorDefault.withValues(alpha: .35)),
      ),
      child: action == null
          ? Center(
              child: Text(
                S.current.keybinding_select_action_hint,
                style: TextStyle(color: Colors.white.withValues(alpha: .55)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  model.groupLabelOf(action),
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55)),
                ),
                const SizedBox(height: 4),
                SelectableText(model.actionLabel(action), style: const TextStyle(fontSize: 18, height: 1.4)),
                const SizedBox(height: 2),
                SelectableText(
                  action.id,
                  style: TextStyle(fontSize: 11, fontFamily: 'Consolas', color: Colors.white.withValues(alpha: .5)),
                ),
                const SizedBox(height: 8),
                Text(
                  model.actionDescription(action) ?? S.current.keybinding_no_description,
                  style: TextStyle(fontSize: 13, height: 1.5, color: Colors.white.withValues(alpha: .66)),
                ),
                const SizedBox(height: 16),
                Text(
                  S.current.keybinding_bindings,
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55)),
                ),
                const SizedBox(height: 8),
                for (final d in ScDeviceType.values)
                  if (action.devices.contains(d)) ...[
                    _DeviceCard(action: action, device: d, state: state, model: model),
                    const SizedBox(height: 8),
                  ],
                if (model.isModified(action)) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Button(
                      onPressed: () => model.resetAction(action),
                      child: Text(S.current.keybinding_reset_action),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.action, required this.device, required this.state, required this.model});

  final ScActionDef action;
  final ScDeviceType device;
  final KeybindingState state;
  final KeybindingModel model;

  @override
  Widget build(BuildContext context) {
    final slot = model.slotOf(action, device);
    final relations = model.relationsOf(action, device);
    final conflicts = model.conflictsOf(action, device);
    final (String tag, Color tagColor) = switch (slot.state) {
      _ when conflicts.isNotEmpty => (S.current.keybinding_state_conflict, kbConflictColor),
      ScSlotState.none => (S.current.keybinding_state_unbound, Colors.white.withValues(alpha: .5)),
      ScSlotState.byDefault =>
        slot.hasModeOverride
            ? (S.current.keybinding_state_modified, FluentTheme.of(context).accentColor.lighter)
            : (S.current.keybinding_state_default, Colors.white.withValues(alpha: .7)),
      ScSlotState.custom => (S.current.keybinding_state_modified, FluentTheme.of(context).accentColor.lighter),
      ScSlotState.cleared => (S.current.keybinding_state_cleared, Colors.white.withValues(alpha: .62)),
    };
    final shown = slot.input ?? slot.defaultInput;
    final canClear = slot.input != null;
    final canReset = state.rebinds[action.id]?.containsKey(device) ?? false;
    final hint = switch (slot.state) {
      ScSlotState.custom =>
        slot.defaultInput == null
            ? S.current.keybinding_default_none
            : S.current.keybinding_default_is(model.formatInput(slot.defaultInput!)),
      ScSlotState.cleared => S.current.keybinding_cleared_hint,
      _ => '',
    };

    return Card(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(deviceLabel(device), style: const TextStyle(fontSize: 13))),
              Text(tag, style: TextStyle(fontSize: 12, color: tagColor)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: shown == null
                    ? Text(
                        S.current.keybinding_state_unbound,
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .5)),
                      )
                    : BindingChip(
                        text: model.formatInput(shown),
                        style: bindingChipStyleOf(slot, conflict: conflicts.isNotEmpty),
                        fontSize: 13,
                      ),
              ),
            ],
          ),
          if (hint.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(hint, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .5))),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Button(
                key: ValueKey('kb_record_${device.name}'),
                style: kbRecordButtonStyle(context),
                onPressed: () => showCaptureDialog(context, model, action, device),
                child: Row(
                  children: [const KbRecordDot(), const SizedBox(width: 6), Text(S.current.keybinding_record)],
                ),
              ),
              const SizedBox(width: 6),
              Button(
                style: kbGhostButtonStyle(context),
                key: ValueKey('kb_clear_${device.name}'),
                onPressed: canClear ? () => model.clearBinding(action, device) : null,
                child: Text(S.current.keybinding_clear),
              ),
              const SizedBox(width: 6),
              Button(
                style: kbGhostButtonStyle(context),
                key: ValueKey('kb_reset_${device.name}'),
                onPressed: canReset ? () => model.resetBinding(action, device) : null,
                child: Text(S.current.keybinding_reset),
              ),
            ],
          ),
          if (slot.input != null && !slot.input!.isAxis) ...[
            const SizedBox(height: 10),
            InfoLabel(
              label: S.current.keybinding_activation_mode,
              labelStyle: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55)),
              child: ComboBox<String>(
                isExpanded: true,
                value: state.rebinds[action.id]?[device]?.activationMode ?? '',
                items: [
                  ComboBoxItem(
                    value: '',
                    child: Text(
                      S.current.keybinding_mode_game_default(activationModeShortLabel(action.modeFor(device), action)),
                    ),
                  ),
                  for (final m in scActivationModeNames)
                    ComboBoxItem(value: m, child: Text('${activationModeShortLabel(m)}  ·  $m')),
                ],
                onChanged: (v) => model.setActivationMode(action, device, (v == null || v.isEmpty) ? null : v),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              activationModeDescription(slot.activationMode, state.data!.profile.activationModes),
              style: TextStyle(fontSize: 12, height: 1.5, color: Colors.white.withValues(alpha: .6)),
            ),
          ],
          for (final r in relations) ...[
            const SizedBox(height: 8),
            _RelationBar(relation: r, input: slot.input!, conflict: conflicts.contains(r), model: model),
          ],
        ],
      ),
    );
  }
}

class _RelationBar extends StatelessWidget {
  const _RelationBar({required this.relation, required this.input, required this.conflict, required this.model});

  final ScRelation relation;
  final ScInput input;
  final bool conflict;
  final KeybindingModel model;

  @override
  Widget build(BuildContext context) {
    final other = relation.other.action;
    final label = model.actionLabel(other);
    final String text;
    if (relation.isPair) {
      text = S.current.keybinding_relation_pair(
        label,
        activationModeShortLabel(relation.other.slot.activationMode, other),
      );
    } else if (conflict) {
      text = S.current.keybinding_relation_conflict(label, model.groupLabelOf(other));
    } else {
      text = S.current.keybinding_relation_default_overlap(label, model.groupLabelOf(other));
    }
    return InfoBar(
      title: Text(model.formatInput(input), style: const TextStyle(fontSize: 12)),
      content: Text(text, style: const TextStyle(fontSize: 12)),
      severity: conflict ? InfoBarSeverity.warning : InfoBarSeverity.info,
      isLong: true,
      // Actions the game hides from its own list can still clash, but there is nothing to open.
      action: model.isListed(other)
          ? HyperlinkButton(onPressed: () => model.revealAction(other), child: Text(S.current.keybinding_view))
          : null,
    );
  }
}
