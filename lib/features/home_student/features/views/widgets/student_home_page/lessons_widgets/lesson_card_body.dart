import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/student_home_page/lessons_widgets/lesson_icon_box.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/student_home_page/lessons_widgets/lesson_time_info.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/student_home_page/lessons_widgets/lesson_title_info.dart';
import 'package:flutter/material.dart';

class LessonCardBody extends StatelessWidget {
  const LessonCardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LessonIconBox(icon: ImageManager.bookIcon),
        SizedBox(width: 8),
        LessonTitleInfo(),
        Spacer(),
        LessonTimeInfo(),
      ],
    );
  }
}
