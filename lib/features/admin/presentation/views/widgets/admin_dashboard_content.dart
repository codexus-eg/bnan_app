import 'package:bnan_app/features/dashboard/data/models/admin_dashboard_model.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_departments_section.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_profit_section.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_stats_section.dart';
import 'package:flutter/material.dart';

class AdminDashboardContent extends StatelessWidget {
  const AdminDashboardContent({
    super.key,
    required this.dashboard,
    required this.onRegistrationRequests,
    required this.onPendingReceipts,
  });
  final AdminDashboardModel dashboard;
  final VoidCallback onRegistrationRequests;
  final VoidCallback onPendingReceipts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminStatsSection(
          statistics: dashboard.statistics,
          onRegistrationRequests: onRegistrationRequests,
          onPendingReceipts: onPendingReceipts,
        ),
        const SizedBox(height: 16),
        AdminProfitSection(revenue: dashboard.revenue),
        const SizedBox(height: 16),
        AdminDepartmentsSection(data: dashboard.statistics.studentsBySection),
      ],
    );
  }
}
