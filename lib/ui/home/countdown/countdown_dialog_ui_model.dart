import 'package:starcitizen_doctor/base/ui_model.dart';
import 'package:starcitizen_doctor/data/countdown_festival_item_data.dart';

class CountdownDialogUIModel extends BaseUIModel {
  final List<CountdownFestivalItemData> countdownFestivalListData;

  CountdownDialogUIModel(this.countdownFestivalListData);

  onBack() {
    Navigator.pop(context!);
  }
}
