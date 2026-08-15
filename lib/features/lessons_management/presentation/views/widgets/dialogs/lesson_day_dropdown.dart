import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/lessons_management/presentation/models/lesson_days.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonDayDropdown extends StatelessWidget {
  const LessonDayDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.days = lessonDays,
  });

  final String value;
  final ValueChanged<String?>? onChanged;
  final List<String> days;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomDropdown(
      label: s.day,
      value: value,
      items: days,
      itemsLabels: {for (final day in days) day: lessonDayLabel(s, day)},
      onChanged: onChanged,
    );
  }
}
