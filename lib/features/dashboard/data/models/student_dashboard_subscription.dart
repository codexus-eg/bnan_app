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
    this.planKind = '',
    this.purchasedMonths = 0,
    this.startDate,
    this.endDate,
    this.remainingType = '',
    this.remainingValue,
    this.status = '',
    this.computedStatus = '',
    this.gracePeriodEndsAt,
    this.renewalDueDate,
  });
  final String packageName, packageType;
  final int totalHours, usedHours, remainingHours;
  final double progressPercentage;
  final bool isActive;
  final String status, computedStatus;
  final String planKind, remainingType;
  final int purchasedMonths;
  final DateTime? startDate, endDate, gracePeriodEndsAt, renewalDueDate;
  final int? remainingValue;

  bool get isMonthly => planKind.trim().isNotEmpty
      ? planKind.trim().toLowerCase() == 'egyptian_monthly'
      : packageType.trim().toLowerCase() == 'monthly';

  factory DashboardSubscription.fromJson(Map<String, dynamic> json) {
    final summary = dashboardMap(json['summary']);
    final package = dashboardMap(json['package']);
    final remaining = dashboardMap(summary['remaining']);
    return DashboardSubscription(
      packageName: dashboardString(
        summary['packageName'] ?? package['name'] ?? json['packageName'],
      ),
      packageType: dashboardString(
        summary['packageType'] ?? json['packageType'],
      ),
      totalHours: dashboardInt(summary['totalHours']),
      usedHours: dashboardInt(summary['usedHours']),
      remainingHours: dashboardInt(
        summary['remainingHours'] ?? json['remainingHours'],
      ),
      progressPercentage: dashboardDouble(summary['progressPercentage']),
      isActive: dashboardBool(json['isActive'] ?? summary['isActive']),
      status: dashboardString(json['status'] ?? summary['status']),
      computedStatus: dashboardString(
        json['computedStatus'] ?? summary['computedStatus'],
      ),
      planKind: dashboardString(json['planKind'] ?? summary['planKind']),
      purchasedMonths: dashboardInt(
        json['purchasedMonths'] ?? summary['purchasedMonths'],
      ),
      startDate: _date(json['startDate'] ?? summary['startDate']),
      endDate: _date(
        json['endDate'] ?? json['expiryDate'] ?? summary['endDate'],
      ),
      remainingType: dashboardString(remaining['type']),
      remainingValue: remaining['value'] == null
          ? null
          : dashboardInt(remaining['value']),
      gracePeriodEndsAt: _date(
        json['gracePeriodEndsAt'] ?? summary['gracePeriodEndsAt'],
      ),
      renewalDueDate: _date(
        json['renewalDueDate'] ?? summary['renewalDueDate'],
      ),
    );
  }

  static DateTime? _date(Object? value) =>
      DateTime.tryParse(dashboardString(value));
}
