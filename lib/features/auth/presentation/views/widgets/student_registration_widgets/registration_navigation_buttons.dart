import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/manager/student_registration_cubit/student_registration_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationNavigationButtons extends StatelessWidget {
  const RegistrationNavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final step = context.watch<StudentRegistrationCubit>().state;

    return Column(
      children: [
        CustomAppButton(
          text: step == 5 ? S.of(context).confirm : S.of(context).next,
          onPressed: () => context.read<StudentRegistrationCubit>().nextStep(),
        ),
        if (step > 1) ...[
          const SizedBox(height: 16),
          CustomAppButton(
            text: S.of(context).previous,
            backgroundColor:ColorManager.secondaryColor,
            textColor: ColorManager.mainColor14,
            onPressed: () {
              context.read<StudentRegistrationCubit>().previousStep();
            },
          ),
        ],
      ],
    );
  }
}