part of 'curriculum_management_body.dart';

extension _CurriculumActions on _CurriculumManagementBodyState {
  Future<void> _addCurriculum() async {
    final s = S.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => NameInputDialog(
        title: s.addNewCurriculum,
        label: s.curriculum,
        hint: s.saudiCurriculum,
      ),
    );
    if (!mounted || name == null) return;
    _update(() {
      final id = 'curriculum-${++_nextId}';
      _curriculums.add(CurriculumModel(id: id, name: name, grades: []));
      _expandedCurriculums.add(id);
    });
  }

  Future<void> _addGrade(CurriculumModel curriculum) async {
    final s = S.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => NameInputDialog(
        title: s.addNewGrade,
        label: s.gradeName,
        hint: s.parentFirstPreparatoryGrade,
      ),
    );
    if (!mounted || name == null) return;
    _update(() {
      final id = 'grade-${++_nextId}';
      curriculum.grades.add(GradeModel(id: id, name: name, semesters: []));
      _expandedGrades.add(id);
    });
  }

  Future<void> _addSemester(GradeModel grade) async {
    final s = S.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => NameInputDialog(
        title: s.addNewSemester,
        label: s.semesterName,
        hint: s.semesterOne,
      ),
    );
    if (!mounted || name == null) return;
    _update(() {
      grade.semesters.add(
        SemesterModel(id: 'semester-${++_nextId}', name: name),
      );
    });
  }
}
