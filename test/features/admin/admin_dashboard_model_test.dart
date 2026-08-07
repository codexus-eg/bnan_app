import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'admin_dashboard_test_data.dart';

void main() {
  test('parses complete statistics and numeric strings safely', () {
    final data = dashboardStatistics();

    expect(data.totalStudents, 29);
    expect(data.pendingStudentRegistrations, 1);
    expect(data.totalTeachers, 38);
    expect(data.todayTimezone, 'Africa/Cairo');
    expect(data.studentsBySection.sections, hasLength(2));
    expect(data.studentsBySection.sections.first.progress, closeTo(.6207, .001));
  });

  test('missing statistics and malformed values default to zero', () {
    final missing = AdminDashboardStatisticsModel.fromResponse({});
    final malformed = AdminDashboardStatisticsModel.fromResponse({
      'data': {
        'statistics': {
          'totalStudents': false,
          'studentsBySection': {'sections': 'invalid'},
        },
      },
    });

    expect(missing.totalStudents, 0);
    expect(malformed.totalStudents, 0);
    expect(malformed.studentsBySection.sections, isEmpty);
  });

  test('progress clamps but percentage remains unchanged', () {
    final data = AdminDashboardStatisticsModel.fromResponse({
      'data': {
        'statistics': {
          'studentsBySection': {
            'sections': [
              {'key': 'egyptian', 'count': 0, 'percentage': 150},
            ],
          },
        },
      },
    });

    expect(data.studentsBySection.sections.single.progress, 1);
    expect(data.studentsBySection.sections.single.percentage, 150);
  });
}
