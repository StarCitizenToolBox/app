import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';

import 'binding_chip.dart';

/// Category → group navigation, the game's own grouping (UICategory / actionmap UILabel).
class GroupTreePanel extends StatelessWidget {
  const GroupTreePanel({super.key, required this.state, required this.model});

  final KeybindingState state;
  final KeybindingModel model;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final searching = state.query.trim().isNotEmpty;
    final all = model.allActions();
    final items = [
      TreeViewItem(
        value: KeybindingModel.allScopeId,
        selected: !searching && state.selectedGroupId == KeybindingModel.allScopeId,
        content: _Row(
          label: S.current.keybinding_scope_all,
          count: all.length,
          modified: all.where(model.isModified).length,
          conflict: all.any(model.hasConflict),
        ),
      ),
      for (final c in state.categories)
        TreeViewItem(
          value: '${KeybindingModel.categoryScopePrefix}${c.id}',
          expanded: !state.collapsedCategories.contains(c.id),
          selected: !searching && state.selectedGroupId == '${KeybindingModel.categoryScopePrefix}${c.id}',
          content: _Row(
            label: c.label,
            count: c.groups.fold(0, (n, g) => n + g.actions.length),
            modified: c.groups.fold(0, (n, g) => n + g.actions.where(model.isModified).length),
            conflict: c.groups.any((g) => g.actions.any(model.hasConflict)),
            dim: true,
          ),
          children: [
            for (final g in c.groups)
              TreeViewItem(
                value: g.id,
                selected: !searching && g.id == state.selectedGroupId,
                content: _Row(
                  label: g.label,
                  count: g.actions.length,
                  modified: g.actions.where(model.isModified).length,
                  conflict: g.actions.any(model.hasConflict),
                ),
              ),
          ],
        ),
    ];
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: .035),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.resources.cardStrokeColorDefault.withValues(alpha: .35)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TreeView(
        items: items,
        selectionMode: TreeViewSelectionMode.single,
        narrowSpacing: true,
        onItemInvoked: (item, reason) async {
          // The chevron toggles expansion only; clicking the row selects (a category lists all its groups).
          if (reason != TreeViewItemInvokeReason.expandToggle) model.selectGroup(item.value as String);
        },
        onItemExpandToggle: (item, expanded) async {
          final value = item.value as String;
          if (value.startsWith(KeybindingModel.categoryScopePrefix)) {
            model.toggleCategory(value.substring(KeybindingModel.categoryScopePrefix.length));
          }
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.count,
    required this.modified,
    required this.conflict,
    this.dim = false,
  });

  final String label;
  final int count;
  final int modified;
  final bool conflict;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final accent = FluentTheme.of(context).accentColor;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: dim ? .7 : .9)),
          ),
        ),
        if (conflict) ...[Icon(FluentIcons.warning, size: 12, color: kbConflictColor), const SizedBox(width: 6)],
        if (modified > 0) ...[InfoBadge(source: Text('$modified'), color: accent), const SizedBox(width: 6)],
        Text('$count', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .45))),
        const SizedBox(width: 14),
      ],
    );
  }
}
