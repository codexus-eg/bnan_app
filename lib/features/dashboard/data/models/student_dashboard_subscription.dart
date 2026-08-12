import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';

class DashboardSubscription {
  const DashboardSubscription({
    required this.packageName,
    required this.packageType,
    required this.totalHours,
    required this.usedHours,
    required this.remainingHours,
    required this.progressPercentage,
    required this.isActive,
  });
  final String packageName, packageType;
  final int totalHours, usedHours, remainingHours;
  final double progressPercentage;
  final bool isActive;

  factory DashboardSubscription.fromJson(Map<String, dynamic> json) {
    final summary = dashboardMap(json['summary']);
    return DashboardSubscription(
      packageName: dashboardString(summary['packageName']),
      packageType: dashboardString(
        summary['packageType'] ?? json['packageType'],
      ),
      totalHours: dashboardInt(summary['totalHours']),
      usedHours: dashboardInt(summary['usedHours']),
      remainingHours: dashboardInt(
        summary['remainingHours'] ?? json['remainingHours'],
      ),
      progressPercentage: dashboardDouble(summary['progressPercentage']),
      isActive: dashboardBool(summary['isActive']),
    );
  }
}
