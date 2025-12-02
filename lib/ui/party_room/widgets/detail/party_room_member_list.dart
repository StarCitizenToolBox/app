import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pb.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/utils/party_room_utils.dart';
import 'package:starcitizen_doctor/widgets/src/cache_image.dart';
import 'package:starcitizen_doctor/generated/l10n.dart';

/// 成员列表侧边栏
class PartyRoomMemberList extends ConsumerWidget {
  final List<RoomMember> members;
  final bool isOwner;
  final PartyRoom partyRoom;

  const PartyRoomMemberList({super.key, required this.members, required this.isOwner, required this.partyRoom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (members.isEmpty) {
      return Center(
        child: Text(S.current.party_room_no_members, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return PartyRoomMemberItem(member: member, isOwner: isOwner, partyRoom: partyRoom);
      },
    );
  }
}

/// 成员列表项
class PartyRoomMemberItem extends ConsumerWidget {
  final RoomMember member;
  final bool isOwner;
  final PartyRoom partyRoom;

  const PartyRoomMemberItem({super.key, required this.member, required this.isOwner, required this.partyRoom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl = PartyRoomUtils.getAvatarUrl(member.avatarUrl);
    final partyRoomState = ref.watch(partyRoomProvider);
    final currentUserId = partyRoomState.auth.userInfo?.gameUserId ?? '';
    final isSelf = member.gameUserId == currentUserId;
    final flyoutController = FlyoutController();

    return FlyoutTarget(
      controller: flyoutController,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: GestureDetector(
          onTapUp: (details) => _showMemberContextMenu(context, member, partyRoom, isOwner, isSelf, flyoutController),
          onSecondaryTapUp: (details) =>
              _showMemberContextMenu(context, member, partyRoom, isOwner, isSelf, flyoutController),
          child: HoverButton(
            onPressed: null,
            builder: (context, states) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: states.isHovered ? const Color(0xFF404249) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    // 头像
                    _buildUserAvatar(member.handleName, avatarUrl: avatarUrl, size: 32, isOwner: isOwner),
                    const SizedBox(width: 8),
                    // 名称和状态
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  member.handleName.isNotEmpty ? member.handleName : member.gameUserId,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: member.isOwner ? const Color(0xFFFAA81A) : const Color(0xFFDBDEE1),
                                    fontWeight: member.isOwner ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (member.isOwner) ...[
                                const SizedBox(width: 4),
                                const Icon(FluentIcons.crown, size: 10, color: Color(0xFFFAA81A)),
                              ],
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  member.status.currentLocation.isNotEmpty ? member.status.currentLocation : '...',
                                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .9)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMemberContextMenu(
    BuildContext context,
    RoomMember member,
    PartyRoom partyRoom,
    bool isOwner,
    bool isSelf,
    FlyoutController controller,
  ) {
    final menuItems = <MenuFlyoutItemBase>[
      // 复制ID - 所有用户可用
      MenuFlyoutItem(
        leading: const Icon(FluentIcons.copy, size: 16),
        text: Text(S.current.party_room_copy_game_id),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: member.gameUserId));
        },
      ),
    ];

    // 房主专属功能 - 不能对自己和其他房主使用
    if (isOwner && !member.isOwner && !isSelf) {
      menuItems.addAll([
        const MenuFlyoutSeparator(),
        MenuFlyoutItem(
          leading: const Icon(FluentIcons.people, size: 16),
          text: Text(S.current.party_room_transfer_owner),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => ContentDialog(
                title: Text(S.current.party_room_transfer_owner),
                content: Text('确定要将房主转移给 ${member.handleName.isNotEmpty ? member.handleName : member.gameUserId} 吗？'),
                actions: [
                  Button(child: Text(S.current.home_action_cancel), onPressed: () => Navigator.pop(context, false)),
                  FilledButton(child: Text(S.current.party_room_transfer), onPressed: () => Navigator.pop(context, true)),
                ],
              ),
            );
            if (confirmed == true && context.mounted) {
              try {
                await partyRoom.transferOwnership(member.gameUserId);
              } catch (e) {
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (context) => ContentDialog(
                      title: Text(S.current.party_room_operation_failed),
                      content: Text('转移房主失败：$e'),
                      actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                    ),
                  );
                }
              }
            }
          },
        ),
        MenuFlyoutItem(
          leading: const Icon(FluentIcons.remove_from_shopping_list, size: 16),
          text: Text(S.current.party_room_kick_member),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => ContentDialog(
                title: Text(S.current.party_room_kick_member),
                content: Text('确定要踢出 ${member.handleName.isNotEmpty ? member.handleName : member.gameUserId} 吗？'),
                actions: [
                  Button(child: Text(S.current.home_action_cancel), onPressed: () => Navigator.pop(context, false)),
                  FilledButton(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xFFDA373C))),
                    child: Text(S.current.party_room_kick),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            );
            if (confirmed == true && context.mounted) {
              try {
                await partyRoom.kickMember(member.gameUserId);
              } catch (e) {
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (context) => ContentDialog(
                      title: Text(S.current.party_room_operation_failed),
                      content: Text('踢出成员失败：$e'),
                      actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
                    ),
                  );
                }
              }
            }
          },
        ),
      ]);
    }

    controller.showFlyout(
      autoModeConfiguration: FlyoutAutoConfiguration(preferredMode: FlyoutPlacementMode.bottomCenter),
      barrierColor: Colors.transparent,
      builder: (context) {
        return MenuFlyout(items: menuItems);
      },
    );
  }

  Widget _buildUserAvatar(String memberName, {String? avatarUrl, bool isOwner = false, double size = 32}) {
    final avatarWidget = SizedBox(
      width: size,
      height: size,
      child: avatarUrl == null
          ? CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF5865F2),
              child: Text(
                memberName.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CacheNetImage(url: avatarUrl),
            ),
    );
    return avatarWidget;
  }
}