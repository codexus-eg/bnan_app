import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherRegisterStepButtons extends StatelessWidget {
  const TeacherRegisterStepButtons({
    super.key,
    required this.currentStep,
    required this.stepsCount,
    this.onNext,
    required this.onPrevious,
    this.isLoading = false,
  });

  final int currentStep;
  final int stepsCount;
  final VoidCallback? onNext;
  final VoidCallback onPrevious;
  final bool isLoading;

  bool get isFirstStep => currentStep == 1;
  bool get isLastStep => currentStep == stepsCount;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onNext == null || isLoading;

    if (isFirstStep) {
      return CustomAppButton(
        text: S.of(context).next,
        onPressed: isDisabled ? null : onNext,
      );
    }

    return Row(
      children: [
        Expanded(
          child: CustomAppButton(
            text: S.of(context).previous,
            height: 42,
            backgroundColor: Colors.white,
            textColor: ColorManager.mainColor14,
            borderColor: ColorManager.greyA8AF,
            onPressed: isLoading ? null : onPrevious,
          ),
        ),
        const SizedBox(width: 23),

        Expanded(
          child: CustomAppButton(
            text: isLastStep ? S.of(context).submitRequest : S.of(context).next,
            height: 42,
            isLoading: isLoading,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.white),
            onPressed: isDisabled ? null : onNext,
          ),
        ),
      ],
    );
  }
}
