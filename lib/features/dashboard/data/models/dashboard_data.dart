enum DashboardRole { admin, supervisor, teacher, parent, student }

abstract class DashboardData {
  const DashboardData({required this.role, required this.generatedAt});

  final DashboardRole role;
  final DateTime? generatedAt;
}
