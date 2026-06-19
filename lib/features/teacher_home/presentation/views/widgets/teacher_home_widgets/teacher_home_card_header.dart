import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeacherHomeCardHeader extends StatelessWidget {
  const TeacherHomeCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              ImageManager.trophyIcon,
              height: 24,
              width: 24,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                ColorManager.orangeE6,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              S.of(context).excellencePoints,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: ColorManager.white),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 12,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(510),
          ),
          child: Text(
            S.of(context).excellentTeacher,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.black),
          ),
        ),
      ],
    );
  }
}
