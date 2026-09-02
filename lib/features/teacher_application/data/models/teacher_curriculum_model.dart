class TeacherCurriculumModel {
  final String name;
  final String icon;
  final String id;

  TeacherCurriculumModel({
    required this.name,
    required this.icon,
    required this.id,
  });

  factory TeacherCurriculumModel.fromJson(Map<String, dynamic> json) {
    return TeacherCurriculumModel(
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      id: json['id'] ?? '',
    );
  }
}
