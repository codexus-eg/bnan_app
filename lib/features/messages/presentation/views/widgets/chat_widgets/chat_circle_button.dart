import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatCircleButton extends StatelessWidget {
  const ChatCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isDark = false,
  });

  final String icon;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: isDark ? ColorManager.mainColor14 : ColorManager.greyD9D9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            icon,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}