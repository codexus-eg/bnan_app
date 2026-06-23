import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherAccountFields extends StatelessWidget {
  const TeacherAccountFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);

    return Column(
      children: [
        CustomTextField(
          label: S.of(context).password,
          isRequired: true,
          controller: cubit.passwordController,
          obscureText: true,
          validator: MyValidator.validatePassword,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).nationality,
          isRequired: true,
          controller: cubit.nationalityController,
          validator: (value) =>
              MyValidator.requiredField(value, S.of(context).nationality),
        ),
      ],
    );
  }
}