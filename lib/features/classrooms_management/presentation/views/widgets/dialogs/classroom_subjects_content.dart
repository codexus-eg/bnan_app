import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_assigned_subject.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_subject_item_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomSubjectsContent extends StatelessWidget {
  const ClassroomSubjectsContent({
    super.key,
    required this.subjects,
    required this.onDelete,
    required this.enabled,
  });

  final List<ClassroomAssignedSubject> subjects;
  final ValueChanged<ClassroomAssignedSubject> onDelete;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            S.of(context).noAssignedSubjects,
            style: StylesManager.styleRegular12(context)
                .copyWith(color: ColorManager.grey7A7C),
          ),
        ),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 220),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: subjects.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) => ClassroomSubjectItemCard(
          subject: subjects[i],
          enabled: enabled,
          onDelete: () => onDelete(subjects[i]),
        ),
      ),
    );
  }
}
