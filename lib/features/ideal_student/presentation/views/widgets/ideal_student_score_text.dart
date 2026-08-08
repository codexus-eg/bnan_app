import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IdealStudentScoreText extends StatelessWidget {
  const IdealStudentScoreText({
    super.key,
    required this.points,
    this.textColor,
  });
  final num points;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(ImageManager.starIcon, height: 12, width: 12),
        const SizedBox(width: 4),
        Text(
          '$points ${S.of(context).point}',
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: textColor ?? ColorManager.greyA8AF),
        ),
      ],
    );
  }
}
