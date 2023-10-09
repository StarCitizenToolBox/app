import 'package:dio/dio.dart';
import 'package:starcitizen_doctor/base/ui_model.dart';

class MDContentDialogUIModel extends BaseUIModel {
  String title;
  String url;

  MDContentDialogUIModel(this.title, this.url);

  String? data;

  @override
  Future loadData() async {
    final r = await handleError(() => Dio().get(url));
    if (r == null) return;
    data = r.data;
    notifyListeners();
  }
}
