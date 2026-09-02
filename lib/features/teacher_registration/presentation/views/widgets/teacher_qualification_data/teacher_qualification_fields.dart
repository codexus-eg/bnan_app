import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_qualification_data/teacher_degree_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_qualification_data/teacher_graduation_info_fields.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherQualificationFields extends StatelessWidget {
  const TeacherQualificationFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);

    return Column(
      children: [
        const TeacherDegreeField(),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).specialization,
          controller: cubit.specializationController,
          isRequired: true,
          validator: (value) =>
              MyValidator.requiredField(value, S.of(context).specialization),
        ),
        const SizedBox(height: 16),
        const TeacherGraduationInfoFields(),
      ],
    );
  }
}
