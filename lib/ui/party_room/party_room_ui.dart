import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_hero/local_hero.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/party_room_connect_page.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/party_room_list_page.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/detail/party_room_detail_page.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/party_room_register_page.dart';

class PartyRoomUI extends HookConsumerWidget {
  const PartyRoomUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyRoomState = ref.watch(partyRoomProvider);
    final uiState = ref.watch(partyRoomUIModelProvider);

    Widget widget = const PartyRoomListPage();

    // 根据状态显示不同页面
    if (!partyRoomState.client.isConnected) {
      widget = PartyRoomConnectPage();
    } else if (!partyRoomState.auth.isLoggedIn) {
      widget = PartyRoomRegisterPage();
    } else if (partyRoomState.room.isInRoom && !uiState.isMinimized) {
      widget = PartyRoomDetailPage();
    }

    return LocalHeroScope(
      duration: Duration(milliseconds: 180),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 230),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: widget,
      ),
    );
  }
}
