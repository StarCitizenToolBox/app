import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_binding_resolver.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_keybinding_repository.dart';
import 'package:starcitizen_doctor/common/keybinding/sc_profile_document.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'binding_chip.dart';
import 'keybinding_styles.dart';
import 'keybinding_text.dart';

/// Lists the game's own layouts; picking one opens the change preview.
Future<void> showPresetPicker(BuildContext context, KeybindingModel model) async {
  final preset = await showDialog<ScPreset>(
    context: context,
    builder: (_) => _PresetPicker(model: model),
  );
  if (preset == null || !context.mounted) return;
  await showImportPreview(
    context,
    model,
    title: model.presetLabel(preset),
    subtitle: model.presetDescription(preset),
    incoming: preset.document.readRebinds(),
    presetSticks: preset.joysticks,
  );
}

/// Reads a layout / profile file and opens the change preview for it.
/// Previews importing [file]. With [restore] (a backup of actionmaps.xml) the whole profile comes
/// back, including stick numbering and axis settings, not just the bindings.
Future<void> showImportFilePreview(
  BuildContext context,
  KeybindingModel model,
  File file, {
  bool restore = false,
}) async {
  final ScProfileDocument doc;
  try {
    doc = await model.repo.readLayout(file);
  } catch (e) {
    if (context.mounted) await showToast(context, S.current.keybinding_import_failed(e));
    return;
  }
  if (!context.mounted) return;
  await showImportPreview(
    context,
    model,
    title: file.uri.pathSegments.last,
    subtitle: restore ? S.current.keybinding_restore_hint : null,
    incoming: doc.readRebinds(),
    restoreProfile: restore ? doc : null,
  );
}

/// Shows exactly what an import would change and applies it only on confirm.
Future<void> showImportPreview(
  BuildContext context,
  KeybindingModel model, {
  required String title,
  String? subtitle,
  required ScRebindMap incoming,
  Map<int, String> presetSticks = const {},
  ScProfileDocument? restoreProfile,
}) async {
  await showDialog(
    context: context,
    builder: (_) => _ImportPreview(
      model: model,
      title: title,
      subtitle: subtitle,
      incoming: incoming,
      presetSticks: presetSticks,
      restoreProfile: restoreProfile,
    ),
  );
}

class _PresetPicker extends StatefulWidget {
  const _PresetPicker({required this.model});

  final KeybindingModel model;

  @override
  State<_PresetPicker> createState() => _PresetPickerState();
}

class _PresetPickerState extends State<_PresetPicker> {
  List<ScPreset>? _presets;
  bool _readingP4k = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.model
        .listPresets(onStep: (step) => mounted ? setState(() => _readingP4k = step == 'p4k') : null)
        .then((v) {
          if (mounted) setState(() => _presets = v);
        })
        .catchError((Object e) {
          if (mounted) setState(() => _error = e.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final muted = TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6));
    final presets = _presets;
    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 620, maxHeight: 620),
      title: Text(S.current.keybinding_preset_title),
      content: SizedBox(
        height: 420,
        child: _error != null
            ? InfoBar(
                title: Text(S.current.keybinding_load_failed),
                content: Text(_error!),
                severity: InfoBarSeverity.error,
                isLong: true,
              )
            : presets == null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ProgressRing(),
                    const SizedBox(height: 12),
                    Text(_readingP4k ? S.current.keybinding_preset_reading : S.current.keybinding_loading_game_data),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.only(right: 12),
                children: [
                  for (final p in presets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        title: Text(model.presetLabel(p)),
                        subtitle: Text(
                          [
                            if (model.presetDescription(p) case final d? when d.isNotEmpty) d,
                            if (p.joysticks.isNotEmpty)
                              p.joysticks.entries.map((e) => 'js${e.key} ${e.value}').join(' · '),
                            p.fileName,
                          ].join('\n'),
                          style: muted,
                        ),
                        onPressed: () => closeDialog(context, p),
                      ),
                    ),
                ],
              ),
      ),
      actions: [Button(onPressed: () => closeDialog(context), child: Text(S.current.app_common_tip_cancel))],
    );
  }
}

class _ImportPreview extends StatefulWidget {
  const _ImportPreview({
    required this.model,
    required this.title,
    required this.subtitle,
    required this.incoming,
    required this.presetSticks,
    this.restoreProfile,
  });

