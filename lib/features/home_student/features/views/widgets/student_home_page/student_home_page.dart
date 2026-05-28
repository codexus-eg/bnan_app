import 'package:bnan_app/features/home_student/features/views/widgets/home_appbar.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/student_home_page/lesson_schedule/lesson_schedule_card.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/student_home_page/lessons_widgets/upcoming_lesson_card.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/student_home_page/package_details/package_details_card.dart';
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
          onNotificationTap: () {},
        ),
        PackageDetailsCard(),
        // const SizedBox(height: 16),
        UpcomingLessonCard(),
        LessonScheduleCard(),
      ],
    );
  }
}
