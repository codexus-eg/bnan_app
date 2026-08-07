import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_departments_section.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_stats_section.dart';
import 'package:flutter/material.dart';

class AdminDashboardContent extends StatelessWidget {
  const AdminDashboardContent({
    super.key,
    required this.statistics,
    required this.onRegistrationRequests,
    required this.onPendingReceipts,
  });
  final AdminDashboardStatisticsModel statistics;
  final VoidCallback onRegistrationRequests;
  final VoidCallback onPendingReceipts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminStatsSection(
          statistics: statistics,
          onRegistrationRequests: onRegistrationRequests,
          onPendingReceipts: onPendingReceipts,
        ),
        const SizedBox(height: 16),
        // TODO: Re-enable revenue sections when the backend returns daily
        // and monthly revenue grouped by currency.
        AdminDepartmentsSection(data: statistics.studentsBySection),
      ],
    );
  }
}
