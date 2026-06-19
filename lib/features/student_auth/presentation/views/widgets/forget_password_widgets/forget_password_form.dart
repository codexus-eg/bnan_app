import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/forgot_password_cubit/forgot_password_state.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({super.key, required this.onSuccess});

  final void Function(String email) onSuccess;

  @override
  Widget build(BuildContext context) {
    final cubit = ForgotPasswordCubit.get(context);

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          showCustomSnackBar(context, state.message, true);
          onSuccess(cubit.emailController.text.trim());
        }

        if (state is ForgotPasswordFailure) {
          showCustomSnackBar(context, state.errorMessage, false);
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;

        return Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextField(
                label: S.of(context).email,
                hintText: '',
                controller: cubit.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: MyValidator.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomAppButton(
                text: S.of(context).sendResetCode,
                isLoading: isLoading,
                onPressed: cubit.forgotPassword,
              ),
            ],
          ),
        );
      },
    );
  }
}