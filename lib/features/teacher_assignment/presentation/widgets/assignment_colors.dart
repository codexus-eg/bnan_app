import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/teacher_assignment/data/teacher_assignment_filter_type.dart';
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

  factory AssignmentColors.fromStatus(TeacherAssignmentStatus status) {
    switch (status) {
      case TeacherAssignmentStatus.active:
        return const AssignmentColors(
          backgroundColor: ColorManager.blueDEE,
          badgeColor: ColorManager.blueC8E,
          textColor: ColorManager.blue007,
        );
      case TeacherAssignmentStatus.submitted:
        return const AssignmentColors(
          backgroundColor: ColorManager.greenE1,
          badgeColor: ColorManager.greenCEE,
          textColor: ColorManager.green33B,
        );
      case TeacherAssignmentStatus.notSubmitted:
        return const AssignmentColors(
          backgroundColor: ColorManager.redF2,
          badgeColor: ColorManager.redEE,
          textColor: ColorManager.redD8,
        );
      case TeacherAssignmentStatus.finished:
        return const AssignmentColors(
          backgroundColor: ColorManager.greyEA,
          badgeColor: ColorManager.greyC9,
          textColor: ColorManager.grey7D7D,
        );
    }
  }
}
