class AcademicGradeModel {
  const AcademicGradeModel({
    required this.id,
    required this.name,
    this.curriculumId,
    this.curriculumName,
    this.curriculumIcon,
  });

  final String id;
  final String name;
  final String? curriculumId;
  final String? curriculumName;
  final String? curriculumIcon;

  factory AcademicGradeModel.fromJson(Map<String, dynamic> json) {
    final curriculum = json['curriculum'];

    return AcademicGradeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      curriculumId: curriculum is Map
          ? curriculum['id']?.toString()
          : null,
      curriculumName: curriculum is Map
          ? curriculum['name']?.toString()
          : null,
      curriculumIcon: curriculum is Map
          ? curriculum['icon']?.toString()
          : null,
    );
  }

  String get displayName {
    final curriculum = curriculumName?.trim();

    if (curriculum == null || curriculum.isEmpty) {
      return name;
    }

    return '$name - $curriculum';
  }
}