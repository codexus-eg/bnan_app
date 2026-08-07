import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_stats_mapper.dart';
import 'package:flutter/material.dart';

class AdminStatsSection extends StatelessWidget {
  const AdminStatsSection({
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
    return HomeStatsSection(
      states: adminDashboardStats(
        context,
        statistics,
        onRegistrationRequests,
        onPendingReceipts,
      ),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      titleTextAlign: TextAlign.center,
      titleOverflow: TextOverflow.ellipsis,
    );
  }
}
