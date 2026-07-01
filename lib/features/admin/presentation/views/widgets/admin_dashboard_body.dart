import 'package:bnan_app/features/admin/presentation/views/widgets/admin_departments_section.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_profit_section.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_quick_actions_section.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_stats_section.dart';
import 'package:flutter/material.dart';

class AdminDashboardBody extends StatelessWidget {
  const AdminDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
      child: Column(
        children: const [
          AdminStatsSection(),
          SizedBox(height: 16),
          AdminProfitSection(),
          SizedBox(height: 16),
          AdminDepartmentsSection(),
          SizedBox(height: 16),
          AdminQuickActionsSection(),
        ],
      ),
    );
  }
}
