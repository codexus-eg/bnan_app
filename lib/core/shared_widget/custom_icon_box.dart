import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconBox extends StatelessWidget {
  const CustomIconBox({super.key, this.iconPath, this.title, this.backgroundColor, this.widgetColor});
  final String? iconPath, title;
  final Color? backgroundColor ,widgetColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(13),
      decoration: BoxDecoration(
        color:backgroundColor?? ColorManager.blueE3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: iconPath != null
            ? SvgPicture.asset(
                iconPath!,
                width: 24,
                height: 24,
                colorFilter:  ColorFilter.mode(
                widgetColor??  ColorManager.mainColor14,
                  BlendMode.srcIn,
                ),
              )
            : Text(
                title ?? '',
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
      ),
    );
  }
}
