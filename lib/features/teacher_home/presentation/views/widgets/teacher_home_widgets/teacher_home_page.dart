import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/dashboard/data/models/teacher_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_builder.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_card.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_statistics_card.dart';
import 'package:bnan_app/features/teacher_home/presentation/manager/teacher_session_statistics_cubit.dart';
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
            isIdealTeacher: false,
            points: 0,
            classrooms: 0,
            students: 0,
            subjects: 0,
          ),
          builder: (context, data, loading) => RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                context.read<DashboardCubit>().refresh(),
                context.read<TeacherSessionStatisticsCubit>().load(),
              ]);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                AppSkeletonizer(
                  isLoading: loading,
                  child: Column(
                    children: [
                      if (data.isIdealTeacher)
                        TeacherHomeCard(points: data.effectivePoints),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: TeacherStatisticsCard(),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: HomeStatsSection(
                          states: _stats(context, data),
                          crossAxisCount: 2,
                        ),
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
    HomeStateModel(
      icon: ImageManager.crownSimple,
      value: data.teacherPoints != null ? '${data.teacherPoints}' : '—',
      title: S.of(context).myPointsThisWeek,
      iconColor: ColorManager.mainColor14,
    ),
  ];
}
