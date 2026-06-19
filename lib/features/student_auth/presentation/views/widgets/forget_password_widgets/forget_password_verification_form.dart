import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/forgot_password_cubit/forgot_password_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/reset_password_cubit/reset_password_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/forget_password_widgets/otp_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordVerificationForm extends StatelessWidget {
  const ForgetPasswordVerificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final resetCubit = ResetPasswordCubit.get(context);
    final forgotCubit = ForgotPasswordCubit.get(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              showCustomSnackBar(context, state.message, true);
            }

            if (state is ForgotPasswordFailure) {
              showCustomSnackBar(context, state.errorMessage, false);
            }
          },
        ),
        BlocListener<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is VerifyResetCodeSuccess) {
              MyNavigator.goToOffAll(
                context,
                Routes.changePassword,
                extra: ForgotPasswordCubit.get(
                  context,
                ).emailController.text.trim(),
              );
            }

            if (state is ResetPasswordFailure) {
              showCustomSnackBar(context, state.errorMessage, false);
            }
          },
        ),
      ],
      child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
        builder: (context, resetState) {
          return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
            builder: (context, forgotState) {
              final isVerifyLoading = resetState is ResetPasswordLoading;
              final isResendLoading = forgotState is ForgotPasswordLoading;
              final isLoading = isVerifyLoading || isResendLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OtpWidget(pinController: resetCubit.otpController),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: isLoading ? null : forgotCubit.resendCode,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 28),
                    ),
                    child: Text(
                      S.of(context).resendCode,
                      style: StylesManager.styleBold12(context).copyWith(
                        color: isLoading
                            ? ColorManager.greyA8AF
                            : ColorManager.secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomAppButton(
                    text: S.of(context).verify,
                    isLoading: isVerifyLoading,
                    onPressed: resetCubit.verifyResetCode,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
