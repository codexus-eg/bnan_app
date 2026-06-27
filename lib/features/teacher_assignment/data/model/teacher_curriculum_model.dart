class TeacherCurriculumModel {
  final String id;
  final String name;
  final String icon;

  const TeacherCurriculumModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory TeacherCurriculumModel.fromJson(Map<String, dynamic> json) {
    return TeacherCurriculumModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  factory TeacherCurriculumModel.placeholder() {
    return const TeacherCurriculumModel(
      id: '',
      name: 'Saudi',
      icon: '',
    );
  }
}