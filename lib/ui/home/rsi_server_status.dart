import 'package:fluent_ui/fluent_ui.dart';

enum RsiServerStatusSeverity {
  operational,
  degraded,
  partialOutage,
  majorOutage,
}

const rsiStatusOperationalColor = Color(0xFF008000);
const rsiStatusDegradedColor = Color(0xFFF2B705);
const rsiStatusPartialOutageColor = Color(0xFFCC4400);
const rsiStatusMajorOutageColor = Color(0xFFE60000);

RsiServerStatusSeverity classifyRsiServerStatus(Object? status) {
  final normalized = status?.toString().trim().toLowerCase().replaceAll(
    RegExp(r'[\s-]+'),
    '_',
  );

  return switch (normalized) {
    'ok' || 'operational' => RsiServerStatusSeverity.operational,
    'degraded' ||
    'degraded_performance' ||
    'maintenance' ||
    'under_maintenance' => RsiServerStatusSeverity.degraded,
    'disrupted' ||
    'minor_outage' ||
    'partial_outage' => RsiServerStatusSeverity.partialOutage,
    'down' || 'major_outage' => RsiServerStatusSeverity.majorOutage,
    _ => RsiServerStatusSeverity.majorOutage,
  };
}

Color rsiServerStatusColor(Object? status) {
  return switch (classifyRsiServerStatus(status)) {
    RsiServerStatusSeverity.operational => rsiStatusOperationalColor,
    RsiServerStatusSeverity.degraded => rsiStatusDegradedColor,
    RsiServerStatusSeverity.partialOutage => rsiStatusPartialOutageColor,
    RsiServerStatusSeverity.majorOutage => rsiStatusMajorOutageColor,
  };
}
