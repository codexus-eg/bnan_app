import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_eligible_subject.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomAddSubjectRow extends StatelessWidget {
  const ClassroomAddSubjectRow({
    super.key,
    required this.eligibleSubjects,
    required this.selectedSubjectId,
    required this.onSubjectChanged,
    required this.onAdd,
    required this.isLoading,
  });

  final List<ClassroomEligibleSubject> eligibleSubjects;
  final String? selectedSubjectId;
  final ValueChanged<String?> onSubjectChanged;
  final VoidCallback onAdd;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      children: [
        Expanded(
          child: CustomDropdown(
            label: s.eligibleSubjects,
            hint: s.eligibleSubjects,
            showLabel: false,
            value: selectedSubjectId,
            items: eligibleSubjects.map((e) => e.id).toList(),
            itemsLabels: {for (final e in eligibleSubjects) e.id: e.name},
            backgroundColor: ColorManager.white,
            onChanged: onSubjectChanged,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: CustomAppButton(
            text: s.addAction,
            isLoading: isLoading,
            onPressed: (selectedSubjectId != null && !isLoading) ? onAdd : null,
          ),
        ),
      ],
    );
  }
}
