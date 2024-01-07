import 'package:starcitizen_doctor/base/ui.dart';

import 'party_room_home_ui_model.dart';

class PartyRoomHomeUI extends BaseUI<PartyRoomHomeUIModel> {
  @override
  Widget? buildBody(BuildContext context, PartyRoomHomeUIModel model) {
    if (model.pingServerMessage == null) return makeLoading(context);
    if (model.pingServerMessage!.isNotEmpty) {
      return Center(
        child: Text("${model.pingServerMessage}"),
      );
    }
    return Center(
      child: Text("PartyRoom"),
    );
  }

  @override
  String getUITitle(BuildContext context, PartyRoomHomeUIModel model) =>
      "PartyRoom";
}
