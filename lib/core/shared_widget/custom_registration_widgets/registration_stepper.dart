import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationStepper extends StatelessWidget {
  const RegistrationStepper({
    super.key,
    required this.currentStep,
    required this.listLength,
  });

  final int currentStep, listLength;

  @override
  Widget build(BuildContext context) {
    final progress = listLength <= 1
        ? 0.0
        : ((currentStep - 1) / (listLength - 1)).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(27.5, 16, 27.5, 16),
      child: SizedBox(
        height: 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PositionedDirectional(
              start: 15,
              end: 15,
              child: Container(height: 2, color: ColorManager.greyA8AF),
            ),
            PositionedDirectional(
              start: 15,
              end: 15,
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: progress,
                child: Container(height: 2, color: ColorManager.mainColor14),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(listLength, (index) {
                final step = index + 1;
                final isActive = step <= currentStep;

                return CircleAvatar(
                  radius: 15,
                  backgroundColor: isActive
                      ? ColorManager.mainColor15
                      : ColorManager.greyA8AF,
                  child: Text(
                    '$step',
                    style: StylesManager.styleMedium14(context),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
