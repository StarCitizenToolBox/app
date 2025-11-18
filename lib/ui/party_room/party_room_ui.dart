import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/provider/party_room.dart';
import 'package:starcitizen_doctor/ui/party_room/party_room_ui_model.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/party_room_connect_page.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/party_room_list_page.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/party_room_detail_page.dart';
import 'package:starcitizen_doctor/ui/party_room/widgets/party_room_register_page.dart';

class PartyRoomUI extends HookConsumerWidget {
  const PartyRoomUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyRoomState = ref.watch(partyRoomProvider);
    ref.watch(partyRoomUIModelProvider.select((_) => null));
    // 根据状态显示不同页面
    if (!partyRoomState.client.isConnected) {
      return const PartyRoomConnectPage();
    }

    if (!partyRoomState.auth.isLoggedIn) {
      return const PartyRoomRegisterPage();
    }

    if (partyRoomState.room.isInRoom) {
      return const PartyRoomDetailPage();
    }

    return const PartyRoomListPage();
  }
}
