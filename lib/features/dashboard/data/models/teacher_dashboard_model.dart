import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';
import 'package:bnan_app/features/dashboard/data/models/points_period_model.dart';

class TeacherDashboardModel extends DashboardData {
  const TeacherDashboardModel({
    required super.generatedAt,
    this.teacherPoints,
    this.pointsPeriod,
    this.points,
    this.isIdealTeacher = false,
    required this.classrooms,
    required this.students,
    required this.subjects,
  }) : super(role: DashboardRole.teacher);

  final int? teacherPoints;
  final PointsPeriodModel? pointsPeriod;
  final bool isIdealTeacher;
  final int? points;
  final int classrooms, students, subjects;

  int get effectivePoints => teacherPoints ?? points ?? 0;

  factory TeacherDashboardModel.fromJson(
    Map<String, dynamic> json,
    DateTime? at,
  ) {
    final counts = dashboardMap(json['counts']);
    final period = json['pointsPeriod'] is Map
        ? PointsPeriodModel.fromJson(dashboardMap(json['pointsPeriod']))
        : null;
    return TeacherDashboardModel(
      generatedAt: at,
      teacherPoints: dashboardNullableInt(json['teacherPoints']),
      pointsPeriod: period,
      isIdealTeacher: dashboardBool(json['isIdealTeacher']),
      classrooms: dashboardInt(counts['classrooms']),
      students: dashboardInt(counts['students']),
      subjects: dashboardInt(counts['subjects']),
    );
  }
}
