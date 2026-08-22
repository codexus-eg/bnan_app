import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';

class TeacherDashboardModel extends DashboardData {
  const TeacherDashboardModel({
    required super.generatedAt,
    required this.isIdealTeacher,
    required this.points,
    required this.classrooms,
    required this.students,
    required this.subjects,
  }) : super(role: DashboardRole.teacher);

  final bool isIdealTeacher;
  final int points, classrooms, students, subjects;

  factory TeacherDashboardModel.fromJson(
    Map<String, dynamic> json,
    DateTime? at,
  ) {
    final counts = dashboardMap(json['counts']);
    final excellence = dashboardMap(json['excellence']);
    return TeacherDashboardModel(
      generatedAt: at,
      isIdealTeacher: dashboardBool(
        excellence['isIdealTeacher'] ?? excellence['isIdeal'],
      ),
      points: dashboardInt(excellence['points']),
      classrooms: dashboardInt(counts['classrooms']),
      students: dashboardInt(counts['students']),
      subjects: dashboardInt(counts['subjects']),
    );
  }
}
