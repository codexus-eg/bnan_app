part of 'curriculum_management_body.dart';

extension _CurriculumDeleteActions on _CurriculumManagementBodyState {
  void _toggleCurriculum(String id) => _update(() {
    _expandedCurriculums.contains(id)
        ? _expandedCurriculums.remove(id)
        : _expandedCurriculums.add(id);
  });

  void _toggleGrade(String id) => _update(() {
    _expandedGrades.contains(id)
        ? _expandedGrades.remove(id)
        : _expandedGrades.add(id);
  });

  Future<void> _deleteCurriculum(int index) async {
    if (!await _confirmDelete()) return;
    if (!mounted) return;
    _update(() => _curriculums.removeAt(index));
  }

  Future<void> _deleteGrade(int curriculumIndex, int gradeIndex) async {
    if (!await _confirmDelete()) return;
    if (!mounted) return;
    _update(() => _curriculums[curriculumIndex].grades.removeAt(gradeIndex));
  }

  void _deleteSemester(GradeModel grade, int semesterIndex) {
    _update(() => grade.semesters.removeAt(semesterIndex));
  }

  Future<bool> _confirmDelete() async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => const DeleteConfirmationDialog(),
        ) ??
        false;
  }
}
