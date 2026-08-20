import 'dart:async';

import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/features/student_auth/data/models/otp_flow_args.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_registration_body.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/registration_back_handler.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegistrationView extends StatelessWidget {
  const StudentRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final step = context.watch<RegisterCubit>().state.currentStep;
    return PopScope(
      canPop: step == RegisterCubit.firstStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(RegistrationBackHandler.previous(context));
      },
      child: BlocListener<RegisterCubit, RegisterState>(
        listenWhen: (_, state) => state is RegisterSuccess,
        listener: (context, state) {
          if (context.read<RegisterCubit>().isGulf) return;
          MyNavigator.goToOffAll(
            context,
            Routes.forgetPassword,
            extra: OtpFlowArgs.accountVerification(
              context.read<RegisterCubit>().studentEmailController.text.trim(),
              showEgyptianRegistrationSuccess: true,
            ),
          );
        },
        child: const Scaffold(
          resizeToAvoidBottomInset: true,
          body: StudentRegistrationBody(),
        ),
      ),
    );
  }
}
