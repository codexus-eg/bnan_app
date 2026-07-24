import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GradeFilterDropdown extends StatelessWidget {
  const GradeFilterDropdown({
    super.key,
    required this.grades,
    required this.selectedGrade,
    required this.isLoading,
    required this.onChanged,
    this.backgroundColor,
  });

  static const _allGradesValue = '__all_grades__';

  final List<AcademicGradeModel> grades;
  final AcademicGradeModel? selectedGrade;
  final bool isLoading;
  final ValueChanged<AcademicGradeModel?> onChanged;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final gradesById = {for (final grade in grades) grade.id: grade};
    final selectedId = selectedGrade?.id;

    return CustomDropdown(
      label: S.of(context).chooseGrade,
      hint: isLoading ? S.of(context).loading : S.of(context).chooseGrade,
      value: selectedId != null && gradesById.containsKey(selectedId)
          ? selectedId
          : _allGradesValue,
      items: isLoading ? null : [_allGradesValue, ...gradesById.keys],
      itemsLabels: {
        _allGradesValue: S.of(context).allGrades,
        for (final entry in gradesById.entries)
          entry.key: entry.value.displayName,
      },
      backgroundColor: backgroundColor,
      onChanged: (value) {
        if (value == null) return;
        onChanged(value == _allGradesValue ? null : gradesById[value]);
      },
    );
  }
}
