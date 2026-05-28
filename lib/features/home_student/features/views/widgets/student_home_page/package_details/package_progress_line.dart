import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class PackageProgressLine extends StatelessWidget {
  const PackageProgressLine({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 10,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorManager.greyE8E9,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: 10,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [ColorManager.blue73B9, ColorManager.blue4260],
              stops: [0.0, 1.0],
            ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}