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
    this.showAddButton = true,
    this.adjacentFilter,
  });

  final List<LessonClassroomUiModel> classrooms;
  final String? selectedClassroomId;
  final ValueChanged<String?> onClassroomChanged;
  final VoidCallback? onAddTap;
  final bool showAddButton;
  final Widget? adjacentFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (adjacentFilter == null)
            _classroomDropdown()
          else
            Row(
              children: [
                Expanded(flex: 3, child: _classroomDropdown()),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: adjacentFilter!),
              ],
            ),
          if (showAddButton) ...[
            const SizedBox(height: 12),
            AddLessonButton(onTap: onAddTap),
          ],
        ],
      ),
    );
  }

  Widget _classroomDropdown() => LessonClassroomDropdown(
    classrooms: classrooms,
    value: selectedClassroomId,
    onChanged: onClassroomChanged,
  );
}
