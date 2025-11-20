import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pb.dart' as partroom;
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/widgets/src/cache_image.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/services.dart';

/// 消息列表组件
class PartyRoomMessageList extends ConsumerWidget {
  final List events;
  final ScrollController scrollController;

  const PartyRoomMessageList({super.key, required this.events, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final room = partyRoomState.room.currentRoom;
    final hasSocialLinks = room != null && room.socialLinks.isNotEmpty;

    // 计算总项数：社交链接消息（如果有）+ 复制 ID 消息 + 事件消息
    final totalItems = (hasSocialLinks ? 1 : 0) + 1 + events.length;

    if (totalItems == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FluentIcons.chat, size: 64, color: Colors.white.withValues(alpha: .6)),
            const SizedBox(height: 16),
            Text('暂无消息', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
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
        // 第二条消息显示复制 ID
        final copyIdIndex = hasSocialLinks ? 1 : 0;
        if (index == copyIdIndex) {
          return _buildCopyIdMessage(room);
        }
        // 其他消息显示事件
        final eventIndex = index - (hasSocialLinks ? 2 : 1);
        final event = events[eventIndex];
        return _MessageItem(event: event);
      },
    );
  }

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
                  '该房间包含第三方社交连接，点击加入自由交流吧~',
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

  Widget _buildCopyIdMessage(dynamic room) {
    final ownerGameId = room?.ownerGameId ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF2B2D31), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                child: const Icon(FluentIcons.copy, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '复制房主的游戏ID，可在游戏首页添加好友，快速组队',
                  style: TextStyle(fontSize: 14, color: Color(0xFFDBDEE1), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFF1E1F22), borderRadius: BorderRadius.circular(4)),
                  child: Text(ownerGameId, style: const TextStyle(fontSize: 13, color: Color(0xFFDBDEE1))),
                ),
              ),
              const SizedBox(width: 8),
              Button(
                onPressed: ownerGameId.isNotEmpty
                    ? () async {
                        await Clipboard.setData(ClipboardData(text: ownerGameId));
                      }
                    : null,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.isPressed) return const Color(0xFF3A40A0);
                    if (states.isHovered) return const Color(0xFF4752C4);
                    return const Color(0xFF5865F2);
                  }),
                ),
                child: const Text(
                  '复制',
                  style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
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
}

/// 消息项
class _MessageItem extends ConsumerWidget {
  final dynamic event;

  const _MessageItem({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomEvent = event as partroom.RoomEvent;
    final isSignal = roomEvent.type == partroom.RoomEventType.SIGNAL_BROADCAST;
    final userName = _getEventUserName(roomEvent);
    final avatarUrl = _getEventAvatarUrl(roomEvent);

    // 检查是否是死亡信号，显示特殊卡片
    if (isSignal && roomEvent.signalId == 'special_death') {
      return _buildDeathMessageCard(context, roomEvent, userName, avatarUrl);
    }

    final text = _getEventText(roomEvent, ref);
    if (text == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserAvatar(userName, avatarUrl: avatarUrl, size: 28),
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
                  text,
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

  Widget _buildDeathMessageCard(
    BuildContext context,
    partroom.RoomEvent roomEvent,
    String userName,
    String? avatarUrl,
  ) {
    final location = roomEvent.signalParams['location'] ?? '未知位置';
    final area = roomEvent.signalParams['area'] ?? '未知区域';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserAvatar(userName, avatarUrl: avatarUrl, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户名和时间
                Row(
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(roomEvent.timestamp),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF80848E)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 死亡卡片
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2D31),
                    border: Border.all(color: const Color(0xFFED4245).withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFED4245).withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(FluentIcons.status_error_full, size: 14, color: Color(0xFFED4245)),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '玩家死亡',
                            style: TextStyle(fontSize: 14, color: Color(0xFFED4245), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // 位置信息
                      _buildInfoRow(icon: FluentIcons.location, label: '位置', value: location),
                      const SizedBox(height: 8),
                      // 区域信息
                      _buildInfoRow(icon: FluentIcons.map_pin, label: '区域', value: area),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: .4)),
        const SizedBox(width: 8),
        Text(
          '$label:   ',
          style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .4), fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFFDBDEE1))),
        ),
      ],
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

  String? _getEventText(partroom.RoomEvent event, WidgetRef ref) {
    final partyRoomState = ref.read(partyRoomProvider);
    final signalTypes = partyRoomState.room.signalTypes;
    switch (event.type) {
      case partroom.RoomEventType.SIGNAL_BROADCAST:
        final signalType = signalTypes[event.signalId];
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
        return null;
      case partroom.RoomEventType.ROOM_DISMISSED:
        return '房间已解散';
      case partroom.RoomEventType.MEMBER_KICKED:
        return '被踢出房间';
      default:
        return null;
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

  Widget _buildUserAvatar(String memberName, {String? avatarUrl, double size = 32}) {
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
}
