import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pb.dart' as partroom;
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pb.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';
import 'package:starcitizen_doctor/widgets/src/cache_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// 房间详情页面 (Discord 样式)
class PartyRoomDetailPage extends ConsumerStatefulWidget {
  const PartyRoomDetailPage({super.key});

  @override
  ConsumerState<PartyRoomDetailPage> createState() => _PartyRoomDetailPageState();
}

class _PartyRoomDetailPageState extends ConsumerState<PartyRoomDetailPage> {
  final ScrollController _scrollController = ScrollController();
  int _lastEventCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final partyRoom = ref.read(partyRoomProvider.notifier);
    final room = partyRoomState.room.currentRoom;
    final members = partyRoomState.room.members;
    final isOwner = partyRoomState.room.isOwner;
    final events = partyRoomState.room.recentEvents;

    // 检测消息数量变化，触发滚动
    if (events.length != _lastEventCount) {
      _lastEventCount = events.length;
      if (events.isNotEmpty) {
        _scrollToBottom();
      }
    }

    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Row(
        children: [
          // 左侧成员列表 (类似 Discord 侧边栏)
          Container(
            width: 240,
            decoration: BoxDecoration(
              color: Color(0xFF232428).withValues(alpha: .3),
              border: Border(right: BorderSide(color: Colors.black.withValues(alpha: 0.3), width: 1)),
            ),
            child: Column(
              children: [
                // 房间信息头部
                _buildRoomHeader(context, room, members, isOwner, partyRoom),
                const Divider(
                  style: DividerThemeData(thickness: 1, decoration: BoxDecoration(color: Color(0xFF1E1F22))),
                ),
                // 成员列表
                Expanded(child: _buildMembersSidebar(context, ref, members, isOwner, partyRoom)),
              ],
            ),
          ),
          // 右侧消息区域
          Expanded(
            child: Column(
              children: [
                // 消息列表
                Expanded(child: _buildMessageList(context, events, _scrollController, ref)),
                // 信号发送按钮
                _buildSignalSender(context, ref, partyRoom, room),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 房间信息头部
  Widget _buildRoomHeader(BuildContext context, dynamic room, List members, bool isOwner, PartyRoom partyRoom) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FluentIcons.room, size: 16, color: Color(0xFFB5BAC1)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  room?.ownerGameId ?? '房间',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(FluentIcons.group, size: 12, color: Color(0xFF80848E)),
              const SizedBox(width: 4),
              Text(
                '${members.length}/${room?.targetMembers ?? 0} 成员',
                style: const TextStyle(fontSize: 11, color: Color(0xFF80848E)),
              ),
            ],
          ),
          if (isOwner) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Button(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => ContentDialog(
                      title: const Text('确认解散'),
                      content: const Text('确定要解散房间吗？所有成员将被移出。'),
                      actions: [
                        Button(child: const Text('取消'), onPressed: () => Navigator.pop(context, false)),
                        FilledButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xFFDA373C))),
                          child: const Text('解散', style: TextStyle(color: Colors.white)),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    ref.read(partyRoomUIModelProvider.notifier).dismissRoom();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((state) {
                    if (state.isHovered || state.isPressed) {
                      return const Color(0xFFB3261E);
                    }
                    return const Color(0xFFDA373C);
                  }),
                ),
                child: const Text('解散房间', style: TextStyle(color: Colors.white)),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Button(
                onPressed: () async {
                  await partyRoom.leaveRoom();
                },
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xFF404249))),
                child: const Text('离开房间', style: TextStyle(color: Color(0xFFB5BAC1))),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getSocialIcon(String link) {
    if (link.contains('qq.com')) return FontAwesomeIcons.qq;
    if (link.contains('discord')) return FontAwesomeIcons.discord;
    if (link.contains('kook')) return FluentIcons.chat;
    return FluentIcons.link;
  }

  String _getSocialName(String link) {
    if (link.contains('discord')) return 'Discord';
    if (link.contains('kook')) return 'KOOK';
    if (link.contains('qq')) return 'QQ';
    return '链接';
  }

