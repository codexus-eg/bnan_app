import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/utils/teacher_degree_labels.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherDegreeField extends StatelessWidget {
  const TeacherDegreeField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);
    final labels = TeacherDegreeLabels.of(context);
    return CustomDropdownFormField(
      label: S.of(context).qualification,
      value: cubit.degree,
      items: labels.keys.toList(),
      itemsLabels: labels,
      isRequired: true,
      onChanged: cubit.changeDegree,
      validator: (value) =>
          MyValidator.requiredField(value, S.of(context).qualification),
    );
  }
}
