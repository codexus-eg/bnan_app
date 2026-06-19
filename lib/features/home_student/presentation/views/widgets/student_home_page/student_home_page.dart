import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/evaluation_metric/weekly_evaluation_section.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/lesson_schedule/lesson_schedule_card.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/lessons_widgets/upcoming_lesson_card.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/package_details_card.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({
    super.key,
    required this.onMenuTap,
    required this.userName,
  });
  final VoidCallback onMenuTap;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeAppBar(
          userName: userName,
          onMenuTap: onMenuTap,
          onNotificationTap: () {
            MyNavigator.goTo(context, Routes.notification);
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PackageDetailsCard(), // const SizedBox(height: 16),
                UpcomingLessonCard(),
                LessonScheduleCard(),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: HomeStatsSection(states: studentHomeState),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: const WeeklyEvaluationSection(),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
