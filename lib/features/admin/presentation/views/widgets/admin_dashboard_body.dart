import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/admin/data/models/admin_dashboard_statistics_model.dart';
import 'package:bnan_app/features/admin/presentation/manager/admin_dashboard_cubit.dart';
import 'package:bnan_app/features/admin/presentation/manager/admin_dashboard_state.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_dashboard_failure.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_dashboard_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardBody extends StatelessWidget {
  const AdminDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminDashboardCubit, AdminDashboardState>(
      listener: (context, state) {
        if (state is AdminDashboardRefreshFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        if (state is AdminDashboardFailure) {
          return AdminDashboardFailureView(message: state.message);
        }
        final data = state is AdminDashboardDataState
            ? state.statistics
            : const AdminDashboardStatisticsModel();
        return AdminDashboardScroll(
          statistics: data,
          loading:
              state is AdminDashboardInitial || state is AdminDashboardLoading,
        );
      },
    );
  }
}
