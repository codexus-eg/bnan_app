import 'package:bnan_app/features/lessons_management/presentation/views/widgets/add_lesson_button.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/lesson_classroom_dropdown.dart';
import 'package:flutter/material.dart';

class LessonsManagementHeader extends StatelessWidget {
  const LessonsManagementHeader({
    super.key,
    required this.classrooms,
    required this.selectedClassroomId,
    required this.onClassroomChanged,
    required this.onAddTap,
  });

  final List<LessonClassroomUiModel> classrooms;
  final String? selectedClassroomId;
  final ValueChanged<String?> onClassroomChanged;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LessonClassroomDropdown(
            classrooms: classrooms,
            value: selectedClassroomId,
            onChanged: onClassroomChanged,
          ),
          const SizedBox(height: 12),
          AddLessonButton(onTap: onAddTap),
        ],
      ),
    );
  }
}
