import 'package:bnan_app/features/admin/data/models/admin_dashboard_parsing.dart';
import 'package:bnan_app/features/admin/data/models/admin_students_by_section_model.dart';

class AdminDashboardStatisticsModel {
  const AdminDashboardStatisticsModel({
    this.totalStudents = 0,
    this.pendingStudentRegistrations = 0,
    this.totalTeachers = 0,
    this.todaySessions = 0,
    this.activeSubscriptions = 0,
    this.expiredSubscriptions = 0,
    this.pendingReceipts = 0,
    this.todayTimezone = '',
    this.studentsBySection = const AdminStudentsBySectionModel(),
  });

  final int totalStudents;
  final int pendingStudentRegistrations;
  final int totalTeachers;
  final int todaySessions;
  final int activeSubscriptions;
  final int expiredSubscriptions;
  final int pendingReceipts;
  final String todayTimezone;
  final AdminStudentsBySectionModel studentsBySection;

  factory AdminDashboardStatisticsModel.fromResponse(Object? response) {
    final data = adminMap(adminMap(response)['data']);
    return AdminDashboardStatisticsModel.fromJson(data['statistics']);
  }

  factory AdminDashboardStatisticsModel.fromJson(Object? value) {
    final json = adminMap(value);
    return AdminDashboardStatisticsModel(
      totalStudents: adminInt(json['totalStudents']),
      pendingStudentRegistrations: adminInt(
        json['pendingStudentRegistrations'],
      ),
      totalTeachers: adminInt(json['totalTeachers']),
      todaySessions: adminInt(json['todaySessions']),
      activeSubscriptions: adminInt(json['activeSubscriptions']),
      expiredSubscriptions: adminInt(json['expiredSubscriptions']),
      pendingReceipts: adminInt(json['pendingReceipts']),
      todayTimezone: adminString(json['todayTimezone']),
      studentsBySection: AdminStudentsBySectionModel.fromJson(
        json['studentsBySection'],
      ),
    );
  }
}
