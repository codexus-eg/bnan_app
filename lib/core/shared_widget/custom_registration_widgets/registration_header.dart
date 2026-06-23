import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({super.key, required this.title, required this.subtitle});
  final String title,subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        Text(
         title,
          style: StylesManager.styleBold20(context).copyWith(
            color: ColorManager.mainColor15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
      ],
    );
  }
}