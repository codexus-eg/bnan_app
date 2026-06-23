import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherLocationFields extends StatelessWidget {
  const TeacherLocationFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);

    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: S.of(context).country,
            isRequired: true,
            controller: cubit.countryController,
            validator: (value) =>
                MyValidator.requiredField(value, S.of(context).country),
          ),
        ),
        const SizedBox(width: 23),
        Expanded(
          child: CustomTextField(
            label: S.of(context).city,
            controller: cubit.cityController,
            isRequired: true,
            validator: (value) =>
                MyValidator.requiredField(value, S.of(context).city),
          ),
        ),
      ],
    );
  }
}
