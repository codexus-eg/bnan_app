import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lesson_week_day_item.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonsWeekDaysSelector extends StatelessWidget {
  const LessonsWeekDaysSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Row(
        children: [
          LessonWeekDayItem(day: s.saturday, number: '05'),
          const SizedBox(width: 8),
          LessonWeekDayItem(day: s.friday, number: '06'),
          const SizedBox(width: 8),
          LessonWeekDayItem(day: s.thursday, number: '07', isSelected: true),
          const SizedBox(width: 8),
          LessonWeekDayItem(day: s.wednesday, number: '08'),
          const SizedBox(width: 8),
          LessonWeekDayItem(day: s.tuesday, number: '09'),
          const SizedBox(width: 8),
          LessonWeekDayItem(day: s.monday, number: '10'),
        ],
      ),
    );
  }
}
