import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherContactFields extends StatelessWidget {
  const TeacherContactFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);

    return Column(
      children: [
        CustomTextField(
          label: S.of(context).fullName,
          controller: cubit.fullNameController,
          isRequired: true,
          validator: MyValidator.validateName,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).phoneNumber,
          controller: cubit.phoneController,
          isRequired: true,
          keyboardType: TextInputType.phone,
          validator: (value) =>
              MyValidator.requiredField(value, S.of(context).phoneNumber),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).whatsappNumber,
          controller: cubit.whatsappController,
          isRequired: true,
          keyboardType: TextInputType.phone,
          validator: (value) =>
              MyValidator.requiredField(value, S.of(context).whatsappNumber),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).email,
          controller: cubit.emailController,
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          validator: MyValidator.validateEmail,
        ),
      ],
    );
  }
}