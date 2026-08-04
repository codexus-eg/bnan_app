import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lesson_week_day_item.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonsWeekDaysSelector extends StatelessWidget {
  const LessonsWeekDaysSelector({
    super.key,
    required this.selectedDay,
    required this.onSelected,
  });

  final String selectedDay;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final day in lessonDays) ...[
            LessonWeekDayItem(
              day: lessonDayLabel(s, day),
              isSelected: selectedDay == day,
              onTap: () => onSelected(day),
            ),
            if (day != lessonDays.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
