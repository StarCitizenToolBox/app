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
    }, []);
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .56,
      ),
      title: (loginState.loginStatus == 2) ? null :  Text(S.current.home_action_one_click_launch),
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
                       Text(S.current.home_title_logging_in),
                      const SizedBox(height: 12),
                      const ProgressRing(),
                      if (loginState.isDeviceSupportWinHello ?? false)
                        const SizedBox(height: 24),
                      Text(
                        S.current.home_info_auto_fill_notice,
                        style: TextStyle(
                            fontSize: 13, color: Colors.white.withOpacity(.6)),
                      )
                    ],
                  ),
                ),
              ] else if (loginState.loginStatus == 2 ||
                  loginState.loginStatus == 3) ...[
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        S.current.home_login_title_welcome_back,
                        style: const TextStyle(fontSize: 20),
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
                      Text(S.current.home_login_title_launching_game),
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