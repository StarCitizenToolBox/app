import 'package:starcitizen_doctor/common/utils/log.dart';

extension AsyncError on Future {
  Future<T?> unwrap<T>() async {
    try {
      return await this;
    } catch (e) {
      dPrint("unwrap error:$e");
      return null;
    }
  }
}
