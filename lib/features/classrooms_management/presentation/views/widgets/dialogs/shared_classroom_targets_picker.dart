import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_target_chip.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SharedClassroomTargetsPicker extends StatelessWidget {
  const SharedClassroomTargetsPicker({
    super.key,
    required this.grades,
    required this.grade1Id,
    required this.grade2Id,
    required this.primaryTargetIndex,
    required this.onGrade1Changed,
    required this.onGrade2Changed,
    required this.onPrimaryChanged,
  });

  final List<AcademicGradeModel> grades;
  final String? grade1Id, grade2Id;
  final int primaryTargetIndex;
  final ValueChanged<String?> onGrade1Changed, onGrade2Changed;
  final ValueChanged<int> onPrimaryChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final items = grades.map((g) => g.id).toList();
    final labels = {for (final g in grades) g.id: g.name};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(label: s.firstGrade, value: grade1Id, items: items, itemsLabels: labels, backgroundColor: ColorManager.white, onChanged: onGrade1Changed),
        const SizedBox(height: 12),
        CustomDropdown(label: s.secondGrade, value: grade2Id, items: items, itemsLabels: labels, backgroundColor: ColorManager.white, onChanged: onGrade2Changed),
        const SizedBox(height: 12),
        Row(
          children: [
            Text('${s.primaryTarget}: ', style: StylesManager.styleBold12(context)),
            const SizedBox(width: 8),
            SharedClassroomTargetChip(label: s.firstGrade, isSelected: primaryTargetIndex == 0, onTap: () => onPrimaryChanged(0)),
            const SizedBox(width: 8),
            SharedClassroomTargetChip(label: s.secondGrade, isSelected: primaryTargetIndex == 1, onTap: () => onPrimaryChanged(1)),
          ],
        ),
      ],
    );
  }
}
