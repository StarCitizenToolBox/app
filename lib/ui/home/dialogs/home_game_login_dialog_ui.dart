import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'home_game_login_dialog_ui_model.dart';

class HomeGameLoginDialogUI extends HookConsumerWidget {
  const HomeGameLoginDialogUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(homeGameLoginUIModelProvider);
    useEffect(() {
      ref.read(homeGameLoginUIModelProvider.notifier).launchWebLogin(context);
      return null;
    }, const []);
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .56,
      ),
      title: (loginState.loginStatus == 2) ? null : const Text("一键启动"),
      content: AnimatedSize(
        duration: const Duration(milliseconds: 230),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(),
              if (loginState.loginStatus == 0) ...[
                Center(
                  child: Column(
                    children: [
                      const Text("登录中..."),
                      const SizedBox(height: 12),
                      const ProgressRing(),
                      if (loginState.isDeviceSupportWinHello ?? false)
                        const SizedBox(height: 24),
                      Text(
                        "* 若开启了自动填充，请留意弹出的 Windows Hello 窗口",
                        style: TextStyle(
                            fontSize: 13, color: Colors.white.withOpacity(.6)),
                      )
                    ],
                  ),
                ),
              ] else if (loginState.loginStatus == 1) ...[
                Text(
                    "请输入RSI账户 [${loginState.nickname}] 的邮箱，以保存登录状态（输入错误会导致无法进入游戏！）"),
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
              ] else if (loginState.loginStatus == 2 ||
                  loginState.loginStatus == 3) ...[
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        "欢迎回来！",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 24),
                      if (loginState.avatarUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: CacheNetImage(
                            url: loginState.avatarUrl!,
                            width: 128,
                            height: 128,
                            fit: BoxFit.fill,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        loginState.nickname ?? "",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      Text(loginState.loginStatus == 2
                          ? "正在为您启动游戏..."
                          : "正在等待优化CPU参数..."),
                      const SizedBox(height: 12),
                      const ProgressRing(),
                    ],
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