  /// Set when restoring a backup: applying brings back the whole file, not just bindings.
  final ScProfileDocument? restoreProfile;

  final KeybindingModel model;
  final String title;
  final String? subtitle;
  final ScRebindMap incoming;
  final Map<int, String> presetSticks;

  @override
  State<_ImportPreview> createState() => _ImportPreviewState();
}

class _ImportPreviewState extends State<_ImportPreview> {
  bool _merge = false;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final muted = TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6));
    final all = model.previewImport(widget.incoming, merge: _merge);
    final q = _query.trim().toLowerCase();
    final changes = q.isEmpty
        ? all
        : all.where((c) {
            return model.actionLabel(c.action).toLowerCase().contains(q) ||
                c.action.name.toLowerCase().contains(q) ||
                (c.after.input?.toXml().toLowerCase().contains(q) ?? false) ||
                (c.before.input?.toXml().toLowerCase().contains(q) ?? false);
          }).toList();
    final sticks = model.joysticks;
    final stickMismatch = widget.presetSticks.entries
        .where((e) => sticks[e.key] != null && sticks[e.key]!.name.isNotEmpty && sticks[e.key]!.name != e.value)
        .toList();

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 820, maxHeight: 720),
      title: Text(S.current.keybinding_import_preview_title(widget.title)),
      content: SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.subtitle case final s? when s.isNotEmpty) ...[Text(s, style: muted), const SizedBox(height: 8)],
            if (stickMismatch.isNotEmpty) ...[
              InfoBar(
                title: Text(S.current.keybinding_import_stick_mismatch),
                content: Text(stickMismatch.map((e) => 'js${e.key}: ${e.value} ≠ ${sticks[e.key]!.name}').join('\n')),
                severity: InfoBarSeverity.warning,
                isLong: true,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.restoreProfile == null)
              Row(
                children: [
                  KbSegmented<bool>(
                    value: _merge,
                    items: [(false, S.current.keybinding_import_replace), (true, S.current.keybinding_import_merge)],
                    onChanged: (v) => setState(() => _merge = v),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _merge ? S.current.keybinding_import_merge_hint : S.current.keybinding_import_replace_hint,
                      style: muted,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(S.current.keybinding_import_change_count(all.length), style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextBox(
                    placeholder: S.current.keybinding_search_hint,
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(FluentIcons.search, size: 12),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: all.isEmpty
                  ? Center(child: Text(S.current.keybinding_import_no_change, style: muted))
                  : SuperListView.builder(
                      padding: const EdgeInsets.only(right: 12),
                      itemCount: changes.length,
                      itemBuilder: (context, i) => _ChangeRow(change: changes[i], model: model),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        Button(onPressed: () => closeDialog(context), child: Text(S.current.app_common_tip_cancel)),
        FilledButton(
          // A restore may only change stick numbering / axis settings, so it is never "no change".
          onPressed: all.isEmpty && widget.restoreProfile == null
              ? null
              : () {
                  if (widget.restoreProfile case final doc?) {
                    model.restoreProfile(doc);
                  } else {
                    model.applyImport(widget.incoming, merge: _merge);
                  }
                  closeDialog(context);
                },
          child: Text(S.current.keybinding_import_apply(all.length)),
        ),
      ],
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.change, required this.model});

  final KbChange change;
  final KeybindingModel model;

  Widget _chip(ScSlot slot) {
    final input = slot.input;
    if (input == null) {
      return BindingChip(
        text: slot.defaultInput == null ? S.current.keybinding_state_unbound : model.formatInput(slot.defaultInput!),
        style: slot.defaultInput == null ? BindingChipStyle.none : BindingChipStyle.cleared,
      );
    }
    return BindingChip(text: model.formatInput(input), style: bindingChipStyleOf(slot));
  }

  String _mode(ScSlot s) => activationModeShortLabel(s.activationMode, change.action);

  @override
  Widget build(BuildContext context) {
    final c = change;
    final modeChanged = c.before.activationMode != c.after.activationMode;
    final muted = TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: .5));
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .03), borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.actionLabel(c.action), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${model.groupLabelOf(c.action)} · ${deviceLabel(c.device)}', style: muted),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Flexible(child: _chip(c.before)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(FluentIcons.forward, size: 12)),
                Flexible(child: _chip(c.after)),
                if (modeChanged) ...[
                  const SizedBox(width: 8),
                  Text('${_mode(c.before)} → ${_mode(c.after)}', style: muted),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
