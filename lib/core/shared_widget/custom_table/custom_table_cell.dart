import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CustomTableCell extends StatelessWidget {
  const CustomTableCell({
    super.key,
    required this.child,
    required this.width,
    this.height = 37,
    this.margin = const EdgeInsetsDirectional.only(
      start: 10,
      end: 10,
      bottom: 12,
    ),
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.backgroundColor = ColorManager.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.constraints,
  });

  final Widget child;
  final double width;
  final double? height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
