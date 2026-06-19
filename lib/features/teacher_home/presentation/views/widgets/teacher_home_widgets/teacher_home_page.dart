import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/core/shared_widget/home_state/home_stats_section.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/next_lessons_body.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_card.dart';
import 'package:flutter/material.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key, required this.onMenuTap});
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeAppBar(
          userName: 'Salma Ehab',
          onMenuTap: onMenuTap,
          onNotificationTap: () {
            MyNavigator.goTo(context, Routes.notification);
          },
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              TeacherHomeCard(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeStatsSection(states: teacherHomeState),
              ),
              const SizedBox(height:16),
              NextLessonsBody()
            ],
          ),
        ),
      ],
    );
  }
}
