import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForgetPasswordSubtitle extends StatelessWidget {
  const ForgetPasswordSubtitle({
    super.key,
    required this.isCodeSent,
    required this.email,
    this.isAccountVerification = false,
  });

  final bool isCodeSent;
  final String email;
  final bool isAccountVerification;

  @override
  Widget build(BuildContext context) {
    if (!isCodeSent) {
      return Text(
        S.of(context).forgotPasswordSubtitle,
        textAlign: TextAlign.center,
        style: StylesManager.styleRegular12(
          context,
        ).copyWith(color: ColorManager.greyA8AF),
      );
    }

    return Text.rich(
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
            text: isAccountVerification
                ? S.of(context).accountVerificationInstructions
                : S.of(context).resetPasswordInstructions,
            style: StylesManager.styleRegular12(context),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
