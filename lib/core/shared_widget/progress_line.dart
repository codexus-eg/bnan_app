import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    required this.value,
    this.color,
    this.gradient,
    this.backgroundColor,
    this.height = 7,
  });

  final double value;
  final Color? color;
  final Gradient? gradient;
  final Color? backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor ?? ColorManager.greyE8E9,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: height,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                color: color,
                gradient: color != null
                    ? null
                    : (gradient ??
                        const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            ColorManager.blue73B9,
                            ColorManager.blue4260,
                          ],
                          stops: [0.0, 1.0],
                        )),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}