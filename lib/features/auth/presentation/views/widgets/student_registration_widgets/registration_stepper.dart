import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationStepper extends StatelessWidget {
  const RegistrationStepper({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27.5, 25, 27.5, 16),
      child: SizedBox(
        height: 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PositionedDirectional(
              start: 15,
              end: 15,
              child: Container(
                height: 2,
                color: ColorManager.greyA8AF,
              ),
            ),
            PositionedDirectional(
              start: 15,
              end: 15,
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: (currentStep - 1) / 4,
                child: Container(
                  height: 2,
                  color: ColorManager.mainColor14,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
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