import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AuthSwitchText extends StatelessWidget {
  const AuthSwitchText({
    super.key,
    required this.normalText,
    required this.actionText,
    required this.onTap,
  });

  final String normalText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          normalText,
          style: StylesManager.styleBold14(context),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.secondaryColor
          ),
          ),
        ),
      ],
    );
  }
}