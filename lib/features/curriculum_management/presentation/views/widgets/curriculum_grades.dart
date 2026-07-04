import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/grade_row.dart';
import 'package:flutter/material.dart';

class CurriculumGrades extends StatelessWidget {
  const CurriculumGrades({
    super.key,
    required this.curriculum,
    required this.expandedGrades,
    required this.onAddGrade,
    required this.onDeleteGrade,
    required this.onAddSemester,
    required this.onDeleteSemester,
    required this.onToggleGrade,
  });

  final CurriculumModel curriculum;
  final Set<String> expandedGrades;
  final VoidCallback onAddGrade;
  final void Function(int index) onDeleteGrade;
  final void Function(GradeModel grade) onAddSemester;
  final void Function(GradeModel grade, int index) onDeleteSemester;
  final void Function(String id) onToggleGrade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in curriculum.grades.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom:12 ),
            child: GradeRow(
              grade: item.$2,
              isExpanded: expandedGrades.contains(item.$2.id),
              onToggle: () => onToggleGrade(item.$2.id),
              onDelete: () => onDeleteGrade(item.$1),
              onAddSemester: () => onAddSemester(item.$2),
              onDeleteSemester: (index) => onDeleteSemester(item.$2, index),
            ),
          ),
      ],
    );
  }
}
