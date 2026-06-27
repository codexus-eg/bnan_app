class TeacherClassroomModel {
  final String id;
  final String name;

  const TeacherClassroomModel({
    required this.id,
    required this.name,
  });

  factory TeacherClassroomModel.fromJson(Map<String, dynamic> json) {
    final classroom = json['classroom'] ?? {};

    return TeacherClassroomModel(
      id: classroom['id'] ?? '',
      name: classroom['name'] ?? '',
    );
  }

  factory TeacherClassroomModel.placeholder() {
    return const TeacherClassroomModel(
      id: '',
      name: 'Math - Mr. Test',
    );
  }
}