import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_profile.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_stats.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_subscription.dart';

export 'student_dashboard_profile.dart';
export 'student_dashboard_stats.dart';
export 'student_dashboard_subscription.dart';

class StudentDashboardModel extends DashboardData {
  const StudentDashboardModel({
    required super.generatedAt,
    required this.student,
    required this.subscription,
    required this.stats,
    required this.weeklyEvaluation,
  }) : super(role: DashboardRole.student);

  final DashboardStudent student;
  final DashboardSubscription? subscription;
  final DashboardStudentStats stats;
  final DashboardWeeklyEvaluation? weeklyEvaluation;

  factory StudentDashboardModel.fromJson(
    Map<String, dynamic> json,
    DateTime? at,
  ) {
    final subscription = dashboardMap(json['subscription']);
    final weekly = dashboardMap(json['weeklyEvaluation']);
    return StudentDashboardModel(
      generatedAt: at,
      student: DashboardStudent.fromJson(dashboardMap(json['student'])),
      subscription: subscription.isEmpty
          ? null
          : DashboardSubscription.fromJson(subscription),
      stats: DashboardStudentStats.fromJson(dashboardMap(json['stats'])),
      weeklyEvaluation: weekly.isEmpty
          ? null
          : DashboardWeeklyEvaluation.fromJson(weekly),
    );
  }
}
