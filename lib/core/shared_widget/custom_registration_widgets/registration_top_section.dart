import 'package:bnan_app/core/shared_widget/custom_registration_widgets/registration_header.dart';
import 'package:bnan_app/core/shared_widget/custom_registration_widgets/registration_stepper.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationTopSection extends StatelessWidget {
  const RegistrationTopSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentStep,
    required this.listLength,
    required this.stepHeader,
    this.textColor,
    this.showHeader = true,
  });
  final String title, subtitle, stepHeader;
  final int currentStep, listLength;
  final Color? textColor;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showHeader) RegistrationHeader(title: title, subtitle: subtitle),
        RegistrationStepper(currentStep: currentStep, listLength: listLength),
        Text(
          stepHeader,
          style: StylesManager.styleBold16(
            context,
          ).copyWith(color: textColor ?? ColorManager.black),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
