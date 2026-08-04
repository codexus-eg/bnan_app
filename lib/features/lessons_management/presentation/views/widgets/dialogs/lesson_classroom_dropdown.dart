import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonClassroomDropdown extends StatelessWidget {
  const LessonClassroomDropdown({
    super.key,
    required this.classrooms,
    required this.value,
    required this.onChanged,
  });

  final List<LessonClassroomUiModel> classrooms;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      label: S.of(context).classroom,
      hint: S.of(context).selectClassroom,
      value: value,
      items: classrooms.map((item) => item.id).toList(),
      itemsLabels: {for (final item in classrooms) item.id: item.name},
      onChanged: onChanged,
    );
  }
}
