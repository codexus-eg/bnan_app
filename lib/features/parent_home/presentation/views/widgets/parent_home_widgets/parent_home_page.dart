import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/features/dashboard/data/models/parent_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_builder.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_children_section.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_stats_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({
    super.key,
    required this.onMenuTap,
    required this.onShowAllChildren,
  });
  final VoidCallback onMenuTap, onShowAllChildren;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      HomeAppBar(
        userName:
            SessionManager.instance.userName ?? S.of(context).parentGuardian,
        onMenuTap: onMenuTap,
        onNotificationTap: () => MyNavigator.goTo(context, Routes.notification),
      ),
      Expanded(
        child: DashboardBuilder<ParentDashboardModel>(
          skeleton: const ParentDashboardModel(
            generatedAt: null,
            childrenCount: 0,
            certificates: 0,
            evaluations: 0,
            subscriptions: 0,
            children: [
              ParentChildModel(fullName: 'Child name', grade: 'Grade'),
              ParentChildModel(fullName: 'Child name', grade: 'Grade'),
            ],
          ),
          builder: (context, data, loading) => RefreshIndicator(
            onRefresh: context.read<DashboardCubit>().refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
              child: AppSkeletonizer(
                isLoading: loading,
                child: Column(
                  children: [
                    ParentHomeStatsSection(data: data),
                    const SizedBox(height: 16),
                    ParentChildrenSection(
                      onShowAll: onShowAllChildren,
                      children: data.children,
                      loading: loading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
