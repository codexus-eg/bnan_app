import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_password_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/student_password_note.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentInfoStep extends StatelessWidget {
  const StudentInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = RegisterCubit.get(context);
    return Form(
      key: cubit.studentFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: cubit.studentNameController,
            label: S.of(context).studentName,
            isRequired: true,
            validator: MyValidator.validateName,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: cubit.studentEmailController,
            label: S.of(context).studentEmail,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            validator: MyValidator.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomPasswordField(
            controller: cubit.studentPasswordController,
            label: S.of(context).studentPasswordField,
            hintText: S.of(context).passwordHint,
          ),
          const SizedBox(height: 12),
          const StudentPasswordNote(),
        ],
      ),
    );
  }
}
