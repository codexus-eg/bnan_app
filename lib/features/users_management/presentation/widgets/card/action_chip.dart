import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionChipButton extends StatelessWidget {
  const ActionChipButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.color,
    this.height,
    this.width,
  });

  final String title;
  final String icon;
  final VoidCallback? onTap;
  final Color? color;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? ColorManager.mainColor14;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 10,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ColorManager.blueD0DE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(icon, height: height ?? 12, width: width ?? 12),
            const SizedBox(width: 4),
            Text(
              title,
              style: StylesManager.styleRegular10(
                context,
              ).copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
