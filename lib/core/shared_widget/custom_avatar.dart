import 'package:bnan_app/core/helper/characters.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    super.key,
    required this.firstName,
    this.radius,
    this.backgroundColor,
    this.textColor,
  });
  final String firstName;
  final double? radius;
  final Color? backgroundColor, textColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 28,
      backgroundColor: backgroundColor ?? const Color(0xffE9C77B),
      child: Text(
        getInitials(firstName),
        style: StylesManager.styleBold14(
          context,
        ).copyWith(color: textColor ?? ColorManager.mainColor14),
      ),
    );
  }
}

