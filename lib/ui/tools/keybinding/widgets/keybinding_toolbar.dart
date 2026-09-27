import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'binding_chip.dart';

import 'import_dialogs.dart';
import 'keybinding_dialogs.dart';
import 'keybinding_styles.dart';

class KeybindingToolbar extends HookWidget {
  const KeybindingToolbar({super.key, required this.state, required this.model, required this.onOpenDevices});

  final KeybindingState state;
  final KeybindingModel model;
  final VoidCallback onOpenDevices;

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController(text: state.query);
    useEffect(() {
      if (search.text != state.query) search.text = state.query;
      return null;
    }, [state.query]);

    final modified = model.modifiedCount;
    final conflicts = model.conflictCount;
    final joysticks = state.joysticks.values.toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: Row(
        children: [
          DropDownButton(
            leading: const Icon(FluentIcons.settings, size: 14),
            title: Text(S.current.keybinding_profile_menu),
            items: [
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.game),
                text: Text(S.current.keybinding_import_preset),
                onPressed: () => _afterMenuCloses(() => showPresetPicker(context, model)),
              ),
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.download),
                text: Text(S.current.keybinding_import_layout),
                onPressed: () => _afterMenuCloses(() => _importLayout(context)),
              ),
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.history),
                text: Text(S.current.keybinding_restore_backup),
                onPressed: () => _afterMenuCloses(() => showRestoreBackupDialog(context, model)),
              ),
              const MenuFlyoutSeparator(),
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.undo),
                text: Text(S.current.keybinding_discard_changes),
                onPressed: model.isDirty
                    ? () => _afterMenuCloses(() async {
                        if (await confirmDiscardChanges(context)) model.discardChanges();
                      })
                    : null,
              ),
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.reset),
                text: Text(S.current.keybinding_reset_all),
                onPressed: () => _afterMenuCloses(() async {
                  if (await showConfirmDialogs(
                    context,
                    S.current.keybinding_reset_all,
                    Text(S.current.keybinding_reset_all_confirm),
                  )) {
                    model.resetAllToDefaults();
                  }
                }),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextBox(
              controller: search,
              placeholder: S.current.keybinding_search_hint,
              prefix: const Padding(padding: EdgeInsets.only(left: 10), child: Icon(FluentIcons.search, size: 14)),
              suffix: state.query.isEmpty
                  ? null
                  : IconButton(icon: const Icon(FluentIcons.clear, size: 12), onPressed: () => model.setQuery('')),
              onChanged: model.setQuery,
            ),
          ),
          const SizedBox(width: 10),
          KbSegmented<KeybindingDeviceFilter>(
            value: state.deviceFilter,
            items: [for (final f in KeybindingDeviceFilter.values) (f, _filterLabel(f))],
            onChanged: (f) {
              model.setJoystickInstanceFilter(null);
              model.setDeviceFilter(f);
            },
          ),
          // Dual-stick setups: narrow the joystick view to one stick.
          if (state.deviceFilter == KeybindingDeviceFilter.joystick && joysticks.length > 1) ...[
            const SizedBox(width: 6),
            ComboBox<int>(
              value: state.joystickInstanceFilter ?? 0,
              items: [
                ComboBoxItem(value: 0, child: Text(S.current.keybinding_all_sticks)),
                for (final js in joysticks)
                  ComboBoxItem(
                    value: js.instance,
                    child: Text(js.alias.isEmpty ? 'JS${js.instance}' : 'JS${js.instance} ${js.alias}'),
                  ),
              ],
              onChanged: (v) => model.setJoystickInstanceFilter(v == null || v == 0 ? null : v),
            ),
          ],
          const SizedBox(width: 6),
          ToggleButton(
            style: kbToggleStyle(context),
            checked: state.onlyModified,
            onChanged: (_) => model.toggleOnlyModified(),
            child: Row(
              children: [
                Text(S.current.keybinding_only_modified),
                const SizedBox(width: 6),
                InfoBadge(source: Text('$modified'), color: FluentTheme.of(context).accentColor),
              ],
            ),
          ),
          const SizedBox(width: 6),
          ToggleButton(
            style: kbToggleStyle(context, tint: kbConflictColor),
            checked: state.onlyConflicts,
            onChanged: (_) => model.toggleOnlyConflicts(),
            child: Row(
              children: [
                Icon(FluentIcons.warning, size: 13, color: conflicts > 0 ? kbConflictColor : null),
                const SizedBox(width: 6),
                Text(S.current.keybinding_conflicts),
                const SizedBox(width: 6),
                InfoBadge(source: Text('$conflicts'), color: conflicts > 0 ? kbConflictColor : Colors.grey[100]),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Button(
            style: kbGhostButtonStyle(context),
            onPressed: onOpenDevices,
            child: Row(
              children: [
                const Icon(FluentIcons.game, size: 14),
                const SizedBox(width: 6),
                Text(S.current.keybinding_devices),
              ],
            ),
          ),
          const SizedBox(width: 6),
          FilledButton(
            onPressed: () => showSaveDialog(context, model),
            child: Row(
              children: [
                const Icon(FluentIcons.save, size: 14),
                const SizedBox(width: 6),
                Text(S.current.keybinding_save),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _filterLabel(KeybindingDeviceFilter f) => switch (f) {
    KeybindingDeviceFilter.all => S.current.keybinding_filter_all,
    KeybindingDeviceFilter.keyboard => S.current.keybinding_filter_keyboard,
    KeybindingDeviceFilter.joystick => S.current.keybinding_filter_joystick,
    KeybindingDeviceFilter.gamepad => S.current.keybinding_filter_gamepad,
  };

  /// Menu items open dialogs only after the flyout has closed; opening one straight from the item
  /// leaves the flyout stuck open underneath.
  void _afterMenuCloses(VoidCallback action) => WidgetsBinding.instance.addPostFrameCallback((_) => action());

  Future<void> _importLayout(BuildContext context) async {
    final dir = model.repo.mappingsDir;
    final result = await FilePicker.pickFiles(
      dialogTitle: S.current.keybinding_import_layout,
      initialDirectory: await dir.exists() ? dir.path : null,
      type: FileType.custom,
      allowedExtensions: ['xml'],
    );
    final path = result.firstOrNull?.path;
    if (path == null || !context.mounted) return;
    await showImportFilePreview(context, model, File(path));
  }
}
