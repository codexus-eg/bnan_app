import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationNavigationButtons extends StatelessWidget {
  const RegistrationNavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final step = context.watch<RegisterCubit>().state.currentStep;

    return Column(
      children: [
        CustomAppButton(
          backgroundColor: step == 4 ? ColorManager.orangeED : null,
          text: step == 5
              ? S.of(context).confirm
              : step == 4
                  ? S.of(context).goToPayment
                  : S.of(context).next,
          onPressed: () {
            if (step == 5) {
              MyNavigator.goToOffAll(context, Routes.logIn);
              return;
            }

            RegisterCubit.get(context).nextStep();
          },
        ),
        if (step > 1 && step < 5) ...[
          const SizedBox(height: 16),
          CustomAppButton(
            text: S.of(context).previous,
            backgroundColor: ColorManager.secondaryColor,
            textColor: ColorManager.mainColor14,
            onPressed: () {
              RegisterCubit.get(context).previousStep();
            },
          ),
        ],
      ],
    );
  }
}