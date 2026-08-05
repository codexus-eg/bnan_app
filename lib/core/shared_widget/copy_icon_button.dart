import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CopyIconButton extends StatelessWidget {
  const CopyIconButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Opacity(
          opacity: onPressed == null ? .4 : 1,
          child: SvgPicture.asset(
            ImageManager.usersManagementCopyIcon,
            width: 12,
            height: 12,
          ),
        ),
      ),
    );
  }
}
