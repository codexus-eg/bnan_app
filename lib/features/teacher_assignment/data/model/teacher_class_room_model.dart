class TeacherClassroomModel {
  final String id;
  final String name;

  const TeacherClassroomModel({required this.id, required this.name});

  factory TeacherClassroomModel.fromJson(Map<String, dynamic> json) {
    final nestedClassroom = json['classroom'];
    final classroom = nestedClassroom is Map
        ? Map<String, dynamic>.from(nestedClassroom)
        : json;

    return TeacherClassroomModel(
      id: _asString(classroom['id'] ?? classroom['_id']),
      name: _asString(classroom['name']),
    );
  }

  factory TeacherClassroomModel.placeholder() {
    return const TeacherClassroomModel(id: '', name: 'Math - Mr. Test');
  }
}

String _asString(dynamic value) => value?.toString().trim() ?? '';
