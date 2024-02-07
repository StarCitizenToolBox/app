import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/common/io/rs_http.dart';

class MDContentDialogUIModel extends BaseUIModel {
  String title;
  String url;

  MDContentDialogUIModel(this.title, this.url);

  String? data;

  @override
  Future loadData() async {
    final r = await handleError(() => RSHttp.getText(url));
    if (r == null) return;
    data = r;
    notifyListeners();
  }
}
