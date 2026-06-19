import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/reset_password_cubit/reset_password_state.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    final cubit = ResetPasswordCubit.get(context);

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          showCustomSnackBar(context, S.of(context).passwordChangedSuccessfully, true);
          MyNavigator.goToOffAll(context, Routes.logIn);
        }

        if (state is ResetPasswordFailure) {
          showCustomSnackBar(context, state.errorMessage, false);
        }
      },
      builder: (context, state) {
        final isLoading = state is ResetPasswordLoading;

        return Form(
          key: cubit.formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: cubit.newPasswordController,
                label: S.of(context).newPassword,
                hintText: S.of(context).passwordHint,
                obscureText: !cubit.isNewPasswordVisible,
                suffixIcon: IconButton(
                  onPressed: cubit.toggleNewPasswordVisibility,
                  icon: Icon(
                    cubit.isNewPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 24,
                    color: ColorManager.greyA8AF,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: cubit.confirmPasswordController,
                label: S.of(context).confirmNewPassword,
                hintText: S.of(context).passwordHint,
                obscureText: !cubit.isConfirmPasswordVisible,
                suffixIcon: IconButton(
                  onPressed: cubit.toggleConfirmPasswordVisibility,
                  icon: Icon(
                     cubit.isNewPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 24,
                    color: ColorManager.greyA8AF,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomAppButton(
                text: S.of(context).confirm,
                isLoading: isLoading,
                onPressed: () => cubit.resetPassword(email: email),
              ),
            ],
          ),
        );
      },
    );
  }
}