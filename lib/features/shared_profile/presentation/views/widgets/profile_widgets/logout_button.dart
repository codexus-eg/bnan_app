import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: SvgPicture.asset(
        ImageManager.logout,
        colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
      ),
      label: Text(
        S.of(context).logout,
        style: StylesManager.styleBold14(
          context,
        ).copyWith(color: ColorManager.black),
      ),
    );
  }
}
