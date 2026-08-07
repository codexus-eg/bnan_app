import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';

const dashboardResponse = {
  'data': {
    'statistics': {
      'totalStudents': 29,
      'pendingStudentRegistrations': '1',
      'totalTeachers': 38.9,
      'todaySessions': 6,
      'activeSubscriptions': 5,
      'expiredSubscriptions': 2,
      'pendingReceipts': 3,
      'todayTimezone': 'Africa/Cairo',
      'studentsBySection': {
        'total': 29,
        'sections': [
          {'key': 'egyptian', 'count': 18, 'percentage': '62.07'},
          {'key': 'gulf', 'count': 11, 'percentage': 37.93},
        ],
      },
    },
  },
};

AdminDashboardStatisticsModel dashboardStatistics() {
  return AdminDashboardStatisticsModel.fromResponse(dashboardResponse);
}
