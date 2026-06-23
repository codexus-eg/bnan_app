class SelectedGradeSubjects {
  SelectedGradeSubjects({
    required this.gradeId,
    required this.subjectIds,
  });

  final String gradeId;
  final List<String> subjectIds;

  Map<String, dynamic> toJson() {
    return {
      'grade': gradeId,
      'subjects': subjectIds,
    };
  }
}