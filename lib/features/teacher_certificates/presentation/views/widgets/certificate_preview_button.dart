import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CertificatePreviewButton extends StatelessWidget {
  const CertificatePreviewButton({
    super.key,
    required this.title,
    this.icon,
    this.isPrimary = false,
    this.onTap,
    this.imageUrl,
  });

  final String title;
  final IconData? icon;
  final String? imageUrl;

  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary ? ColorManager.mainColor14 : ColorManager.white;
    final textColor = isPrimary ? ColorManager.white : ColorManager.mainColor14;

    return Expanded(
      child: SizedBox(
        height: 40,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: imageUrl != null
              ? SvgPicture.asset(
                  imageUrl!,
                  colorFilter: ColorFilter.mode(
                    ColorManager.white,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(icon, size: 18),
          label: Text(title,style: StylesManager.styleBold12(context).copyWith(
            color: textColor
          )),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: bgColor,
            foregroundColor: textColor,
            textStyle: StylesManager.styleBold12(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
