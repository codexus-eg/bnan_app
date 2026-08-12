import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/dashboard/data/models/admin_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_dashboard_content.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_dashboard_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardScroll extends StatelessWidget {
  const AdminDashboardScroll({
    super.key,
    required this.dashboard,
    required this.loading,
  });
  final AdminDashboardModel dashboard;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<DashboardCubit>().refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
        child: AppSkeletonizer(
          isLoading: loading,
          child: AdminDashboardContent(
            dashboard: dashboard,
            onRegistrationRequests: () =>
                openAdminRegistrationRequests(context),
            onPendingReceipts: () => openAdminRegistrationRequests(context),
          ),
        ),
      ),
    );
  }
}
