import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AdminDashboardStatisticsModel parses totalPaidEgp and totalPaidSar seamlessly', () {
    final json = {
      "success": true,
      "data": {
        "statistics": {
          "totalStudents": 28,
          "pendingStudentRegistrations": 0,
          "studentsBySection": {
            "total": 28,
            "sections": [
              { "key": "egyptian", "count": 3, "percentage": 10.71 },
              { "key": "gulf", "count": 25, "percentage": 89.29 }
            ]
          },
          "activeSubscriptions": 12,
          "expiredSubscriptions": 0,
          "pendingReceipts": 0,
          "totalPaidEgp": 0,
          "totalPaidSar": 1290.2,
          "totalTeachers": 53,
          "todaySessions": 0,
          "todayTimezone": "Africa/Cairo"
        }
      }
    };

    final model = AdminDashboardStatisticsModel.fromResponse(json);
    expect(model.totalStudents, 28);
    expect(model.pendingStudentRegistrations, 0);
    expect(model.totalTeachers, 53);
    expect(model.todaySessions, 0);
    expect(model.activeSubscriptions, 12);
    expect(model.expiredSubscriptions, 0);
    expect(model.pendingReceipts, 0);
    expect(model.totalPaidEgp, 0.0);
    expect(model.totalPaidSar, 1290.2);
    expect(model.todayTimezone, 'Africa/Cairo');
    expect(model.studentsBySection.total, 28);
    expect(model.studentsBySection.sections.length, 2);
  });
}
