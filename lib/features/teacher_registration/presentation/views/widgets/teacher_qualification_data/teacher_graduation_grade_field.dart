import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherGraduationGradeField extends StatelessWidget {
  const TeacherGraduationGradeField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);
    final gradesMap = {
      S.of(context).excellent: 'excellent',
      S.of(context).veryGood: 'very-good',
      S.of(context).good: 'good',
    };
    return CustomDropdownFormField(
      label: S.of(context).graduationGrade,
      value: cubit.graduationGrade == null
          ? null
          : gradesMap.entries
                .firstWhere((entry) => entry.value == cubit.graduationGrade)
                .key,
      isRequired: true,
      items: gradesMap.keys.toList(),

      onChanged: (value) {
        cubit.changeGraduationGrade(gradesMap[value]);
      },
      validator: (value) =>
          MyValidator.requiredField(value, S.of(context).graduationGrade),
    );
  }
}
