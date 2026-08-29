import 'dart:async';

import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/features/student_auth/data/models/otp_flow_args.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_registration_body.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/registration_back_handler.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/tamara_verification_loading.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegistrationView extends StatelessWidget {
  const StudentRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final register = context.watch<RegisterCubit>();
    final step = register.state.currentStep;
    final payment = context.watch<TamaraPaymentCubit>();
    final isVerifying =
        register.isGulf &&
        (payment.isAwaitingVerification ||
            payment.state is TamaraPaymentVerificationPending);
    return PopScope(
      canPop: !isVerifying && step == RegisterCubit.firstStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !isVerifying) {
          unawaited(RegistrationBackHandler.previous(context));
        }
      },
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) async {
          final cubit = context.read<RegisterCubit>();
          if (state is ParentVerificationRequired) {
            final verified = await MyNavigator.goTo<bool>(
              context,
              Routes.forgetPassword,
              extra: OtpFlowArgs.accountVerification(
                cubit.parentEmailController.text.trim(),
                resumeStudentRegistration: true,
              ),
            );
            if (verified == true && context.mounted) {
              await cubit.authenticateParentAndContinue();
            }
            return;
          }
          if (state is ParentAuthenticated) {
            if (cubit.isGulf) {
              await context.read<TamaraPaymentCubit>().resumeAfterParentAuth();
            }
            return;
          }
          if (state is! RegisterSuccess || cubit.isGulf) return;
          MyNavigator.goToOffAll(
            context,
            Routes.forgetPassword,
            extra: OtpFlowArgs.accountVerification(
              context.read<RegisterCubit>().studentEmailController.text.trim(),
              showEgyptianRegistrationSuccess: true,
            ),
          );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              const StudentRegistrationBody(),
              if (isVerifying) const TamaraVerificationLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
