import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsClassroomFilter extends StatelessWidget {
  const WeeklyEvaluationsClassroomFilter({
    super.key,
    required this.classrooms,
    required this.selectedClassroom,
    required this.onChanged,
  });

  final List<String> classrooms;
  final String? selectedClassroom;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      label: S.of(context).chooseClassRoom,
      value: selectedClassroom,
      hint: S.of(context).selectClassroom,
      items: classrooms,
      backgroundColor: ColorManager.white,
      onChanged: onChanged,
    );
  }
}
