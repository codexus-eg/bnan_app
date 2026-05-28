import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 40),
          ),
          child: Text(
            S.of(context).skip,
            style: StylesManager.styleBold12(context).copyWith(
              color: ColorManager.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}