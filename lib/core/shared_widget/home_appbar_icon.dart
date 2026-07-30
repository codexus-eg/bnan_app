import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBarIcon extends StatelessWidget {
  const HomeAppBarIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24,
  });

  final String icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        icon,
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(
          ColorManager.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
