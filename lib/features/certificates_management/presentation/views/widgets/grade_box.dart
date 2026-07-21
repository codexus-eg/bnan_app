import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class GradeBox extends StatelessWidget {
  const GradeBox({
    super.key,
    required this.text,
    this.isLight = false,
    this.alignment,
  });

  final String text;
  final bool isLight;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        top: 11,
        bottom: 12,
        start: alignment == Alignment.centerRight ? 8 : 0,
      ),
      alignment: alignment ?? Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorManager.blueD0DE),
      ),
      child: Text(
        text,
        style: StylesManager.styleBold14(context).copyWith(
          color: isLight ? ColorManager.blue7ED : ColorManager.mainColor14,
        ),
      ),
    );
  }
}
