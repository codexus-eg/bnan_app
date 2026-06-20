import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegistrationRequestInfoRow extends StatelessWidget {
  const RegistrationRequestInfoRow({
    super.key,
    required this.iconPath,
    required this.text,
    this.textColor,
  });

  final String iconPath;
  final String text;
  final Color? textColor;
  bool get _isSvg => iconPath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        const SizedBox(width: 4),
        Text(
          text,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: textColor ?? ColorManager.greyA8AF),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (_isSvg) {
      return SvgPicture.asset(
        iconPath,
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(ColorManager.greyA8AF, BlendMode.srcIn),
      );
    }

    return Image.asset(iconPath, width: 16, height: 16);
  }
}
