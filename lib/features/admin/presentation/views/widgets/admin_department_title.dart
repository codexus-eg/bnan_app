import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminDepartmentTitle extends StatelessWidget {
  const AdminDepartmentTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          ImageManager.userProfileGroupIcon,
          colorFilter: ColorFilter.mode(
            ColorManager.secondaryColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          S.of(context).studentsByDepartment,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.black),
        ),
      ],
    );
  }
}
