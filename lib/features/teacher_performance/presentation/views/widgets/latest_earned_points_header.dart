import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LatestEarnedPointsHeader extends StatelessWidget {
  const LatestEarnedPointsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(ImageManager.starIcon),
        const SizedBox(width: 4),
        Text(
          S.of(context).latestEarnedPoints,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.mainColor15,
          ),
        ),
      ],
    );
  }
}