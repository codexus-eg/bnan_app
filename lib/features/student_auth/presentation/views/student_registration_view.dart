import 'dart:async';

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
      child: const Scaffold(
        resizeToAvoidBottomInset: true,
        body: StudentRegistrationBody(),
      ),
    );
  }
}
