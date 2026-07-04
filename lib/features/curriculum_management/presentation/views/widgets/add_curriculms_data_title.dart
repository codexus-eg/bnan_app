import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AddCurriculmsDataTitle extends StatelessWidget {
  const AddCurriculmsDataTitle({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
     title,
          style: StylesManager.styleMedium14(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
        const SizedBox(width: 4),
        Text(
          subtitle,
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
        ),
      ],
    );
  }
}
