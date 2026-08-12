import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_home_ui_data.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_notifications_section.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorHomePage extends StatelessWidget {
  const SupervisorHomePage({
    super.key,
    required this.userName,
    required this.data,
    required this.onMenuTap,
    required this.loading,
    required this.onNotificationTap,
  });

  final String userName;
  final SupervisorHomeUiData data;
  final VoidCallback onMenuTap;
  final bool loading;
  final ValueChanged<DashboardNotification> onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeAppBar(
          userName: userName,
          onMenuTap: onMenuTap,
          onNotificationTap: () =>
              MyNavigator.goTo(context, Routes.notification),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: context.read<DashboardCubit>().refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
              children: [
                AppSkeletonizer(
                  isLoading: loading,
                  child: Column(
                    children: [
                      HomeStatsSection(
                        states: data.summary,
                        crossAxisSpacing: 12,
                      ),
                      const SizedBox(height: 16),
                      SupervisorNotificationsSection(
                        notifications: data.notifications,
                        onTap: onNotificationTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
