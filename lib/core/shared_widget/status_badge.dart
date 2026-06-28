import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.text, this.horizontalPadding});

  final String text;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal:horizontalPadding?? 12,vertical: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorManager.mainColor14,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: StylesManager.styleBold12(context).copyWith(
          color: ColorManager.white,
        ),
      ),
    );
  }
}