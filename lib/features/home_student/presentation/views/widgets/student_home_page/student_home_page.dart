import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_builder.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_home_subscription_section.dart';
import 'package:bnan_app/features/student_subscriptions/presentation/manager/student_subscriptions_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({
    super.key,
    required this.onMenuTap,
    required this.userName,
  });
  final VoidCallback onMenuTap;
  final String userName;

  @override
  Widget build(BuildContext context) => DashboardBuilder<StudentDashboardModel>(
    skeleton: StudentDashboardModel(
      generatedAt: null,
      student: DashboardStudent(id: '', fullName: userName, email: ''),
      stats: const DashboardStudentStats(
        certificates: 0,
        attendance: DashboardAttendance(
          total: 0,
          present: 0,
          late: 0,
          absent: 0,
        ),
      ),
      weeklyEvaluation: null,
    ),
    builder: (context, data, loading) => Column(
      children: [
        HomeAppBar(
          userName: userName,
          onMenuTap: onMenuTap,
          onNotificationTap: () =>
              MyNavigator.goTo(context, Routes.notification),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => Future.wait([
              context.read<DashboardCubit>().refresh(),
              context.read<StudentSubscriptionsCubit>().loadHome(),
            ]),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: AppSkeletonizer(
                isLoading: loading,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HomeStatsSection(states: _stats(context, data)),
                    ),
                    const SizedBox(height: 16),
                    const StudentHomeSubscriptionSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  List<HomeStateModel> _stats(
    BuildContext context,
    StudentDashboardModel data,
  ) => [
    HomeStateModel(
      icon: ImageManager.arrowGrowthIcon,
      value: data.stats.attendance.percentage == null
          ? '--'
          : '${data.stats.attendance.percentage!.toStringAsFixed(0)}%',
      title: S.of(context).attendance,
      iconColor: ColorManager.blue4260,
    ),
    HomeStateModel(
      icon: ImageManager.trophyIcon,
      value: '${data.stats.certificates}',
      title: S.of(context).certificates,
      iconColor: ColorManager.mainColor14,
    ),
  ];
}
