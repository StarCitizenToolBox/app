import 'package:starcitizen_doctor/base/ui.dart';
import 'package:starcitizen_doctor/ui/settings/settings_ui_model.dart';

class SettingUI extends BaseUI<SettingUIModel> {
  @override
  Widget? buildBody(BuildContext context, SettingUIModel model) {
    return const Center(
      child: Text("暂时没啥好设置的。"),
    );
  }

  @override
  String getUITitle(BuildContext context, SettingUIModel model) => "SettingUI";
}
