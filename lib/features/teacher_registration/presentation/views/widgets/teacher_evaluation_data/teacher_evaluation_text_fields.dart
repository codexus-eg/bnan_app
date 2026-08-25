import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherEvaluationTextFields extends StatelessWidget {
  const TeacherEvaluationTextFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);

    return Column(
      children: [
        CustomTextField(
          label: S.of(context).shortVideoLink,
          isRequired: true,
          controller: cubit.shortVideoLinkController,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).whyJoinBananAcademy,
          controller: cubit.whyJoinBananController,
          isRequired: true,
          maxLine: 3,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: S.of(context).howHandleWeakStudent,
          controller: cubit.howHandleWeakStudentController,
          isRequired: true,
          maxLine: 3,
        ),
      ],
    );
  }
}
