import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';

class DashboardStudent {
  const DashboardStudent({
    required this.id,
    required this.fullName,
    required this.email,
    this.curriculum,
    this.grade,
    this.subjects = const [],
  });
  final String id, fullName, email;
  final DashboardNamedItem? curriculum, grade;
  final List<DashboardNamedItem> subjects;

  factory DashboardStudent.fromJson(Map<String, dynamic> json) {
    DashboardNamedItem? item(Object? value) {
      final map = dashboardMap(value);
      return map.isEmpty ? null : DashboardNamedItem.fromJson(map);
    }

    return DashboardStudent(
      id: dashboardString(json['id']),
      fullName: dashboardString(json['fullName']),
      email: dashboardString(json['email']),
      curriculum: item(json['curriculum']),
      grade: item(json['grade']),
      subjects: dashboardList(
        json['subjects'],
      ).map(DashboardNamedItem.fromJson).toList(),
    );
  }
}

class DashboardNamedItem {
  const DashboardNamedItem({required this.id, required this.name});
  final String id, name;
  factory DashboardNamedItem.fromJson(Map<String, dynamic> json) =>
      DashboardNamedItem(
        id: dashboardString(json['id']),
        name: dashboardString(json['name']),
      );
}
