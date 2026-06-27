import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/teacher_assignment/data/teacher_assignment_filter_type.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentFilterSection extends StatelessWidget {
  const TeacherAssignmentFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final TeacherAssignmentFilterType selectedFilter;
  final ValueChanged<TeacherAssignmentFilterType> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomFilterTabs<TeacherAssignmentFilterType>(
      items: {
        TeacherAssignmentFilterType.all: S.of(context).all,
        TeacherAssignmentFilterType.active: S.of(context).active2,
        TeacherAssignmentFilterType.finished: S.of(context).finished,
      },
      selectedItem: selectedFilter,
      onChanged: onChanged,
    );
  }
}