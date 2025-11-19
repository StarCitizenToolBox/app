import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';

/// 信号发送器组件
class PartyRoomSignalSender extends ConsumerWidget {
  final PartyRoom partyRoom;
  final dynamic room;

  const PartyRoomSignalSender({super.key, required this.partyRoom, required this.room});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final signalTypes = partyRoomState.room.signalTypes.values.where((s) => !s.isSpecial).toList();

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
                onPressed: () => _sendSignal(context, signal),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _sendSignal(BuildContext context, dynamic signal) async {
    if (room == null) return;

    try {
      await partyRoom.sendSignal(signal.id);
      // 信号已发送，会通过事件流更新到消息列表
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
}
