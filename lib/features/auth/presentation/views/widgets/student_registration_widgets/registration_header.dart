import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        Text(
          S.of(context).studentRegistrationForm,
          style: StylesManager.styleBold20(context).copyWith(
            color: ColorManager.mainColor15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          S.of(context).pleaseFillRequiredInfo,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
      ],
    );
  }
}