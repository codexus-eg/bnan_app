import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppDrawerItem extends StatelessWidget {
  const CustomAppDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap, this.iconColor,
  });

  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected ? ColorManager.mainColor14 : ColorManager.white;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsetsDirectional.only(start: 8, top: 5,bottom: 5),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
             _DrawerIconBox(
              icon: icon,
              iconColor: iconColor,
              isSelected: isSelected,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: StylesManager.styleBold16(context).copyWith(
                color: textColor,
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}

class _DrawerIconBox extends StatelessWidget {
  const _DrawerIconBox({
    required this.icon,
    required this.isSelected, this.iconColor,
  });

  final String icon;
  final bool isSelected;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ColorManager.blueE3,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(iconColor??ColorManager.mainColor14, BlendMode.srcIn),
        ),
      ),
    );
  }
}