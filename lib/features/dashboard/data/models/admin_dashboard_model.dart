import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_money.dart';

class AdminDashboardModel extends DashboardData {
  const AdminDashboardModel({
    required super.generatedAt,
    required this.statistics,
    required this.revenue,
  }) : super(role: DashboardRole.admin);

  final AdminDashboardStatisticsModel statistics;
  final DashboardRevenue revenue;

  factory AdminDashboardModel.fromJson(
    Map<String, dynamic> json,
    DateTime? generatedAt,
  ) => AdminDashboardModel(
    generatedAt: generatedAt,
    statistics: AdminDashboardStatisticsModel.fromJson(json['statistics']),
    revenue: DashboardRevenue.fromJson(json['revenue']),
  );
}
