import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';

class PartyRoomUtils {
  static final DateFormat dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// rpc Int64 时间戳 转 DateTime
  static DateTime? getDateTime(Int64? timestamp) {
    if (timestamp == null || timestamp == Int64.ZERO) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
  }

  static String? formatDateTime(Int64? timestamp) {
    final dateTime = getDateTime(timestamp);
    if (dateTime == null) {
      return null;
    }
    return dateTimeFormatter.format(dateTime);
  }
}
