import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_appbar.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/assignments/assignments_preview_section.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/certification/certificates_preview_section.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/evaluation_metric/weekly_evaluation_section.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/lesson_schedule/lesson_schedule_card.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/lessons_widgets/upcoming_lesson_card.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/package_details_card.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_state/student_stats_section.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/study_materials/study_materials_section.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key, required this.onMenuTap});
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeAppBar(
          userName: 'فهد ناصر',
          onMenuTap: onMenuTap,
          onNotificationTap: () {
            MyNavigator.goTo(context, Routes.notification);
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PackageDetailsCard(),
                // const SizedBox(height: 16),
                UpcomingLessonCard(),
                LessonScheduleCard(),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: StudentStatsSection(),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: const WeeklyEvaluationSection(),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: const StudyMaterialsSection(),
                ),
                const AssignmentsPreviewSection(),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: const CertificatesPreviewSection(),
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
