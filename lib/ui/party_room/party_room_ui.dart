import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    if (!partyRoomState.client.isConnected || uiState.isLoggingIn) {
      widget = PartyRoomConnectPage();
    } else if (!partyRoomState.auth.isLoggedIn) {
      widget = PartyRoomRegisterPage();
    } else if (partyRoomState.room.isInRoom && !uiState.isMinimized) {
      widget = PartyRoomDetailPage();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 230),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: widget,
    );
  }
}
