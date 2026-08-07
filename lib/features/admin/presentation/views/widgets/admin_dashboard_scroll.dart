import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/presentation/manager/admin_dashboard_cubit.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_dashboard_content.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_dashboard_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardScroll extends StatelessWidget {
  const AdminDashboardScroll({
    super.key,
    required this.statistics,
    required this.loading,
  });
  final AdminDashboardStatisticsModel statistics;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<AdminDashboardCubit>().refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
        child: AppSkeletonizer(
          isLoading: loading,
          child: AdminDashboardContent(
            statistics: statistics,
            onRegistrationRequests: () =>
                openAdminRegistrationRequests(context),
            onPendingReceipts: () => openAdminRegistrationRequests(context),
          ),
        ),
      ),
    );
  }
}
