import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherBirthDateField extends StatelessWidget {
  const TeacherBirthDateField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);
    return CustomTextField(
      label: S.of(context).dateOfBirth,
      controller: cubit.dateOfBirthController,
      isRequired: true,
      readOnly: true,
      suffixIcon: const Icon(Icons.calendar_month_outlined),
      onTap: () => _pick(context, cubit),
      validator: (value) =>
          MyValidator.requiredField(value, S.of(context).dateOfBirth),
    );
  }

  Future<void> _pick(
    BuildContext context,
    TeacherRegistrationCubit cubit,
  ) async {
    final now = DateTime.now();
    final date = await AppPickers.pickDate(
      context: context,
      initialDate: cubit.dateOfBirth ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (date != null) cubit.changeDateOfBirth(date);
  }
}
