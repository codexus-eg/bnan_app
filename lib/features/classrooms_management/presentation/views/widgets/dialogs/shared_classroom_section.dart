import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_form_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_subjects_picker.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_targets_picker.dart';
import 'package:flutter/material.dart';

class SharedClassroomSection extends StatelessWidget {
  const SharedClassroomSection({
    super.key,
    required this.state,
    required this.onGrade1Changed,
    required this.onGrade2Changed,
    required this.onPrimaryChanged,
    required this.onToggleSubject,
  });

  final SharedClassroomFormState state;
  final ValueChanged<String?> onGrade1Changed, onGrade2Changed;
  final ValueChanged<int> onPrimaryChanged;
  final ValueChanged<String> onToggleSubject;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SharedClassroomTargetsPicker(
          grades: state.grades,
          grade1Id: state.grade1Id,
          grade2Id: state.grade2Id,
          primaryTargetIndex: state.primaryTargetIndex,
          onGrade1Changed: onGrade1Changed,
          onGrade2Changed: onGrade2Changed,
          onPrimaryChanged: onPrimaryChanged,
        ),
        const SizedBox(height: 12),
        SharedClassroomSubjectsPicker(
          subjects: state.unionSubjects,
          selectedIds: state.selectedSubjectIds,
          isLoading: state.loadingSubjects,
          onToggle: onToggleSubject,
        ),
      ],
    );
  }
}
