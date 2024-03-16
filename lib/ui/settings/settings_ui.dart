import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui_model.dart';

class SettingsUI extends HookConsumerWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sate = ref.watch(settingsUIModelProvider);
    final model = ref.read(settingsUIModelProvider.notifier);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          makeSettingsItem(const Icon(FluentIcons.link, size: 20),
              S.current.setting_action_create_settings_shortcut,
              subTitle: S.current.setting_action_create_desktop_shortcut,
              onTap: () => model.addShortCut(context)),
          if (ConstConf.isMSE) ...[
            const SizedBox(height: 12),
            makeSettingsItem(const Icon(FluentIcons.reset_device, size: 20),
                S.current.setting_action_reset_auto_password_fill,
                subTitle: S.current.setting_action_info_device_support_info(
                    sate.isEnableAutoLogin
                        ? S.current.setting_action_info_enabled
                        : S.current.setting_action_info_disabled,
                    sate.isDeviceSupportWinHello
                        ? S.current.setting_action_info_support
                        : S.current.setting_action_info_not_support,
                    sate.autoLoginEmail,
                    sate.isEnableAutoLoginPwd
                        ? S.current.setting_action_info_encrypted_saved
                        : S.current.setting_action_info_not_saved),
                onTap: () => model.onResetAutoLogin(context)),
          ],
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FontAwesomeIcons.microchip, size: 20),
              S.current.setting_action_ignore_efficiency_cores_on_launch,
              subTitle: S.current
                  .setting_action_set_core_count(sate.inputGameLaunchECore),
              onTap: () => model.setGameLaunchECore(context)),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.folder_open, size: 20),
              S.current.setting_action_set_launcher_file,
              subTitle: sate.customLauncherPath != null
                  ? "${sate.customLauncherPath}"
                  : S.current
                      .setting_action_info_manual_launcher_location_setting,
              onTap: () => model.setLauncherPath(context),
              onDel: () {
                model.delName("custom_launcher_path");
              }),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.game, size: 20),
              S.current.setting_action_set_game_file,
              subTitle: sate.customGamePath != null
                  ? "${sate.customGamePath}"
                  : S.current.setting_action_info_manual_game_location_setting,
              onTap: () => model.setGamePath(context),
              onDel: () {
                model.delName("custom_game_path");
              }),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.delete, size: 20),
              S.current.setting_action_clear_translation_file_cache,
              subTitle: S.current.setting_action_info_cache_clearing_info(
                  (sate.locationCacheSize / 1024 / 1024).toStringAsFixed(2)),
              onTap: () => model.cleanLocationCache(context)),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.speed_high, size: 20),
              S.current.setting_action_tool_site_access_acceleration,
              onTap: () =>
                  model.onChangeToolSiteMirror(!sate.isEnableToolSiteMirrors),
              subTitle: S.current.setting_action_info_mirror_server_info,
              onSwitch: model.onChangeToolSiteMirror,
              switchStatus: sate.isEnableToolSiteMirrors),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.document_set, size: 20),
              S.current.setting_action_view_log,
              onTap: () => model.showLogs(),
              subTitle: S.current.setting_action_info_view_log_file),
        ],
      ),
    );
  }

  Widget makeSettingsItem(Widget icon, String title,
      {String? subTitle,
      VoidCallback? onTap,
      VoidCallback? onDel,
      void Function(bool? b)? onSwitch,
      bool switchStatus = false}) {
    return Button(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title),
                      const Spacer(),
                    ],
                  ),
                  if (subTitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subTitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(.6)),
                    )
                  ]
                ],
              ),
            ),
            if (onDel != null) ...[
              Button(
                  onPressed: onDel,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(FluentIcons.delete),
                  )),
            ],
            if (onSwitch != null) ...[
              ToggleSwitch(checked: switchStatus, onChanged: onSwitch),
            ],
            const SizedBox(width: 12),
            const Icon(FluentIcons.chevron_right),
          ],
        ),
      ),
    );
  }
}
