import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';

class DashboardStudentStats {
  const DashboardStudentStats({
    required this.certificates,
    required this.attendance,
  });
  final int certificates;
  final DashboardAttendance attendance;
  factory DashboardStudentStats.fromJson(Map<String, dynamic> json) =>
      DashboardStudentStats(
        certificates: dashboardInt(dashboardMap(json['certificates'])['count']),
        attendance: DashboardAttendance.fromJson(
          dashboardMap(json['attendance']),
        ),
      );
}

class DashboardAttendance {
  const DashboardAttendance({
    this.percentage,
    required this.total,
    required this.present,
    required this.late,
    required this.absent,
  });
  final double? percentage;
  final int total, present, late, absent;
  factory DashboardAttendance.fromJson(Map<String, dynamic> json) =>
      DashboardAttendance(
        percentage: dashboardNullableDouble(json['percentage']),
        total: dashboardInt(json['total']),
        present: dashboardInt(json['present']),
        late: dashboardInt(json['late']),
        absent: dashboardInt(json['absent']),
      );
}

class DashboardWeeklyEvaluation {
  const DashboardWeeklyEvaluation({
    this.attendance,
    this.homework,
    this.behavior,
    this.teacherNote,
  });
  final double? attendance, homework, behavior;
  final String? teacherNote;
  factory DashboardWeeklyEvaluation.fromJson(Map<String, dynamic> json) {
    final note = dashboardString(json['teacherNote']);
    return DashboardWeeklyEvaluation(
      attendance: dashboardNullableDouble(json['attendancePercentage']),
      homework: dashboardNullableDouble(json['homeworkPercentage']),
      behavior: dashboardNullableDouble(json['behaviorPercentage']),
      teacherNote: note.isEmpty ? null : note,
    );
  }
}
