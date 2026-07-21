import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/ui/home/rsi_server_status.dart';

void main() {
  test('maps operational statuses to green', () {
    expect(
      classifyRsiServerStatus('operational'),
      RsiServerStatusSeverity.operational,
    );
    expect(rsiServerStatusColor('ok'), rsiStatusOperationalColor);
  });

  test('maps degraded statuses to yellow instead of red', () {
    expect(
      classifyRsiServerStatus('Degraded'),
      RsiServerStatusSeverity.degraded,
    );
    expect(
      rsiServerStatusColor('degraded-performance'),
      rsiStatusDegradedColor,
    );
    expect(rsiStatusDegradedColor, isNot(rsiStatusMajorOutageColor));
  });

  test('maps partial outages to orange red', () {
    expect(
      classifyRsiServerStatus('Partial Outage'),
      RsiServerStatusSeverity.partialOutage,
    );
    expect(rsiServerStatusColor('disrupted'), rsiStatusPartialOutageColor);
  });

  test('maps major outages to red', () {
    expect(
      classifyRsiServerStatus('major_outage'),
      RsiServerStatusSeverity.majorOutage,
    );
    expect(rsiServerStatusColor('down'), rsiStatusMajorOutageColor);
  });

  test('keeps unknown statuses conservative', () {
    expect(rsiServerStatusColor('unexpected'), rsiStatusMajorOutageColor);
    expect(rsiServerStatusColor(null), rsiStatusMajorOutageColor);
  });
}
