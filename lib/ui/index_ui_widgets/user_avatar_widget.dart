import 'package:fixnum/fixnum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';
import 'package:starcitizen_doctor/ui/party_room/utils/party_room_utils.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

class UserAvatarWidget extends HookConsumerWidget {
  final VoidCallback onTapNavigateToPartyRoom;

  const UserAvatarWidget({super.key, required this.onTapNavigateToPartyRoom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final uiState = ref.watch(partyRoomUIModelProvider);
    final isLoggedIn = partyRoomState.auth.isLoggedIn;
    final userName = partyRoomState.auth.userInfo?.gameUserId ?? S.current.user_not_logged_in;
    final avatarUrl = partyRoomState.auth.userInfo?.avatarUrl;
    final enlistedDate = partyRoomState.auth.userInfo?.enlistedDate;
    final fullAvatarUrl = PartyRoomUtils.getAvatarUrl(avatarUrl);
    return HoverButton(
      onPressed: () {
        if (isLoggedIn) {
          _showAccountCard(context, ref, userName, fullAvatarUrl, enlistedDate);
        } else {
          onTapNavigateToPartyRoom();
        }
      },
      builder: (BuildContext context, Set<WidgetState> states) {
        return Container(
          decoration: BoxDecoration(
            color: states.isHovered ? Colors.white.withValues(alpha: .1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 头像
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isLoggedIn ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: .3), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: uiState.isLoggingIn
                      ? const Padding(padding: EdgeInsets.all(4), child: ProgressRing(strokeWidth: 2))
                      : (fullAvatarUrl != null
                      ? CacheNetImage(url: fullAvatarUrl, fit: BoxFit.cover)
                      : Center(
                    child: Icon(
                      isLoggedIn ? FluentIcons.contact : FluentIcons.unknown,
                      size: 16,
                      color: Colors.white,
                    ),
                  )),
                ),
              ),
              const SizedBox(width: 8),
              // 用户名
              Text(
                uiState.isLoggingIn ? S.current.home_title_logging_in : userName,
                style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: isLoggedIn ? 1.0 : .6)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAccountCard(BuildContext context, WidgetRef ref, String userName, String? avatarUrl, Int64? enlistedDate) {
    final targetContext = context;
    final box = targetContext.findRenderObject() as RenderBox?;
    final offset = box?.localToGlobal(Offset.zero) ?? Offset.zero;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return Stack(
          children: [
            // 透明遮罩，点击关闭
            GestureDetector(
              onTap: () => Navigator.of(dialogContext).pop(),
              child: Container(color: Colors.transparent),
            ),
            // 账户卡片
            Positioned(
              left: offset.dx - 100,
              top: offset.dy + (box?.size.height ?? 0) + 8,
              child: Container(
                width: 360,
                decoration: BoxDecoration(
                  color: FluentTheme
                      .of(context)
                      .micaBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: .1), width: 1),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: .3), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 用户信息
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(24)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: avatarUrl != null
                                  ? CacheNetImage(url: avatarUrl, fit: BoxFit.cover)
                                  : const Center(child: Icon(FluentIcons.contact, size: 24, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '注册时间：${PartyRoomUtils.formatDateTime(enlistedDate)}',
                                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .6)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      // 注销按钮
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            await _handleUnregister(context, ref);
                          },
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
                          child: Text(S.current.user_action_unregister, style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleUnregister(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialogs(
      context,
      S.current.user_confirm_unregister_title,
      Text(S.current.user_confirm_unregister_message),
      constraints: const BoxConstraints(maxWidth: 400),
    );

    if (confirmed == true) {
      try {
        final partyRoom = ref.read(partyRoomProvider.notifier);
        await partyRoom.unregister();
        if (context.mounted) {
          showToast(context, S.current.user_unregister_success);
        }
      } catch (e) {
        if (context.mounted) {
          showToast(context, '${S.current.user_unregister_failed}: $e');
        }
      }
    }
  }
}
