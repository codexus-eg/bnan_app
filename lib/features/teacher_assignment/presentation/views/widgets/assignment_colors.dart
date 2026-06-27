import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class AssignmentColors {
  const AssignmentColors({
    required this.backgroundColor,
    required this.badgeColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color badgeColor;
  final Color textColor;

  factory AssignmentColors.fromStatus(String status) {
    if (status == 'active') {
      return const AssignmentColors(
        backgroundColor: ColorManager.blueDEE,
        badgeColor: ColorManager.blueC8E,
        textColor: ColorManager.blue007,
      );
    }

    return const AssignmentColors(
      backgroundColor: ColorManager.greyEA,
      badgeColor: ColorManager.greyC9,
      textColor: ColorManager.grey7D7D,
    );
  }
}