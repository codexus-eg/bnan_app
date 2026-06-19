import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeacherGroupInfoItem extends StatelessWidget {
  const TeacherGroupInfoItem({super.key, this.iconPath, required this.text});

  final String? iconPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        if (iconPath != null) ...[
          SvgPicture.asset(
            iconPath!,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              ColorManager.greyA8AF,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
        ),
      ],
    );
  }
}
