class TeacherGradeModel {
  final String id;
  final String name;

  const TeacherGradeModel({
    required this.id,
    required this.name,
  });

  factory TeacherGradeModel.fromJson(Map<String, dynamic> json) {
    return TeacherGradeModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  factory TeacherGradeModel.placeholder() {
    return const TeacherGradeModel(
      id: '',
      name: 'الصف الأول',
    );
  }
}