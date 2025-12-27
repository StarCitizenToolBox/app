import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/auth/auth_ui_model.dart';
import 'package:starcitizen_doctor/ui/party_room/utils/party_room_utils.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AuthPage extends HookConsumerWidget {
  final String? callbackUrl;
  final String? stateParameter;
  final String? nonce;

  const AuthPage({super.key, this.callbackUrl, this.stateParameter, this.nonce});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = authUIModelProvider(callbackUrl: callbackUrl, stateParameter: stateParameter, nonce: nonce);
    final model = ref.watch(provider);
    final modelNotifier = ref.read(provider.notifier);

    final partyRoomState = ref.watch(partyRoomProvider);
    final userName = partyRoomState.auth.userInfo?.handleName ?? '未知用户';
    final userEmail = partyRoomState.auth.userInfo?.gameUserId ?? ''; // Using gameUserId as email-like identifier
    final avatarUrl = partyRoomState.auth.userInfo?.avatarUrl;
    final fullAvatarUrl = PartyRoomUtils.getAvatarUrl(avatarUrl);

    useEffect(() {
      Future.microtask(() => modelNotifier.initialize());
      return null;
    }, const []);

    return ContentDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
      // Remove standard title to customize layout
      title: const SizedBox.shrink(),
      content: _buildBody(context, model, modelNotifier, userName, userEmail, fullAvatarUrl),
      actions: [
        if (model.error == null && model.isLoggedIn) ...[
          // Cancel button
          Button(onPressed: () => Navigator.of(context).pop(), child: const Text('拒绝')),
          // Allow button (Primary)
          FilledButton(
            onPressed: model.isLoading ? null : () => _handleAuthorize(context, ref, false),
            child: const Text('允许'),
          ),
        ] else ...[
          Button(onPressed: () => Navigator.of(context).pop(), child: const Text('关闭')),
        ],
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    AuthUIState state,
    AuthUIModel model,
    String userName,
    String userEmail,
    String? avatarUrl,
  ) {
    if (state.isLoading) {
      return const SizedBox(height: 300, child: Center(child: ProgressRing()));
    }

    if (state.isWaitingForConnection) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [const ProgressRing(), const SizedBox(height: 24)]),
        ),
      );
    }

    if (state.error != null) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FluentIcons.error_badge, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => model.initialize(), child: const Text('重试')),
            ],
          ),
        ),
      );
    }

    if (!state.isLoggedIn) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FluentIcons.warning, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              const Text('您需要先登录才能授权', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('前往登录')),
            ],
          ),
        ),
      );
    }

    final name = state.domainName ?? state.domain ?? '未知应用';
    final domain = state.domain;
    final isTrusted = state.isDomainTrusted;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          // Title
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 20, color: Colors.white.withValues(alpha: 0.95), fontFamily: 'Segoe UI'),
              children: [
                TextSpan(
                  text: name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' 申请访问您的账户'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (domain != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.domainName != null)
                    Text(domain, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5))),
                  if (state.domainName != null) const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (isTrusted ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: (isTrusted ? Colors.green : Colors.orange).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isTrusted ? FluentIcons.completed : FluentIcons.warning,
                          size: 10,
                          color: isTrusted ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isTrusted ? '已认证' : '未验证',
                          style: TextStyle(
                            fontSize: 10,
                            color: isTrusted ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // 2. User Account Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: avatarUrl != null
                        ? CacheNetImage(url: avatarUrl, fit: BoxFit.cover)
                        : const Icon(FluentIcons.contact, size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  userEmail.isNotEmpty ? userEmail : userName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Align(
            alignment: Alignment.centerLeft,
            child: Text('此操作将允许 $domain：', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 16),

          _buildPermissionItem(FluentIcons.contact_info, '访问您的公开资料', '包括用户名、头像'),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleAuthorize(BuildContext context, WidgetRef ref, bool copyOnly) async {
    final provider = authUIModelProvider(callbackUrl: callbackUrl, stateParameter: stateParameter, nonce: nonce);
    final modelNotifier = ref.read(provider.notifier);
    final model = ref.read(provider);

    // First, generate the code if not already generated
    if (model.code == null) {
      final success = await modelNotifier.generateCodeOnConfirm();
      if (!success) {
        if (context.mounted) {
          final currentState = ref.read(provider);
          await showToast(context, currentState.error ?? '生成授权码失败');
        }
        return;
      }
    }

    final authUrl = modelNotifier.getAuthorizationUrl();
    if (authUrl == null) {
      if (context.mounted) {
        await showToast(context, '生成授权链接失败');
      }
      return;
    }

    if (copyOnly) {
      await modelNotifier.copyAuthorizationUrl();
      if (context.mounted) {
        await showToast(context, '授权链接已复制到剪贴板');
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    } else {
      try {
        final launched = await launchUrlString(authUrl);
        if (!launched) {
          if (context.mounted) {
            await showToast(context, '打开浏览器失败，请复制链接手动访问');
          }
          return;
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          await showToast(context, '打开浏览器失败: $e');
        }
      }
    }
  }
}
