import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_dashboard_scroll.dart';
import 'package:bnan_app/features/dashboard/data/models/admin_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_money.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_builder.dart';
import 'package:flutter/material.dart';

class AdminDashboardBody extends StatelessWidget {
  const AdminDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardBuilder<AdminDashboardModel>(
      skeleton: const AdminDashboardModel(
        generatedAt: null,
        statistics: AdminDashboardStatisticsModel(),
        revenue: DashboardRevenue(),
      ),
      builder: (_, data, loading) =>
          AdminDashboardScroll(dashboard: data, loading: loading),
    );
  }
}