  // 成员侧边栏
  Widget _buildMembersSidebar(BuildContext context, WidgetRef ref, List members, bool isOwner, PartyRoom partyRoom) {
    if (members.isEmpty) {
      return Center(
        child: Text('暂无成员', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return _buildMemberItem(context, ref, member, isOwner, partyRoom);
      },
    );
  }

  Widget _buildMemberItem(BuildContext context, WidgetRef ref, RoomMember member, bool isOwner, PartyRoom partyRoom) {
    final avatarUrl = member.avatarUrl.isNotEmpty ? '${URLConf.rsiAvatarBaseUrl}${member.avatarUrl}' : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: HoverButton(
        onPressed: isOwner && !member.isOwner ? () => _showMemberContextMenu(context, member, partyRoom) : null,
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
                makeUserAvatar(member.handleName, avatarUrl: avatarUrl, size: 32),
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
                      if (member.status.currentLocation.isNotEmpty)
                        Text(
                          member.status.currentLocation,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF80848E)),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                // 状态指示器
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF23A559), // 在线绿色
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget makeUserAvatar(String memberName, {String? avatarUrl, double size = 32}) {
    return SizedBox(
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
  }

  void _showMemberContextMenu(BuildContext context, dynamic member, PartyRoom partyRoom) async {
    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(member.handleName.isNotEmpty ? member.handleName : member.gameUserId),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => ContentDialog(
                    title: const Text('转移房主'),
                    content: Text(
                      '确定要将房主转移给 ${member.handleName.isNotEmpty ? member.handleName : member.gameUserId} 吗？',
                    ),
                    actions: [
                      Button(child: const Text('取消'), onPressed: () => Navigator.pop(context, false)),
                      FilledButton(child: const Text('转移'), onPressed: () => Navigator.pop(context, true)),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await partyRoom.transferOwnership(member.gameUserId);
                }
              },
              child: const Text('转移房主'),
            ),
            const SizedBox(height: 8),
            Button(
              onPressed: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => ContentDialog(
                    title: const Text('踢出成员'),
                    content: Text('确定要踢出 ${member.handleName.isNotEmpty ? member.handleName : member.gameUserId} 吗？'),
                    actions: [
                      Button(child: const Text('取消'), onPressed: () => Navigator.pop(context, false)),
                      FilledButton(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xFFDA373C))),
                        child: const Text('踢出'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await partyRoom.kickMember(member.gameUserId);
                }
              },
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xFFDA373C))),
              child: const Text('踢出成员', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        actions: [Button(child: const Text('关闭'), onPressed: () => Navigator.pop(context))],
      ),
    );
  }

  // 消息列表
  Widget _buildMessageList(BuildContext context, List events, ScrollController scrollController, WidgetRef ref) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final room = partyRoomState.room.currentRoom;
    final hasSocialLinks = room != null && room.socialLinks.isNotEmpty;

    // 计算总项数：社交链接消息（如果有）+ 事件消息
    final totalItems = (hasSocialLinks ? 1 : 0) + events.length;

    if (totalItems == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.chat, size: 64, color: Color(0xFF404249)),
            const SizedBox(height: 16),
            Text('暂无消息', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
            const SizedBox(height: 4),
            Text('发送一条信号开始对话吧！', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        // 第一条消息显示社交链接（如果有）
        if (hasSocialLinks && index == 0) {
          return _buildSocialLinksMessage(room);
        }

        // 其他消息显示事件
        final eventIndex = hasSocialLinks ? index - 1 : index;
        final event = events[eventIndex];
        return _buildMessageItem(event, ref);
      },
    );
  }

  // 社交链接系统消息
  Widget _buildSocialLinksMessage(dynamic room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D31),
        border: Border.all(color: const Color(0xFF5865F2).withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Color(0xFF5865F2), shape: BoxShape.circle),
                child: const Icon(FluentIcons.info, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '该房间包含第三方社交连接，点击加入一起开黑吧~',
                  style: TextStyle(fontSize: 14, color: Color(0xFFDBDEE1), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: room.socialLinks.map<Widget>((link) {
              return HyperlinkButton(
                onPressed: () => launchUrlString(link),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.isHovered) return const Color(0xFF4752C4);
                    return const Color(0xFF5865F2);
                  }),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getSocialIcon(link), size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      _getSocialName(link),
                      style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(dynamic event, WidgetRef ref) {
    final roomEvent = event as partroom.RoomEvent;
    final isSignal = roomEvent.type == partroom.RoomEventType.SIGNAL_BROADCAST;
    final userName = _getEventUserName(roomEvent);
    final avatarUrl = _getEventAvatarUrl(roomEvent);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          makeUserAvatar(userName, avatarUrl: avatarUrl, size: 28),
          const SizedBox(width: 12),
          // 消息内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSignal ? Colors.white : const Color(0xFF80848E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(roomEvent.timestamp),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF80848E)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getEventText(roomEvent, ref),
                  style: TextStyle(
                    fontSize: 14,
                    color: isSignal ? const Color(0xFFDBDEE1) : const Color(0xFF949BA4),
                    fontStyle: isSignal ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEventUserName(partroom.RoomEvent event) {
    switch (event.type) {
      case partroom.RoomEventType.SIGNAL_BROADCAST:
        return event.signalSender.isNotEmpty ? event.signalSender : '未知用户';
      case partroom.RoomEventType.MEMBER_JOINED:
      case partroom.RoomEventType.MEMBER_LEFT:
      case partroom.RoomEventType.MEMBER_KICKED:
        return event.hasMember() && event.member.handleName.isNotEmpty
            ? event.member.handleName
            : event.hasMember()
            ? event.member.gameUserId
            : '未知用户';
      case partroom.RoomEventType.OWNER_CHANGED:
        return event.hasMember() && event.member.handleName.isNotEmpty ? event.member.handleName : '新房主';
      default:
        return '系统';
    }
  }

  String? _getEventAvatarUrl(partroom.RoomEvent event) {
    if (event.type == partroom.RoomEventType.SIGNAL_BROADCAST ||
        event.type == partroom.RoomEventType.MEMBER_JOINED ||
        event.type == partroom.RoomEventType.MEMBER_LEFT ||
        event.type == partroom.RoomEventType.MEMBER_KICKED ||
        event.type == partroom.RoomEventType.OWNER_CHANGED) {
      if (event.hasMember() && event.member.avatarUrl.isNotEmpty) {
        return '${URLConf.rsiAvatarBaseUrl}${event.member.avatarUrl}';
      }
    }
    return null;
  }

  // 信号发送器
  Widget _buildSignalSender(BuildContext context, WidgetRef ref, PartyRoom partyRoom, dynamic room) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final signalTypes = partyRoomState.room.signalTypes.where((s) => !s.isSpecial).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D31).withValues(alpha: .4),
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          const Spacer(),
          DropDownButton(
            leading: const Icon(FluentIcons.send, size: 16),
            title: Text(signalTypes.isEmpty ? '加载中...' : '发送信号'),
            disabled: signalTypes.isEmpty || room == null,
            items: signalTypes.map((signal) {
              return MenuFlyoutItem(
                leading: const Icon(FluentIcons.radio_bullet, size: 16),
                text: Text(signal.name.isNotEmpty ? signal.name : signal.id),
                onPressed: () => _sendSignal(context, ref, partyRoom, room, signal),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _sendSignal(
    BuildContext context,
    WidgetRef ref,
    PartyRoom partyRoom,
    dynamic room,
    dynamic signal,
  ) async {
    if (room == null) return;

    try {
      await partyRoom.sendSignal(signal.id);

      // 发送成功后，显示在消息列表中
      if (context.mounted) {
        // 信号已发送，会通过事件流更新到消息列表
      }
    } catch (e) {
      // 显示错误提示
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => ContentDialog(
            title: const Text('发送失败'),
            content: Text(e.toString()),
            actions: [FilledButton(child: const Text('确定'), onPressed: () => Navigator.pop(context))],
          ),
        );
      }
    }
  }

  String _getEventText(partroom.RoomEvent event, WidgetRef ref) {
    final partyRoomState = ref.read(partyRoomProvider);
    final signalTypes = partyRoomState.room.signalTypes;
    switch (event.type) {
      case partroom.RoomEventType.SIGNAL_BROADCAST:
        // 从 signalTypes 提取信号名称
        final signalType = signalTypes.where((s) => s.id == event.signalId).firstOrNull;
        // 显示信号ID和参数
        if (event.signalId.isNotEmpty) {
          if (event.signalParams.isNotEmpty) {
            final params = event.signalParams;
            return "signalId: ${event.signalId}，params:$params";
          }
        }
        return signalType?.name ?? event.signalId;

      case partroom.RoomEventType.MEMBER_JOINED:
        return '加入了房间';

      case partroom.RoomEventType.MEMBER_LEFT:
        return '离开了房间';

      case partroom.RoomEventType.OWNER_CHANGED:
        return '成为了新房主';

      case partroom.RoomEventType.ROOM_UPDATED:
        return '房间信息已更新';

      case partroom.RoomEventType.MEMBER_STATUS_UPDATED:
        if (event.hasMember()) {
          final member = event.member;
          final name = member.handleName.isNotEmpty ? member.handleName : member.gameUserId;
          if (member.hasStatus() && member.status.currentLocation.isNotEmpty) {
            return '$name 更新了状态: ${member.status.currentLocation}';
          }
          return '$name 更新了状态';
        }
        return '成员状态已更新';

      case partroom.RoomEventType.ROOM_DISMISSED:
        return '房间已解散';

      case partroom.RoomEventType.MEMBER_KICKED:
        return '被踢出房间';

      default:
        return '未知事件';
    }
  }

  String _formatTime(dynamic timestamp) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) {
        return '刚刚';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes} 分钟前';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} 小时前';
      } else {
        return '${diff.inDays} 天前';
      }
    } catch (e) {
      return '';
    }
  }
}
