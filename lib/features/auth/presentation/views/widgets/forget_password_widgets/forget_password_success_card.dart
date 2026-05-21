import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForgetPasswordSuccessCard extends StatelessWidget {
  const ForgetPasswordSuccessCard({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 19,
            backgroundColor: ColorManager.orangeFFE,
            child: Icon(
              Icons.email_outlined,
              color: ColorManager.orangeFF7,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).resetPasswordSuccessTitle,
            style: StylesManager.styleBold16(context).copyWith(
              color: ColorManager.mainColor14
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              style: StylesManager.styleRegular12(context),
              children: [
                TextSpan(text: S.of(context).checkYourEmailPrefix),
                TextSpan(
                  text: email,
                  style: StylesManager.styleRegular12(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                TextSpan(
                  text: S.of(context).resetPasswordInstructions,
                  style: StylesManager.styleRegular12(context),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          CustomAppButton(
            text: S.of(context).backToLogin,
            padding: 34,
            onPressed: () => MyNavigator.pop(context),
          ),
        ],
      ),
    );
  }
}
