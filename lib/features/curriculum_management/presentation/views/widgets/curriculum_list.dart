import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_card.dart';
import 'package:flutter/material.dart';

class CurriculumList extends StatelessWidget {
  const CurriculumList({
    super.key,
    required this.curriculums,
    required this.expandedCurriculums,
    required this.expandedGrades,
    required this.onToggleCurriculum,
    required this.onDeleteCurriculum,
    required this.onAddGrade,
    required this.onDeleteGrade,
    required this.onAddSemester,
    required this.onDeleteSemester,
    required this.onToggleGrade,
  });

  final List<CurriculumModel> curriculums;
  final Set<String> expandedCurriculums;
  final Set<String> expandedGrades;
  final void Function(String id) onToggleCurriculum;
  final void Function(int index) onDeleteCurriculum;
  final void Function(CurriculumModel curriculum) onAddGrade;
  final void Function(int curriculumIndex, int gradeIndex) onDeleteGrade;
  final void Function(GradeModel grade) onAddSemester;
  final void Function(GradeModel grade, int index) onDeleteSemester;
  final void Function(String id) onToggleGrade;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 24),
      itemCount: curriculums.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, index) => CurriculumCard(
        curriculum: curriculums[index],
        isExpanded: expandedCurriculums.contains(curriculums[index].id),
        expandedGrades: expandedGrades,
        onToggle: () => onToggleCurriculum(curriculums[index].id),
        onDelete: () => onDeleteCurriculum(index),
        onAddGrade: () => onAddGrade(curriculums[index]),
        onDeleteGrade: (gradeIndex) => onDeleteGrade(index, gradeIndex),
        onAddSemester: onAddSemester,
        onDeleteSemester: onDeleteSemester,
        onToggleGrade: onToggleGrade,
      ),
    );
  }
}
