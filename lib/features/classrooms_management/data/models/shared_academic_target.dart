class SharedAcademicTarget {
  const SharedAcademicTarget({
    required this.curriculum,
    required this.grade,
    this.gradeName,
    this.curriculumName,
  });

  final String curriculum;
  final String grade;
  final String? gradeName;
  final String? curriculumName;

  factory SharedAcademicTarget.fromJson(Map<String, dynamic> json) {
    final rawCurriculum = json['curriculum'];
    String curriculumId = '';
    String? curriculumName;
    if (rawCurriculum is Map) {
      curriculumId =
          rawCurriculum['id']?.toString() ??
          rawCurriculum['_id']?.toString() ??
          '';
      curriculumName = rawCurriculum['name']?.toString();
    } else if (rawCurriculum != null) {
      curriculumId = rawCurriculum.toString();
    }

    final rawGrade = json['grade'];
    String gradeId = '';
    String? gradeName;
    if (rawGrade is Map) {
      gradeId =
          rawGrade['id']?.toString() ?? rawGrade['_id']?.toString() ?? '';
      gradeName = rawGrade['name']?.toString();
    } else if (rawGrade != null) {
      gradeId = rawGrade.toString();
    }

    return SharedAcademicTarget(
      curriculum: curriculumId,
      grade: gradeId,
      gradeName: gradeName,
      curriculumName: curriculumName,
    );
  }

  Map<String, dynamic> toJson() => {'curriculum': curriculum, 'grade': grade};
}
