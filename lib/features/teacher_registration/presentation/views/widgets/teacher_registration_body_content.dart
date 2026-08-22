import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/student_auth/data/models/otp_flow_args.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_registration_body_slivers.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_registration_handle_next.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRegistrationBodyContent extends StatelessWidget {
  const TeacherRegistrationBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherRegistrationCubit, TeacherRegistrationState>(
      listener: (context, state) {
        if (state is TeacherRegistrationFailureState) {
          showCustomSnackBar(context, state.errorMessage, false);
        }

        if (state is TeacherRegistrationSuccessState) {
          MyNavigator.goToOffAll(
            context,
            Routes.forgetPassword,
            extra: OtpFlowArgs.accountVerification(
              TeacherRegistrationCubit.get(context).emailController.text.trim(),
            ),
          );
          showCustomSnackBar(
            context,
            S.of(context).requestSubmittedUnderReview,
            true,
          );
        }
      },
      builder: (context, state) {
        final cubit = TeacherRegistrationCubit.get(context);

        return TeacherRegistrationBodySlivers(
          state: state,
          isLoading: state is TeacherRegistrationLoadingState,
          onNext: cubit.isSubmitDisabled
              ? null
              : () => TeacherRegistrationHandleNext.call(context, state),
        );
      },
    );
  }
}
