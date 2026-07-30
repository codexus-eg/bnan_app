import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plan_date_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddDailyPlanSelectFields extends StatelessWidget {
  const AddDailyPlanSelectFields({
    super.key,
    required this.policy,
    required this.dateController,
    required this.onGradeChanged,
    required this.onTeacherChanged,
    required this.onSubjectChanged,
  });

  final PlansAccessPolicy policy;
  final TextEditingController dateController;
  final ValueChanged<String?> onGradeChanged;
  final ValueChanged<String?> onTeacherChanged;
  final ValueChanged<String?> onSubjectChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        _dropdown(s.grade, s.chooseGrade, onGradeChanged, {
          'first': s.firstPrimaryClassroom,
          'second': s.secondPrimaryClassroom,
        }),
        if (policy.showTeacherFieldInAddDialog) ...[
          const SizedBox(height: 12),
          _dropdown(s.teacher, s.selectTeacher, onTeacherChanged, {
            'teacher1': s.sampleTeacherOne,
            'teacher2': s.sampleTeacherTwo,
          }),
        ],
        const SizedBox(height: 12),
        PlanDateField(controller: dateController),
        const SizedBox(height: 12),
        _dropdown(s.subject, s.selectSubject, onSubjectChanged, {
          'math': s.math,
          'arabic': s.arabic,
        }),
      ],
    );
  }

  Widget _dropdown(
    String label,
    String hint,
    ValueChanged<String?> onChanged,
    Map<String, String> labels,
  ) {
    return CustomDropdownFormField(
      label: label,
      hint: hint,
      items: labels.keys.toList(),
      itemsLabels: labels,
      isRequired: true,
      onChanged: onChanged,
      validator: (value) => MyValidator.requiredField(value, label),
    );
  }
}
