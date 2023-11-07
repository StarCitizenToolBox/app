import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/widgets/cache_image.dart';

import 'login_dialog_ui_model.dart';

class LoginDialog extends BaseUI<LoginDialogModel> {
  @override
  Widget? buildBody(BuildContext context, LoginDialogModel model) {
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .56,
      ),
      title: (model.loginStatus == 2) ? null : const Text("一键启动"),
      content: AnimatedSize(
        duration: const Duration(milliseconds: 230),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(),
            if (model.loginStatus == 0) ...[
              Center(
                child: Column(
                  children: [
                    const Text("登录中..."),
                    const SizedBox(height: 12),
                    const ProgressRing(),
                    if (model.isDeviceSupportWinHello)
                      const SizedBox(height: 24),
                    Text(
                      "* 若开启了自动填充，请留意弹出的 Windows Hello 窗口",
                      style: TextStyle(
                          fontSize: 13, color: Colors.white.withOpacity(.6)),
                    )
                  ],
                ),
              ),
            ] else if (model.loginStatus == 1) ...[
              Text("请输入RSI账户 [${model.nickname}] 的邮箱，以保存登录状态（输入错误会导致无法进入游戏！）"),
              const SizedBox(height: 12),
              TextFormBox(
                  // controller: model.emailCtrl,
                  ),
              const SizedBox(height: 6),
              Text(
                "*该操作同一账号只需执行一次，输入错误请在盒子设置中清理，切换账号请在汉化浏览器中操作。",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(.6),
                ),
              )
            ] else if (model.loginStatus == 2) ...[
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      "欢迎回来！",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 24),
                    if (model.avatarUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: CacheNetImage(
                          url: model.avatarUrl!,
                          width: 128,
                          height: 128,
                          fit: BoxFit.fill,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      model.nickname,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    const Text("正在为您启动游戏..."),
                    const SizedBox(height: 12),
                    const ProgressRing(),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
      actions: const [
        // if (model.loginStatus == 1) ...[
        //   Button(
        //       child: const Padding(
        //         padding: EdgeInsets.all(4),
        //         child: Text("取消"),
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       }),
        //   const SizedBox(width: 80),
        //   FilledButton(
        //       child: const Padding(
        //         padding: EdgeInsets.all(4),
        //         child: Text("保存"),
        //       ),
        //       onPressed: () => model.onSaveEmail()),
        // ],
      ],
    );
  }

  @override
  String getUITitle(BuildContext context, LoginDialogModel model) => "";
}
