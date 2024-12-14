import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui_model.dart';
import 'package:starcitizen_doctor/ui/tools/tools_ui_model.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GuideUI extends HookConsumerWidget {
  const GuideUI({super.key});

  static const version = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolsState = ref.watch(toolsUIModelProvider);
    final toolsModel = ref.read(toolsUIModelProvider.notifier);

    final settingModel = ref.read(settingsUIModelProvider.notifier);

    useEffect(() {
      addPostFrameCallback(() {
        toolsModel.reScanPath(context, checkActive: true, skipToast: true);
      });
      return null;
    }, []);

    return makeDefaultPage(
      context,
      automaticallyImplyLeading: false,
      titleRow: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          children: [
            Image.asset(
              "assets/app_logo_mini.png",
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Text(
              S.current.app_index_version_info(
                  ConstConf.appVersion, ConstConf.isMSE ? "" : " Dev"),
            )
          ],
        ),
      ),
      content: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/app_logo.png", width: 192, height: 192),
            SizedBox(height: 12),
            Text(
              S.current.guide_title_welcome,
              style: TextStyle(
                fontSize: 38,
              ),
            ),
            SizedBox(height: 24),
            Text(S.current.guide_info_check_settings),
            SizedBox(height: 32),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          makeGameLauncherPathSelect(
                              context, toolsModel, toolsState, settingModel),
                          const SizedBox(height: 12),
                          makeGamePathSelect(
                              context, toolsModel, toolsState, settingModel),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Button(
                      onPressed: () => toolsModel.reScanPath(context,
                          checkActive: true, skipToast: true),
                      child: const Padding(
                        padding: EdgeInsets.only(
                            top: 30, bottom: 30, left: 12, right: 12),
                        child: Icon(FluentIcons.refresh),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.guide_info_game_download_note,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: .6)),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 38),
            Row(
              children: [
                Spacer(),
                Button(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(S.current.guide_action_get_help),
                  ),
                  onPressed: () {
                    launchUrlString(URLConf.feedbackFAQUrl);
                  },
                ),
                SizedBox(width: 24),
                FilledButton(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(S.current.guide_action_complete_setup),
                  ),
                  onPressed: () async {
                    if (toolsState.rsiLauncherInstallPaths.isEmpty) {
                      final ok = await showConfirmDialogs(
                          context,
                          S.current.guide_dialog_confirm_complete_setup,
                          Text(S.current
                              .guide_action_info_no_launcher_path_warning));
                      if (!ok) return;
                    }
                    if (toolsState.scInstallPaths.isEmpty) {
                      if (!context.mounted) return;
                      final ok = await showConfirmDialogs(
                          context,
                          S.current.guide_dialog_confirm_complete_setup,
                          Text(S
                              .current.guide_action_info_no_game_path_warning));
                      if (!ok) return;
                    }
                    final appConf = await Hive.openBox("app_conf");
                    await appConf.put("guide_version", version);
                    if (!context.mounted) return;
                    context.pop();
                  },
                ),
                SizedBox(width: 32),
              ],
            ),
            SizedBox(height: 128),
          ],
        ),
      ),
    );
  }

  Widget makeGameLauncherPathSelect(BuildContext context, ToolsUIModel model,
      ToolsUIState state, SettingsUIModel settingModel) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.current.tools_info_rsi_launcher_location),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ComboBox<String>(
              isExpanded: true,
              value: state.rsiLauncherInstalledPath,
              items: [
                for (final path in state.rsiLauncherInstallPaths)
                  ComboBoxItem(
                    value: path,
                    child: Text(path),
                  )
              ],
              onChanged: (v) {
                model.onChangeLauncherPath(v!);
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Button(
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(FluentIcons.folder_search),
          ),
          onPressed: () async {
            await settingModel.setLauncherPath(context);
            if (!context.mounted) return;
            model.reScanPath(context, checkActive: true, skipToast: true);
          },
        ),
      ],
    );
  }

  Widget makeGamePathSelect(BuildContext context, ToolsUIModel model,
      ToolsUIState state, SettingsUIModel settingModel) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.current.tools_info_game_install_location),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 36,
            child: ComboBox<String>(
              isExpanded: true,
              value: state.scInstalledPath,
              items: [
                for (final path in state.scInstallPaths)
                  ComboBoxItem(
                    value: path,
                    child: Text(path),
                  )
              ],
              onChanged: (v) {
                model.onChangeGamePath(v!);
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Button(
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(FluentIcons.folder_search),
            ),
            onPressed: () async {
              await settingModel.setGamePath(context);
              if (!context.mounted) return;
              model.reScanPath(context, checkActive: true, skipToast: true);
            })
      ],
    );
  }
}
