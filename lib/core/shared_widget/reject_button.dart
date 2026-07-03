import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StatusActionButton extends StatelessWidget {
  const StatusActionButton({
    super.key,
    required this.onPressed,
    this.title,
    this.backgroundColor,
    this.icon,
  });

  final VoidCallback onPressed;
  final String? title;
  final Color? backgroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 66,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.close, size: 12,color: ColorManager.white,),
        label: Text(
          title ?? S.of(context).reject,
          style: StylesManager.styleRegular10(
            context,
          ).copyWith(color: ColorManager.white),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor ?? ColorManager.redDC,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
