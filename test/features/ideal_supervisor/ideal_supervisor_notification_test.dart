import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ideal supervisor certificate notification type parses safely', () {
    final notification = DashboardNotification.fromJson({
      'title': 'Certificate issued',
      'notificationType': 'IDEAL_SUPERVISOR_CERTIFICATE_ISSUED',
    });
    expect(notification.type, 'IDEAL_SUPERVISOR_CERTIFICATE_ISSUED');
  });
}
