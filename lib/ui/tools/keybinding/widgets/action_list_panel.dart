import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_default_profile.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_input.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'binding_chip.dart';
import 'keybinding_text.dart';

class ActionListPanel extends StatelessWidget {
  const ActionListPanel({super.key, required this.state, required this.model});

  final KeybindingState state;
  final KeybindingModel model;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final actions = model.visibleActions();
    final searching = state.query.trim().isNotEmpty;
    final title = searching ? S.current.keybinding_search_results : model.scopeLabel();
    final headerStyle = TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55));

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: .035),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.resources.cardStrokeColorDefault.withValues(alpha: .35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(title, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 10),
                Text(S.current.keybinding_action_count(actions.length), style: headerStyle),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) {
                final columns = _Columns.of(state, box.maxWidth);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 28,
                      padding: const EdgeInsets.only(left: 40, right: 28),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: .06))),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(S.current.keybinding_column_action, style: headerStyle)),
                          if (!columns.stacked) ...[
                            if (columns.keyboard)
                              SizedBox(
                                width: columns.width,
                                child: Text(S.current.keybinding_device_keyboard_mouse, style: headerStyle),
                              ),
                            if (columns.joystick)
                              SizedBox(
                                width: columns.width,
                                child: Text(S.current.keybinding_device_joystick, style: headerStyle),
                              ),
                            if (columns.gamepad)
                              SizedBox(
                                width: columns.width,
                                child: Text(S.current.keybinding_device_gamepad, style: headerStyle),
                              ),
                          ],
                          SizedBox(
                            width: _Columns.modeWidth,
                            child: Text(S.current.keybinding_column_mode, style: headerStyle),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: actions.isEmpty
                          ? Center(
                              child: Text(
                                searching
                                    ? S.current.keybinding_no_search_result(state.query)
                                    : S.current.keybinding_no_actions,
                                style: TextStyle(color: Colors.white.withValues(alpha: .55)),
                              ),
                            )
                          : SuperListView.builder(
                              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
                              itemCount: actions.length,
                              itemBuilder: (context, i) => _ActionRow(
                                action: actions[i],
                                model: model,
                                columns: columns,
                                selected: actions[i].id == state.selectedActionId,
                                showGroup: searching || model.scopeSpansGroups,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Columns {
  const _Columns(this.keyboard, this.joystick, this.gamepad, this.width, this.stacked);

  final bool keyboard;
  final bool joystick;
  final bool gamepad;
  final double width;

  /// Too narrow for device columns: chips go on a line under the action name.
  final bool stacked;

  static const modeWidth = 84.0;
  static const _titleMin = 180.0;
  static const _chrome = 76.0;

  factory _Columns.of(KeybindingState s, double listWidth) {
    final (kb, js, gp) = switch (s.deviceFilter) {
      KeybindingDeviceFilter.all => (true, true, true),
      KeybindingDeviceFilter.keyboard => (true, false, false),
      KeybindingDeviceFilter.joystick => (false, true, false),
      KeybindingDeviceFilter.gamepad => (false, false, true),
    };
    final count = [kb, js, gp].where((v) => v).length;
    final available = listWidth - _chrome - modeWidth - _titleMin;
    final width = (available / count).clamp(0.0, count == 1 ? 320.0 : 180.0);
    return _Columns(kb, js, gp, width, width < 104);
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.action,
    required this.model,
    required this.columns,
    required this.selected,
    required this.showGroup,
  });

  final ScActionDef action;
  final KeybindingModel model;
  final _Columns columns;
  final bool selected;
  final bool showGroup;

  Widget _chip(ScDeviceType d) {
    final slot = model.slotOf(action, d);
    final conflict = model.conflictsOf(action, d).isNotEmpty;
    final input = slot.input ?? slot.defaultInput;
    if (input == null) return const BindingChip(text: '', style: BindingChipStyle.none);
    return Tooltip(
      message: input.toXml().trim(),
      child: BindingChip(
        text: model.formatInput(input),
        style: bindingChipStyleOf(slot, conflict: conflict),
      ),
    );
  }

  Widget _cell(List<ScDeviceType> devices) {
    final shown = devices.where((d) => model.slotOf(action, d).state != ScSlotState.none).toList();
    if (shown.isEmpty) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: BindingChip(text: '', style: BindingChipStyle.none),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(spacing: 4, runSpacing: 4, children: [for (final d in shown) _chip(d)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modified = model.isModified(action);
    final conflict = model.hasConflict(action);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile.selectable(
        selected: selected,
        onSelectionChange: (_) => model.selectAction(action.id),
        leading: SizedBox(
          width: 8,
          child: modified
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: FluentTheme.of(context).accentColor, shape: BoxShape.circle),
                )
              : null,
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                model.actionLabel(action),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (conflict) ...[const SizedBox(width: 6), Icon(FluentIcons.warning, size: 13, color: kbConflictColor)],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              showGroup ? '${model.groupLabelOf(action)} · ${action.name}' : action.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, fontFamily: 'Consolas', color: Colors.white.withValues(alpha: .45)),
            ),
            if (columns.stacked) ...[
              const SizedBox(height: 4),
              _cell([
                if (columns.keyboard) ...const [ScDeviceType.keyboard, ScDeviceType.mouse],
                if (columns.joystick) ScDeviceType.joystick,
                if (columns.gamepad) ScDeviceType.gamepad,
              ]),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!columns.stacked) ...[
              if (columns.keyboard)
                SizedBox(width: columns.width, child: _cell(const [ScDeviceType.keyboard, ScDeviceType.mouse])),
              if (columns.joystick) SizedBox(width: columns.width, child: _cell(const [ScDeviceType.joystick])),
              if (columns.gamepad) SizedBox(width: columns.width, child: _cell(const [ScDeviceType.gamepad])),
            ],
            SizedBox(
              width: _Columns.modeWidth,
              child: Text(
                activationModeShortLabel(action.activationMode, action),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .62)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
