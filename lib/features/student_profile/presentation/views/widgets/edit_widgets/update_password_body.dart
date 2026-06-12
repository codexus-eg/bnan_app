import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/bnan_footer.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/update_password_cubit/update_password_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/update_password_cubit/update_password_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'update_password_text_field.dart';

class UpdatePasswordBody extends StatelessWidget {
  const UpdatePasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdatePasswordCubit>();

    return BlocConsumer<UpdatePasswordCubit, UpdatePasswordState>(
      listener: (context, state) {
        if (state is UpdatePasswordSuccess) {
          showCustomSnackBar(context, state.message, true);
Navigator.pop(context, true);        }

        if (state is UpdatePasswordFailure) {
          showCustomSnackBar(context, state.errorMessage, false);
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdatePasswordLoading;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                UpdatePasswordTextField(
                  controller: cubit.currentPasswordController,
                  obscureText: cubit.isCurrentPasswordObscure,
                  onVisibilityTap: cubit.toggleCurrentPasswordVisibility,
                  label: S.of(context).oldPasswordLabel,
                  hintText: S.of(context).passwordHint,
                ),
                const SizedBox(height: 16),
                UpdatePasswordTextField(
                  controller: cubit.newPasswordController,
                  label: S.of(context).newPasswordLabel,
                  obscureText: cubit.isNewPasswordObscure,
                  onVisibilityTap: cubit.toggleNewPasswordVisibility,
                  hintText: S.of(context).passwordHint,
                ),
                const SizedBox(height: 16),
                UpdatePasswordTextField(
                  controller: cubit.confirmNewPasswordController,
                  obscureText: cubit.isConfirmPasswordObscure,
                  onVisibilityTap: cubit.toggleConfirmPasswordVisibility,
                  label: S.of(context).confirmNewPassword,
                  hintText: S.of(context).passwordHint,
                ),
                const SizedBox(height: 16),
                CustomAppButton(
                  text: S.of(context).confirm,
                  isLoading: isLoading,
                  onPressed: () {
                    if (isLoading) return;
                    cubit.updatePassword();
                  },
                ),
                const Spacer(),
                const BnanFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
