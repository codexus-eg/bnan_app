import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBarIcon extends StatelessWidget {
  const HomeAppBarIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24,
    this.badgeCount = 0,
  });

  final String icon;
  final VoidCallback onTap;
  final double size;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            icon,
            width: size,
            height: size,
            colorFilter: const ColorFilter.mode(
              ColorManager.white,
              BlendMode.srcIn,
            ),
          ),
          if (badgeCount > 0)
            PositionedDirectional(
              top: -8,
              end: -10,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  color: ColorManager.redD8,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  style: const TextStyle(
                    color: ColorManager.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
