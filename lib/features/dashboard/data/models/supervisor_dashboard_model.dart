import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';

class SupervisorDashboardModel extends DashboardData {
  const SupervisorDashboardModel({
    required super.generatedAt,
    required this.classrooms,
    required this.evaluations,
    this.idealTeacher,
    required this.notifications,
  }) : super(role: DashboardRole.supervisor);

  final int classrooms, evaluations;
  final DashboardIdealTeacher? idealTeacher;
  final List<DashboardNotification> notifications;

  factory SupervisorDashboardModel.fromJson(
    Map<String, dynamic> json,
    DateTime? at,
  ) {
    final counts = dashboardMap(json['counts']);
    return SupervisorDashboardModel(
      generatedAt: at,
      classrooms: dashboardInt(counts['classrooms']),
      evaluations: dashboardInt(counts['evaluations']),
      idealTeacher: null,
      notifications: dashboardList(
        json['notifications'],
      ).map(DashboardNotification.fromJson).take(10).toList(),
    );
  }
}

class DashboardIdealTeacher {
  const DashboardIdealTeacher(this.id, this.fullName, this.points);
  final String id, fullName;
  final int points;
  factory DashboardIdealTeacher.fromJson(Map<String, dynamic> json) =>
      DashboardIdealTeacher(
        dashboardString(json['id']),
        dashboardString(json['fullName']),
        dashboardInt(json['points']),
      );
}
