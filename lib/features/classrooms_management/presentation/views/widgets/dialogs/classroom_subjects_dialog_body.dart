import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_assigned_subject.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_add_subject_row.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_subjects_content.dart';
import 'package:flutter/material.dart';

class ClassroomSubjectsDialogBody extends StatelessWidget {
  const ClassroomSubjectsDialogBody({
    super.key,
    required this.loaded,
    required this.selectedSubjectId,
    required this.onSubjectChanged,
    required this.onAdd,
    required this.onDelete,
  });

  final ClassroomSubjectsLoaded? loaded;
  final String? selectedSubjectId;
  final ValueChanged<String?> onSubjectChanged;
  final VoidCallback onAdd;
  final ValueChanged<ClassroomAssignedSubject> onDelete;

  @override
  Widget build(BuildContext context) {
    final unassigned = loaded?.data.unassignedEligibleSubjects ?? [];
    final msg = loaded?.feedbackMessage;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClassroomSubjectsContent(
          subjects: loaded?.data.subjects ?? [],
          enabled: !(loaded?.actionLoading ?? false),
          onDelete: onDelete,
        ),
        if (unassigned.isNotEmpty) ...[
          const SizedBox(height: 16),
          ClassroomAddSubjectRow(
            eligibleSubjects: unassigned,
            selectedSubjectId: selectedSubjectId,
            isLoading: loaded?.actionLoading ?? false,
            onSubjectChanged: onSubjectChanged,
            onAdd: onAdd,
          ),
        ],
        if (msg != null) ...[
          const SizedBox(height: 12),
          Text(msg,
              textAlign: TextAlign.center,
              style: StylesManager.styleRegular12(context).copyWith(
                  color: loaded!.isError ? ColorManager.red : ColorManager.blue3A)),
        ],
      ],
    );
  }
}
