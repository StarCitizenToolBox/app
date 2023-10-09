import 'dart:convert';

import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/ui/home/webview/webview.dart';

class WebviewLocalizationCaptureUIModel extends BaseUIModel {
  final WebViewModel webViewModel;

  WebviewLocalizationCaptureUIModel(this.webViewModel);

  Map<String, dynamic> data = {};
  Map<String, dynamic> oldData = {};

  String renderString = "";

  final jsonEncoder = const JsonEncoder.withIndent('  ');

  @override
  void initModel() {
    webViewModel.addOnWebMessageReceivedCallback(_onMessage);
    super.initModel();
  }

  @override
  void dispose() {
    webViewModel.removeOnWebMessageReceivedCallback(_onMessage);
    super.dispose();
  }

  void _onMessage(String message) {
    final map = json.decode(message);
    if (map["action"] == "webview_localization_capture") {
      dPrint(
          "<WebviewLocalizationCaptureUIModel> webview_localization_capture message == $map");
      if (!oldData.containsKey(map["key"])) {
        data[map["key"].toString().trim().toLowerCase().replaceAll(" ", "_")] =
            map["value"];
      }
      _updateRenderString();
    }
  }

  _updateRenderString() {
    renderString = "```json\n${jsonEncoder.convert(data)}\n```";
    notifyListeners();
  }

  doClean() {
    oldData.addAll(data);
    data.clear();
    _updateRenderString();
  }
}
