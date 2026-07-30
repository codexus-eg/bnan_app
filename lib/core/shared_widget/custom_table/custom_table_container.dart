import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CustomTableContainer extends StatelessWidget {
  const CustomTableContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(8),
    this.backgroundColor = ColorManager.greyF8F9,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.hasShadow = true,
    this.shadowBlurRadius = 1,
    this.shadowOffset = const Offset(0, 1),
    this.clipBehavior = Clip.none,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final bool hasShadow;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: ColorManager.black.withAlpha((255 * .25).round()),
                  blurRadius: shadowBlurRadius,
                  offset: shadowOffset,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
