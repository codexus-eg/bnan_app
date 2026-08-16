import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignmentActionButton extends StatelessWidget {
  const AssignmentActionButton({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
    this.isFilled = false,
    this.isLoading = false,
  });

  final String text;
  final String icon;
  final VoidCallback? onTap;
  final bool isFilled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isFilled ? ColorManager.mainColor14 : null,
        foregroundColor: isFilled
            ? ColorManager.white
            : ColorManager.mainColor14,
        side: const BorderSide(color: ColorManager.mainColor14),
        textStyle: StylesManager.styleBold12(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ColorManager.white,
              ),
            )
          else
            SvgPicture.asset(icon),
          const SizedBox(width: 8),
          Text(
            text,
            style: StylesManager.styleBold12(context).copyWith(
              color: isFilled ? ColorManager.white : ColorManager.mainColor14,
            ),
          ),
        ],
      ),
    );
  }
}
