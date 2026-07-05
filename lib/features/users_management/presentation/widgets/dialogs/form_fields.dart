import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_mode.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/password_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  });

  final FormMode mode;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;

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
            validator: (value) => MyValidator.requiredField(
              value,
              s.phoneNumber,
            ),
            hintStyle: getStyle(context),
            backgroundColor: ColorManager.white,
          ),
          const SizedBox(height: 16),
          CustomDropdownFormField(
            label: s.userRole,
            value: _roleLabel(context),
            backgroundColor: ColorManager.white,
            items: [s.student, s.parentRole, s.supervisor, s.teacher],
            validator: (value) => MyValidator.requiredField(
              value,
              s.userRole,
            ),
            onChanged: (value) {
              context.read<UsersManagementCubit>().setSelectedRole(
                _roleValue(context, value),
              );
            },
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

  String _roleLabel(BuildContext context) {
    final s = S.of(context);
    final role = context.read<UsersManagementCubit>().selectedRole;
    if (role == 'parent') return s.parentRole;
    if (role == 'supervisor') return s.supervisor;
    if (role == 'teacher') return s.teacher;
    return s.student;
  }

  String _roleValue(BuildContext context, String? value) {
    final s = S.of(context);
    if (value == s.parentRole) return 'parent';
    if (value == s.supervisor) return 'supervisor';
    if (value == s.teacher) return 'teacher';

    return 'student';
  }
}
