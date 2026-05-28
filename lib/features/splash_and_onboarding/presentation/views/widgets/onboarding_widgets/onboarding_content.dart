import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/splash_and_onboarding/data/models/onboarding_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.data,
    required this.isLast,
    required this.onPressed,
  });

  final OnboardingModel data;
  final bool isLast;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Spacer(flex: 2),
      
          SizedBox(
            width: 244,
            child: AspectRatio(
              aspectRatio: 244 / 220,
              child: SvgPicture.asset(
                data.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
      
          const Spacer(flex: 2),
      
          Center(
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleBold24(context).copyWith(
                color: ColorManager.mainColor04,
              ),
            ),
          ),
      
          const SizedBox(height: 16),
      
          Center(
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleRegular16(context).copyWith(
                color: ColorManager.grey6F6F,
              ),
            ),
          ),
      
          const SizedBox(height: 16),
      
          CustomAppButton(
            text: isLast ? S.of(context).startNow : S.of(context).next,
            onPressed: onPressed,
          ),
      
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}