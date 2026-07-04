class CurriculumModel {
  CurriculumModel({required this.id, required this.name, required this.grades});

  final String id;
  final String name;
  final List<GradeModel> grades;
}

class GradeModel {
  GradeModel({required this.id, required this.name, required this.semesters});

  final String id;
  final String name;
  final List<SemesterModel> semesters;
}

class SemesterModel {
  const SemesterModel({required this.id, required this.name});

  final String id;
  final String name;
}
