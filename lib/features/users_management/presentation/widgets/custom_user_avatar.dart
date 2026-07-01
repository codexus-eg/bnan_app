import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomUserAvatar extends StatelessWidget {
  const CustomUserAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: ColorManager.secondaryColor,
      child: Center(
        child: SvgPicture.asset(ImageManager.usersManagementUserIcon),
      ),
    );
  }
}
