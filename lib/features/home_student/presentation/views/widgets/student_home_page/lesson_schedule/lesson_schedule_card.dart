import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/lesson_schedule/lesson_schedule_clock_icon.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/lesson_schedule/lesson_schedule_info.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/lesson_schedule/lesson_schedule_time.dart';
import 'package:flutter/material.dart';

class LessonScheduleCard extends StatelessWidget {
  const LessonScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        top: 6,
        // bottom: 16,
      ),
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LessonScheduleTime(),
          SizedBox(
            height: 49,
            child: VerticalDivider( width: 18,color: ColorManager.greyA8AF)),
          SizedBox(width: 8),
          LessonScheduleInfo(),
          Spacer(),
          LessonScheduleClockIcon(),
        ],
      ),
    );
  }
}
