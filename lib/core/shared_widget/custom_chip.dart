import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class Customship extends StatelessWidget {
  const Customship(this.title, {super.key, this.padding,  this.style});

  final String title;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ??
          const EdgeInsetsDirectional.symmetric(horizontal: 13, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: ColorManager.blueD0DE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style:style?? StylesManager.styleRegular12(
          context,
        ).copyWith(color: ColorManager.mainColor14),
      ),
    );
  }
}
