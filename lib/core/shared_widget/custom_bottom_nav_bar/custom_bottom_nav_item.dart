import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavItem extends StatelessWidget {
  const CustomBottomNavItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String imagePath;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? ColorManager.mainColor14 : ColorManager.grey7D7D;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imagePath,
            height: 22,
            width: 22,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleBold12(context).copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
