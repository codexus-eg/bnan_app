import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatCircleButton extends StatelessWidget {
  const ChatCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isDark = false,
    this.isLoading = false,
  });

  final String icon;
  final VoidCallback onTap;
  final bool isDark;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: isDark
            ? ColorManager.mainColor14
            : ColorManager.greyD9D9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorManager.white,
                  ),
                )
              : SvgPicture.asset(icon, height: 24, width: 24),
        ),
      ),
    );
  }
}
