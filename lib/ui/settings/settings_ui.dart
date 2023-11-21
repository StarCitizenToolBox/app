import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/common/conf.dart';
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
          if (AppConf.isMSE) ...[
            makeSettingsItem(const Icon(FluentIcons.reset_device), "重置自动密码填充",
                subTitle:
                    "启用：${model.isEnableAutoLogin ? "已启用" : "已禁用"}    设备支持：${model.isDeviceSupportWinHello ? "支持" : "不支持"}     邮箱：${model.autoLoginEmail}      密码：${model.isEnableAutoLoginPwd ? "已加密保存" : "未保存"}",
                onTap: model.onResetAutoLogin),
            const SizedBox(height: 12),
            makeSettingsItem(const Icon(FontAwesomeIcons.microchip),
                "启动游戏时忽略能效核心（ 适用于Intel 12+ 处理器 ）",
                subTitle:
                    "已设置的核心数量：${model.inputGameLaunchECore}    （ 设置需要忽略的处理器的能效心数量，盒子将在使用启动游戏功能时为您修改游戏所运行的CPU参数，当为 0 时不启用此功能 ）",
                onTap: model.setGameLaunchECore),
            const SizedBox(height: 12),
          ],
          makeSettingsItem(
              const Icon(FluentIcons.folder_open), "设置启动器文件（RSI Launcher.exe）",
              subTitle: model.customLauncherPath != null
                  ? "${model.customLauncherPath}"
                  : "手动设置启动器位置，建议仅在无法自动扫描安装位置时使用",
              onTap: model.setLauncherPath,
              onDel: () {
                model.delName("custom_launcher_path");
              }),
          const SizedBox(height: 12),
          makeSettingsItem(
              const Icon(FluentIcons.game), "设置游戏文件 （StarCitizen.exe）",
              subTitle: model.customGamePath != null
                  ? "${model.customGamePath}"
                  : "手动设置游戏安装位置，建议仅在无法自动扫描安装位置时使用",
              onTap: model.setGamePath,
              onDel: () {
                model.delName("custom_game_path");
              }),
        ],
      ),
    );
  }

  Widget makeSettingsItem(Widget icon, String title,
      {String? subTitle, VoidCallback? onTap, VoidCallback? onDel}) {
    return Button(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      icon,
                      const SizedBox(width: 12),
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
              const SizedBox(width: 12),
            ],
            const Icon(FluentIcons.chevron_right),
          ],
        ),
      ),
    );
  }

  @override
  String getUITitle(BuildContext context, SettingUIModel model) => "SettingUI";
}
