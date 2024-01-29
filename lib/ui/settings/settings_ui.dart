import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/common/conf/app_conf.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui_model.dart';

class SettingUI extends BaseUI<SettingUIModel> {
  @override
  Widget? buildBody(BuildContext context, SettingUIModel model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          makeSettingsItem(const Icon(FluentIcons.link, size: 20), "创建设置快捷方式",
              subTitle: "在桌面创建《SC汉化盒子》快捷方式", onTap: model.addShortCut),
          if (AppConf.isMSE) ...[
            const SizedBox(height: 12),
            makeSettingsItem(
                const Icon(FluentIcons.reset_device, size: 20), "重置自动密码填充",
                subTitle:
                    "启用：${model.isEnableAutoLogin ? "已启用" : "已禁用"}    设备支持：${model.isDeviceSupportWinHello ? "支持" : "不支持"}     邮箱：${model.autoLoginEmail}      密码：${model.isEnableAutoLoginPwd ? "已加密保存" : "未保存"}",
                onTap: model.onResetAutoLogin),
          ],
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FontAwesomeIcons.microchip, size: 20),
              "启动游戏时忽略能效核心（ 适用于Intel 12th+ 处理器 ） [实验性功能，请随时反馈]",
              subTitle:
                  "已设置的核心数量：${model.inputGameLaunchECore}   （此功能适用于首页的盒子一键启动 或 工具中的RSI启动器管理员模式，当为 0 时不启用此功能 ）",
              onTap: model.setGameLaunchECore),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.folder_open, size: 20),
              "设置启动器文件（RSI Launcher.exe）",
              subTitle: model.customLauncherPath != null
                  ? "${model.customLauncherPath}"
                  : "手动设置启动器位置，建议仅在无法自动扫描安装位置时使用",
              onTap: model.setLauncherPath, onDel: () {
            model.delName("custom_launcher_path");
          }),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.game, size: 20),
              "设置游戏文件 （StarCitizen.exe）",
              subTitle: model.customGamePath != null
                  ? "${model.customGamePath}"
                  : "手动设置游戏安装位置，建议仅在无法自动扫描安装位置时使用",
              onTap: model.setGamePath, onDel: () {
            model.delName("custom_game_path");
          }),
          const SizedBox(height: 12),
          makeSettingsItem(const Icon(FluentIcons.delete, size: 20), "清理汉化文件缓存",
              subTitle:
                  "缓存大小 ${(model.locationCacheSize / 1024 / 1024).toStringAsFixed(2)}MB，清理盒子下载的汉化文件缓存，不会影响已安装的汉化",
              onTap: model.cleanLocationCache),
          const SizedBox(height: 12),
          makeSettingsItem(
              const Icon(FluentIcons.internet_sharing, size: 20), "工具站访问加速",
              onTap: () =>
                  model.onChangeToolSiteMirror(!model.isEnableToolSiteMirrors),
              subTitle:
                  "使用镜像服务器加速访问 Dps Uex 等工具网站，若访问异常请关闭该功能。 为保护账户安全，任何情况下都不会加速RSI官网。",
              onSwitch: model.onChangeToolSiteMirror,
              switchStatus: model.isEnableToolSiteMirrors),
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

  @override
  String getUITitle(BuildContext context, SettingUIModel model) => "SettingUI";
}
