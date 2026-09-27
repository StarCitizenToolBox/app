import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'import_dialogs.dart';
import 'keybinding_styles.dart';

Future<bool> confirmDiscardChanges(BuildContext context) => showConfirmDialogs(
  context,
  S.current.keybinding_discard_changes,
  Text(S.current.keybinding_discard_changes_confirm),
);

Future<void> showSaveDialog(BuildContext context, KeybindingModel model) async {
  await showDialog(
    context: context,
    builder: (_) => _SaveDialog(model: model),
  );
}

class _SaveDialog extends StatefulWidget {
  const _SaveDialog({required this.model});

  final KeybindingModel model;

  @override
  State<_SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<_SaveDialog> {
  final _name = TextEditingController(
    text: 'sctoolbox_${DateTime.now().toIso8601String().substring(0, 10).replaceAll('-', '')}',
  );
  KbSaveTarget _target = KbSaveTarget.layout;
  bool? _gameRunning;
  bool _saving = false;
  String? _error;

  /// Installed channels (LIVE, PTU, …) and which ones to install into; the current one by default.
  List<String> _channels = const [];
  late final Set<String> _selected = {widget.model.repo.channel};

  @override
  void initState() {
    super.initState();
    widget.model.repo.listSiblingChannels().then((v) {
      if (mounted) setState(() => _channels = v);
    });
    widget.model.isGameRunning().then((v) {
      if (mounted) setState(() => _gameRunning = v);
    });
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  List<String> get _orderedTargets => [
    for (final c in _channels.isEmpty ? [widget.model.repo.channel] : _channels)
      if (_selected.contains(c)) c,
  ];

  String get _safeName => _name.text.trim().replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '_');

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (_target == KbSaveTarget.layout) {
        final targets = _orderedTargets;
        final existing = await widget.model.existingLayouts(_safeName, channels: targets);
        if (!mounted) return;
        if (existing.isNotEmpty &&
            !await showConfirmDialogs(
              context,
              S.current.keybinding_layout_exists_title,
              Text(S.current.keybinding_layout_exists(existing.map((f) => f.path).join('\n'))),
            )) {
          if (mounted) setState(() => _saving = false);
          return;
        }
        final files = await widget.model.exportLayout(_safeName, channels: targets);
        if (!mounted) return;
        closeDialog(context);
        showToast(
          context,
          files.length == 1
              ? S.current.keybinding_export_done(files.single.path, 'pp_RebindKeys $_safeName')
              : S.current.keybinding_export_done_multi(files.length, targets.join(', '), 'pp_RebindKeys $_safeName'),
        );
      } else {
        final running = await widget.model.isGameRunning();
        if (!mounted) return;
        if (running) {
          setState(() {
            _gameRunning = true;
            _saving = false;
          });
          return;
        }
        // Bindings changed in-game after the tool loaded them would be lost; ask first.
        if (_orderedTargets.contains(widget.model.repo.channel) && await widget.model.actionMapsChangedOnDisk()) {
          if (!mounted) return;
          if (!await showConfirmDialogs(
            context,
            S.current.keybinding_disk_changed_title,
            Text(S.current.keybinding_disk_changed(widget.model.repo.backupDir.path)),
          )) {
            if (mounted) setState(() => _saving = false);
            return;
          }
        }
        final targets = _orderedTargets;
        final backups = await widget.model.writeActionMaps(channels: targets);
        if (!mounted) return;
        closeDialog(context);
        showToast(
          context,
          backups.length == 1
              ? S.current.keybinding_write_done(backups.values.single ?? '-')
              : S.current.keybinding_write_done_multi(backups.length, targets.join(', ')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final conflicts = model.conflictCount;
    final muted = TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .62));
    final canWriteLive = _gameRunning == false;
    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 640),
      title: Text(S.current.keybinding_save_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.current.keybinding_save_summary(model.modifiedCount), style: muted),
          if (conflicts > 0) ...[
            const SizedBox(height: 8),
            InfoBar(
              title: Text(S.current.keybinding_save_conflicts(conflicts)),
              severity: InfoBarSeverity.warning,
              isLong: true,
            ),
          ],
          const SizedBox(height: 14),
          RadioGroup<KbSaveTarget>(
            groupValue: _target,
            onChanged: (v) => setState(() => _target = v ?? _target),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RadioButton<KbSaveTarget>(value: KbSaveTarget.layout, content: Text(S.current.keybinding_save_layout)),
                Padding(
                  padding: const EdgeInsets.only(left: 28, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InfoLabel(
                        label: S.current.keybinding_save_layout_name,
                        child: TextBox(controller: _name, enabled: _target == KbSaveTarget.layout),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${model.repo.mappingsDir.path}\\$_safeName.xml',
                        style: muted.copyWith(fontFamily: 'Consolas', fontSize: 11),
                      ),
                      const SizedBox(height: 8),
                      Text(S.current.keybinding_save_layout_hint, style: muted),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              'pp_RebindKeys $_safeName',
                              style: TextStyle(
                                fontFamily: 'Consolas',
                                fontSize: 13,
                                color: FluentTheme.of(context).accentColor.lightest,
                              ),
                            ),
                          ),
                          Button(
                            onPressed: () => Clipboard.setData(ClipboardData(text: 'pp_RebindKeys $_safeName')),
                            child: Text(S.current.keybinding_copy),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                RadioButton<KbSaveTarget>(
                  value: KbSaveTarget.actionMaps,
                  content: Text(S.current.keybinding_save_actionmaps),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _gameRunning == null
                            ? S.current.keybinding_game_checking
                            : (_gameRunning!
                                  ? S.current.keybinding_game_running
                                  : S.current.keybinding_game_not_running),
                        style: TextStyle(
                          fontSize: 12,
                          color: _gameRunning == true
                              ? Colors.warningPrimaryColor
                              : Colors.white.withValues(alpha: .72),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(S.current.keybinding_save_actionmaps_hint(model.repo.backupDir.path), style: muted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_channels.length > 1) ...[
            const SizedBox(height: 16),
            Text(S.current.keybinding_sync_to, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final c in _channels)
                  ToggleButton(
                    style: kbToggleStyle(context),
                    checked: _selected.contains(c),
                    onChanged: (v) => setState(() {
                      // Keep at least one target.
                      if (v) {
                        _selected.add(c);
                      } else if (_selected.length > 1) {
                        _selected.remove(c);
                      }
                    }),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_selected.contains(c)) ...[
                          const Icon(FluentIcons.check_mark, size: 11),
                          const SizedBox(width: 6),
                        ],
                        Text(c),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(S.current.keybinding_sync_hint, style: muted),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            InfoBar(
              title: Text(S.current.keybinding_save_failed),
              content: Text(_error!),
              severity: InfoBarSeverity.error,
              isLong: true,
            ),
          ],
        ],
      ),
      actions: [
        Button(onPressed: () => closeDialog(context), child: Text(S.current.app_common_tip_cancel)),
        FilledButton(
          onPressed: _saving || (_target == KbSaveTarget.layout ? _safeName.isEmpty : !canWriteLive) ? null : _save,
          child: _saving
              ? const SizedBox(width: 16, height: 16, child: ProgressRing(strokeWidth: 2))
              : Text(S.current.keybinding_save),
        ),
      ],
    );
  }
}

Future<void> showRestoreBackupDialog(BuildContext context, KeybindingModel model) async {
  final backups = await model.listBackups();
  if (!context.mounted) return;
  if (backups.isEmpty) {
    await showToast(context, S.current.keybinding_no_backups);
    return;
  }
  final picked = await showDialog<File>(
    context: context,
    builder: (dialogContext) => ContentDialog(
      constraints: const BoxConstraints(maxWidth: 560, maxHeight: 520),
      title: Text(S.current.keybinding_restore_backup),
      content: SizedBox(
        height: 320,
        child: ListView(
          children: [
            for (final f in backups)
              ListTile(
                title: Text(f.uri.pathSegments.last),
                subtitle: Text(f.statSync().modified.toString().substring(0, 19)),
                onPressed: () => closeDialog(dialogContext, f),
              ),
          ],
        ),
      ),
      actions: [Button(onPressed: () => closeDialog(dialogContext), child: Text(S.current.app_common_tip_cancel))],
    ),
  );
  if (picked != null && context.mounted) await showImportFilePreview(context, model, picked, restore: true);
}
