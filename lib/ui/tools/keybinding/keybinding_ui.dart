import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/provider/keybinding.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'widgets/action_list_panel.dart';
import 'widgets/action_detail_panel.dart';

import 'widgets/group_tree_panel.dart';
import 'widgets/keybinding_dialogs.dart';
import 'widgets/keybinding_toolbar.dart';

class KeybindingUI extends HookConsumerWidget {
  const KeybindingUI({super.key, this.gamePath});

  final String? gamePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(keybindingModelProvider);
    final model = ref.read(keybindingModelProvider.notifier);
    final path = gamePath ?? ref.read(toolsUIModelProvider).scInstalledPath;

    // Load whenever the provider has no game yet (first open, or after it was recreated).
    final needsLoad = state.gamePath.isEmpty;
    useEffect(() {
      if (needsLoad) addPostFrameCallback(() => model.load(path));
      return null;
    }, [needsLoad]);

    final dirty = !state.isLoading && state.data != null && model.isDirty;

    return PopScope(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await confirmDiscardChanges(context) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: makeDefaultPage(
        context,
        title: '${S.current.keybinding_title}  ->  $path',
        useBodyContainer: false,
        // context.pop() ignores PopScope; maybePop lets the unsaved-changes prompt run.
        onBack: () => Navigator.maybePop(context),
        content: _buildBody(context, state, model),
      ),
    );
  }

  Widget _buildBody(BuildContext context, KeybindingState state, KeybindingModel model) {
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const ProgressRing(), const SizedBox(height: 16), Text(state.loadingMessage)],
        ),
      );
    }
    if (state.errorMessage != null || state.data == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.error_badge, size: 48, color: Colors.warningPrimaryColor),
            const SizedBox(height: 16),
            Text(S.current.keybinding_load_failed),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                state.errorMessage ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => model.load(state.gamePath), child: Text(S.current.keybinding_retry)),
          ],
        ),
      );
    }
    return Column(
      children: [
        KeybindingToolbar(state: state, model: model, onOpenDevices: () => context.push('/tools/keybinding/devices')),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 12, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 220,
                  child: GroupTreePanel(state: state, model: model),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionListPanel(state: state, model: model),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 300,
                  child: ActionDetailPanel(state: state, model: model),
                ),
              ],
            ),
          ),
        ),
        _StatusBar(state: state, model: model),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.state, required this.model});

  final KeybindingState state;
  final KeybindingModel model;

  @override
  Widget build(BuildContext context) {
    final data = state.data!;
    final dirty = model.isDirty;
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.black.withValues(alpha: .18),
      child: Row(
        children: [
          Text(
            S.current.keybinding_status_source(
              data.gameVersion.isEmpty ? '-' : data.gameVersion,
              model.allActions().length,
              data.language,
            ),
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
          ),
          const Spacer(),
          if (dirty)
            Text(
              S.current.keybinding_status_unsaved(model.modifiedCount),
              style: TextStyle(fontSize: 12, color: FluentTheme.of(context).accentColor.lighter),
            )
          else
            Text(
              S.current.keybinding_status_saved(model.modifiedCount),
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
            ),
        ],
      ),
    );
  }
}
