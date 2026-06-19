import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomSharedHomeInfo extends StatelessWidget {
  const CustomSharedHomeInfo({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StylesManager.styleBold16(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
        Text(
          subtitle,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
        ),
      ],
    );
  }
}
