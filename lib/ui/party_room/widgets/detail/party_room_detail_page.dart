import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/common/utils/base_utils.dart';
import 'package:starcitizen_doctor/common/utils/log.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/detail/party_room_message_list.dart';

import 'party_room_header.dart';
import 'party_room_member_list.dart';
import 'party_room_signal_sender.dart';

/// 房间详情页面 (Discord 样式)
class PartyRoomDetailPage extends ConsumerStatefulWidget {
  const PartyRoomDetailPage({super.key});

  @override
  ConsumerState<PartyRoomDetailPage> createState() => _PartyRoomDetailPageState();
}

class _PartyRoomDetailPageState extends ConsumerState<PartyRoomDetailPage> {
  final ScrollController _scrollController = ScrollController();
  int _lastEventCount = 0;
  bool _isShowingDialog = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showReconnectDialog() async {
    if (_isShowingDialog || !mounted) return;
    _isShowingDialog = true;

    final partyRoom = ref.read(partyRoomProvider.notifier);

    final result = await showBaseDialog(
      context,
      title: '连接已断开',
      content: const Text('与房间服务器的连接已断开，是否重新连接？'),
      actions: [
        Button(
          onPressed: () => Navigator.of(context).pop('leave'),
          child: const Padding(padding: EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8), child: Text('退出房间')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop('reconnect'),
          child: const Padding(padding: EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8), child: Text('重新连接')),
        ),
      ],
    );

    _isShowingDialog = false;

    if (!mounted) return;

    if (result == 'reconnect') {
      try {
        await partyRoom.refreshRoomAndReconnect();
        dPrint('[PartyRoomDetailPage] Reconnect success');
      } catch (e) {
        dPrint('[PartyRoomDetailPage] Reconnect failed: $e');
        // 重连失败，重新显示对话框
        if (mounted) {
          _showReconnectDialog();
        }
      }
    } else if (result == 'leave') {
      try {
        partyRoom.acknowledgeDisconnection();
        await partyRoom.leaveRoom();
      } catch (e) {
        dPrint('[PartyRoomDetailPage] Leave room failed: $e');
        if (mounted) {
          await showToast(context, '退出房间失败: $e');
        }
      }
    } else {
      // 用户关闭对话框
      partyRoom.acknowledgeDisconnection();
    }
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
    ref.listen<PartyRoomFullState>(partyRoomProvider, (previous, next) {
      // 监听事件流断开状态
      if (next.room.isInRoom && next.room.eventStreamDisconnected && !_isShowingDialog) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showReconnectDialog();
          }
        });
      }
    });

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
                PartyRoomHeader(room: room, members: members, isOwner: isOwner, partyRoom: partyRoom),
                const Divider(
                  style: DividerThemeData(thickness: 1, decoration: BoxDecoration(color: Color(0xFF1E1F22))),
                ),
                // 成员列表
                Expanded(
                  child: PartyRoomMemberList(members: members, isOwner: isOwner, partyRoom: partyRoom),
                ),
              ],
            ),
          ),
          // 右侧消息区域
          Expanded(
            child: Column(
              children: [
                // 消息列表
                Expanded(
                  child: PartyRoomMessageList(events: events, scrollController: _scrollController),
                ),
                // 信号发送按钮
                PartyRoomSignalSender(partyRoom: partyRoom, room: room),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
