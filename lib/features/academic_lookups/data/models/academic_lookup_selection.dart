class AcademicLookupSelection {
  const AcademicLookupSelection({
    this.curriculumId,
    this.curriculumName,
    this.gradeId,
    this.gradeName,
    this.classroomId,
    this.classroomName,
    this.subjectId,
    this.subjectName,
  });

  final String? curriculumId;
  final String? curriculumName;
  final String? gradeId;
  final String? gradeName;
  final String? classroomId;
  final String? classroomName;
  final String? subjectId;
  final String? subjectName;

  bool isComplete({bool requireClassroom = false}) {
    final hasMainSelection =
        curriculumId != null && gradeId != null && subjectId != null;

    if (!requireClassroom) return hasMainSelection;

    return hasMainSelection && classroomId != null;
  }
}
