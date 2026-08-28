import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentAddChildNavigation extends StatelessWidget {
  const ParentAddChildNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ParentAddChildCubit>();
    final state = context.watch<ParentAddChildCubit>().state;
    final isLast = state.currentStep == state.lastStep;
    return Column(
      children: [
        CustomAppButton(
          text: isLast
              ? state.isGulf
                    ? S.of(context).renewalConfirmPayment
                    : S.of(context).submitRegistrationRequest
              : S.of(context).next,
          isLoading: state.isBusy,
          onPressed: isLast ? cubit.submit : cubit.nextStep,
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
