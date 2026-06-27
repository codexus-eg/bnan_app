import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocumentPreviewButtonIcon extends StatelessWidget {
  const DocumentPreviewButtonIcon({super.key, this.icon, this.imageUrl});

  final IconData? icon;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) return Icon(icon, size: 18);

    return SvgPicture.asset(
      imageUrl!,
      colorFilter: ColorFilter.mode(ColorManager.white, BlendMode.srcIn),
    );
  }
}
