import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenewalNavigation extends StatelessWidget {
  const RenewalNavigation({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ParentSubscriptionRenewalCubit>();
    final state = context.watch<ParentSubscriptionRenewalCubit>().state;
    return Column(
      children: [
        CustomAppButton(
          text: state.currentStep == 5
              ? S.of(context).parentSubmitPayment
              : S.of(context).next,
          isLoading: state.isBusy,
          onPressed: state.currentStep == 5 ? cubit.submit : cubit.nextStep,
        ),
        if (state.currentStep > 0) ...[
          const SizedBox(height: 12),
          CustomAppButton(
            text: S.of(context).previous,
            backgroundColor: ColorManager.secondaryColor,
            textColor: ColorManager.mainColor14,
            onPressed: state.isBusy ? null : cubit.previousStep,
          ),
        ],
      ],
    );
  }
}
