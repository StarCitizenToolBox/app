import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';

/// 房间信息头部组件
class PartyRoomHeader extends ConsumerWidget {
  final dynamic room;
  final List members;
  final bool isOwner;
  final PartyRoom partyRoom;

  const PartyRoomHeader({
    super.key,
    required this.room,
    required this.members,
    required this.isOwner,
    required this.partyRoom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(FluentIcons.back, size: 16, color: Color(0xFFB5BAC1)),
                onPressed: () {
                  ref.read(partyRoomUIModelProvider.notifier).setMinimized(true);
                },
              ),
              const SizedBox(width: 8),
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
}
