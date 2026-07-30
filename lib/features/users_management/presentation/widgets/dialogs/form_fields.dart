import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/add_user_curriculum_field.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/add_user_role_field.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_mode.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/password_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class FormFields extends StatelessWidget {
  const FormFields({
    super.key,
    required this.mode,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.curriculumId,
    required this.onCurriculumChanged,
  });

  final FormMode mode;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final String? curriculumId;
  final ValueChanged<String?> onCurriculumChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        if (mode != FormMode.password)
          CustomTextField(
            label: s.fullName,
            controller: nameController,
            validator: MyValidator.validateName,
            hintStyle: getStyle(context),
            backgroundColor: ColorManager.white,
          ),
        if (mode == FormMode.add) ...[
          const SizedBox(height: 16),
          CustomTextField(
            label: s.email,
            controller: emailController,
            validator: MyValidator.validateEmail,
            hintStyle: getStyle(context),
            backgroundColor: ColorManager.white,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: s.phoneNumber,
            controller: phoneController,
            validator: (value) =>
                MyValidator.requiredField(value, s.phoneNumber),
            hintStyle: getStyle(context),
            backgroundColor: ColorManager.white,
          ),
          const SizedBox(height: 16),
          const AddUserRoleField(),
          const SizedBox(height: 16),
          AddUserCurriculumField(
            value: curriculumId,
            onChanged: onCurriculumChanged,
          ),
        ],
        if (mode != FormMode.edit) ...[
          const SizedBox(height: 16),
          PasswordField(
            mode: mode,
            controller: passwordController,
            validator: MyValidator.validatePassword,
            obscureText: obscurePassword,
            onToggleVisibility: onTogglePasswordVisibility,
          ),
        ],
      ],
    );
  }

  TextStyle getStyle(context) {
    return StylesManager.styleMedium14(
      context,
    ).copyWith(color: ColorManager.mainColor14);
  }
}
