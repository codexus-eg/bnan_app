import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddNewTopicButton extends StatelessWidget {
  const AddNewTopicButton({
    super.key,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.secondColor,
    required this.path,
  });
  final String title, path;
  final Function()? onTap;
  final Color? backgroundColor, secondColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: 11.5,
          end: 10.5,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorManager.mainColor14,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              path,
              colorFilter: ColorFilter.mode(
                secondColor ?? ColorManager.white,
                BlendMode.srcIn,
              ),
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: StylesManager.styleBold12(
                context,
              ).copyWith(color: secondColor ?? ColorManager.white),
            ),
          ],
        ),
      ),
    );
  }
}
