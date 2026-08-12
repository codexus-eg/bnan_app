import 'package:bnan_app/features/dashboard/data/models/admin_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';
import 'package:bnan_app/features/dashboard/data/models/parent_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/models/supervisor_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/models/teacher_dashboard_model.dart';

abstract final class DashboardResponse {
  static DashboardData parse(Object? response) {
    final data = dashboardMap(dashboardMap(response)['data']);
    final role = DashboardRole.values
        .where(
          (item) => item.name == dashboardString(data['role']).toLowerCase(),
        )
        .firstOrNull;
    final generatedAt = DateTime.tryParse(dashboardString(data['generatedAt']));
    return switch (role) {
      DashboardRole.admin => AdminDashboardModel.fromJson(data, generatedAt),
      DashboardRole.supervisor => SupervisorDashboardModel.fromJson(
        data,
        generatedAt,
      ),
      DashboardRole.teacher => TeacherDashboardModel.fromJson(
        data,
        generatedAt,
      ),
      DashboardRole.parent => ParentDashboardModel.fromJson(data, generatedAt),
      DashboardRole.student => StudentDashboardModel.fromJson(
        data,
        generatedAt,
      ),
      null => throw const FormatException('Unsupported dashboard role'),
    };
  }
}
