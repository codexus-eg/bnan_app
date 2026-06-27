import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CustomDetailsWidgetBackground extends StatelessWidget {
  const CustomDetailsWidgetBackground({super.key, required this.child, this.padding, this.shadow =true, this.margin, this.backgroundColor});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool? shadow;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:padding?? const EdgeInsetsDirectional.all(8),
      margin:margin ,
      decoration: BoxDecoration(
        color: backgroundColor?? ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow:shadow != false? [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ]:null,
      ),
      child: child,
    );
  }
}
