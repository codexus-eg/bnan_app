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
  });

  final String text;
  final String icon;
  final VoidCallback? onTap;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isFilled ? ColorManager.mainColor14 : null,
        foregroundColor: isFilled ? ColorManager.white : ColorManager.mainColor14,
        side: const BorderSide(color: ColorManager.mainColor14),
        textStyle: StylesManager.styleBold12(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         SvgPicture.asset(icon),
         const SizedBox(width: 17),
         Text(text,style: StylesManager.styleBold12(context).copyWith(
          color: isFilled?ColorManager.white:ColorManager.mainColor14
         ),)
        ],
      ),
    );
  }
}