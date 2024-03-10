import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/conf/const_conf.dart';
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
          makeSettingsItem(const Icon(FluentIcons.link, size: 20), "创建设置快捷方式",
              subTitle: "在桌面创建《SC汉化盒子》快捷方式", onTap: ()=> model.addShortCut(context)),
          if (ConstConf.isMSE) ...[
            const SizedBox(height: 12),
            makeSettingsItem(
                const Icon(FluentIcons.reset_device, size: 20), "重置自动密码填充",
                subTitle:
                    "启用：${sate.isEnableAutoLogin ? "已启用" : "已禁用"}    设备支持：${sate.isDeviceSupportWinHello ? "支持" : "不支持"}     邮箱：${sate.autoLoginEmail}      密码：${sate.isEnableAutoLoginPwd ? "已加密保存" : "未保存"}",
                onTap: ()=> model.onResetAutoLogin(context)),
          ],
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FontAwesomeIcons.microchip, size: 20),
              "启动游戏时忽略能效核心（ 适用于Intel 12th+ 处理器 ） [实验性功能，请随时反馈]",
              subTitle:
                  "已设置的核心数量：${sate.inputGameLaunchECore}   （此功能适用于首页的盒子一键启动 或 工具中的RSI启动器管理员模式，当为 0 时不启用此功能 ）",
              onTap:()=> model.setGameLaunchECore(context)),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.folder_open, size: 20),
              "设置启动器文件（RSI Launcher.exe）",
              subTitle: sate.customLauncherPath != null
                  ? "${sate.customLauncherPath}"
                  : "手动设置启动器位置，建议仅在无法自动扫描安装位置时使用",
              onTap: ()=> model.setLauncherPath(context), onDel: () {
            model.delName("custom_launcher_path");
          }),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.game, size: 20),
              "设置游戏文件 （StarCitizen.exe）",
              subTitle: sate.customGamePath != null
                  ? "${sate.customGamePath}"
                  : "手动设置游戏安装位置，建议仅在无法自动扫描安装位置时使用",
              onTap: ()=> model.setGamePath(context), onDel: () {
            model.delName("custom_game_path");
          }),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.delete, size: 20), "清理汉化文件缓存",
              subTitle:
                  "缓存大小 ${(sate.locationCacheSize / 1024 / 1024).toStringAsFixed(2)}MB，清理盒子下载的汉化文件缓存，不会影响已安装的汉化",
              onTap: ()=> model.cleanLocationCache(context)),
          const SizedBox(height: 12),
          makeSettingsItem(
              const Icon(FluentIcons.speed_high, size: 20), "工具站访问加速",
              onTap: () =>
                  model.onChangeToolSiteMirror(!sate.isEnableToolSiteMirrors),
              subTitle:
                  "使用镜像服务器加速访问 Dps Uex 等工具网站，若访问异常请关闭该功能。 为保护账户安全，任何情况下都不会加速RSI官网。",
              onSwitch: model.onChangeToolSiteMirror,
              switchStatus: sate.isEnableToolSiteMirrors),
          const SizedBox(height: 12),
          makeSettingsItem(
              const Icon(FluentIcons.document_set, size: 20), "查看log",
              onTap: () => model.showLogs(),
              subTitle: "查看汉化盒子的 log 文件，以定位盒子的 bug"),
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
