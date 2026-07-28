class TeacherAssignedSubjectModel {
  const TeacherAssignedSubjectModel({
    required this.classroomSubjectId,
    required this.id,
    required this.name,
  });

  final String classroomSubjectId;
  final String id;
  final String name;

  factory TeacherAssignedSubjectModel.fromJson(Map<String, dynamic> json) {
    return TeacherAssignedSubjectModel(
      classroomSubjectId: json['classroomSubjectId']?.toString().trim() ?? '',
      id: json['id']?.toString().trim() ?? '',
      name: json['name']?.toString().trim() ?? '',
    );
  }
}
