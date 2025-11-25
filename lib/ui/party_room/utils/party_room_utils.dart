import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';
import 'package:starcitizen_doctor/common/conf/url_conf.dart';

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

  /// 统一处理 avatarUrl
  /// 对于 http/https 开头的直接返回，否则使用旧的拼接规则
  static String? getAvatarUrl(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return null;
    }

    // 如果已经是完整的 URL，直接返回
    if (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://')) {
      return avatarUrl;
    }

    // 否则使用 RSI 头像基础 URL 拼接
    return '${URLConf.rsiAvatarBaseUrl}$avatarUrl';
  }
}
