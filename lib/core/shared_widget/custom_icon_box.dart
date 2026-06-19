import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconBox extends StatelessWidget {
  const CustomIconBox({
    super.key,
    this.imagePath,
    this.title,
    this.backgroundColor,
    this.widgetColor,
    this.height,
    this.width,
  });

  final String? imagePath;
  final String? title;
  final Color? backgroundColor;
  final Color? widgetColor;
  final double? height;
  final double? width;

  bool get _isSvg => imagePath?.toLowerCase().endsWith('.svg') ?? false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorManager.blueE3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: imagePath != null
            ? _buildImage()
            : Text(
                title ?? '',
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(
                  color: widgetColor ?? ColorManager.mainColor14,
                ),
              ),
      ),
    );
  }

  Widget _buildImage() {
    if (_isSvg) {
      return SvgPicture.asset(
        imagePath!,
        width: width ?? 24,
        height: height ?? 24,
        colorFilter: ColorFilter.mode(
          widgetColor ?? ColorManager.mainColor14,
          BlendMode.srcIn,
        ),
      );
    }

    return Image.asset(
      imagePath!,
      width: width ?? 24,
      height: height ?? 24,
      color: widgetColor,
    );
  }
}