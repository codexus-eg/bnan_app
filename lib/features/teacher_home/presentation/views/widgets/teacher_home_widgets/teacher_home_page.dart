import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/dashboard/data/models/teacher_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_builder.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key, required this.onMenuTap});
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      HomeAppBar(
        userName: CurrentUserUi.name(context),
        onMenuTap: onMenuTap,
        onNotificationTap: () => MyNavigator.goTo(context, Routes.notification),
      ),
      Expanded(
        child: DashboardBuilder<TeacherDashboardModel>(
          skeleton: const TeacherDashboardModel(
            generatedAt: null,
            points: 0,
            classrooms: 0,
            students: 0,
            subjects: 0,
          ),
          builder: (context, data, loading) => RefreshIndicator(
            onRefresh: context.read<DashboardCubit>().refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                AppSkeletonizer(
                  isLoading: loading,
                  child: Column(
                    children: [
                      TeacherHomeCard(points: data.points),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: HomeStatsSection(states: _stats(context, data)),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  List<HomeStateModel> _stats(
    BuildContext context,
    TeacherDashboardModel data,
  ) => [
    HomeStateModel(
      icon: ImageManager.teacherBookTwoIcon,
      value: '${data.classrooms}',
      title: S.of(context).classes,
    ),
    HomeStateModel(
      icon: ImageManager.userProfileGroupIcon,
      value: '${data.students}',
      title: S.of(context).students,
    ),
    HomeStateModel(
      icon: ImageManager.teacherBookOneIcon,
      value: '${data.subjects}',
      title: S.of(context).subject,
    ),
  ];
}
