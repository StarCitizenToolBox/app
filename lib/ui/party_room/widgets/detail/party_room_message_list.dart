import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';
import 'package:starcitizen_doctor/generated/proto/partroom/partroom.pb.dart' as partroom;
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/widgets/src/cache_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  String _getEventText(partroom.RoomEvent event, WidgetRef ref) {
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
